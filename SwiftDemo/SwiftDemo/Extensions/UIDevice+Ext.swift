//
//  UIDevice+Ext.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/10/16.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

extension UIDevice {
    static var isMordenPhone: Bool {
        let size = ScreenHelper.mainBounds.size
        switch size {
        /// iPhone X/Xs/11Pro
        case CGSize(width: 375, height: 812), CGSize(width: 812, height: 375):
            return true
        /// iPhone XsMax/Xr/11/11ProMax
        case CGSize(width: 414, height: 896), CGSize(width: 896, height: 414):
            return true
        default:
            return false
        }
    }
    
    // https://www.theiphonewiki.com/wiki/Models
    // https://zh.wikipedia.org/wiki/IOS%E5%92%8CiPadOS%E8%AE%BE%E5%A4%87%E5%88%97%E8%A1%A8
    // https://www.jianshu.com/p/d0382538049a
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        
        // 型号标识
        let resultName = machineMirror.children.reduce("") { (result, child) -> String in
            guard let value = child.value as? Int8, value != 0 else {
                return result
            }
            return result + String(UnicodeScalar(UInt8(value)))
        }
        
        return resultName
    }
}
