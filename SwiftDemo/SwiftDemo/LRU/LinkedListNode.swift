//
//  LinkedListNode.swift
//  SwiftDemo
//
//  Created by youdun on 2025/2/13.
//  Copyright © 2025 dzcx. All rights reserved.
//

import Foundation

// MARK: - 双向链表节点
class LinkedListNode<Key, Value> {
    var key: Key
    var value: Value
    var prev: LinkedListNode?
    var next: LinkedListNode?
    
    init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }
}
