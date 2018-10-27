//
//  NSString+NDLSize.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/6.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NSString+NDLSize.h"

@implementation NSString (NDLSize)

- (CGSize)ndl_sizeForSingleLineStringWithFont:(UIFont *)font
{
    return [self sizeWithAttributes:@{NSFontAttributeName : font}];// iOS7.0
}

- (CGSize)ndl_sizeForMultiLinesStringWithAttributes:(NSDictionary *)attributeDic maxWidth:(CGFloat)maxWidth
{
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);//CGFLOAT_MAX
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil].size;
}

- (CGSize)ndl_sizeForMultiLinesStringWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    NSMutableDictionary *attributeDic = [NSMutableDictionary dictionary];
    attributeDic[NSFontAttributeName] = font;
    return [self ndl_sizeForMultiLinesStringWithAttributes:[attributeDic copy] maxWidth:maxWidth];
}

@end
