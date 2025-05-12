//
//  SimulatingScratchyAnalogFilmViewController.swift
//  TestCoreImage
//
//  Created by youdun on 2023/8/23.
//

import UIKit
import CoreImage

// MARK: - Core Graphics/CGAffineTransform
// https://developer.apple.com/documentation/corefoundation/cgaffinetransform
/**
 An affine transformation matrix for use in drawing 2D graphics.
 
 An affine transformation matrix is used to rotate, scale, translate, or skew the objects you draw in a graphics context.
 a b 0
 c  d 0
 tx ty 1
 Because the third column is always (0,0,1), the CGAffineTransform data structure contains values for only the first two columns.
 */

// MARK: - Simulating Scratchy Analog Film
/**
 Degrade the quality of an image to make it look like dated, scratchy analog film.
 
 The CISepiaTone filter changes the tint of an image to a reddish-brownish hue resembling old analog photographs.
 You can enhance the effect by applying random specks and scratches.
 Combine filtered white noise with dark scratches to the CISepiaTone filter to create an old analog film effect
 
 The following steps leverage built-in Core Image filters to tint and texture an image to look as if it were analog film:
 Apply the CISepiaTone filter.
 Create randomly varying white specks to simulate grain.
 Create randomly varying dark scratches to simulate scratchy film.
 Composite the speckle image and scratches onto the sepia-toned image.
 */
class SimulatingScratchyAnalogFilmViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let context: CIContext = CIContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        let imageFileUrl = URL(fileURLWithPath: "\(Bundle.main.bundlePath)/avator.jpg")
        if let inputImage = CIImage(contentsOf: imageFileUrl) {
            guard let sepiaToneImage = sepiaToneFilter(inputImage) else { return }
            // check effect
//            showCIImage(sepiaToneImage)
            
            guard let noiseImage = randomNoiseFilter() else { return }
            // check effect 直接showCIImage(noiseImage)是不会显示图片的
//            showCIImage(noiseImage)
            
            // MARK: - 为什么不crop，没法显示noiseImage？
            guard let cropNoiseImage = cropFilterWith(inputImage: noiseImage, size: CGSize(width: 360, height: 360)) else { return }
            // check effect
//            showCIImage(cropNoiseImage)
//            return
            
            guard let whiteSpecksImage = colorMatrixFilter(cropNoiseImage) else { return }
            // check effect
//            showCIImage(whiteSpecksImage)
//            return

            // MARK: - speckledImage
            guard let speckledImage = speckledFilter(whiteSpecksImage, backgroundImage: sepiaToneImage) else { return }
            showCIImage(speckledImage)
            
            //
        }
        
    }
    
    // MARK: - Apply the Sepia Tone Filter to the Original Image
    func sepiaToneFilter(_ inputImage: CIImage) -> CIImage? {
        guard let sepiaToneFilter = CIFilter(name: "CISepiaTone", parameters: [
            kCIInputImageKey: inputImage,
            kCIInputIntensityKey: 1.0
        ]) else {
            return nil
        }
        
        return sepiaToneFilter.outputImage
    }
    
    // MARK: - Simulate Grain by Creating Randomly Varying Speckle
    /**
     You can use the output of the CIRandomGenerator filter as a basis for random noise images.
     Even though the noise pattern is not customizable in size, it can be extended and cropped to fit the image.
     
     Note
     The image output from CIRandomGenerator is always the same; even if you reseed your random number generator, the image output from this filter is always the same 512x512 pattern.
     However, it is suitable for giving the appearance of randomness. For truly random noise generation, see GameplayKit.
     
     Next, apply a whitening effect by chaining the noise output to a CIColorMatrix filter.
     This built-in filter multiplies the noise color values individually and applies a bias to each component.
     For white grain, apply whitening to the y-component of RGB and no bias.
     */
    func randomNoiseFilter() -> CIImage? {
        // Generates an image of infinite extent whose pixel values are made up of four independent, uniformly-distributed random numbers in the 0 to 1 range.
        guard let colorNoise = CIFilter(name: "CIRandomGenerator") else {
            return nil
        }
        
        return colorNoise.outputImage
    }
    
    func cropFilterWith(inputImage: CIImage, size: CGSize) -> CIImage? {
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter?.setValue(inputImage, forKey: "inputImage")
        cropFilter?.setValue(CIVector(x: 0, y: 0, z: size.width, w: size.height), forKey: "inputRectangle")
        return cropFilter?.outputImage
    }
    
    func colorMatrixFilter(_ noiseImage: CIImage) -> CIImage? {
        /**
         CIColorMatrix:
         Multiplies source color values and adds a bias factor to each color component.
         
         This filter performs a matrix multiplication, as follows, to transform the color vector:
         s.r = dot(s, redVector)
         s.g = dot(s, greenVector)
         s.b = dot(s, blueVector)
         s.a = dot(s, alphaVector)
         s = s + bias
         */
        
        let whitenVector = CIVector(x: 0, y: 1, z: 0, w: 0)
        let fineGrain = CIVector(x: 0, y: 0.005, z: 0, w: 0)
        let zeroVector = CIVector(x: 0, y: 0, z: 0, w: 0)
        guard let whiteningFilter = CIFilter(name: "CIColorMatrix", parameters: [
            kCIInputImageKey: noiseImage,
            "inputRVector": whitenVector,
            "inputGVector": whitenVector,
            "inputBVector": whitenVector,
            "inputAVector": fineGrain,
            "inputBiasVector": zeroVector]) else {
            return nil
        }

        // The whiteSpecks resulting from this filter have the appearance of spotty grain when viewed as an image.
        // White speckle grain created from a whitening CIColorMatrix applied to CIRandomGenerator noise
        let whiteSpecks = whiteningFilter.outputImage
        return whiteSpecks
    }
    
    // Create the grainy image by compositing the whitened noise as input over the sepia-toned source image using the CISourceOverCompositing filter.
    func speckledFilter(_ whiteSpecksImage: CIImage, backgroundImage: CIImage) -> CIImage? {
        guard let speckCompositor = CIFilter(name: "CISourceOverCompositing", parameters: [
                kCIInputImageKey: whiteSpecksImage,
                kCIInputBackgroundImageKey: backgroundImage
            ]) else {
            return nil
        }
        
        return speckCompositor.outputImage
    }
    
    // MARK: - Simulate Scratch by Scaling Randomly Varying Noise
    
    
    // The resulting scratches are cyan, so grayscale them using the CIMinimumComponentFilter, which takes the minimum of the RGB values to produce a grayscale image.
    // The grayscale filter produces random lines that resemble dark scratches.
    func grayscaleFilterWith(randomScratchesImage: CIImage) -> CIImage? {
        // CIMinimumComponent: Returns a grayscale image from min(r,g,b).
        guard let grayscaleFilter = CIFilter(name:"CIMinimumComponent",
                                             parameters: [kCIInputImageKey: randomScratchesImage]) else {
            return nil
        }
        
        return grayscaleFilter.outputImage
    }
    
    // Dark scratches created from a darkening CIColorMatrix applied to CIRandomGenerator noise
    

    // MARK: - Composite the Specks and Scratches to the Sepia Image
    /**
     Now that the components are set, you can add the scratches to the grainy sepia image produced earlier.
     However, unlike the grainy texture, the scratches impact the image multiplicatively.
     Instead of the CISourceOverCompositing filter, which composites source over background, use the CIMultiplyCompositing filter to compose the scratches multiplicatively.
     Set the scratched image as the filter’s input image, and tab the speckle-composited sepia image as the input background image.
     */
    func multiplyCompositingFilterWith(darkScratchesImage: CIImage, speckledImage: CIImage) -> CIImage? {
        guard let oldFilmCompositor = CIFilter(name: "CIMultiplyCompositing", parameters: [
            kCIInputImageKey: darkScratchesImage,
            kCIInputBackgroundImageKey: speckledImage]) else {
            return nil
        }
        return oldFilmCompositor.outputImage
    }
    
    
    // MARK: - private methods
    private func showCIImage(_ ciImage: CIImage) {
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return
        }
        let uiImage = UIImage(cgImage: cgImage)
        self.imageView.image = uiImage
    }
    
    private func test() {
        let imageFileUrl = URL(fileURLWithPath: "\(Bundle.main.bundlePath)/avator.jpg")
        if let inputImage = CIImage(contentsOf: imageFileUrl) {
            if let greenChannelFilter = CIFilter(name: "CIColorMatrix") {
                greenChannelFilter.setValue(inputImage, forKey: kCIInputImageKey)
                greenChannelFilter.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputRVector")
                greenChannelFilter.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputGVector")
                greenChannelFilter.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputBVector")
                greenChannelFilter.setValue(CIVector(x: 0, y: 0, z: 0, w: 1), forKey: "inputAVector")
                
                if let greenChannelImage = greenChannelFilter.outputImage {
                    showCIImage(greenChannelImage)
                }
            }
        }
    }
    
    
}
