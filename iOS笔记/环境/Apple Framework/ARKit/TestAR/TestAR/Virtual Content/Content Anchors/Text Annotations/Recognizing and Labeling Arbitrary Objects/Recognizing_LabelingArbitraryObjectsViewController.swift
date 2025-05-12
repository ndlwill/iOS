//
//  Recognizing_LabelingArbitraryObjectsViewController.swift
//  TestAR
//
//  Created by youdun on 2024/12/30.
//

import ARKit
import Vision

// MARK: - Vision
/**
 Apply computer vision algorithms to perform a variety of tasks on input images and videos.
 */

// MARK: - Core ML
/**
 Integrate machine learning models into your app.
 */

// MARK: - Recognizing and Labeling Arbitrary Objects
/**
 Create anchors that track objects you recognize in the camera feed, using a custom optical-recognition algorithm.
 
 This sample app parses the camera feed, using the Vision framework with a Core ML model that recognizes regular desktop items.
 Because the Core ML model used by this app doesn’t tell you where the object lies within an image, label placement relative to the object depends on where you tap.
 
 Note
 ARKit requires an iOS device with an A9 or later processor. ARKit is not available in iOS Simulator.
 */
class Recognizing_LabelingArbitraryObjectsViewController: UIViewController {
    
    @IBOutlet weak var skView: ARSKView!
    
    private lazy var statusViewController: SKStatusViewController = {
        return children.lazy.compactMap({ $0 as? SKStatusViewController }).first!
    }()
    
    // The ML model to be used for recognition of arbitrary objects.
    private var _inceptionv3Model: Inceptionv3!
    private var inceptionv3Model: Inceptionv3! {
        get {
            if let model = _inceptionv3Model { return model }
            _inceptionv3Model = {
                do {
                    let configuration = MLModelConfiguration()
                    return try Inceptionv3(configuration: configuration)
                } catch {
                    fatalError("Couldn't create Inceptionv3 due to: \(error)")
                }
            }()
            return _inceptionv3Model
        }
    }
    
    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            // Instantiate the model from its generated Swift class.
            let model = try VNCoreMLModel(for: inceptionv3Model.model)
            // Create a new request with a model.
            let coreMLRequest = VNCoreMLRequest(model: model) { [weak self] request, error in
                print("===VNCoreMLRequest completionHandler===")
                
                self?.processClassifications(for: request, error: error)
            }
            
            // Crop input images to square area at center, matching the way the ML model was trained.
            coreMLRequest.imageCropAndScaleOption = .centerCrop
            
            // Use CPU for Vision processing to ensure that there are adequate GPU resources for rendering.
            coreMLRequest.usesCPUOnly = true
            
            return coreMLRequest
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    // The pixel buffer being held for analysis; used to serialize Vision requests.
    private var currentBuffer: CVPixelBuffer?
    
    // Labels for classified objects by ARAnchor UUID
    private var anchorLabels = [UUID: String]()
    
    // Classification results
    private var identifierString = ""
    
    // Queue for dispatching vision classification requests
    private let visionQueue = DispatchQueue(label: "com.example.apple-samplecode.ARKitVision.serialVisionQueue")
    
