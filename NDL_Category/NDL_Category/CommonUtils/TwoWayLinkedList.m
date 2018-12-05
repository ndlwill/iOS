//
//  TwoWayLinkedList.m
//  NDL_Category
//
//  Created by dzcx on 2018/11/29.
//  Copyright © 2018 ndl. All rights reserved.
//

#import "TwoWayLinkedList.h"
#import "Node.h"

@interface TwoWayLinkedList ()

@property (nonatomic, strong) NSMutableArray *nodeArray;

@property (nonatomic, strong) Node *headNode;// 头节点
@property (nonatomic, strong) Node *tailNode;// 尾节点

@property (nonatomic, assign) NSUInteger length;

@end

@implementation TwoWayLinkedList

#pragma mark - lazy load
- (NSMutableArray *)nodeArray
{
    if (!_nodeArray) {
        _nodeArray = [NSMutableArray array];
    }
    return _nodeArray;
}

#pragma mark - class methods
+ (instancetype)twoWayLinkedList
{
    TwoWayLinkedList *instance = [[self alloc] init];
    instance.headNode = nil;
    instance.tailNode = nil;
    instance.length = 0;
    
    return instance;
}

#pragma mark - public methods
- (BOOL)isEmpty
{
    return (self.length == 0 ? YES : NO);
}

- (void)printAllNode
{
    Node *tempNode = self.headNode;
    // 遍历
    while (tempNode) {
        NSLog(@"value = %@", tempNode.data);
        
        tempNode = tempNode.next;
    }
}

- (void)addNodeData:(id)nodeData
{
    if (!nodeData) {
        return;
    }

    self.length++;

    Node *newNode = [[Node alloc] init];
    newNode.data = nodeData;

    // 头节点为nil,设置为头节点
    if (!self.headNode) {
        newNode.previous = nil;
        newNode.next = nil;
        
        self.headNode = newNode;
        self.tailNode = newNode;

        return;
    }

    // 尾添加
    newNode.previous = self.tailNode;
    newNode.next = nil;

    // 给上一个节点的next赋值
    // 如果当前只有1个节点 头尾节点指向同一内存
    self.tailNode.next = newNode;

    // 赋值尾节点
    self.tailNode = newNode;
}


- (void)removeNodeData:(id)nodeData
{
    if (!nodeData || !self.headNode) {
        return;
    }
    
    // 到这边表示不是空链表
    Node *tempNode = self.headNode;

}

- (void)removeNode:(Node *)node
{
    if (!node || !self.headNode) {
        return;
    }
    
    Node *tempNode = self.headNode;
    
    Node *preNode = nil;
    Node *nextNode = nil;
    
    while (tempNode) {
        if (tempNode == node) {// 匹配上了
            preNode = node.previous;
            nextNode = node.next;
            
            if (preNode) {
                preNode.next = nextNode;
            }
            
            if (nextNode) {
                nextNode.previous = preNode;
            }
            
            self.length--;
            
            break;
        } else {
            tempNode = tempNode.next;
        }
    }
}

@end
