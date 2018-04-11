//
//  UIColor+NDLExtension.m
//  NDL_Category
//
//  Created by ndl on 2018/1/31.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "UIColor+NDLExtension.h"

@implementation UIColor (NDLExtension)

+ (instancetype)ndl_colorWithHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if (colorString.length < 6) {
        return [UIColor clearColor];
    }
    
    if ([colorString hasPrefix:@"0X"]) {
        colorString = [colorString substringFromIndex:2];
    }
    
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    }
    
    if (colorString.length != 6) {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    // r
    NSString *rString = [colorString substringWithRange:range];
    
    // g
    range.location = 2;
    NSString *gString = [colorString substringWithRange:range];
    
    // b
    range.location = 4;
    NSString *bString = [colorString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0];
}

// arc4random_uniform(x)  0~(x-1)  alpha（不透明度）:0 透明，看不见
+ (instancetype)ndl_randomColor
{
    CGFloat r = arc4random_uniform(256) / 255.0f;
    CGFloat g = arc4random_uniform(256) / 255.0f;
    CGFloat b = arc4random_uniform(256) / 255.0f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

@end