    private var confidence: VNConfidence = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("ARKit is not available on this device.")
        }
        
        /**
         Configure and present the SpriteKit scene that draws overlay content.
         */
        skView.delegate = self
        skView.session.delegate = self
        let overlayScene = SKScene()
        overlayScene.scaleMode = .aspectFill
        skView.presentScene(overlayScene)
        
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartSession()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        skView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        skView.session.pause()
    }

    /**
     When the user taps, add an anchor associated with the current classification result.
     */
    @IBAction func placeLabelAtLocation(_ sender: UITapGestureRecognizer) {
        let hitLocationInView = sender.location(in: skView)
        
        let hitTestResults = skView.hitTest(hitLocationInView,
                                            types: [.featurePoint, .estimatedHorizontalPlane])
        
        if let result = hitTestResults.first {
            
            // Add a new anchor at the tap location.
            let anchor = ARAnchor(transform: result.worldTransform)
            skView.session.add(anchor: anchor)
            
            // Track anchor ID to associate text with the anchor after ARKit creates a corresponding SKNode.
            anchorLabels[anchor.identifier] = identifierString
        }
    }
    
    private func restartSession() {
        statusViewController.cancelAllScheduledMessages()
        statusViewController.showMessage("RESTARTING SESSION")

        anchorLabels = [UUID: String]()
        
        let configuration = ARWorldTrackingConfiguration()
        skView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func setOverlaysHidden(_ shouldHide: Bool) {
        /**
         SKScene:
         
         The scene that the node is currently in.
         */
        skView.scene!.children.forEach { node in
            if shouldHide {
                // Hide overlay content immediately during relocalization.
                node.alpha = 0
            } else {
                // Fade overlay content in after relocalization succeeds.
                node.run(.fadeIn(withDuration: 0.5))
            }
        }
    }
    
    private func displayErrorMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session",
                                          style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.restartSession()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /**
     Implement the Vision/Core ML Image Classifier:
     
     The sample code’s classificationRequest property, classifyCurrentImage() method, and processClassifications(for:error:) method manage:
     A Core ML image-classifier model, loaded from an mlmodel file bundled with the app using the Swift API that Core ML generates for the model
     VNCoreMLRequest and VNImageRequestHandler objects for passing image data to the model for evaluation
     */
    
    // MARK: - VNCoreMLRequest
    /**
     An image-analysis request that uses a Core ML model to process images.
     */
    
    // Run the Vision+ML classifier on the current image buffer.
    private func classifyCurrentImage() {
        /**
         Most computer vision tasks are not rotation agnostic so it is important to pass in the orientation of the image with respect to device.
         */
        
        let orientation = CGImagePropertyOrientation(deviceOrientation: UIDevice.current.orientation)
        
        if let pixelBuffer = currentBuffer {
            // MARK: - VNImageRequestHandler
            /**
             An object that processes one or more image analysis requests pertaining to a single image.
             */
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: orientation)
            
            visionQueue.async {
                do {
                    // Release the pixel buffer when done, allowing the next buffer to be processed.
                    defer { self.currentBuffer = nil }
                    
                    try requestHandler.perform([self.classificationRequest])
                } catch {
                    print("Error: Vision request failed with error \"\(error)\"")
                }
            }
        }
    }
  
    // MARK: - VNRequest
    /**
     The abstract superclass for analysis requests.
     
     Important
     A VNRequest discards the alpha channel of input images, so don’t rely on it.
     */
    // MARK: - VNObservation
    /**
     The abstract superclass for analysis results.
     
     Observations resulting from Vision image analysis requests inherit from this abstract base class. Don’t use this abstract superclass directly.
     */
    // MARK: - Handle completion of the Vision request and choose results to display.
    /**
     The processClassifications(for:error:) method stores the best-match result label produced by the image classifier and displays it in the corner of the screen.
     The user can then tap in the AR scene to place that label at a real-world position.
     Placing a label requires two main steps.
     
     First, a tap gesture recognizer fires the placeLabelAtLocation(sender:) action.
     This method uses the ARKit hitTest(_:types:) method to estimate the 3D real-world position corresponding to the tap, and adds an anchor to the AR session at that position.
     
     Next, after ARKit automatically creates a SpriteKit node for the newly added anchor, the view(_:didAdd:for:) delegate method provides content for that node. 
     In this case, the sample TemplateLabelNode class creates a styled text label using the string provided by the image classifier.
     */
    func processClassifications(for request: VNRequest, error: Error?) {
        print(#function, "Thread.current = \(Thread.current)")
        
        guard let results: [VNObservation] = request.results else {
            print("Unable to classify image.\n\(error!.localizedDescription)")
            return
        }
        
        // MARK: - VNClassificationObservation
        /**
         An object that represents classification information that an image analysis request produces.
         
         This type of observation results from performing a VNCoreMLRequest image analysis with a Core ML model whose role is classification (rather than prediction or image-to-image processing).
         Vision infers that an MLModel object is a classifier model if that model predicts a single feature.
         That is, the model’s modelDescription object has a non-nil value for its predictedFeatureName property.
         */
        // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
        let classifications = results as! [VNClassificationObservation]
        
        // Show a label for the highest-confidence result (but only above a minimum confidence threshold).
        if let bestResult = classifications.first(where: { result in result.confidence > 0.5 }),
           let label = bestResult.identifier.split(separator: ",").first {
            identifierString = String(label)
            confidence = bestResult.confidence
        } else {
            identifierString = ""
            confidence = 0
        }
            
        DispatchQueue.main.async { [weak self] in
            self?.displayClassifierResults()
        }
    }
    
    // Show the classification results in the UI.
    private func displayClassifierResults() {
        guard !self.identifierString.isEmpty else {
            return // No object was classified.
        }
        let message = String(format: "Detected \(self.identifierString) with %.2f", self.confidence * 100) + "% confidence"
        statusViewController.showMessage(message)
    }
    
}

