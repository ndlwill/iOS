//
//  BadgeView.m
//  NDL_Category
//
//  Created by dzcx on 2018/9/11.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "BadgeView.h"

//static const CGFloat BadgeViewHeight = 17.0f;// FontSize:14
//static const CGFloat BadgeViewHeight = 18.0f;// FontSize:15

@implementation BadgeView

#pragma mark - class methods
+ (void)initialize
{
    if (self == [BadgeView class]) {
        [self configeCommonSettings];
    }
}

+ (void)configeCommonSettings
{
    BadgeView *badgeView = [BadgeView appearance];
    badgeView.backgroundColor = [UIColor clearColor];
    
    // 默认右上角，红底，白字（font:15）
    badgeView.alignment = BadgeViewAlignment_TopRight;
    badgeView.badgeBackgroundColor = [UIColor redColor];
    badgeView.badgeTextColor = [UIColor whiteColor];
    badgeView.badgeTextFont = [UIFont systemFontOfSize:15.0];
    
    // shadow
    badgeView.badgeShadowColor = nil;
    badgeView.badgeTextShadowColor = nil;
    badgeView.badgeShadowBlur = 1.0;
    // stroke
    badgeView.badgeStrokeWidth = 1.0f;
    badgeView.badgeStrokeColor = badgeView.badgeBackgroundColor;
    
    badgeView.badgeTextOffsetEdgeTotalWidthMargin = 8.0;
    badgeView.badgeMinWH = 8.0;
}

#pragma mark - init
- (instancetype)initWithParentView:(UIView *)parentView alignment:(BadgeViewAlignment)alignment
{
    if (self = [super initWithFrame:CGRectZero]) {
        _alignment = alignment;
        [parentView addSubview:self];
    }
    return self;
}

