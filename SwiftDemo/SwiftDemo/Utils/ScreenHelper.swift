//
//  ScreenHelper.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/10/16.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

struct ScreenHelper {
    static var mainBounds: CGRect {
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes where scene.activationState == .foregroundActive {
                if let delegate = scene.delegate as? UIWindowSceneDelegate {
                    // delegate.window: UIWindow??
                    if let bounds = delegate.window??.bounds {
                        return bounds
                    }
                }
            }
        }
        
        return UIApplication.shared.windows[0].bounds
    }
}
