//
//  UIView+Extensions.swift
//  SwiftDemo
//
//  Created by dzcx on 2019/8/16.
//  Copyright © 2019 dzcx. All rights reserved.
//

import UIKit

extension UIView {
    func renderToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        defer {
            UIGraphicsEndImageContext()
        }
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}
