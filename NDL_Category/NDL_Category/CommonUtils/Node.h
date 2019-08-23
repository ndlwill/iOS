//
//  Node.h
//  NDL_Category
//
//  Created by dzcx on 2018/11/29.
//  Copyright © 2018 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

// dummyHead虚拟头结点: 因为头结点是没有前一个结点的，因此我们要浪费一个空间使其为dummyHead这样链表总是以null作为头结点


// 节点
@interface Node : NSObject

@property (nonatomic, strong) Node *previous;
@property (nonatomic, strong) Node *next;

@property (nonatomic, strong) id data;

@end
