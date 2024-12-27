//
//  TrackingAndAlteringImagesViewController.swift
//  TestAR
//
//  Created by youdun on 2024/5/31.
//

import UIKit
import ARKit

// MARK: - Tracking and altering images (iOS 13.0)
/**
 Create images from rectangular shapes found in the user’s environment, and augment their appearance.
 
 To demonstrate general image recognition, this sample app uses Vision to detect rectangular shapes in the user’s environment that are most likely artwork or photos.
 Run the app on an iPhone or iPad, and point the device’s camera at a movie poster or wall-mounted picture frame.
 When the app detects a rectangular shape, you extract the pixel data defined by that shape from the camera feed to create an image.
 
 The sample app changes the appearance of the image by applying a Core ML model that performs a stylistic alteration.
 By repeating this action in succession, you achieve real-time image processing using a trained neural network.
 
 To complete the effect of augmenting an image in the user’s environment, you use ARKit’s image tracking feature.
 ARKit can hold an altered image steady over the original image as the user moves the device in their environment.
 ARKit also tracks the image if it moves on its own, as when the app recognizes a banner on the side of a bus, and the bus begins to drive away.
 
 This sample app uses SceneKit to render its graphics.
 */
class TrackingAndAlteringImagesViewController: UIViewController {
    
    @IBOutlet weak var arscnView: ARSCNView!
    
    @IBOutlet weak var messagePanel: UIVisualEffectView!
    
    @IBOutlet weak var messageLabel: UILabel!
    // An object that detects rectangular shapes in the user's environment.
    var rectangleDetector: RectangleDetector!
    
    // An object that represents an augmented image that exists in the user's environment.
    var alteredImage: AlteredImage?
    
    // The timer for message presentation.
    private var messageHideTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rectangleDetector = RectangleDetector(with: self.arscnView.session)
        rectangleDetector.delegate = self

        arscnView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        searchForNewImageToTrack()
    }
    
    func searchForNewImageToTrack() {
        alteredImage?.delegate = nil
        alteredImage = nil
        
        // Restart the session and remove any image anchors that may have been detected previously.
        runImageTrackingSession(with: [], runOptions: [.removeExistingAnchors, .resetTracking])
        
        showMessage("Look for a rectangular image.", autoHide: false)
    }
    
    func showMessage(_ message: String, autoHide: Bool = true) {
        DispatchQueue.main.async {
            self.messageLabel.text = message
            self.setMessageHidden(false)
            
            self.messageHideTimer?.invalidate()
            if autoHide {
                self.messageHideTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
                    self?.setMessageHidden(true)
                }
            }
        }
    }
    
    // MARK: - private methods
    private func runImageTrackingSession(with trackingImages: Set<ARReferenceImage>,
                                         runOptions: ARSession.RunOptions = [.removeExistingAnchors]) {
        // MARK: - Track the image using ARKit
        /**
         
         */
        let configuration = ARImageTrackingConfiguration()
        configuration.maximumNumberOfTrackedImages = 1
        configuration.trackingImages = trackingImages
        arscnView.session.run(configuration, options: runOptions)
    }
    
    private func setMessageHidden(_ hide: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState], animations: {
                self.messagePanel.alpha = hide ? 0 : 1
            })
        }
    }
    
    @IBAction func didTap(_ sender: Any) {
        print(#function)
        
        
    }
    
}

extension TrackingAndAlteringImagesViewController: ARSCNViewDelegate {
    // ImageWasRecognized
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
}

// MARK: - RectangleDetectorDelegate
extension TrackingAndAlteringImagesViewController: RectangleDetectorDelegate {
    
    // Called when the app recognized a rectangular shape in the user's envirnment.
    func rectangleFound(rectangleContent: CIImage) {
        print(#function, Thread.current)
        
        DispatchQueue.main.async {
            // Ignore detected rectangles if the app is currently tracking an image.
            guard self.alteredImage == nil else {
                return
            }
            
            guard let referenceImagePixelBuffer = rectangleContent.toPixelBuffer(pixelFormat: kCVPixelFormatType_32BGRA) else {
                print("Error: Could not convert rectangle content into an ARReferenceImage.")
                return
            }
            
            // MARK: - Create a reference image
            /**
             To prepare to track the cropped image, you create an ARReferenceImage, which provides ARKit with everything it needs, like its look and physical size, to locate that image in the physical environment.
             
             ARKit requires that reference images contain sufficient detail to be recognizable;
             for example, ARKit can’t track an image that is a solid color with no features.
             To ensure ARKit can track a reference image, you validate it first before attempting to use it.
             
             Set a default physical width of 50 centimeters for the new reference image.
             While this estimate is likely incorrect, that's fine for the purpose of the app.
             The content will still appear in the correct location and at the correct scale relative to the image that's being tracked.
             */
            let possibleReferenceImage = ARReferenceImage(referenceImagePixelBuffer,
                                                          orientation: .up,
                                                          physicalWidth: CGFloat(0.5))
            
            possibleReferenceImage.validate { [weak self] (error) in
                if let error = error {
                    print("Reference image validation failed: \(error.localizedDescription)")
                    return
                }

                // Try tracking the image that lies within the rectangle which the app just detected.
                guard let newAlteredImage = AlteredImage(rectangleContent, referenceImage: possibleReferenceImage) else { return }
                newAlteredImage.delegate = self
                self?.alteredImage = newAlteredImage
                
                // Start the session with the newly recognized image.
//                self?.runImageTrackingSession(with: [newAlteredImage.referenceImage])
            }
        }
    }
}

// MARK: - AlteredImageDelegate
extension TrackingAndAlteringImagesViewController: AlteredImageDelegate {
    func alteredImageLostTracking(_ alteredImage: AlteredImage) {
        searchForNewImageToTrack()
    }
}
