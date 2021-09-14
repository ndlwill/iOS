//
//  SXTAttributedLabel+Draw.m
//  01-CoreText绘制文字
//
//  Created by YanZhang on 15/4/10.
//  Copyright © 2015年 YanZhang. All rights reserved.
//

#import "ZYAttributedLabel+Draw.h"
#import "NSMutableAttributedString+FrameRef.h"
#import "ZYAttributedImage.h"
#import "UIView+frameAdjust.h"
#import "UIImageView+GIF.h"

/**
 * 绘制高亮背景圆角半径
 */
static CGFloat kRadius = 2.f;

@implementation ZYAttributedLabel (Draw)
@dynamic attributedString;
@dynamic frameRef;
@dynamic selectedLink;

/**
 * 绘制高亮背景颜色
 */
- (void)drawHighlightedColor
{
    if (self.selectedLink && self.frameRef) {
        // 1.获取选中的link所在的位置
        NSRange linkRange = self.selectedLink.range;
        
        // 2.获取每一行lineRef所在的位置
        // 2.1获取lineRef的数组
        CFArrayRef lines = CTFrameGetLines(self.frameRef);
        // 2.2获取lineRef的个数
        CFIndex lineCount = CFArrayGetCount(lines);
        // 2.3获取每行LineRef所在的坐标
        CGPoint lineOrigins[lineCount];
        CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, 0), lineOrigins);
        
        // 3.循环遍历每一组中是否包含link
        for (CFIndex idx = 0; idx < lineCount; idx ++) {
            // 3.1根据lineRef的数组获取对应行的lineRef
            CTLineRef lineRef = CFArrayGetValueAtIndex(lines, idx);
            // 3.2判断当前行(CTLineRef)中是否有包含link
            if (CTLineContainsCharactersFromStringRange(lineRef, linkRange)) continue;
            
            // 3.3获取点中link的rect
            CGRect highlightRect = CTRunGetTypographicBoundsForLinkRect(lineRef, linkRange, lineOrigins[idx]);
            
            // 3.4如果返回的highlightRect不为空，则绘制
            if (!CGRectIsEmpty(highlightRect)) {
                // 3.4.1绘制高亮背景
                [self drawBackgroundColorWithRect:highlightRect];
            }
        }
    }
}

/**
 * 绘制选中链接的高亮背景
 */
- (void)drawBackgroundColorWithRect:(CGRect)rect
{
    CGFloat pointX = rect.origin.x;
    CGFloat pointY = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 填充颜色
    [self.highlightColor setFill];
    
    // 移动到初始点
    CGContextMoveToPoint(context, pointX, pointY);
    
    // 绘制第1条线和第1个1/4圆弧，右上圆弧
    CGContextAddLineToPoint(context, pointX + width - kRadius, pointY);
    CGContextAddArc(context, pointX + width - kRadius, pointY + kRadius, kRadius, -0.5*M_PI, 0.0, 0);
    
    // 绘制第2条线和第2个1/4圆弧，右下圆弧
    CGContextAddLineToPoint(context, pointX + width, pointY + height - kRadius);
    CGContextAddArc(context, pointX + width - kRadius, pointY + height - kRadius, kRadius, 0.0, 0.5*M_PI, 0);
    
    // 绘制第3条线和第3个1/4圆弧，左下圆弧
    CGContextAddLineToPoint(context, pointX + kRadius, pointY + height);
    CGContextAddArc(context, pointX + kRadius, pointY + height - kRadius, kRadius, 0.5*M_PI, M_PI, 0);
    
    // 绘制第4条线和第4个1/4圆弧，左上圆弧
    CGContextAddLineToPoint(context, pointX, pointY + kRadius);
    CGContextAddArc(context, pointX + kRadius, pointY + kRadius, kRadius, M_PI, 1.5*M_PI, 0);
    
    // 闭合路径
    CGContextFillPath(context);
}

/**
 * 绘制图片
 */
- (void)drawImages
{
    // 如果_frameRef不存在，直接退出
    if (!self.frameRef) return;
    
    // 移除以前的图片视图
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    // 1.获取需要展示的行数
    // 1.1获取lineRef的数组
    CFArrayRef lines = CTFrameGetLines(self.frameRef);
    // 1.2获取lineRef的个数
    CFIndex lineCount = CFArrayGetCount(lines);
    // 1.3计算需要展示的行树
    NSUInteger numberOfLines = self.numberOfLines != 0 ? MIN(lineCount, self.numberOfLines) : lineCount;
    
    //  2.获取每一行的起始位置数组
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, numberOfLines), lineOrigins);
    
    // 3.循环遍历每一组中是否包含link
    for (CFIndex idx = 0; idx < numberOfLines; idx ++) {
        // 3.1寻找图片占位符的准备工作
        // 3.1.1获取idx对应行的lineRef
        CTLineRef lineRef = CFArrayGetValueAtIndex(lines, idx);
        // 3.1.2获取当前lineRef中的runRef数组
        CFArrayRef runs = CTLineGetGlyphRuns(lineRef);
        // 3.1.3获取当前lineRef中的runRef的个数
        CFIndex runCount = CFArrayGetCount(runs);
        // 3.1.4获取每一行对应的位置
        CGPoint lineOrigin = lineOrigins[idx];
        
        // 3.2遍历lineRef中的runRef,查找图片占位符
        for (CFIndex idx = 0; idx < runCount; idx ++) {
            // 3.2.1获取lineRef中对应的RunRef
            CTRunRef runRef = CFArrayGetValueAtIndex(runs, idx);
            // 3.2.2获取对应runRef的属性字典
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(runRef);
            // 3.2.3获取对应runRef的CTRunDelegateRef
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            // 3.2.3如果不存在，直接退出本次遍历
            // ->证明不是图片，因为我们只给图片设置了CTRunDelegateRef
            if (nil == delegate) continue;
            
            // －>证明图片在runRef里
            // 4.开始绘制图片
            // 4.1获取图片的数据模型
            ZYAttributedImage *imageData = (ZYAttributedImage *)CTRunDelegateGetRefCon(delegate);
            
            // 4.2获取需要展示图片的frame
            CGRect imageFrame = CTRunGetTypographicBoundsForImageRect(runRef, lineRef, lineOrigin, imageData);
            
            // 4.3添加图片
            if (imageData.imageType == SXTImageGIFTppe) {
                // 初始化imageView
                UIImageView *imageView = [UIImageView imageViewWithGIFName:imageData.imageName frame:imageFrame];
                // 调整imageView的Y坐标
                [imageView setY:self.height - imageView.height - imageView.y];
                [self addSubview:imageView];
            }else{
                // 添加图形上下文
                CGContextRef context = UIGraphicsGetCurrentContext();
                UIImage *image = [UIImage imageNamed:imageData.imageName];
                // 绘制图片
                CGContextDrawImage(context, imageFrame, image.CGImage);
            }
        }
    }
}

