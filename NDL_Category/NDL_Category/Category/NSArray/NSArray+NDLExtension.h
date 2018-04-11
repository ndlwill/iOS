//
//  NSArray+NDLExtension.h
//  NDL_Category
//
//  Created by ndl on 2018/1/24.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NDLExtension)

// 没有重复对象的数组
- (NSArray *)ndl_uniqueObjectArray;

// 反转数组
- (NSArray *)ndl_reversedArray;

// 排序
// (nullable NSString *)key
// key : 排序key, 某个对象的属性名称; 如果对字符串进行排序, 则传nil(@"2134" 在 @“345”前面)
// ascending : 是否升序, YES-升序, NO-降序
- (NSArray *)ndl_sortWithKey:(NSString *)key ascending:(BOOL)ascending;
/*
 // 按年龄升序排列, 相同的再按身高降序排列
 NSSortDescriptor *ageSort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
 NSSortDescriptor *heightSort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
 [peoples sortUsingDescriptors:@[ageSort, heightSort]];
 */

@end