#pragma mark - setting
// =====reDraw=====
- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    if (badgeBackgroundColor != _badgeBackgroundColor) {
        _badgeBackgroundColor = badgeBackgroundColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    if (badgeTextColor != _badgeTextColor) {
        _badgeTextColor = badgeTextColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setBadgeTextShadowOffset:(CGSize)badgeTextShadowOffset
{
    _badgeTextShadowOffset = badgeTextShadowOffset;
    
    [self setNeedsDisplay];
}

- (void)setBadgeTextShadowColor:(UIColor *)badgeTextShadowColor
{
    if (badgeTextShadowColor != _badgeTextShadowColor) {
        _badgeTextShadowColor = badgeTextShadowColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setBadgeStrokeColor:(UIColor *)badgeStrokeColor
{
    if (badgeStrokeColor != _badgeStrokeColor) {
        _badgeStrokeColor = badgeStrokeColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setBadgeShadowOffset:(CGSize)badgeShadowOffset
{
    if (!CGSizeEqualToSize(badgeShadowOffset, _badgeShadowOffset)) {
        _badgeShadowOffset = badgeShadowOffset;
        
        [self setNeedsDisplay];
    }
}

- (void)setBadgeShadowColor:(UIColor *)badgeShadowColor
{
    if (badgeShadowColor != _badgeShadowColor) {
        _badgeShadowColor = badgeShadowColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setBadgeShadowBlur:(CGFloat)badgeShadowBlur
{
    _badgeShadowBlur = badgeShadowBlur;
    
    [self setNeedsDisplay];
}

// =====reLayout=====
- (void)setBadgeText:(NSString *)badgeText
{
    if (badgeText != _badgeText) {
        _badgeText = [badgeText copy];
        
        [self setNeedsLayout];
    }
}

- (void)setAlignment:(BadgeViewAlignment)alignment
{
    if (alignment != _alignment) {
        _alignment = alignment;
        
        [self setNeedsLayout];
    }
}

- (void)setBadgeTextFont:(UIFont *)badgeTextFont
{
    if (badgeTextFont != _badgeTextFont) {
        _badgeTextFont = badgeTextFont;
        
        [self setNeedsLayout];
    }
}

- (void)setBadgeStrokeWidth:(CGFloat)badgeStrokeWidth
{
    if (badgeStrokeWidth != _badgeStrokeWidth) {
        _badgeStrokeWidth = badgeStrokeWidth;
        
        [self setNeedsLayout];
    }
}

- (void)setBadgeTextOffsetEdgeTotalWidthMargin:(CGFloat)badgeTextOffsetEdgeTotalWidthMargin
{
    _badgeTextOffsetEdgeTotalWidthMargin = badgeTextOffsetEdgeTotalWidthMargin;
    
    [self setNeedsLayout];
}

- (void)setBadgePositionOffset:(CGPoint)badgePositionOffset
{
    _badgePositionOffset = badgePositionOffset;
    
    [self setNeedsLayout];
}

- (void)setBadgeMinWH:(CGFloat)badgeMinWH
{
    _badgeMinWH = badgeMinWH;
    
    [self setNeedsLayout];
}

#pragma mark - overrides
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"===BadgeView layoutSubviews===");
    
    CGRect newFrame = self.frame;
    CGRect superviewBounds = self.superview.bounds;

    NSDictionary *attrDic = @{NSFontAttributeName : self.badgeTextFont};
    
    CGFloat viewWidth = 0.0;
    CGFloat viewHeight = 0.0;
    if (self.badgeText && self.badgeText.length > 0) {// 有text
        CGSize textSize = [self.badgeText sizeWithAttributes:attrDic];

        CGFloat strokeTotalLen = self.badgeStrokeWidth * 2;
        
        viewWidth = textSize.width + _badgeTextOffsetEdgeTotalWidthMargin + strokeTotalLen;
        viewHeight = textSize.height + strokeTotalLen;
        
        newFrame.size.width = viewWidth;
        newFrame.size.height = viewHeight;
    } else {// red point
        viewWidth = _badgeMinWH;
        viewHeight = _badgeMinWH;
        newFrame.size = CGSizeMake(viewWidth, viewHeight);
    }
    
    CGFloat superviewWidth = superviewBounds.size.width;
    CGFloat superviewHeight = superviewBounds.size.height;
   
    switch (self.alignment) {
        case BadgeViewAlignment_TopLeft:
            newFrame.origin.x = -viewWidth / 2.0f;
            newFrame.origin.y = -viewHeight / 2.0f;
            break;
        case BadgeViewAlignment_TopRight:
            newFrame.origin.x = superviewWidth - (viewWidth / 2.0f);
            newFrame.origin.y = -viewHeight / 2.0f;
            break;
        case BadgeViewAlignment_TopCenter:
            newFrame.origin.x = (superviewWidth - viewWidth) / 2.0f;
            newFrame.origin.y = -viewHeight / 2.0f;
            break;
        case BadgeViewAlignment_LeftCenter:
            newFrame.origin.x = -viewWidth / 2.0f;
            newFrame.origin.y = (superviewHeight - viewHeight) / 2.0f;
            break;
        case BadgeViewAlignment_RightCenter:
            newFrame.origin.x = superviewWidth - (viewWidth / 2.0f);
            newFrame.origin.y = (superviewHeight - viewHeight) / 2.0f;
            break;
        case BadgeViewAlignment_BottomLeft:
            newFrame.origin.x = -viewWidth / 2.0f;
            newFrame.origin.y = superviewHeight - (viewHeight / 2.0f);
            break;
        case BadgeViewAlignment_BottomRight:
            newFrame.origin.x = superviewWidth - (viewWidth / 2.0f);
            newFrame.origin.y = superviewHeight - (viewHeight / 2.0f);
            break;
        case BadgeViewAlignment_BottomCenter:
            newFrame.origin.x = (superviewWidth - viewWidth) / 2.0f;
            newFrame.origin.y = superviewHeight - (viewHeight / 2.0f);
            break;
        case BadgeViewAlignment_Center:
            newFrame.origin.x = (superviewWidth - viewWidth) / 2.0f;
            newFrame.origin.y = (superviewHeight - viewHeight) / 2.0f;
            break;
        default:
            break;
    }
    
    newFrame.origin.x += _badgePositionOffset.x;
    newFrame.origin.y += _badgePositionOffset.y;
    
    // 计算自己的frame
    self.bounds = CGRectIntegral(CGRectMake(0, 0, CGRectGetWidth(newFrame), CGRectGetHeight(newFrame)));
    self.center = CGPointMake(ceilf(CGRectGetMidX(newFrame)), ceilf(CGRectGetMidY(newFrame)));
    
    [self setNeedsDisplay];
}

// layout->draw
- (void)drawRect:(CGRect)rect
{
    NSLog(@"===BadgeView drawRect===");
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect rectToDraw = CGRectInset(rect, self.badgeStrokeWidth / 2.0, self.badgeStrokeWidth / 2.0);
    CGFloat cornerRadius = rectToDraw.size.width > rectToDraw.size.height ? rectToDraw.size.height : rectToDraw.size.width;
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:rectToDraw byRoundingCorners:(UIRectCorner)UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    
    /* Background and shadow */
    CGContextSaveGState(ctx);
    {
        CGContextAddPath(ctx, borderPath.CGPath);
        
        // 设置背景色
        CGContextSetFillColorWithColor(ctx, self.badgeBackgroundColor.CGColor);
        
        if (self.badgeShadowColor) {
            // param2:shadow offset
            CGContextSetShadowWithColor(ctx, self.badgeShadowOffset, self.badgeShadowBlur, self.badgeShadowColor.CGColor);
        }
        
        CGContextDrawPath(ctx, kCGPathFill);
    }
    CGContextRestoreGState(ctx);
    
    /* Stroke */
    CGContextSaveGState(ctx);
    {
        CGContextAddPath(ctx, borderPath.CGPath);
        
        CGContextSetLineWidth(ctx, self.badgeStrokeWidth);
        CGContextSetStrokeColorWithColor(ctx, self.badgeStrokeColor.CGColor);
        
        CGContextDrawPath(ctx, kCGPathStroke);
    }
    CGContextRestoreGState(ctx);
    
    if (self.badgeText && self.badgeText.length > 0) {// 有Text
        /* Text */
        CGContextSaveGState(ctx);
        {
            CGContextSetShadowWithColor(ctx, self.badgeTextShadowOffset, self.badgeShadowBlur, self.badgeTextShadowColor.CGColor);
            
            CGRect textFrame = rectToDraw;
            
            NSDictionary *attrDic = @{NSFontAttributeName : self.badgeTextFont};
            CGSize textSize = [self.badgeText sizeWithAttributes:attrDic];
            
            textFrame.size.height = textSize.height;
            textFrame.origin.y = rectToDraw.origin.y + floorf((rectToDraw.size.height - textFrame.size.height) / 2.0f);
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByClipping;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            NSDictionary *textAttrDic = @{NSFontAttributeName: self.badgeTextFont, NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: self.badgeTextColor};
            [self.badgeText drawInRect:textFrame withAttributes:textAttrDic];
        }
        CGContextRestoreGState(ctx);
    }
}

@end
