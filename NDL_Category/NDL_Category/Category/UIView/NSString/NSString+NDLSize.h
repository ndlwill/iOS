//
//  NSString+NDLSize.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/6.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NDLSize)

// 单行文字size
- (CGSize)ndl_sizeForSingleLineStringWithFont:(UIFont *)font;

// 多行文字size
- (CGSize)ndl_sizeForMultiLinesStringWithAttributes:(NSDictionary *)attributeDic maxWidth:(CGFloat)maxWidth;
- (CGSize)ndl_sizeForMultiLinesStringWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

@end
