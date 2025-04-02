//
//  DoublyLinkedList.swift
//  SwiftDemo
//
//  Created by youdun on 2025/2/13.
//  Copyright © 2025 dzcx. All rights reserved.
//

import Foundation

// MARK: - 双向链表
class DoublyLinkedList<Key, Value> {
    private var head: LinkedListNode<Key, Value>?
    private var tail: LinkedListNode<Key, Value>?
    
    init() {
        // 链表初始化为空，head 和 tail 都是 nil
        self.head = nil
        self.tail = nil
    }
    
    // 将节点添加到链表头部
    @discardableResult
    func addHead(_ key: Key, _ value: Value) -> LinkedListNode<Key, Value> {
        let newNode = LinkedListNode(key: key, value: value)
        
        if let firstNode = head {
            // 如果链表已有节点，则将新节点放到头部
            newNode.next = firstNode
            firstNode.prev = newNode
        } else {
            // 如果链表为空，新节点同时作为 head 和 tail
            tail = newNode
        }
        
        head = newNode
        return newNode
    }
    
    // 移动节点到链表头部
    func moveToHead(_ node: LinkedListNode<Key, Value>) {
        remove(node)
        addHead(node.key, node.value)
    }
    
    // 移除节点
    func remove(_ node: LinkedListNode<Key, Value>) {
        /**
         ==：它默认比较基本类型的值，比如：Int，String等，它不可以比较引用类型(reference type)或值类型(value type)，除非该类实现了Equatable
         
         LinkedListNode不实现Equatable协议的话，它是不支持==运算符的
         
         ===:它是检查两个对象是否完全一致(它会检测对象的指针是否指向同一地址)，它只能比较引用类型(reference type)，不可以比较基本类型和值类型(type value)
         */
        if node === head {
            head = node.next
        } else {
            node.prev?.next = node.next
        }
        
        if node === tail {
            tail = node.prev
        } else {
            node.next?.prev = node.prev
        }
    }
    
    // 移除链表尾部节点
    func removeTail() -> Key? {
        guard let tailNode = tail else {
            return nil
        }
        
        remove(tailNode)
        return tailNode.key
    }
}
