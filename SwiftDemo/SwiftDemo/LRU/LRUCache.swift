//
//  LRUCache.swift
//  SwiftDemo
//
//  Created by youdun on 2025/2/13.
//  Copyright © 2025 dzcx. All rights reserved.
//

import Foundation

// MARK: - LRU
/**
 LRU（Least Recently Used）是 最近最少使用 的意思，是一种缓存淘汰策略。
 LRU 缓存算法的核心思想是：当缓存满时，优先淘汰那些最久未被访问的数据。
 LRU 会根据数据的使用顺序来决定缓存中哪些数据应该被移除。
 每次访问某个缓存项时，这个缓存项会被标记为最近使用。如果缓存已经满了，LRU 会删除最久没有被访问的缓存项来腾出空间。
 
 实现 LRU：
 双向链表（Doubly Linked List）：每次访问一个缓存项时，将该项移动到链表的头部，表示它是最近使用的。链表的尾部表示最久未使用的缓存项。
 哈希表（Hash Map）：通过哈希表来快速定位缓存项，从而在 O(1) 时间内查找、更新或删除缓存项。
 
 LRU 算法常用于各种缓存机制中，例如浏览器缓存等。
 
 LRU 算法的目的是最大限度地利用缓存空间，减少不必要的数据访问。
 
 
 使用 双向链表（Doubly Linked List）而不是 单向链表（Singly Linked List）在实现 LRU 缓存（Least Recently Used）时，主要是为了提高效率，尤其是在操作缓存项的顺序时
 1. 快速删除尾部节点（最久未使用的元素）
 LRU 缓存的核心逻辑是：当缓存容量已满时，我们需要删除 最久未使用的元素，通常是链表尾部的节点。

 在 双向链表 中，尾部节点的前一个节点是可以直接访问的，这使得删除尾部节点变得非常高效。删除尾部节点的时间复杂度是 O(1)，因为我们可以直接访问尾节点的前驱节点并修改指针。

 对于 单向链表，我们无法直接访问尾部节点的前一个节点，因此需要从头节点开始遍历整个链表才能找到尾部的前一个节点，时间复杂度是 O(n)，其中 n 是链表的长度。这使得删除尾部节点的操作效率较低。
 
 2. 高效的节点移动
 在 LRU 缓存中，每次访问缓存项时，都需要将该项 移动到链表的头部，表示它是最新访问的。对于 双向链表，我们可以直接通过节点的前驱和后继指针，将该节点从链表中移除，然后将其插入到链表的头部，这个操作的时间复杂度是 O(1)。

 如果使用 单向链表，要实现类似的操作，首先需要遍历链表找到目标节点，并修改指针来移除节点。接着，还需要插入到链表头部。这个过程的时间复杂度是 O(n)，因为我们必须遍历链表来找到目标节点。
 
 双向链表 让我们能够在常数时间 O(1) 内进行节点的删除和插入操作，特别是移动和删除尾部节点（LRU 缓存中最重要的操作）。
 单向链表 则需要遍历链表才能找到目标节点，效率较低，特别是在频繁操作节点时。
 */
class LRUCache<Key: Hashable, Value> {
    private var capacity: Int
    private var cache: [Key: LinkedListNode<Key, Value>] = [:]  // 字典只存储键和节点
    private var order: DoublyLinkedList<Key, Value> = DoublyLinkedList()
    
    init(capacity: Int) {
        self.capacity = capacity
    }
    
    // 获取缓存的值
    func get(_ key: Key) -> Value? {
        guard let node = cache[key] else {
            return nil
        }
        // 将节点移动到头部，表示它是最近使用的
        order.moveToHead(node)
        return node.value
    }
    
    // 设置缓存的值
    func put(_ key: Key, _ value: Value) {
        if let node = cache[key] {
            // 更新已有节点的值，并移动到头部
            node.value = value
            order.moveToHead(node)
        } else {
            // 插入新的节点
            let newNode = order.addHead(key, value)
            cache[key] = newNode
            
            // 如果缓存超过容量，移除尾部节点
            if cache.count > capacity {
                if let tailKey = order.removeTail() {
                    cache.removeValue(forKey: tailKey)
                }
            }
        }
    }
}
