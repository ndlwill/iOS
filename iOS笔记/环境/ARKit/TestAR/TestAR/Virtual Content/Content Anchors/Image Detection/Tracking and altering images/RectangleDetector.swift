//
//  RectangleDetector.swift
//  TestAR
//
//  Created by youdun on 2024/5/31.
//

import Vision
import CoreImage
import ARKit

protocol RectangleDetectorDelegate: AnyObject {
    func rectangleFound(rectangleContent: CIImage)
}

// MARK: - Detect rectangular shapes in the user’s environment
/**
 As shown below, you can use Vision in real-time to check the camera feed for rectangles. 
 You perform this check up to 10 times a second by using RectangleDetector to schedule a repeating timer with an updateInterval of 0.1 seconds.

 Because Vision requests can be taxing on the processor, check the camera feed no more than 10 times a second.
 Checking for rectangles more frequently may cause the app’s frame rate to decrease, without noticeably improving the app’s results.
 
 When you make Vision requests in real-time with an ARKit–based app, you should do so serially. 
 By waiting for one request to finish before invoking another, you ensure that the AR experience remains smooth and free of interruptions.
 


 */
class RectangleDetector {
    private var updateTimer: Timer?

    private var updateInterval: TimeInterval = 0.1
    
    private var isBusy = false
    
    private var currentCameraImage: CVPixelBuffer!
    
    weak var delegate: RectangleDetectorDelegate?
    
    init(with arSession: ARSession) {
        self.updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            // CVPixelBuffer
            if let capturedImage = arSession.currentFrame?.capturedImage {
                self?.search(in: capturedImage)
            }
        }
    }
    
    // Search for rectangles in the camera's pixel buffer
    /**
     In the search function, you use the isBusy flag to ensure you’re only checking for one rectangle at a time:
     The sample sets the isBusy flag to false when a Vision request completes or fails.
     */
    private func search(in pixelBuffer: CVPixelBuffer) {
        guard !isBusy else { return }
        isBusy = true
 
        // Remember the current image.
        currentCameraImage = pixelBuffer
        
        // Note that the pixel buffer's orientation doesn't change even when the device rotates.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
        
        // Create a Vision rectangle detection request for running on the GPU.
        let request = VNDetectRectanglesRequest { request, error in
            self.completedVisionRequest(request, error: error)
        }
        
        // Look only for one rectangle at a time.
        request.maximumObservations = 1
        
        // Require rectangles to be reasonably large.
        request.minimumSize = 0.25
        
        // Require high confidence for detection results.
        request.minimumConfidence = 0.90
        
        // Ignore rectangles with a too uneven aspect ratio.
        request.minimumAspectRatio = 0.3
        
        // Ignore rectangles that are skewed too much.
        request.quadratureTolerance = 20
        
        // You leverage the `usesCPUOnly` flag of `VNRequest` to decide whether your Vision requests are processed on the CPU or GPU.
        // This sample disables `usesCPUOnly` because rectangle detection isn't very taxing on the GPU. You may benefit by enabling
        // `usesCPUOnly` if your app does a lot of rendering, or runs a complicated neural network.
        request.usesCPUOnly = false
        
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                print("Error: Rectangle detection failed - vision request failed.")
                self.isBusy = false
            }
        }
    }
    
    // If one is found, crop the camera image and correct its perspective.
    private func completedVisionRequest(_ request: VNRequest?, error: Error?) {
        print(#function, Thread.current)
        
        defer {
            isBusy = false
            print("=====completedVisionRequest defer=====")
        }
        
        // MARK: - Crop the camera feed to an observed rectangle
        /**
         When Vision finds a rectangle in the camera feed, it provides you with the rectangle’s precise coordinates through a VNRectangleObservation.
         You apply those coordinates to a Core Image perspective correction filter to crop it, leaving you with just the image data inside the rectangular shape.
         */
        
        // Only proceed if a rectangular image was detected.
        guard let rectangle = request?.results?.first as? VNRectangleObservation else {
            guard let error = error else { return }
            print("Error: Rectangle detection failed - Vision request returned an error. \(error.localizedDescription)")
            return
        }
        
        guard let filter = CIFilter(name: "CIPerspectiveCorrection") else {
            print("Error: Rectangle detection failed - Could not create perspective correction filter.")
            return
        }
        
        let width = CGFloat(CVPixelBufferGetWidth(currentCameraImage))
        let height = CGFloat(CVPixelBufferGetHeight(currentCameraImage))
        print(#function, "width = \(width)", "height = \(height)")
        let topLeft = CGPoint(x: rectangle.topLeft.x * width, y: rectangle.topLeft.y * height)
        let topRight = CGPoint(x: rectangle.topRight.x * width, y: rectangle.topRight.y * height)
        let bottomLeft = CGPoint(x: rectangle.bottomLeft.x * width, y: rectangle.bottomLeft.y * height)
        let bottomRight = CGPoint(x: rectangle.bottomRight.x * width, y: rectangle.bottomRight.y * height)
        filter.setValue(CIVector(cgPoint: topLeft), forKey: "inputTopLeft")
        filter.setValue(CIVector(cgPoint: topRight), forKey: "inputTopRight")
        filter.setValue(CIVector(cgPoint: bottomLeft), forKey: "inputBottomLeft")
        filter.setValue(CIVector(cgPoint: bottomRight), forKey: "inputBottomRight")
        
        let ciImage = CIImage(cvPixelBuffer: currentCameraImage).oriented(.up)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let perspectiveImage: CIImage = filter.value(forKey: kCIOutputImageKey) as? CIImage else {
            print("Error: Rectangle detection failed - perspective correction filter has no output image.")
            return
        }
        delegate?.rectangleFound(rectangleContent: perspectiveImage)
    }
}
