//
//  UIWindow+Ext.swift
//  AiJiaSuClientIos
//
//  Created by youdone-ndl on 2020/1/10.
//  Copyright © 2020 AiJiaSu Inc. All rights reserved.
//
import UIKit
public extension UIWindow {
    
    func keyWindowTopViewController() -> UIViewController? {
        var curTopVC = UIApplication.shared.keyWindow?.rootViewController
        
        while curTopVC?.presentedViewController != nil {
            curTopVC = curTopVC?.presentedViewController
        }
        
        if curTopVC is UITabBarController {
            curTopVC = (curTopVC as! UITabBarController).selectedViewController
        }
        
        while (curTopVC is UINavigationController) && (curTopVC as! UINavigationController).topViewController != nil {
            curTopVC = (curTopVC as! UINavigationController).topViewController
        }
        
        return curTopVC
    }
}

