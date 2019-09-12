//
//  Utils.swift
//  SwiftDemo
//
//  Created by dzcx on 2019/9/12.
//  Copyright © 2019 dzcx. All rights reserved.
//

import Foundation

// 全局方法
public func delay(by delayTime: TimeInterval, qosClass: DispatchQoS.QoSClass? = nil, _ closure: @escaping () -> Void) {
    let dispatchQueue = qosClass != nil ? DispatchQueue.global(qos: qosClass!) : .main
    dispatchQueue.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: closure)
}
