//
//  NSMutableAttributedString+Link.h
//  01-CoreText绘制文字
//
//  Created by YanZhang on 15/4/10.
//  Copyright © 2015年 YanZhang. All rights reserved.//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Link)

/**
 * 设置link的字体和颜色
 */
- (NSArray *)setLinkWithLinkColor:(UIColor *)linkColor
                         linkFont:(UIFont *)linkFont;

/**
 * 添加自定义链接
 */
- (NSArray *)setCustomLink:(NSString *)link
                 linkColor:(UIColor *)linkColor
                  linkFont:(UIFont *)linkFont;

@end
