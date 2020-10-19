//
//  StatusBarHelper.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/10/16.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

struct StatusBarHelper {
    
    static var height: CGFloat {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return windowScene.statusBarManager?.statusBarFrame.height ?? defaultHeight
            } else {
                return defaultHeight
            }
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    private static var defaultHeight: CGFloat {
        return UIDevice.isMordenPhone ? 44.0 : 20.0
    }
}
