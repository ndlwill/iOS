//
//  AnimatableSpriteLayer.swift
//  SwiftDemo
//
//  Created by dzcx on 2019/8/16.
//  Copyright © 2019 dzcx. All rights reserved.
//

import UIKit

class AnimatableSpriteLayer: CALayer {
    
    private var animationXValues = [CGFloat]()

    convenience init(spriteSheetImage: UIImage, spriteFrameSize: CGSize) {
        self.init()
        
        bounds.size = spriteFrameSize
        masksToBounds = true
        // 为了当前只显示Sprite图的第一幅画面
        contentsGravity = CALayerContentsGravity.left
        contents = spriteSheetImage.cgImage
        
        // contentsRect属性 默认值为(x:0.0, y:0.0, width:1.0, height:1.0) 默认值显示100%的内容区域
        let frameCount = Int(spriteSheetImage.size.width / spriteFrameSize.width)
        for frameIndex in 0..<frameCount {
            animationXValues.append(CGFloat(frameIndex) / CGFloat(frameCount))
        }
    }
    
    func play() {
        let spriteFrameAnimation = CAKeyframeAnimation(keyPath: "contentsRect.origin.x")
        spriteFrameAnimation.values = animationXValues
        spriteFrameAnimation.duration = 2.0
        spriteFrameAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        // 离散模式
        spriteFrameAnimation.calculationMode = CAAnimationCalculationMode.discrete
        add(spriteFrameAnimation, forKey: nil)
    }
}
