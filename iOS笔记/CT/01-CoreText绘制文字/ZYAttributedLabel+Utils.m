//
//  SXTAttributedLabel+Utils.m
//  01-CoreText绘制文字
//
//  Created by YanZhang on 15/4/10.
//  Copyright © 2015年 YanZhang. All rights reserved.//

#import "ZYAttributedLabel+Utils.h"
#import "NSMutableAttributedString+FrameRef.h"
#import "UIView+frameAdjust.h"
#import "ZYAttributedLink.h"

@implementation ZYAttributedLabel (Utils)
@dynamic frameRef;
@dynamic linkArr;
@dynamic imageArr;

/**
 * 检测点击位置是否在链接上
 * ->若在链接上，返回SXTAttributedLink
 *   包含超文本内容和range
 * ->如果没点中反回nil
 */
- (ZYAttributedLink *)touchLinkWithPosition:(CGPoint)position
{
    // 0.判断linkArr是否有值
    if (!self.linkArr || !self.linkArr.count) return nil;
    
    // 1.获取点击位置转换成字符串的偏移量，如果没有找到，则返回-1
    CFIndex index = [self touchPosition:position];
    
    // 2.如果没找到对应的索引，直接返回nil
    if (index == -1) return nil;

    // 3.返回被选中的链接所对应的数据模型，如果没选中SXTAttributedLink为nil
    return [self linkAtIndex:index];
}

/**
 * 监测点击的位置是否在图片上
 * ->若在链接上，返回SXTAttributedImage
 * ->如果没点中反回nil
 */
- (ZYAttributedImage *)touchContentOffWithPosition:(CGPoint)position
{
    // 1.获取点击位置转换成字符串的偏移量，如果没有找到，则返回-1
    CFIndex index = [self touchPosition:position];
    
    // 2.如果没找到对应的索引，直接返回nil
    if (index == -1) return nil;

    // 3.判断index在哪个图片上
    // 3.1准备谓词查询语句
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"position == %@", @(index)];
    NSArray *resultArr = [self.imageArr filteredArrayUsingPredicate:predicate];
    // 3.2获取符合条件的对象
    ZYAttributedImage *imageData = [resultArr firstObject];
    
    return imageData;
}

/**
 * 获取点击位置转换成字符串的偏移量，如果没有找到，则返回-1
 */
- (CFIndex)touchPosition:(CGPoint)position
{
    // 1.获取LineRef的行数
    CFArrayRef lines = CTFrameGetLines(self.frameRef);
    
    // 2.若lines不存在，返回－1
    if (!lines) return -1;
    
    // 3.获取lineRef的个数
    CFIndex lineCount = CFArrayGetCount(lines);
    
    // 4.准备旋转用的transform
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    // 5.获取每一行的位置的数组
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, 0), lineOrigins);
    
    // 6.遍历lines，处理每一行可能会对应的偏移值索引
    NSInteger index = -1;
    for (CFIndex idx = 0; idx < lineCount; idx ++) {
        // 6.1获取每一行的lineRef
        CTLineRef lineRef = CFArrayGetValueAtIndex(lines, idx);
        // 6.2获取每一行的rect
        CGRect flippedRect = CTLineGetTypographicBoundsAsRect(lineRef, lineOrigins[idx]);
        // 6.3翻转坐标系
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        // 6.4判断点中的点是否在这一行中
        if (CGRectContainsPoint(rect, position)) {
            // 6.5将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(position.x - CGRectGetMinX(rect),
                                                position.y - CGRectGetMinY(rect));
            // 6.6获取点击位置所处的字符位置，就是相当于点击了第几个字符
            index = CTLineGetStringIndexForPosition(lineRef, relativePoint);
        }
    }

    return index;
}

/**
 * 返回被选中的链接所对应的数据模型
 * 如果没选中SXTAttributedLink为nil
 */
- (ZYAttributedLink *)linkAtIndex:(CFIndex)index
{
    ZYAttributedLink *link = nil;
    
    for (ZYAttributedLink *linkData in self.linkArr) {
        // 如果index在data.range中，这证明点中链接
        if (NSLocationInRange(index, linkData.range)) {
            link = linkData;
            break;
        }
    }
    return link;
}
@end
