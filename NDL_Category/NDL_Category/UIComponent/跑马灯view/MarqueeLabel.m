//
//  MarqueeLabel.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/18.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "MarqueeLabel.h"
#import "CALayer+NDLExtension.h"
//#import "GradientView.h"

@interface MarqueeLabel ()

@property (nonatomic, strong) CADisplayLink *displayLink;
//@property (nonatomic, strong) GradientView *leftFadeView;
//@property (nonatomic, strong) GradientView *rightFadeView;

@property (nonatomic, strong) CAGradientLayer *leftFadeLayer;
@property (nonatomic, strong) CAGradientLayer *rightFadeLayer;

@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat textWidth;

@property (nonatomic, assign) BOOL firstFlag;

@property (nonatomic, strong) UIColor *edgeFadeEndColor;

// 1 表示不首尾连接，大于 1 表示首尾连接
@property(nonatomic, assign) NSInteger textRepeatCount;

@end


@implementation MarqueeLabel
#pragma mark - Lazy Load
// 不该用懒加载
//- (CAGradientLayer *)leftFadeLayer
//{
//    if (!_leftFadeLayer) {
//        _leftFadeLayer = [CAGradientLayer layer];
//        _leftFadeLayer.startPoint = CGPointMake(0, 0.5);
//        _leftFadeLayer.endPoint = CGPointMake(1, 0.5);
//
//        [self.layer addSublayer:_leftFadeLayer];
//    }
//    return _leftFadeLayer;
//}
//
//- (CAGradientLayer *)rightFadeLayer
//{
//    if (!_rightFadeLayer) {
//        _rightFadeLayer = [CAGradientLayer layer];
//        _rightFadeLayer.startPoint = CGPointMake(1, 0.5);
//        _rightFadeLayer.endPoint = CGPointMake(0, 0.5);
//
//        [self.layer addSublayer:_rightFadeLayer];
//    }
//    return _rightFadeLayer;
//}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.lineBreakMode = NSLineBreakByClipping;
        self.clipsToBounds = YES;
        
        [self _didInitialized];
    }
    return self;
}

- (void)dealloc
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}


#pragma mark - Private Methods
- (void)_didInitialized
{
    self.speed = 0.5;
    self.stayDurationWhenMoveToEdge = 2.5;
    self.textSpacing = 40;
    
    self.edgeFadeStartColor = NDLRGBAColor(255, 255, 255, 1);// 使用懒加载必须在self.showEdgeFadeFlag = YES;之前设置
    self.showEdgeFadeFlag = YES;
    self.edgeFadeWidth = 20;
    
    self.showTextAtFadeTailFlag = YES;
    
    self.firstFlag = YES;
    self.textRepeatCount = 2;
}

- (BOOL)_shouldResumeDisplayLink
{
    BOOL flag = self.window && (self.width > 0) && (self.textWidth > (self.width - ((self.showEdgeFadeFlag && self.showTextAtFadeTailFlag) ? self.edgeFadeWidth : 0)));
    
    return flag;
}

- (void)_resetText
{
    self.offsetX = 0;
    self.textWidth = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    self.displayLink.paused = ![self _shouldResumeDisplayLink];
}

- (void)_initialFadeLayers
{
    if (!self.leftFadeLayer) {
        self.leftFadeLayer = [CAGradientLayer layer];
        self.leftFadeLayer.startPoint = CGPointMake(0, 0.5);
        self.leftFadeLayer.endPoint = CGPointMake(1, 0.5);
        [self.layer addSublayer:self.leftFadeLayer];
        [self setNeedsLayout];// 布局layer frame
    }
    
    if (!self.rightFadeLayer) {
        self.rightFadeLayer = [CAGradientLayer layer];
        self.rightFadeLayer.startPoint = CGPointMake(1, 0.5);
        self.rightFadeLayer.endPoint = CGPointMake(0, 0.5);
        [self.layer addSublayer:self.rightFadeLayer];
        [self setNeedsLayout];
    }
    
    [self _updateFadeLayersColors];
}

- (void)_updateFadeLayersColors
{
    if (self.leftFadeLayer) {
        self.leftFadeLayer.colors = @[(__bridge id)self.edgeFadeStartColor.CGColor, (__bridge id)self.edgeFadeEndColor.CGColor];
    }
    
    if (self.rightFadeLayer) {
        self.rightFadeLayer.colors = @[(__bridge id)self.edgeFadeStartColor.CGColor, (__bridge id)self.edgeFadeEndColor.CGColor];
    }
}

- (void)_updateFadeLayersHidden
{
    if (!self.leftFadeLayer || !self.rightFadeLayer) {
        return;
    }
    
    BOOL showLeftFadeFlag = self.showEdgeFadeFlag && (self.offsetX < 0 || (self.offsetX ==0 && !self.firstFlag));
    self.leftFadeLayer.hidden = !showLeftFadeFlag;
    
    BOOL showRightFadeFlag = self.showEdgeFadeFlag && (self.textWidth > self.width) && self.offsetX != (self.textWidth - self.width);
    self.rightFadeLayer.hidden = !showRightFadeFlag;
}

