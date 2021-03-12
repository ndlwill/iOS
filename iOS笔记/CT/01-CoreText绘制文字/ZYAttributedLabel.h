//
//  SXTAttributedLabel.h
//  CoreText绘制文字
//
//  Created by YanZhang on 15/4/10.
//  Copyright © 2015年 YanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYAttributedLink.h"
#import "ZYAttributedImage.h"
#import <CoreText/CoreText.h>

@class ZYAttributedLabel;

@protocol SXTAttributedLabelDelegate <NSObject>

/**
 * 选中超文本的回调
 * -> 被选中的超文本selectedLink
 */
- (void)attributedLabel:(ZYAttributedLabel *)label selectedLink:(ZYAttributedLink *)selectedLink;

/**
 * 选中图片的回调
 * -> 被选中的图片selectedImage
 */
- (void)attributedLabel:(ZYAttributedLabel *)label selectedImage:(ZYAttributedImage *)selectedImage;

@end

@interface ZYAttributedLabel : UIView

/**
 * 代理
 */
@property (nonatomic, weak) id<SXTAttributedLabelDelegate> delegate;

/**
 * 显示字体
 */
@property (nonatomic, strong) UIFont *font;

/**
 * 超链接文本字体大小
 */
@property (nonatomic, strong) UIFont *linkFont;

/**
 * 显示文字颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 * 超链接文本字体颜色
 */
@property (nonatomic, strong) UIColor *linkColor;

/**
 * 选中超文本选中颜色
 */
@property (nonatomic, strong) UIColor *highlightColor;

/**
 * 显示文字行数
 */
@property (nonatomic, assign) NSUInteger numberOfLines;

/**
 * 设置显示图片大小
 * 如未做设置，图片大小为文字高度的正方形
 */
@property (nonatomic, assign) CGSize imageSize;

/**
 * 设置普通文本
 */
- (void)setText:(NSString *)text;

/**
 * 设置属性文本
 */
- (void)setAttributedText:(NSAttributedString *)attributedText;

/**
 * 添加自定义链接
 */
- (void)addCustomLink:(NSString *)link;
- (void)addCustomLink:(NSString *)link
            linkColor:(UIColor *)linkColor
             linkFont:(UIFont *)linkFont;

@end