extension Recognizing_LabelingArbitraryObjectsViewController: ARSessionDelegate {
    
    // MARK: - Run the AR Session and Process Camera Images
    /**
     The sample ViewController class manages the AR session and displays AR overlay content in a SpriteKit view.
     
     ###
     This is called when a new frame has been updated.
     ###
     */
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        print(#function, "Thread.current = \(Thread.current)")
        
        /**
         Pass camera frames received from ARKit to Vision
         
         Do not enqueue other buffers for processing while another Vision task is still running.
         
         The camera stream has only a finite amount of buffers available;
         holding too many buffers for analysis would starve the camera.
         
         Important:
         Limit your processing to one buffer at a time for performance.
         The camera recycles a finite pool of pixel buffers, so retaining too many buffers for processing could starve the camera and shut down the capture session.
         Passing multiple buffers to Vision for processing would slow down processing of each image, adding latency and reducing the amount of CPU and GPU overhead for rendering AR visualizations.
         */
        guard currentBuffer == nil,
              case .normal = frame.camera.trackingState else {
            return
        }
        
        // Retain the image buffer for Vision processing.
        self.currentBuffer = frame.capturedImage
        
        // run the Vision image classifier.
        classifyCurrentImage()
    }
    
    /**
     This is called when the camera’s tracking state has changed
     */
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print(#function)
        
        let trackingState = camera.trackingState
        statusViewController.showTrackingQualityInfo(for: trackingState, autoHide: true)
        
        switch trackingState {
        case .notAvailable, .limited:
            statusViewController.escalateFeedback(for: trackingState, inSeconds: 3.0)
        case .normal:
            statusViewController.cancelScheduledMessage(for: .trackingStateEscalation)
            // Unhide content after successful relocalization.
            setOverlaysHidden(false)
        }
    }
    
    /**
     This is called when a session fails.
     */
    func session(_ session: ARSession, didFailWithError error: any Error) {
        print(#function)
        
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        // Filter out optional error messages.
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        DispatchQueue.main.async {
            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print(#function)
        
        setOverlaysHidden(true)
    }
    
    /**
     This is called after a session resumes from a pause or interruption to determine whether or not the session should attempt to relocalize.
     */
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        print(#function)
        
        /*
         Allow the session to attempt to resume after an interruption.
         This process may not succeed, so the app must be prepared
         to reset the session if the relocalizing status continues
         for a long time -- see `escalateFeedback` in `StatusViewController`.
         */
        return true
    }
    
}

extension Recognizing_LabelingArbitraryObjectsViewController: ARSKViewDelegate {
    
    /**
     Called when a new node has been mapped to the given anchor.
     */
    func view(_ view: ARSKView, didAdd node: SKNode, for anchor: ARAnchor) {
        print(#function)
        
        guard let labelText = anchorLabels[anchor.identifier] else {
            fatalError("missing expected associated label for anchor")
        }
        let label = TemplateLabelNode(text: labelText)
        node.addChild(label)
    }
}

/*
extension Recognizing_LabelingArbitraryObjectsViewController: UIGestureRecognizerDelegate {
    
}
*/


extension CGImagePropertyOrientation {
    init(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portraitUpsideDown: self = .left
        case .landscapeLeft: self = .up
        case .landscapeRight: self = .down
        default: self = .right
        }
    }
}
