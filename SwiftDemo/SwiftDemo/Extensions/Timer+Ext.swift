//
//  Timer+Ext.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/6/4.
//  Copyright © 2020 dzcx. All rights reserved.
//

import Foundation

class Block<T> {
    var closure: T
    init(_ closure: T) {
        self.closure = closure
    }
}

extension Timer {
    class func ndl_scheduledTimer(timeInterval: TimeInterval, closure: @escaping (Timer) -> Void, repeats: Bool) -> Timer {
        return Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(_execClosure(_:)), userInfo: Block(closure), repeats: repeats)
    }
    
    @objc class func _execClosure(_ timer: Timer) {
        if let block = timer.userInfo as? Block<(Timer) -> Void> {
            block.closure(timer)
        }
    }
}
