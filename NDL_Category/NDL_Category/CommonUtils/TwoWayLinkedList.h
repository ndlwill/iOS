//
//  TwoWayLinkedList.h
//  NDL_Category
//
//  Created by dzcx on 2018/11/29.
//  Copyright © 2018 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Node;

NS_ASSUME_NONNULL_BEGIN

// 双向链表 (首节点的前驱指针和尾节点的后继指针均指向空地址)
@interface TwoWayLinkedList : NSObject

+ (instancetype)twoWayLinkedList;

- (BOOL)isEmpty;

- (void)printAllNode;

- (void)addNodeData:(id)nodeData;

- (void)removeNodeData:(id)nodeData;
- (void)removeNode:(Node *)node;





@end

NS_ASSUME_NONNULL_END
