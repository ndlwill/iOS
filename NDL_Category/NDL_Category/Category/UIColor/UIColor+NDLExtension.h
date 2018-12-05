//
//  UIColor+NDLExtension.h
//  NDL_Category
//
//  Created by ndl on 2018/1/31.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NDLExtension)

// (eg:@"#ccff88")
+ (instancetype)ndl_colorWithHexString:(NSString *)hexString;

// 随机颜色
+ (instancetype)ndl_randomColor;

// 插值颜色
+ (instancetype)ndl_interpolationColorWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor percentComplete:(CGFloat)percentComplete;

@end
