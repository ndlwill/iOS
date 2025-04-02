//
//  AlteredImage.swift
//  TestAR
//
//  Created by youdun on 2024/6/5.
//

import ARKit
/**
 Tells a delegate when image tracking failed.
 */
protocol AlteredImageDelegate: AnyObject {
    func alteredImageLostTracking(_ alteredImage: AlteredImage)
}

class AlteredImage {
    // A delegate to tell when image tracking fails.
    weak var delegate: AlteredImageDelegate?
    
    private var styleIndexArray: MLMultiArray
    
    
    let referenceImage: ARReferenceImage
    
    // A handle to the anchor ARKit assigned the tracked image.
    private(set) var anchor: ARImageAnchor?
    
    // The input parameters to the Core ML model.
    private var modelInputImage: CVPixelBuffer
    
    // A SceneKit node that animates images of varying style.
    private let visualizationSCNNode: VisualizationSCNNode
    
    // A timer that effects a grace period before checking for a new rectangular shape in the user's environment.
    private var failedTrackingTimeout: Timer?
    
    // The timeout in seconds after which the `imageTrackingLost` delegate is called.
    private var timeout: TimeInterval = 1.0
    
    // Stores a reference to the Core ML output image.
    private var modelOutputImage: CVPixelBuffer?
    
    private var numberOfStyles = 1
    
    // The index of the current image's style.
    private var styleIndex = 0
    
    private var fadeBetweenStyles = true
    
    /**
     The ML model to be used for the image alteration.
     For this class to compile, the model has to accept an input image called `image` and a style index called `index`.
     Note that this is static in order to avoid spikes in memory usage when replacing instances of the `AlteredImage` class.
     */
    private static var _styleTransferModel: StyleTransferModel!
    private static var styleTransferModel: StyleTransferModel! {
        get {
            if let model = _styleTransferModel { return model }
            
            _styleTransferModel = {
                do {
                    let configuration = MLModelConfiguration()
                    return try StyleTransferModel(configuration: configuration)
                } catch {
                    fatalError("Couldn't create StyleTransferModel due to: \(error)")
                }
            }()
            return _styleTransferModel
        }
    }
    
    deinit {
        visualizationSCNNode.removeAllAnimations()
        visualizationSCNNode.removeFromParentNode()
    }
    
