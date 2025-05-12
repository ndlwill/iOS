//
//  NSMutableAttributedString+FrameRef.h
//  01-CoreText绘制文字
//
//  Created by YanZhang on 15/4/10.
//  Copyright © 2015年 YanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@class ZYAttributedImage;

@interface NSMutableAttributedString (FrameRef)

/**
 * 判断当前行(CTLineRef)中是否包含超文本链接
 */
BOOL CTLineContainsCharactersFromStringRange(CTLineRef lineRef, NSRange range);

/**
 * 判断当前runRef(CTRunRef)中是否包含超文本链接
 */
BOOL CTRunContainsCharactersFromStringRange(CTRunRef runRef, NSRange range);

/**
 * 获取点中link的rect
 */
CGRect CTRunGetTypographicBoundsForLinkRect(CTLineRef lineRef, NSRange range, CGPoint lineOrigin);

/**
 * 获取每一行(lineRef)的rect
 */
CGRect CTLineGetTypographicBoundsAsRect(CTLineRef lineRef, CGPoint lineOrigin);


/**
 * 获取对应runRef的rect
 */
CGRect CTRunGetTypographicBoundsAsRect(CTRunRef runRef, CTLineRef lineRef, CGPoint lineOrigin);

/**
 * 获取图片的rect
 */
CGRect CTRunGetTypographicBoundsForImageRect(CTRunRef runRef, CTLineRef lineRef, CGPoint lineOrigin, ZYAttributedImage *imageData);

/**
 * 获取frameRef
 */
- (CTFrameRef)prepareFrameRefWithRect:(CGRect)rect;

/**
 * 根据属性字符串、宽度和展示行数，计算其所占用的size
 */
- (CGSize)sizeWithWidth:(CGFloat)width
          numberOfLines:(NSUInteger)numberOfLines;

@end
