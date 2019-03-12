//
//  BinaryTreeNode.h
//  NDL_Category
//
//  Created by dzcx on 2019/3/7.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BinaryTreeNode : NSObject

@property (nonatomic, assign) NSInteger value;

@property (nonatomic, strong) BinaryTreeNode *leftNode;
@property (nonatomic, strong) BinaryTreeNode *rightNode;

@end

NS_ASSUME_NONNULL_END