    init?(_ image: CIImage, referenceImage: ARReferenceImage) {
        // Read the required input parameters of the Core ML model.
        var modelInputImageSize: CGSize? = nil
        var modelInputImageFormat: OSType = 0
        var styleIndexArrayShape: [NSNumber] = []
        var styleIndexDataType: MLMultiArrayDataType = .double
        
        // Parse the input parameters of the given Core ML model.
        /**
         MLModelDescription:
         A model holds a description of its required inputs and expected outputs.
         */
        print(#function, "MLModelDescription = \(AlteredImage.styleTransferModel.model.modelDescription)")
        
        for inputDescription in AlteredImage.styleTransferModel.model.modelDescription.inputDescriptionsByName {
            // MARK: - MLFeatureDescription
            /**
             MLFeatureDescription:
             The name, type, and constraints of an input or output feature.
             */
            let featureDescription: MLFeatureDescription = inputDescription.value
            
            if featureDescription.type == .image {
                print("image: featureName = \(featureDescription.name)")
                
                guard let featureConstraint = featureDescription.imageConstraint else {
                    fatalError("Assumption: `imageConstraint` should never be nil for feature descriptions of type `image`.")
                }
                let imageConstraint = featureConstraint
                modelInputImageSize = CGSize(width: imageConstraint.pixelsWide,
                                             height: imageConstraint.pixelsHigh)
                // OSType: kCVPixelFormatType_xxx
                modelInputImageFormat = imageConstraint.pixelFormatType
                
                print("===image===", modelInputImageSize, modelInputImageFormat)
            } else if featureDescription.type == .multiArray {
                print("multiArray: featureName = \(featureDescription.name)")
                
                guard let featureMultiArrayConstraint = featureDescription.multiArrayConstraint else {
                    fatalError("Assumption: `multiArrayConstraint` should never be nil for feature descriptions of type `multiArray`.")
                }
                let multiArrayConstraint = featureMultiArrayConstraint
                styleIndexArrayShape = multiArrayConstraint.shape
                styleIndexDataType = multiArrayConstraint.dataType
                if multiArrayConstraint.shape.count == 1 {
                    print("multiArrayConstraint.shape.count == 1")
                    numberOfStyles = multiArrayConstraint.shape[0].intValue
                }
                
                print("===multiArray===", styleIndexArrayShape, styleIndexDataType, numberOfStyles)
            }
            
        }
        
        // MARK: - MLMultiArray
        /**
         A machine learning collection type that stores numeric values in an array with multiple dimensions.
         
         A multidimensional array, or multiarray, is one of the underlying types of an MLFeatureValue that stores numeric values in multiple dimensions.
         All elements in an MLMultiArray instance are one of the same type
         and one of the types that MLMultiArrayDataType defines:
         MLMultiArrayDataType.int32
         32-bit integer
         MLMultiArrayDataType.float16
         16-bit floating point number
         MLMultiArrayDataType.float32
         32-bit floating point number (also known as float)
         float64
         64-bit floating point number (also known as double)
         
         Each dimension in a multiarray is typically significant or meaningful.
         For example, a model could have an input that accepts images as a multiarray of pixels with three dimensions, C x H x W.
         The first dimension, C, represents the number of color channels, and the second and third dimensions, H and W, represent the image’s height and width, respectively.
         The number of dimensions and size of each dimension define the multiarray’s shape.
         */
        do {
            styleIndexArray = try MLMultiArray(shape: styleIndexArrayShape, dataType: styleIndexDataType)
        } catch {
            print("Error: Could not create altered image input array.")
            return nil
        }
        
        // Scale the image to the size required by the ML model.
        guard let modelImageSize = modelInputImageSize,
              let resizedImage = image.resize(to: modelImageSize),
              let resizedPixelBuffer = resizedImage.toPixelBuffer(pixelFormat: modelInputImageFormat) else {
            print("Error: Could not convert input image to the model's expected format.")
            return nil
        }
        
        modelInputImage = resizedPixelBuffer
        
        self.referenceImage = referenceImage
        
        visualizationSCNNode = VisualizationSCNNode(referenceImage.physicalSize)
        visualizationSCNNode.delegate = self
        
        /**
         Start the failed tracking timer right away. 
         This ensures that the app starts looking for a different image to track if this one isn't trackable.
         */
        resetImageTrackingTimeout()
        
        // Start altering an image with the next style.
        createAlteredImage()
    }
    
    // Toggles whether the app animates successive styles of the altered image.
    func pauseOrResumeFade() {
        guard visualizationSCNNode.parent != nil else { return }
        
        fadeBetweenStyles.toggle()
        if fadeBetweenStyles {
            TrackingAndAlteringImagesViewController.instance?.showMessage("Resume fading between styles.")
        } else {
            TrackingAndAlteringImagesViewController.instance?.showMessage("Pause fading between styles.")
        }
        visualizationSCNNodeDidFinishFade(visualizationSCNNode)
    }
    
    // Prevents the image tracking timeout from expiring.
    private func resetImageTrackingTimeout() {
        failedTrackingTimeout?.invalidate()
        failedTrackingTimeout = Timer.scheduledTimer(withTimeInterval: timeout,
                                                     repeats: false) { [weak self] _ in
            print("=====scheduledTimer 1=====")
            if let strongSelf = self {
                print("=====scheduledTimer 2=====")
                self?.delegate?.alteredImageLostTracking(strongSelf)
            }
        }
    }
    
    // Alters the image's appearance by applying the "StyleTransfer" Core ML model to it.
    func createAlteredImage() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            do {
                self.styleIndexArray.setOnlyThisIndexToOne(self.styleIndex)
                
                let options = MLPredictionOptions()
                
                /**
                 If you leave `MLPredictionOptions` usesCPUOnly at its default value of `false`, Core ML may schedule its work on either the GPU or Neural Engine (for A12+ devices).
                 This sample leaves `usesCPUOnly` disabled because its predications were tested to work well while executed off of the CPU.
                 */
                options.usesCPUOnly = false
                
                let input = StyleTransferModelInput(image: self.modelInputImage, index: self.styleIndexArray)
                let output = try AlteredImage.styleTransferModel.prediction(input: input, options: options)
                self.imageAlteringComplete(output.stylizedImage)
            } catch {
                self.imageAlteringFailed(error.localizedDescription)
            }
        }
    }
    
    func imageAlteringComplete(_ createdImage: CVPixelBuffer) {
        guard fadeBetweenStyles else { return }
        modelOutputImage = createdImage
        visualizationSCNNode.display(createdImage)
    }
    
    // If altering the image failed, notify delegate to stop tracking this image.
    func imageAlteringFailed(_ errorDescription: String) {
        print("Error: Altering image failed - \(errorDescription).")
        self.delegate?.alteredImageLostTracking(self)
    }
    
    func selectNextStyle() {
        styleIndex = (styleIndex + 1) % numberOfStyles
    }
    
    func add(_ anchor: ARAnchor, node: SCNNode) {
        if let imageAnchor = anchor as? ARImageAnchor,
           imageAnchor.referenceImage == referenceImage {
            
            self.anchor = imageAnchor
            
            // Start the image tracking timeout.
            resetImageTrackingTimeout()
            
            /**
             Add the node that displays the altered image to the node graph.
             
             To complete the augmented reality effect, you cover the original image with the altered image.
             First, add a visualization node to hold the altered image as a child of the node provided by ARKit.
             */
            node.addChildNode(visualizationSCNNode)
            
            // If altering the first image completed before the anchor was added, display that image now.
            if let createdImage = modelOutputImage {
                visualizationSCNNode.display(createdImage)
            }
        }
    }
    
    /**
     If an image the app was tracking is no longer tracked for a given amount of time, invalidate the current image tracking session. 
     This, in turn, enables Vision to start looking for a new rectangular shape in the camera feed.
     
     The sample app tracks a single image at a time.
     To do that, you invalidate the current image tracking session if an image the app was tracking is no longer visible.
     This, in turn, enables Vision to start looking for a new rectangular shape in the camera feed.
     */
    func update(_ anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor,
           self.anchor == anchor {
            self.anchor = imageAnchor
            
            // Reset the timeout if the app is still tracking an image.
            if imageAnchor.isTracked {
                resetImageTrackingTimeout()
            }
        }
    }
    
}

// MARK: - VisualizationSCNNodeDelegate
/**
 Start altering an image using the next style if an anchor for this altered image was already added.
 */
extension AlteredImage: VisualizationSCNNodeDelegate {
    func visualizationSCNNodeDidFinishFade(_ visualizationSCNNode: VisualizationSCNNode) {
        guard fadeBetweenStyles,
              anchor != nil else { return }
        selectNextStyle()
        createAlteredImage()
    }
}