#pragma mark - Overrides
// 跳转页面也会调用self.window = null 返回self.window = 一个window
// 官方: ##告诉试图他的window对象改变了## 所以可能moveTo一个window也可能moveTo一个null window
- (void)didMoveToWindow
{
    [super didMoveToWindow];
    NSLog(@"===Marquee didMoveToWindow window = %@===", self.window);
    
    if (self.window) {
        // 进入后台暂停 进入前台继续
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    } else {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    
    self.offsetX = 0;
    self.displayLink.paused = ![self _shouldResumeDisplayLink];
}

// 重绘
- (void)drawTextInRect:(CGRect)rect
{
    CGFloat textInitialX = 0;
    if (self.textAlignment == NSTextAlignmentLeft) {
        textInitialX = 0;
    }

    CGFloat textOffsetXByFade = textInitialX < self.edgeFadeWidth ? ((self.showEdgeFadeFlag && self.showTextAtFadeTailFlag) ? self.edgeFadeWidth : 0) : 0;
    textInitialX += textOffsetXByFade;

    for (NSInteger i = 0; i < self.textRepeatCountConsiderTextWidth; i++) {
        [self.attributedText drawInRect:CGRectMake(self.offsetX + (self.textWidth + self.textSpacing) * i + textInitialX, 0, self.textWidth, CGRectGetHeight(rect))];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.showEdgeFadeFlag) {
        if (self.leftFadeLayer) {
            self.leftFadeLayer.frame = CGRectMake(0, 0, self.edgeFadeWidth, self.height);
            // 显示非英文字符时，UILabel 内部会额外多出一层 layer 盖住了这里的leftFadeLayer，所以要手动设置到最前面
            [self.layer ndl_bringSubLayerToFront:self.leftFadeLayer];
        }
        
        if (self.rightFadeLayer) {
            self.rightFadeLayer.frame = CGRectMake(self.width - self.edgeFadeWidth, 0, self.edgeFadeWidth, self.height);
            [self.layer ndl_bringSubLayerToFront:self.rightFadeLayer];
        }
    }
}

#pragma mark - Setter
- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    numberOfLines = 1;
    [super setNumberOfLines:numberOfLines];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self _resetText];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self _resetText];
}

- (void)setFrame:(CGRect)frame
{
    BOOL sizeEqualFlag = CGSizeEqualToSize(frame.size, self.size);
    [super setFrame:frame];
    if (!sizeEqualFlag) {
        self.offsetX = 0;
        self.displayLink.paused = ![self _shouldResumeDisplayLink];
    }
}

- (void)setShowEdgeFadeFlag:(BOOL)showEdgeFadeFlag
{
    _showEdgeFadeFlag = showEdgeFadeFlag;
    
    if (showEdgeFadeFlag) {
        [self _initialFadeLayers];
    }
}

- (void)setEdgeFadeStartColor:(UIColor *)edgeFadeStartColor
{
    if (!edgeFadeStartColor) {
        return;
    }
    
    _edgeFadeStartColor = edgeFadeStartColor;
    _edgeFadeEndColor = [edgeFadeStartColor colorWithAlphaComponent:0];
    [self _updateFadeLayersColors];
}

- (void)setOffsetX:(CGFloat)offsetX
{
    _offsetX = offsetX;
    
    [self _updateFadeLayersHidden];
}

#pragma mark - Getter
- (NSInteger)textRepeatCountConsiderTextWidth {
    if (self.textWidth < self.width) {
        return 1;
    }
    return self.textRepeatCount;
}

#pragma mark - CADisplayLink
- (void)handleDisplayLink:(CADisplayLink *)displayLink {
    if (self.offsetX == 0) {
        displayLink.paused = YES;
        [self setNeedsDisplay];
        
        NSInteger delay = (self.firstFlag || self.textRepeatCount <= 1) ? self.stayDurationWhenMoveToEdge : 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            displayLink.paused = ![self _shouldResumeDisplayLink];
            if (!displayLink.paused) {
                self.offsetX -= self.speed;
            }
        });
        
        if (delay > 0 && self.textRepeatCount > 1) {
            self.firstFlag = NO;
        }
        
        return;
    }
    
    self.offsetX -= self.speed;
    [self setNeedsDisplay];
    
    if (-self.offsetX >= self.textWidth + (self.textRepeatCountConsiderTextWidth > 1 ? self.textSpacing : 0)) {
        displayLink.paused = YES;
        NSInteger delay = self.textRepeatCount > 1 ? self.stayDurationWhenMoveToEdge : 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.offsetX = 0;
            [self handleDisplayLink:displayLink];
        });
    }
}

@end
