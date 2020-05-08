//
//  UIColor+Ext.swift
//  AiJiaSuClientIos
//
//  Created by youdone-ndl on 2020/1/7.
//  Copyright © 2020 AiJiaSu Inc. All rights reserved.
//

import UIKit
public extension UIColor {
    
    static func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256)) / 255.0
        let g = CGFloat(arc4random_uniform(256)) / 255.0
        let b = CGFloat(arc4random_uniform(256)) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
