//
//  OnceClass.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/7/10.
//  Copyright © 2020 dzcx. All rights reserved.
//

import Foundation

class OnceClass {
    private static let takeOnceTime: Void = {
        print("takeOnceTime")
    }()
    
    static func takeOnceTimeFunc() {
        OnceClass.takeOnceTime
    }
}

// MARK: main.swift
//class MyApplication: UIApplication {
//    override func sendEvent(_ event: UIEvent) {
//        super.sendEvent(event)
//        print("Event sent:\(event)")
//    }
//}
//
//_ = UIApplicationMain(
//    CommandLine.argc,
//    CommandLine.unsafeArgv,
//    NSStringFromClass(MyApplication.self),
//    NSStringFromClass(AppDelegate.self)
//)
