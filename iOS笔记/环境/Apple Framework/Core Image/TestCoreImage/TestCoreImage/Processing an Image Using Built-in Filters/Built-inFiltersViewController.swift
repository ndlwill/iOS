//
//  Built-inFiltersViewController.swift
//  TestCoreImage
//
//  Created by youdun on 2023/8/21.
//

import UIKit
import CoreImage


// MARK: - Processing an Image Using Built-in Filters
/**
 Apply effects such as sepia tint, highlight strengthening, and scaling to images.
 
 You can add effects to images by applying Core Image filters to CIImage objects.
 shows three filters chained together to achieve a cumulative effect:
 Apply the sepia filter to tint an image with a reddish-brown hue.
 Add the bloom filter to accentuate highlights.
 Use the Lanczos scale filter to scale an image down.
 */
class Built_inFiltersViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.backgroundColor = .red
        
        // 1.Create a Context
        /**
         CIImage processing occurs in a CIContext object.
         Creating a CIContext is expensive, so create one during your initial setup and reuse it throughout your app.
         */
        let context = CIContext()
        
        // 2.Load an Image to Process
        /**
         The CIImage object is not itself a displayable image, but rather image data.
         To display it, you must convert it to another type, such as UIImage.
         */
        let imageURL = URL(fileURLWithPath: "\(Bundle.main.bundlePath)/avator.jpg")
        if let originalCIImage = CIImage(contentsOf: imageURL) {
            let originalUIImage = UIImage(ciImage: originalCIImage)
            
            // check effect
//            self.imageView.image = originalUIImage
            
            // 3.Apply Built-In Core Image Filters
            /**
             Note
             The built-in filters are not separate class types with visible properties.
             
             Core Image Filter Reference
             https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP40004346
             
             You must know their names and input parameters in advance; see Core Image Filter Reference for a list of filters and their effects.
             
             Some of the more common input parameter types have associated keys, such as kCIInputImageKey.
             If you cannot infer the associated key constant, you can simply use the string literal found in the filter reference.
             */
            let sepiaCIImage = sepiaFilter(originalCIImage, intensity:0.9)
            
            if let sepiaImage = sepiaCIImage {
                // check effect
//                self.imageView.image = UIImage(ciImage: sepiaImage)
                
                let bloomCIImage = bloomFilter(sepiaImage, intensity: 1, radius: 10)
                
                if let bloomImage = bloomCIImage {
                    // check effect
//                    self.imageView.image = UIImage(ciImage: bloomImage)
                    
                    let imageWidth = originalUIImage.size.width
                    let imageHeight = originalUIImage.size.height
                    // Computing aspect ratio as height over width
                    let aspectRatio = Double(imageWidth) / Double(imageHeight)
                    let scaledCIImage = scaleFilter(bloomImage, aspectRatio:aspectRatio, scale:0.5)
                    
                    // Showing the final result
                    /**
                     Important
                     To optimize computation, Core Image does not actually render any intermediate CIImage result until you force the CIImage to display its content onscreen, as you might do using UIImageView.
                     
                     Note
                     Under the hood, Core Image optimizes filtering by reordering the three chained filters and concatenating them into a single image processing kernel, saving computation and rendering cycles.
                     */
                    if let scaledImage = scaledCIImage {
                        let scaledCgImage = context.createCGImage(scaledImage, from: scaledImage.extent)
                        if let cgImage = scaledCgImage {
                            self.imageView.image = UIImage(cgImage: cgImage)
                        }
                    }
                }
            }

        }
        
    }
    
    // Tint Reddish-Brown with the Sepia Filter
    func sepiaFilter(_ input: CIImage, intensity: Double) -> CIImage? {
        let sepiaFilter = CIFilter(name: "CISepiaTone")
        sepiaFilter?.setValue(input, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        return sepiaFilter?.outputImage
    }
    
    // Strengthen Highlights with the Bloom Filter
    /**
     Like the sepia filter, the intensity of the bloom filter’s effect ranges between 0 and 1, with 1 being the most intense effect.
     The bloom filter has an additional inputRadius parameter to determine how much the glowing regions will expand.
     Experiment with a range to values to fine tune the effect, or assign the input parameter to a control like a UISlider to allow your users to tweak its values.
     
     Note
     The CIGloom filter performs the opposite effect.
     */
    func bloomFilter(_ input: CIImage, intensity: Double, radius: Double) -> CIImage? {
        let bloomFilter = CIFilter(name: "CIBloom")
        bloomFilter?.setValue(input, forKey: kCIInputImageKey)
        bloomFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        bloomFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        return bloomFilter?.outputImage
    }
    
    // Scale Image Size with the Lanczos Scale Filter
    func scaleFilter(_ input: CIImage, aspectRatio: Double, scale: Double) -> CIImage? {
        let scaleFilter = CIFilter(name: "CILanczosScaleTransform")
        scaleFilter?.setValue(input, forKey: kCIInputImageKey)
        scaleFilter?.setValue(scale, forKey: kCIInputScaleKey)
        scaleFilter?.setValue(aspectRatio, forKey: kCIInputAspectRatioKey)
        return scaleFilter?.outputImage
    }
}
