//
//  CommonUtils.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/10/16.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

//class CommonUtils {
//
//}

struct CommonUtils {
    
    static func keyWindow(by view: UIView? = nil) -> UIWindow? {
        if let v = view, let keyWindow = v.window {
            return keyWindow
        } else {
            if #available(iOS 13, *) {
                let resultWindow = UIApplication.shared.connectedScenes // Set<UIScene>
                    .compactMap { $0 as? UIWindowScene } // [UIWindowScene]
                    .flatMap { $0.windows }// [UIWindow]
                    .first { $0.isKeyWindow }
                return resultWindow
            } else {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    return appDelegate.window
                }
                
                // 新创建的window可以设置为makeKeyAndVisible,可能不准
                // return UIApplication.shared.keyWindow
            }
        }
        return nil
    }
    
}
