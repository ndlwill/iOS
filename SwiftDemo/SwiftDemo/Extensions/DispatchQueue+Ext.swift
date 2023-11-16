//
//  DispatchQueue+Ext.swift
//  SwiftDemo
//
//  Created by youdun on 2023/9/18.
//  Copyright © 2023 dzcx. All rights reserved.
//

import Dispatch

extension DispatchQueue {
    private static var _onceTokens = [String]()
    
    class func once(token: String = "\(#file):\(#function):\(#line)", closure: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        if _onceTokens.contains(token) { return }
        _onceTokens.append(token)
        
        closure()
    }
}
