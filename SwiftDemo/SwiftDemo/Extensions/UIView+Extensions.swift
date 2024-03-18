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
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    /// Load a view from nib/xib file that is named the same as the class itself
    static func loadViewFromNib<T>() -> T {
        let nibObjects = nib.instantiate(withOwner: self, options: nil)
        
        for object in nibObjects {
            if let result = object as? T {
                return result
            }
        }
        fatalError("No suitable object found in nib file")
    }
    
    var associatedId: String {
        get {
            if let resultStr = objc_getAssociatedObject(self, AssociatedKey.from(#function)) as? String {
                return resultStr
            } else {
                return ""
            }
        }
        
        set {
            objc_setAssociatedObject(self,
                                     AssociatedKey.from(#function),
                                     newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}
