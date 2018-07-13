//
//  TestModel.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/9.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject <NSCoding>

// 用于NSObject对象
//- (instancetype)init NS_UNAVAILABLE;
//+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithView:(UIView *)view NS_DESIGNATED_INITIALIZER;

- (void)publicMethod:(NSString *)str;

@end
