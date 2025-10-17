//
//  Thread+Ext.swift
//  SwiftDemo
//
//  Created by youdun on 2025/10/15.
//  Copyright © 2025 dzcx. All rights reserved.
//

import Foundation

extension Thread {
    public static var currentThread: Thread {
        return Thread.current
    }
}
