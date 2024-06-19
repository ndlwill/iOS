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
    
    private var numberOfStyles = 1
    
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
    
    init?(_ image: CIImage, referenceImage: ARReferenceImage) {
        // Read the required input parameters of the Core ML model.
        var modelInputImageSize: CGSize? = nil
        var modelInputImageFormat: OSType = 0
        var styleIndexArrayShape: [NSNumber] = []
        var styleIndexDataType: MLMultiArrayDataType = .double
        
        // Parse the input parameters of the given Core ML model.
        for inputDescription in AlteredImage.styleTransferModel.model.modelDescription.inputDescriptionsByName {
            let featureDescription: MLFeatureDescription = inputDescription.value
            
            if featureDescription.type == .image {
                guard let featureConstraint = featureDescription.imageConstraint else {
                    fatalError("Assumption: `imageConstraint` should never be nil for feature descriptions of type `image`.")
                }
                let imageConstraint = featureConstraint
                modelInputImageSize = CGSize(width: imageConstraint.pixelsWide,
                                             height: imageConstraint.pixelsHigh)
                modelInputImageFormat = imageConstraint.pixelFormatType
                
                print("===image===", modelInputImageSize, modelInputImageFormat)
            } else if featureDescription.type == .multiArray {
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
        
        
        
    }
}
