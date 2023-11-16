//
//  SelectivelyFocusingOnImageViewController.swift
//  TestCoreImage
//
//  Created by youdun on 2023/8/22.
//

import UIKit
import CoreImage

// MARK: - Selectively Focusing on an Image
/**
 Focus on a part of an image by applying Gaussian blur and gradient masks.
 
 You specify the region to blur by applying a mask image; the shape and values of the mask image determine the location and strength of the blurring. Creating this effect involves the following steps:
 To focus on a strip across the image, create two linear gradients representing the portions of the image to blur.
 To focus on a circular region in the image, create a radial gradient centered on the region to keep sharp.
 Composite the gradients into a mask.
 Apply Core Image's CIMaskedVariableBlur filter to the original image, inputting the created mask.
 */
class SelectivelyFocusingOnImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = CIContext()
        
        // MARK: - Masking the Blurred Image to Apply Selective Focus
        /**
         The final step is applying your choice of mask with the input image. The CIMaskedVariableBlur built-in CIFilter accomplishes this task with the following input parameters:

         inputImage
         Set to the original, unprocessed CIImage.

         inputRadius
         Set to 10, and experiment to find the right degree of blur desired. (The default is 5.)

         inputMask
         Set to the desired gradient mask, either the outputImage of the CIAdditionCompositing filter for linear focus, or the outputImage of the CIRadialGradient filter for circular focus.
         */
        let inputImageURL = URL(fileURLWithPath: "\(Bundle.main.bundlePath)/avator.jpg")
        if let inputCIImage = CIImage(contentsOf: inputImageURL) {
            let inputImageW = inputCIImage.extent.size.width
            let inputImageH = inputCIImage.extent.size.height
            
            guard let maskedVariableBlur = CIFilter(name:"CIMaskedVariableBlur") else {
                return
            }
            maskedVariableBlur.setValue(inputCIImage, forKey: kCIInputImageKey)
            maskedVariableBlur.setValue(10, forKey: kCIInputRadiusKey)
            maskedVariableBlur.setValue(radialMaskFilterWith(w: inputImageW,
                                                             h: inputImageH)?.outputImage,
                                        forKey: "inputMask")
            let selectivelyFocusedCIImage = maskedVariableBlur.outputImage
            
            // The resulting image shows the original image with portions blurred out according to the mask applied. The linear gradient mask results in an output image focused on a strip, and the radial gradient mask results in an output image focused on a circular region.
            
            if let resultCIImage = selectivelyFocusedCIImage {
                let resultCgImage = context.createCGImage(resultCIImage, from: resultCIImage.extent)
                if let cgImage = resultCgImage {
                    self.imageView.image = UIImage(cgImage: cgImage)
                }
            }
            
        }
    }
    
    // MARK: - Focusing on a Strip of the Image
    func stripMaskFilterWith(h: CGFloat) -> CIFilter? {
        // CILinearGradient-generated linear mask
        /**
         The linear gradients cause the blur to taper smoothly as it approaches the focused stripe of the image. The Core Image CIFilter named CILinearGradient generates filters of the desired color. The linear gradient has four parameters:

         inputPoint0
         The starting point of the gradient ramp, expressed as a CIVector

         inputPoint1
         The endpoint of the gradient ramp, expressed as a CIVector

         inputColor0
         The starting point gradient color, expressed as a CIColor

         inputColor1
         The endpoint gradient color, expressed as a CIColor
         */
        guard let topGradient = CIFilter(name:"CILinearGradient") else {
            return nil
        }
        topGradient.setValue(CIVector(x:0, y:0.85 * h),
                             forKey:"inputPoint0")
        topGradient.setValue(CIColor.green,
                             forKey:"inputColor0")
        topGradient.setValue(CIVector(x:0, y:0.6 * h),
                             forKey:"inputPoint1")
        topGradient.setValue(CIColor(red:0, green:1, blue:0, alpha:0),
                             forKey:"inputColor1")
        
        guard let bottomGradient = CIFilter(name:"CILinearGradient") else {
            return nil
        }
        bottomGradient.setValue(CIVector(x:0, y:0.35 * h),
                                forKey:"inputPoint0")
        bottomGradient.setValue(CIColor.green,
                                forKey:"inputColor0")
        bottomGradient.setValue(CIVector(x:0, y:0.6 * h),
                                forKey:"inputPoint1")
        bottomGradient.setValue(CIColor(red:0, green:1, blue:0, alpha:0),
                                forKey:"inputColor1")
        
        // Creating a Mask by Compositing Linear Gradients
        guard let gradientMask = CIFilter(name:"CIAdditionCompositing") else {
            return nil
        }
        gradientMask.setValue(topGradient.outputImage,
                              forKey: kCIInputImageKey)
        gradientMask.setValue(bottomGradient.outputImage,
                              forKey: kCIInputBackgroundImageKey)
        // The resulting mask is now ready to be applied as part of the CIMaskedVariableBlur filter.
        return gradientMask
    }
    
    // MARK: - Focusing on a Circular Region
    func radialMaskFilterWith(w: CGFloat, h: CGFloat) -> CIFilter? {
        // CIRadialGradient-generated circular transparency mask
        /**
         The filter takes two parameters, inputImage and inputRadius:
         Set the inputCenter to a CIVector pointing to the center of the region you want to leave unblurred.

         Set the inputRadius0 to a fraction of the image's dimension, like 0.2*h in this example. You can tweak this parameter to determine the size of the sharp region.

         Set the inputRadius1 to a larger fraction of the image's dimension, like 0.3*h in this example. Tweaking this parameter changes the extent of the blur's tapering effect; a larger value makes the blur more gradual, whereas a smaller value makes the image transition more abruptly from sharp (at inputRadius0) to blur (at inputRadius1).

         As with the linear gradients, set inputColor0 to transparency, and inputColor1 to a solid opaque color, to indicate the blur's gradation from nonexistent to full.
         */
        
        guard let radialMask = CIFilter(name:"CIRadialGradient") else {
            return nil
        }
        // 0-1 x: 从左到右 y: 从下到上
        let imageCenter = CIVector(x: 0.5 * w, y: 0.6 * h)
        radialMask.setValue(imageCenter, forKey:kCIInputCenterKey)
        radialMask.setValue(0.2 * h, forKey: "inputRadius0")
        radialMask.setValue(0.3 * h, forKey: "inputRadius1")
        radialMask.setValue(CIColor(red:0, green:1, blue:0, alpha:0),
                            forKey: "inputColor0")
        radialMask.setValue(CIColor(red:0, green:1, blue:0, alpha:1),
                            forKey: "inputColor1")
        return radialMask
    }
    
}
