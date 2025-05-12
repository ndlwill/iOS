//
//  NSMutableAttributedString+Link.m
//  01-CoreText绘制文字
//
//  Created by YanZhang on 15/4/10.
//  Copyright © 2015年 YanZhang. All rights reserved.
//

#import "NSMutableAttributedString+Link.h"
#import "NSMutableAttributedString+Attribute.h"
#import "ZYAttributedLink.h"

/**
 * 正则表达式
 *
 * @: (@([\u4e00-\u9fa5A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)._-]+))
 * ##: (#[\u4e00-\u9fa5A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)._-]+#)
 * URL: ((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)
 */

// 检查URL/@/##/
static NSString *const kLinkPattern = @"(@([\u4e00-\u9fa5A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)._-]+))|(#[\u4e00-\u9fa5A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)._-]+#)|((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

@implementation NSMutableAttributedString (Link)

/**
 * 设置link的字体和颜色
 */
- (NSArray *)setLinkWithLinkColor:(UIColor *)linkColor
                    linkFont:(UIFont *)linkFont
{
    // 用来保存link对象的数组
    NSMutableArray *arrM = [NSMutableArray array];
    
    // 正则处理@、#、url
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kLinkPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    // 遍历获取到的link
    [regex enumerateMatchesInString:self.string options:0 range:NSMakeRange(0, self.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        // 超文本在字符串中的范围
        NSRange range = result.range;
        // 获取对应的超文本字符串
        NSString *text = [self.string substringWithRange:range];
        
        // 初始化并设置link对象的属性
        ZYAttributedLink *linkData = [ZYAttributedLink new];
        linkData.text = text;
        linkData.range = range;
        
        // 设置超文本字体大小和颜色
        [self setFont:linkFont range:range];
        [self setTextColor:linkColor range:range];
        
        // 添加进入数组
        [arrM addObject:linkData];
    }];
    
    return arrM;
}

/**
 * 添加自定义链接
 */
static int kInitialLocation = 0;
- (NSArray *)setCustomLink:(NSString *)link
                 linkColor:(UIColor *)linkColor
                  linkFont:(UIFont *)linkFont
{
    // 1.设置初始位置为0
    kInitialLocation = 0;
    
    // 2.初始化存放SXTAttributedLink的数组
    NSMutableArray *customLinks = [NSMutableArray array];
    
    // 3.检查可变字符串中的所有link
    [self checkCustomLink:link string:self.string customLinks:customLinks];
    
    // 4.遍历数组，给数组中的link添加字体和颜色
    for (ZYAttributedLink *linkData in customLinks) {
        // 4.1设置超文本字体大小和颜色
        [self setFont:linkFont range:linkData.range];
        [self setTextColor:linkColor range:linkData.range];
    }

    return customLinks;
}

/**
 * 检查可变字符串中的所有link
 */
- (void)checkCustomLink:(NSString *)link
                 string:(NSString *)string
            customLinks:(NSMutableArray *)customLinks
{
    // 1.获取link在文本中的位置
    NSRange range = [string rangeOfString:link];
    // 2.检查是否存在
    if (range.location != NSNotFound) {
        // 2.1如果存在， 初始化并设置link对象的属性
        ZYAttributedLink *linkData = [ZYAttributedLink new];
        linkData.text = link;
        linkData.range = NSMakeRange(kInitialLocation + range.location, range.length);
        // 2.2添加对象到数组保存
        [customLinks addObject:linkData];
        
        // 3.递归继续查询
        // 3.1设置新的查询字符串
        NSString *result = [string substringFromIndex:range.location + range.length];
        
        // 3.2更新起始点位置
        kInitialLocation += range.location + range.length;
        // 3.3递归继续查询
        [self checkCustomLink:link string:result customLinks:customLinks];
    }
}

@end
