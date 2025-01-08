//
//  ImagePredictor.swift
//  TestAR
//
//  Created by youdun on 2025/1/7.
//

import Vision
import UIKit

// A convenience class that makes image classification predictions.
class ImagePredictor {
    struct Prediction {
        /// The name of the object or scene the image classifier recognizes in an image.
        let classification: String

        /// The image classifier's confidence as a percentage string.
        /// The prediction string doesn't include the % symbol in the string.
        let confidencePercentage: String
    }
    
    typealias ImagePredictionHandler = (_ predictions: [Prediction]?) -> Void
    
    // A dictionary of prediction handler functions, each keyed by its Vision request.
    private var predictionHandlers = [VNRequest: ImagePredictionHandler]()
    
    private static let imageClassifier = createImageClassifierVisionModel()
    /**
     At launch, the ImagePredictor class creates an image classifier singleton by calling its createImageClassifierVisionModel() type method.
     
     The method creates a Core ML model instance for Vision by:
     Creating an instance of the model’s wrapper class that Xcode auto-generates at compile time
     Retrieving the wrapper class instance’s underlying MLModel property
     Passing the model instance to a VNCoreMLModel initializer
     
     The Image Predictor class minimizes runtime by only creating a single instance it shares across the app.
     
     Note:
     Share a single VNCoreMLModel instance for each Core ML model in your project.
     */
    static func createImageClassifierVisionModel() -> VNCoreMLModel {
        // Use a default model configuration.
        let defaultConfig = MLModelConfiguration()

        // Create an instance of the image classifier's wrapper class.
        let imageClassifierWrapper: MobileNet? = try? MobileNet(configuration: defaultConfig)

        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance.")
        }

        // Get the underlying model instance.// 获取底层模型实例。
        let imageClassifierModel: MLModel = imageClassifier.model

        // Create a Vision instance using the image classifier's model instance.
        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }

        return imageClassifierVisionModel
    }
    
    // MARK: - Generates a new request instance that uses the Image Predictor's image classifier model.
    private func createImageClassificationRequest() -> VNImageBasedRequest {
        // Create an image classification request with an image classifier model.
        /**
         VNCoreMLRequest : VNImageBasedRequest : VNRequest
         */
        let imageClassificationRequest = VNCoreMLRequest(model: ImagePredictor.imageClassifier,
                                                         completionHandler: visionRequestHandler)
        /**
         The method tells Vision how to adjust images that don’t meet the model’s image input constraints by setting the request’s imageCropAndScaleOption property to VNImageCropAndScaleOption.centerCrop.
         */
        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
        return imageClassificationRequest
    }
    
    /**
     typealias VNRequestCompletionHandler = (VNRequest, (any Error)?) -> Void
     
     Retrieve the Request’s Results:
     When the image classification request is finished, Vision notifies the Image Predictor by calling the request’s completion handler, visionRequestHandler(_:error:). The method retrieves the request’s results by:
     Checking the error parameter
     Casting results to a VNClassificationObservation array
     */
    private func visionRequestHandler(_ request: VNRequest, error: Error?) {
        // Remove the caller's handler from the dictionary and keep a reference to it.
        guard let predictionHandler = predictionHandlers.removeValue(forKey: request) else {
            fatalError("Every request must have a prediction handler.")
        }
        
        // Start with a `nil` value in case there's a problem.
        var predictions: [Prediction]? = nil
        
        // Call the client's completion handler after the method returns.
        defer {
            // Send the predictions back to the client.
            predictionHandler(predictions)
        }
        
        // Check for an error first.
        if let err = error {
            print("Vision image classification error...\n\n\(err.localizedDescription)")
            return
        }
        
        // Check that the results aren't `nil`.
        if request.results == nil {
            print("Vision request had no results.")
            return
        }
        
        // Cast the request's results as an `VNClassificationObservation` array.
        guard let observations = request.results as? [VNClassificationObservation] else {
            // Image classifiers, like MobileNet, only produce classification observations.
            // However, other Core ML model types can produce other observations.
            // For example, a style transfer model produces `VNPixelBufferObservation` instances.
            print("VNRequest produced the wrong result type: \(type(of: request.results)).")
            return
        }
        
        // Create a prediction array from the observations.
        predictions = observations.map { observation in
            // Convert each observation into an `ImagePredictor.Prediction` instance.
            Prediction(classification: observation.identifier,
                       confidencePercentage: observation.confidencePercentageString)
        }
        
    }
    
    // MARK: - Generates an image classification prediction for a photo.
    func makePredictions(for photo: UIImage,
                         completionHandler: @escaping ImagePredictionHandler) throws {
        let orientation = CGImagePropertyOrientation(imageOrientation: photo.imageOrientation)
        
        guard let cgImage = photo.cgImage else {
            fatalError("Photo doesn't have underlying CGImage.")
        }
        
        let imageClassificationRequest = createImageClassificationRequest()
        // imageClassificationRequest 对应的 completionHandler
        predictionHandlers[imageClassificationRequest] = completionHandler
        
        /**
         Vision rotates the image based on orientation — a CGImagePropertyOrientation instance — before sending the image to the model.
         */
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation)
        let requests: [VNRequest] = [imageClassificationRequest]
        
        // Start the image classification request.
        /**
         Note:
         You can perform multiple Vision requests on the same image by adding each request to the array you pass to the perform(_:) method’s requests parameter.
         */
        try handler.perform(requests)
    }
    
}


extension VNClassificationObservation {
    /// Generates a string of the observation's confidence as a percentage.
    var confidencePercentageString: String {
        let percentage = confidence * 100

        switch percentage {
            case 100.0...:
                return "100%"
            case 10.0..<100.0:
                return String(format: "%.1f", percentage)
            case 1.0..<10.0:
                return String(format: "%.1f", percentage)
            case ..<1.0:
                return String(format: "%.2f", percentage)
            default:
                return String(format: "%.1f", percentage)
        }
    }
}


extension CGImagePropertyOrientation {
    /**
     Converts an image orientation to a Core Graphics image property orientation.
     
     The two orientation types use different raw values.
     */
    init(imageOrientation: UIImage.Orientation) {
        switch imageOrientation {
            case .up: self = .up
            case .down: self = .down
            case .left: self = .left
            case .right: self = .right
            case .upMirrored: self = .upMirrored
            case .downMirrored: self = .downMirrored
            case .leftMirrored: self = .leftMirrored
            case .rightMirrored: self = .rightMirrored
            @unknown default: self = .up
        }
    }
}
