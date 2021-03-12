//
//  SXTAttributedLink.h
//  01-CoreText绘制文字
//
//  Created by YanZhang on 15/4/10.
//  Copyright © 2015年 YanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYAttributedLink : NSObject

/**
 * 超链接文本内容
 */
@property (nonatomic, copy) NSString *text;

/**
 * 超文本内容在字符串中所在的位置
 */
@property (nonatomic, assign) NSRange range;

@end
