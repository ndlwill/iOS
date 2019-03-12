//
//  BinaryTree.h
//  NDL_Category
//
//  Created by dzcx on 2019/3/7.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BinaryTreeNode;

NS_ASSUME_NONNULL_BEGIN

@interface BinaryTree : NSObject

// 创建二叉排序树 二叉排序树：左节点值全部小于根节点值，右节点值全部大于根节点值
// return 二叉树根节点
+ (BinaryTreeNode *)createBinarySortTreeWithValues:(NSArray *)valueArray;

@end

NS_ASSUME_NONNULL_END
