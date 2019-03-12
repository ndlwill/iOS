//
//  BinaryTree.m
//  NDL_Category
//
//  Created by dzcx on 2019/3/7.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "BinaryTree.h"
#import "BinaryTreeNode.h"

@implementation BinaryTree

+ (BinaryTreeNode *)createBinarySortTreeWithValues:(NSArray *)valueArray
{
    BinaryTreeNode *rootNode = nil;
    for (NSInteger i = 0; i < valueArray.count; i++) {
        NSInteger value = [((NSNumber *)valueArray[i]) integerValue];
        rootNode = [BinaryTree addNode:rootNode value:value];
    }
    return rootNode;
}

// 返回rootNode
+ (BinaryTreeNode *)addNode:(BinaryTreeNode *)node value:(NSInteger)value
{
    if (!node) {
        // 根节点
        node = [BinaryTreeNode new];
        node.value = value;
        return node;
    }
    
    if (value <= node.value) {
        // 值小于根节点，则插入到左子树
        node.leftNode = [BinaryTree addNode:node.leftNode value:value];// 递归
    } else {
        node.rightNode = [BinaryTree addNode:node.rightNode value:value];
    }
    return node;
}

// 二叉树中某个位置的节点 位置从0开始算
+ (BinaryTreeNode *)nodeAtIndex:(NSInteger)index inRootNode:(BinaryTreeNode *)rootNode
{
    if (!rootNode || index < 0) {
        return nil;
    }
    
    NSMutableArray *queueArray = [NSMutableArray array];// 数组当成队列
    [queueArray addObject:rootNode];
    while (queueArray.count > 0) {
        BinaryTreeNode *node = queueArray.firstObject;
        if (index == 0) {
            return node;
        }
        
//        [queueArray removeFirstObject];
        [queueArray removeObjectAtIndex:0];
        index--;
        
        if (<#condition#>) {
            <#statements#>
        }
    }
}

@end
