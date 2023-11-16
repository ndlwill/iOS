//
//  CustomizingImageTransitionsViewController.swift
//  TestCoreImage
//
//  Created by youdun on 2023/8/22.
//

import UIKit
import CoreImage
import simd

// MARK: - Customizing Image Transitions
/**
 Transition between images in creative ways using Core Image filters.
 You can add visual effects to an image transition by chaining together Core Image CIFilter objects in the category CICategoryTransition.
 Each filter from this category represents a single transition effect.

 For example, you can combine an effect that dissolves an image and one that pixelates it as a transition to a second image. This particular transition chain comprises three steps:
 Create a CIDissolveTransition transition filter with time as an input parameter.
 Create a CIPixellate pixelation transition filter with time as an input parameter.
 Initiate the transition by adding a time step to your run loop.
 
 Other Transition Visual Effects:
 CICopyMachineTransition
 CIPageCurlWithShadow
 CIBarsSwipeTransition
 */
class CustomizingImageTransitionsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    let context: CIContext = CIContext()
    var sourceCIImage: CIImage?
    var destinationCIImage: CIImage?
    
    // Keeping the display link around beyond function scope allows you to remove it when the transition is done.
    var displayLink: CADisplayLink!
    var time: Double = 0.0
    var dt: Double = 0.005

    override func viewDidLoad() {
        super.viewDidLoad()

        initCIImages()
        beginTransition()
    }
    
    func beginTransition() {
        // Create the Display Link to Call an Update Function
        displayLink = CADisplayLink(target: self, selector: #selector(stepTime))
        displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
    }
    
    // MARK: - Combine CIDissolveTransition and CIPixellate to create a custom image transition.
    /**
     1.Load Source and Target Images
     Filters in the transition category require your program to load both source and target images in order to transform the source into the destination.
     
     2.Create a Time-Dependent Dissolve Transition
     The key difference of transition filters from their normal filter chain counterparts is the dependence on time.
     After creating a CIFilter from the kCICategoryTransition category, you set the value of the inputTime parameter to a float between 0.0 and 1.0 to indicate how far along the transition has progressed.
     
     3.Create a Time-Dependent Pixelate Transition
     
     4.Step Time with a Display Link
     Now, you must move time forward when you want to perform the transition.
     
     Adding a CADisplayLink to your run loop gives you a way to refresh an image every time a screen redraw occurs, so you can execute on a reliably regular time interval. In the case of a transition, you need only perform the following steps:
     1.Create the display link to call an update function.
     2.Add to your app’s main run loop to begin the transition. Start time at 0.0 and track time through the update function.
     3.In the update function, update the transition filters’ inputTime value and refresh the filtered image. Since this example chains two filters for a simultaneous effect, update both filters.
     4.In the update function, remove the link once time has expired.
     
     Note
     Adding a Timer may seem like a logical strategy for stepping time, but the display link fires with greater precision in sync with screen redraws.
     */
    func initCIImages() {
        let sourceURL = URL(fileURLWithPath: "\(Bundle.main.bundlePath)/me.png")
//        let sourceImage = UIImage(contentsOfFile: sourceURL.path)
        sourceCIImage = CIImage(contentsOf: sourceURL)
                
        let destinationURL = URL(fileURLWithPath: "\(Bundle.main.bundlePath)/purchase.png")
//        let destinationImage = UIImage(contentsOfFile: destinationURL.path)
        destinationCIImage = CIImage(contentsOf: destinationURL)
    }
    
    // MARK: - Create a Time-Dependent Dissolve Transition
    func dissolveFilter(_ inputImage: CIImage,
                        to targetImage: CIImage,
                        time: TimeInterval) -> CIImage? {
            
        // a smooth ramp between 0 and 1
        /**
         You do not need to pass time linearly from 0.0 to 1.0. In fact, you can advance the transition at a variable rate by modulating the time variable with a function, such as simd_smoothstep, which is a smooth ramp function clamped between two values, imbuing the dissolve effect with an ease-in ease-out feel.
         */
        let inputTime = simd_smoothstep(0, 1, time)
        
        guard let filter = CIFilter(name: "CIDissolveTransition", parameters: [
            kCIInputImageKey: inputImage,
            kCIInputTargetImageKey: targetImage,
            kCIInputTimeKey: inputTime
        ]) else {
            return nil
        }
            
        return filter.outputImage
    }
    
    // MARK: - Create a Time-Dependent Pixelate Transition
    func pixelateFilter(_ inputImage: CIImage, time: TimeInterval) -> CIImage? {
        // simd_smoothstep(1, 0, abs(time)): a smoothened triangle ramp that goes from 0 to 1 to 0
        /**
         This function puts the peak of the pixelation at the middle of the transition: the pixels start and end small, closely approximating the source image, but as the transition reaches its halfway point, the pixels scale to their largest size, effectively blocking out the moment farthest from source and target.
         */
        let inputScale = simd_smoothstep(1, 0, abs(time))
            
        guard let filter = CIFilter(name: "CIPixellate", parameters: [
                kCIInputImageKey: inputImage,
                kCIInputScaleKey: inputScale
        ]) else {
                return nil
        }
            
        return filter.outputImage
    }
    
    @objc
    func stepTime() {
       time += dt
            
       if time > 1 {
           displayLink.remove(from: RunLoop.main, forMode: .default)
       } else {
           if let sourceImage = sourceCIImage, let destinationImage = destinationCIImage {
               guard let dissolvedCIImage = dissolveFilter(sourceImage,
                                                           to: destinationImage,
                                                           time: time) else {
                   return
               }
               guard let pixelatedCIImage = pixelateFilter(dissolvedCIImage,
                                                           time: time) else {
                   return
               }
               showCIImage(pixelatedCIImage)
           }
       }
    }
    
    
    func showCIImage(_ ciImage: CIImage) {
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return
        }
        let uiImage = UIImage(cgImage: cgImage)
        self.imageView.image = uiImage
    }

}