/**
 * 绘制文字
 */
- (void)frameLineDraw
{
    // 0.如果self.frameRef为空，直接返回
    if (!self.frameRef) return;
    
    // 1.计算当前需要绘制文字的行数
    // 1.1获取lineRef的数组
    CFArrayRef lines = CTFrameGetLines(self.frameRef);
    // 1.2获取lineRef的个数
    CFIndex lineCount = CFArrayGetCount(lines);
    // 1.3计算需要展示的行树
    NSUInteger numberOfLines = self.numberOfLines != 0 ? MIN(lineCount, self.numberOfLines) : lineCount;
    
    //  2.获取每一行的起始位置数组
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, numberOfLines), lineOrigins);
    
    // 3.遍历需要显示文字的行数，并绘制每一行的现实内容
    for (CFIndex idx = 0; idx < numberOfLines; idx ++) {
        // 3.0获取图形上下文和每一行对应的lineRef
        CGContextRef context = UIGraphicsGetCurrentContext();
        CTLineRef lineRef = CFArrayGetValueAtIndex(lines, idx);
        
        // 3.1设置文本的起始绘制位置
        CGContextSetTextPosition(context, lineOrigins[idx].x, lineOrigins[idx].y);
        
        // 3.2设置是否需要完整绘制一行文字的标记
        BOOL shouldDrawLine = YES;
        
        NSLog(@"%ld, %ld, %ld", idx, numberOfLines, self.numberOfLines);
        // 3.3处理最后一行
        if (idx == numberOfLines - 1 && self.numberOfLines != 0) {
            // 3.3.1.处理最后一行的文字绘制
            [self drawLastLineWithLineRef:lineRef];
            
            // 3.3.2标记不用完整的去绘制一行文字
            shouldDrawLine = NO;
        }
        
        // 3.4绘制完整的一行文字
        if (shouldDrawLine) {
            CTLineDraw(lineRef, context);
        }
    }
}

/**
 * 绘制最后一行文字
 */
- (void)drawLastLineWithLineRef:(CTLineRef)lineRef
{
    // 1.获取当前行在文本中的范围
    CFRange lastLineRange = CTLineGetStringRange(lineRef);
    // 2.比较最后显示行的最后一个文字的长度和文本的总长度
    // -> 最后一个文字的长度 < 文本的总长度
    // -> 用户设置了限制文本长度，单独处理最后一个的最后一个字符即可
    if (lastLineRange.location + lastLineRange.length < (CFIndex)self.attributedString.length) {
        // 2.1获取最后一行的属性字符串
        NSMutableAttributedString *truncationString = [[self.attributedString attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
        
        if (lastLineRange.length > 0) {
            // 2.2获取最后一个字符
            unichar lastCharacter = [[truncationString string] characterAtIndex:lastLineRange.length - 1];
            
            // 2.3判断Unicode字符集是否包含lastCharacter
            if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:lastCharacter]) {
                // 2.4.1安全的删除truncationString中最后一个字符
                [truncationString deleteCharactersInRange:NSMakeRange(lastLineRange.length - 1, 1)];
            }
        }
        
        // 2.5获取截断属性的位置
        NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
        
        // 2.6获取需要截断的属性
        NSDictionary *tokenAttributes = [self.attributedString attributesAtIndex:truncationAttributePosition effectiveRange:NULL];
        
        //  2.7初始化一个带属性字符串 -> “...”
        static NSString* const kEllipsesCharacter = @"\u2026";
        NSMutableAttributedString *tokenString = [[NSMutableAttributedString alloc] initWithString:kEllipsesCharacter attributes:tokenAttributes];
        
        // 2.8把“...”添加到最后一行尾部
        [truncationString appendAttributedString:tokenString];
        
        // 2.9处理最后一行的lineRef
        CTLineRef truncationLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationString);
        CTLineTruncationType truncationType = kCTLineTruncationEnd;
        
        CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)tokenString);
        
        CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, self.frame.size.width, truncationType, truncationToken);
        
        if (!truncatedLine) {
            truncatedLine = CFRetain(truncationToken);
        }
        CFRelease(truncationLine);
        CFRelease(truncationToken);
        
        // 绘制本行文字
        CGContextRef context = UIGraphicsGetCurrentContext();
        CTLineDraw(truncatedLine, context);
        CFRelease(truncatedLine);
    }
}

@end
