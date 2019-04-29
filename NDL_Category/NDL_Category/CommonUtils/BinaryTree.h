//
//  BinaryTree.h
//  NDL_Category
//
//  Created by dzcx on 2019/3/7.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinaryTreeNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface BinaryTree : NSObject

// recursion 递归
// non-recursive 非递归

// 二叉查找树（Binary Search Tree） 即二叉搜索树，二叉排序树
// 创建二叉排序树 二叉排序树：左节点值全部小于根节点值，右节点值全部大于根节点值
// return 二叉树根节点
+ (BinaryTreeNode *)createBinarySortTreeWithValues:(NSArray *)valueArray;

+ (BinaryTreeNode *)nodeAtIndex:(NSInteger)index inRootNode:(BinaryTreeNode *)rootNode;
+ (void)preOrderTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler;
+ (void)inOrderTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler;
+ (void)postOrderTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler;
// non-recursive
+ (void)BFSTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler;

+ (void)DFSNonRecursiveTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler;
+ (void)DFSRecursionTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler;

+ (NSInteger)depthOfTree:(BinaryTreeNode *)rootNode;

+ (NSInteger)widthOfTree:(BinaryTreeNode *)rootNode;

+ (NSInteger)numberOfNodesInTree:(BinaryTreeNode *)rootNode;

+ (NSInteger)numberOfNodesOnLevel:(NSInteger)level inTree:(BinaryTreeNode *)rootNode;

+ (NSInteger)numberOfLeadNodesInTree:(BinaryTreeNode *)rootNode;

+ (NSInteger)diameterOfTree:(BinaryTreeNode *)rootNode;

@end

NS_ASSUME_NONNULL_END
