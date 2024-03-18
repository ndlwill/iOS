//
//  AssociatedKey.swift
//  SwiftDemo
//
//  Created by youdun on 2024/3/1.
//  Copyright © 2024 dzcx. All rights reserved.
//

import Foundation

struct AssociatedKey {
    static var associatedKeys: [String: UnsafeRawPointer] = [:]
    static func from(_ string: String) -> UnsafeRawPointer {
        var key = associatedKeys[string]
        if key == nil {
            key = string.data(using: .utf8)?.withUnsafeBytes({ (uint8Ptr: UnsafeRawBufferPointer) -> UnsafeRawPointer in
                return uint8Ptr.load(as: UnsafeRawPointer.self)
            })
        }
        
        return key!
    }
}
