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
    /**
     arc4random_uniform(uint32_t)会随机返回一个0到上界之间（不含上界）的整数
     求一个1~100的随机数
     Int(arc4random_uniform(100)) + 1
     
     arc4random(void)这个全局函数会生成9位数的随机整数。使用arc4random()函数求一个1~100的随机数（包括1和100）
     Int(arc4random()%100) + 1
     */
    CGFloat r = arc4random_uniform(256) / 255.0f;
    CGFloat g = arc4random_uniform(256) / 255.0f;
    CGFloat b = arc4random_uniform(256) / 255.0f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

+ (instancetype)ndl_interpolationColorWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor percentComplete:(CGFloat)percentComplete
{
    CGFloat fromRed = 0.0;
    CGFloat fromGreen = 0.0;
    CGFloat fromBlue = 0.0;
    CGFloat fromAlpha = 0.0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0.0;
    CGFloat toGreen = 0.0;
    CGFloat toBlue = 0.0;
    CGFloat toAlpha = 0.0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = fromRed + (toRed - fromRed) * percentComplete;
    CGFloat newGreen = fromGreen + (toGreen - fromGreen) * percentComplete;
    CGFloat newBlue = fromBlue + (toBlue - fromBlue) * percentComplete;
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

@end
