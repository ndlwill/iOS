//
//  Node.h
//  NDL_Category
//
//  Created by dzcx on 2018/11/29.
//  Copyright © 2018 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

// 节点
@interface Node : NSObject

@property (nonatomic, strong) Node *previous;
@property (nonatomic, strong) Node *next;

@property (nonatomic, strong) id data;

@end
