//
//  NSObject+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/5/23.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NDLExtension)

// 模型转字典 // 针对一层模型
- (NSDictionary *)ndl_model2Dictionary;

- (id)ndl_performSelector:(SEL)selector withObjects:(NSArray<id> *)objects;

@end
