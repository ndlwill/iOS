//
//  TestClass.swift
//  SwiftDemo
//
//  Created by ndl on 2020/5/7.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

@objc(TestObjcClass)
class TestClass: NSObject {
    @objc private var store: Bool = false
    
    @objc var enable: Bool {
        @objc(isEnabled) get {
            return self.store
        }
        
        @objc(setEnabled:) set {
            self.store = newValue
        }
    }
    
    @objc(setTestEnabled:)
    func set(enabled: Bool) {
        self.enable = enabled
    }
}
