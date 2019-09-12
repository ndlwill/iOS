//
//  DustEffectView.swift
//  SwiftDemo
//
//  Created by dzcx on 2019/8/16.
//  Copyright © 2019 dzcx. All rights reserved.
//

import UIKit

class DustEffectView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func createDustImages(image: UIImage) -> [UIImage] {
        var images = [UIImage]()
        guard let inputCGImage = image.cgImage else { return images }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let width = inputCGImage.width
        let height = inputCGImage.height
        let bytesPerPixel = 4
        let bitsPerComponent = 8
        let bytesPerRow = bytesPerPixel * width
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else { return images }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let buffer = context.data else { return images }
        
        let pixelBuffer = buffer.bindMemory(to: UInt32.self, capacity: width * height)
        // 将一张图片的像素随机分配到32张等待动画的图片上
        let imageCounts = 32
        var framePixels = Array(repeating: Array(repeating: UInt32(0), count: width * height), count: imageCounts)
        
        for column in 0..<width {
            for row in 0..<height {
                let offset = row * width + column
                for _ in 0...1 {
                    let temp = Double.random(in: 0..<1) + 2 * (Double(column) / Double(width))
                    let index = Int(floor(Double(imageCounts) * ( temp / 3)))
                    framePixels[index][offset] = pixelBuffer[offset]
                }
            }
        }
        
        for framePixel in framePixels {
            let data = UnsafeMutablePointer(mutating: framePixel)
            guard let context = CGContext(data: data, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
                continue
            }
            images.append(UIImage(cgImage: context.makeImage()!, scale: image.scale, orientation: image.imageOrientation))
        }
        
        return images
    }
}
