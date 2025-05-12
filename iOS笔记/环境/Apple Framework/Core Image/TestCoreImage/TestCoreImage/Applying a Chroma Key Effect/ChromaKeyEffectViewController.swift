//
//  ChromaKeyEffectViewController.swift
//  TestCoreImage
//
//  Created by youdun on 2023/8/22.
//

import UIKit
import CoreImage

// MARK: - Applying a Chroma Key Effect
/**
 The chroma key effect, also known as bluescreening or greenscreening, sets a color or range of colors in an image to transparent (alpha = 0) so that you can substitute a different background image.
 
 You apply this technique in three steps:
 Create a cube map that the CIColorCube filter will consult to determine which colors to set transparent.
 Make all pixels of the specified color in the source image transparent by applying a CIColorCube filter based on the cube map.
 Composite the source and the background image with the CISourceOverCompositing filter.
 
 1.Create a Cube Map
 A color cube is a 3D color-lookup table that assigns a transparency value to RGB colors. For example, to filter out green from the input image, create a custom color cube with the green portion of its values set to 0.

 To specify a range of colors to exclude, model colors with an HSV (hue-saturation-brightness) representation. HSV represents hue as an angle around the central axis, as in a color wheel. In order to make a chroma key color from the source image transparent, set its lookup table value to 0 when its hue is in the screen color's range.
 
 CIColorCube:
 Uses a three-dimensional color table to transform the source image pixels.
 a three-dimensional color lookup table (also called a CLUT or color cube)
 For each RGBA pixel in the input image, the filter uses the R, G, and B component values as indices to identify a location in the table; the RGBA value at that location becomes the RGBA value of the output pixel.
 This data should be an array of texel values in 32-bit floating-point RGBA linear premultiplied format.
 In the color table, the R component varies fastest, followed by G, then B.
 */
class ChromaKeyEffectViewController: UIViewController {
    
    let context: CIContext = CIContext()

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let foregroundImageURL = URL(fileURLWithPath: "\(Bundle.main.bundlePath)/avator.jpg")
        // MARK: - foregroundCIImage
        if let foregroundCIImage = CIImage(contentsOf: foregroundImageURL) {
            
            let meImageURL = URL(fileURLWithPath: "\(Bundle.main.bundlePath)/me.png")
            guard let meImage = CIImage(contentsOf: meImageURL) else { return }
            // check effect
//            showCIImage(meImage)
            
            
            // MARK: - 为什么没效果？
            /**
             let greenImage = CIImage.green
             let clampedGreenImage = greenImage.clamped(to: CGRect(x: 0, y: 0, width: 180, height: 180))
             */
            guard let greenImage = colorFilterWith(color: CIColor(red: 0, green: 1, blue: 0),
                                                   size: CGSize(width: 180, height: 180)) else { return }
            // check effect
//            showCIImage(greenImage)
            
            // MARK: - foregroundImage
            // CIImage的坐标系在左下角 x: 左->右 y: 下->上
            let foregroundImage = meImage.composited(over: greenImage)
            // check effect
//            showCIImage(foregroundImage)
            
            // Remove Green from the Source Image
            let chromaCIFilter = self.chromaKeyFilter(fromHue: 0.3, toHue: 0.4)
            // 使用图片
//            chromaCIFilter?.setValue(foregroundCIImage, forKey: kCIInputImageKey)
            // or
            // 使用滤镜生成的图片
            chromaCIFilter?.setValue(foregroundImage, forKey: kCIInputImageKey)
            
            /**
             The output image contains the foreground with all green pixels made transparent.
             
             The filter passes through each pixel in the input image, looks up its color in the color cube, and replaces the source color with the color in the color cube at the nearest position.
             */
            let sourceCIImageWithoutBackground = chromaCIFilter?.outputImage
            // check effect
//            showCIImage(sourceCIImageWithoutBackground!)
            
            // Composite over a Background Image
            let backgroundImageURL = URL(fileURLWithPath: "\(Bundle.main.bundlePath)/avator.jpg")
            if let backgroundCIImage = CIImage(contentsOf: backgroundImageURL) {
                let compositor = CIFilter(name: "CISourceOverCompositing")
                compositor?.setValue(sourceCIImageWithoutBackground, forKey: kCIInputImageKey)
                compositor?.setValue(backgroundCIImage, forKey: kCIInputBackgroundImageKey)
                let compositedCIImage = compositor?.outputImage
                
                guard let resultImage = compositedCIImage else { return }
                showCIImage(resultImage)
            }
            
        }
        
    }
    
    // Converting RGB to HSV
    func getHue(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        var hue: CGFloat = 0
        color.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
    }
    
    func chromaKeyFilter(fromHue: CGFloat, toHue: CGFloat) -> CIFilter?
    {
        // 1
        let size = 64
        var cubeRGB = [Float]()
           
        // Use a for-loop to iterate through each color combination of red, green, and blue, simulating a color gradient.
        // 2
        for z in 0 ..< size {
            let blue = CGFloat(z) / CGFloat(size - 1)
            for y in 0 ..< size {
                let green = CGFloat(y) / CGFloat(size - 1)
                for x in 0 ..< size {
                    let red = CGFloat(x) / CGFloat(size - 1)
                        
                    // 3
                    let hue = getHue(red: red, green: green, blue: blue)
                    let alpha: CGFloat = (hue >= fromHue && hue <= toHue) ? 0: 1
                        
                    // The CIColorCube filter requires premultiplied alpha values, meaning that the values in the lookup table have their transparency baked into their stored entries rather than applied when accessed.
                    // 4
                    cubeRGB.append(Float(red * alpha))
                    cubeRGB.append(Float(green * alpha))
                    cubeRGB.append(Float(blue * alpha))
                    cubeRGB.append(Float(alpha))
                }
            }
        }
        
        // warning: Initialization of 'UnsafeBufferPointer<Float>' results in a dangling buffer pointer
        let buffer: UnsafeBufferPointer<Float> = UnsafeBufferPointer(start: &cubeRGB,
                                                                     count: cubeRGB.count)
        let data = Data(buffer: buffer)
         

        // 5
        let colorCubeFilter = CIFilter(name: "CIColorCube",
                                       parameters: ["inputCubeDimension": size,
                                                    "inputCubeData": data])
        return colorCubeFilter
    }

    // MARK: - private methods
    private func showCIImage(_ ciImage: CIImage) {
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return
        }
        let uiImage = UIImage(cgImage: cgImage)
        self.imageView.image = uiImage
    }
    
    // CIColor(red: 0, green: 1, blue: 0)
    private func colorFilterWith(color: CIColor, size: CGSize) -> CIImage? {
        let colorFilter = CIFilter(name: "CIConstantColorGenerator")
        colorFilter?.setValue(color, forKey: "inputColor")
        let paletteImage = colorFilter?.outputImage
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter?.setValue(paletteImage, forKey: "inputImage")
        cropFilter?.setValue(CIVector(x: 0, y: 0, z: size.width, w: size.height), forKey: "inputRectangle")
        
        return cropFilter?.outputImage
    }
    
}
