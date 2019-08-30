//
//  NSString+Algorithm.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/25.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "NSString+Algorithm.h"

@implementation NSString (Algorithm)

- (NSString *)ndl_reverseString
{
    // 1.逆序遍历字符串
//    NSMutableString *str = [NSMutableString string];
//    for (NSInteger i = self.length - 1; i >= 0; i--) {
////        unichar ch = [self characterAtIndex:i];
//        NSString *ch = [self substringWithRange:NSMakeRange(i, 1)];
//        NSLog(@"ch = %@", ch);
//        [str appendString:ch];
//    }
//    return [str copy];
    
    // 2.双指针法：遍历字符串，将对称位置上与当前位置上交换字符
    NSUInteger len = self.length;
    NSString *resultStr = [self copy];
    for (NSInteger i = 0; i < (len / 2); i++) {
        NSRange frontRange = NSMakeRange(i, 1);
        NSRange backRange = NSMakeRange(len - 1 - i, 1);
        NSString *FrontStr = [self substringWithRange:frontRange];
        NSString *backStr = [self substringWithRange:backRange];
        NSLog(@"front = %@ back = %@", FrontStr, backStr);
        resultStr = [resultStr stringByReplacingCharactersInRange:frontRange withString:backStr];
        NSLog(@"result = %@", resultStr);
        resultStr = [resultStr stringByReplacingCharactersInRange:backRange withString:FrontStr];
        NSLog(@"result = %@", resultStr);
    }
    
    return resultStr;
    
    // 使用递归实现
}

@end
