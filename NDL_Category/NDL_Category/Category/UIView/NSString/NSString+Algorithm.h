//
//  NSString+Algorithm.h
//  NDL_Category
//
//  Created by dzcx on 2019/8/25.
//  Copyright © 2019 ndl. All rights reserved.
//

/*
 MARK:NSString内存
 NSString *test1 = @"a";
 NSString *test2 = [NSString stringWithString:@"b"];
 NSString *test3 = [NSString stringWithFormat:@"c"];
 NSString *test4 = [[NSString alloc] initWithString:@"d"];
 NSString *test5 = [[NSString alloc] initWithFormat:@"e"];
 
 test1, test2, test4: 常量区 __NSCFConstantString
 test3, test5: 堆区 NSTaggedPointerString
 
 为了节省内存和提高执行效率，苹果提出了Tagged Pointer
 
 Tagged Pointer专门用来存储小的对象
 将一个对象的指针拆成两部分，一部分直接保存数据，另一部分作为特殊标记，表示这是一个特别的指针，不指向任何一个地址
 Tagged Pointer通过在其最后一个bit位设置一个特殊标记，用于将数据直接保存在指针本身中。因为Tagged Pointer并不是真正的对象
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Algorithm)

- (NSString *)ndl_reverseString;

@end

NS_ASSUME_NONNULL_END
