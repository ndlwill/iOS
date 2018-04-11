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

+ (instancetype)ndl_randomColor;

@end
