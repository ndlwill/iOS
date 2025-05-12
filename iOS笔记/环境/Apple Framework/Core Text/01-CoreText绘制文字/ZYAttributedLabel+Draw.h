//
//  SXTAttributedLabel+Draw.h
//  01-CoreText绘制文字
//
//  Created by YanZhang on 15/4/10.
//  Copyright © 2015年 YanZhang. All rights reserved.//

#import "ZYAttributedLabel.h"

@interface ZYAttributedLabel (Draw)

/*************************只读属性*************************/
/**
 * 属性字符串
 */
@property (nonatomic, strong, readonly) NSMutableAttributedString *attributedString;

/**
 * frameRef
 */
@property (nonatomic, assign, readonly) CTFrameRef frameRef;

/**
 * 选中超文本的数据模型
 */
@property (nonatomic, strong, readonly) ZYAttributedLink *selectedLink;

/*************************共有方法*************************/

/**
 * 绘制图片
 */
- (void)drawImages;

/**
 * 绘制文字
 */
- (void)frameLineDraw;

/**
 * 绘制高亮背景颜色
 */
- (void)drawHighlightedColor;

@end
