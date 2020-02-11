//
//  UIBarButtonItem+Ext.swift
//  AiJiaSuClientIos
//
//  Created by youdone-ndl on 2020/1/3.
//  Copyright © 2020 AiJiaSu Inc. All rights reserved.
//

import UIKit
public extension UIBarButtonItem {
    
    /*
     iOS13:
     UINavigationBar->_UINavigationBarContentView->_UIButtonBarStackView->_UITAMICAdaptorView->customView
     */
    static func itemWithNormalImage(_ normalImage: String, highlightedImage: String?, target: Any?, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.red
        button.setImage(UIImage(named: normalImage), for: .normal)
        if let highlightedImageStr = highlightedImage {
            button.setImage(UIImage(named: highlightedImageStr), for: .highlighted)
        }
        button.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 26)
        // 或者
//        button.contentHorizontalAlignment = .left
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
//        button.sizeToFit()
//        button.frame.size.height = 44.0
        
        button.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    static func itemWithTitle(_ title: String, titleColor: UIColor, titleFont: UIFont, target: Any?, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = titleFont
        button.bounds = CGRect(x: 0, y: 0, width: 60, height: 44)
        button.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
}
