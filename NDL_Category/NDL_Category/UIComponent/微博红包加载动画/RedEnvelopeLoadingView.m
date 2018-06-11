//
//  RedEnvelopeLoadingView.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/7.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "RedEnvelopeLoadingView.h"

@interface RedEnvelopeLoadingView ()

// UI
@property (nonatomic, strong) UILabel *leftDotLabel;
@property (nonatomic, strong) UILabel *rightDotLabel;

@property (nonatomic, assign) CGFloat dotsSpace;
@property (nonatomic, assign) CGFloat dotWH;

@end

//static CGFloat const kHalfDuration = 0.5;
static CGFloat const kTotalDuration = 2.0;

@implementation RedEnvelopeLoadingView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame dotsSpace:(CGFloat)spaceValue
{
    if (self = [super initWithFrame:frame]) {
        _dotsSpace = spaceValue;
        
        [self setupUI];
        
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateUIPerFrame)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

#pragma mark - CADisplayLink
// 解决遮挡问题
- (void)updateUIPerFrame
{
    // 一定要用frame , bound不变 我也不知道为啥😄
    CGFloat leftLabelW = self.leftDotLabel.layer.presentationLayer.frame.size.width;
    CGFloat rightLabelW = self.rightDotLabel.layer.presentationLayer.frame.size.width;

    if (leftLabelW < rightLabelW) {
        [self bringSubviewToFront:self.rightDotLabel];
    } else if (leftLabelW > rightLabelW) {
        [self bringSubviewToFront:self.leftDotLabel];
    }
}

#pragma mark - Private Methods
- (void)setupUI
{
    _dotWH = (self.width - _dotsSpace) / 2.0;
    // LeftLabel
    self.leftDotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _dotWH, _dotWH)];
    self.leftDotLabel.backgroundColor = [UIColor ndl_randomColor];
    self.leftDotLabel.layer.cornerRadius = _dotWH / 2.0;
    self.leftDotLabel.layer.masksToBounds = YES;
    self.leftDotLabel.textAlignment = NSTextAlignmentCenter;
    self.leftDotLabel.font = [UIFont boldSystemFontOfSize:20.0];
    self.leftDotLabel.text = @"￥";
    [self addSubview:self.leftDotLabel];
    
    // RightLabel
    self.rightDotLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - _dotWH, 0, _dotWH, _dotWH)];
    self.rightDotLabel.backgroundColor = [UIColor ndl_randomColor];
    self.rightDotLabel.layer.cornerRadius = _dotWH / 2.0;
    self.rightDotLabel.layer.masksToBounds = YES;
    self.rightDotLabel.textAlignment = NSTextAlignmentCenter;
    self.rightDotLabel.font = [UIFont boldSystemFontOfSize:20.0];
    self.rightDotLabel.text = @"￥";
    [self addSubview:self.rightDotLabel];
}

// 顺时针clockwise:YES 逆时针anticlockwise
- (CAAnimation *)leftAnimationWithClosewiseFlag:(BOOL)closewise
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    // 位移动画
    CAKeyframeAnimation *translationAnim = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    // values的第一个为 初始值 不设置一开始在@(self.width / 2.0)开始执行动画
    translationAnim.values = @[@(_dotWH / 2.0), @(self.width / 2.0), @(self.width - _dotWH / 2.0), @(self.width / 2.0), @(_dotWH / 2.0)];
    
    // 缩放动画
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    // values的第一个为 初始值
    if (closewise) {
        scaleAnim.values = @[@(1.0), @(0.7), @(1.0), @(1.3), @(1.0)];
    } else {
        scaleAnim.values = @[@(1.0), @(1.3), @(1.0), @(0.7), @(1.0)];
    }
    
    group.animations = @[translationAnim, scaleAnim];
    group.duration = kTotalDuration;
    group.repeatCount = MAXFLOAT;
    //    group.removedOnCompletion = NO;
    //    group.fillMode = kCAFillModeForwards;
    
    return group;
}

- (CAAnimation *)rightAnimationWithClosewiseFlag:(BOOL)closewise
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    CAKeyframeAnimation *translationAnim = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    translationAnim.values = @[@(self.width - _dotWH / 2.0), @(self.width / 2.0), @(_dotWH / 2.0), @(self.width / 2.0), @(self.width - _dotWH / 2.0)];
    
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    if (closewise) {
        scaleAnim.values = @[@(1.0), @(1.3), @(1.0), @(0.7), @(1.0)];
    } else {
        scaleAnim.values = @[@(1.0), @(0.7), @(1.0), @(1.3), @(1.0)];
    }
    
    group.animations = @[translationAnim, scaleAnim];
    group.duration = kTotalDuration;
    group.repeatCount = MAXFLOAT;
    
    return group;
}

#pragma mark - Public Methods
- (void)startAnimation
{
    if (self.moveDirection == RedEnvelopeLoadingDirection_Left) {
        [self.leftDotLabel.layer addAnimation:[self leftAnimationWithClosewiseFlag:YES] forKey:nil];
        [self.rightDotLabel.layer addAnimation:[self rightAnimationWithClosewiseFlag:YES] forKey:nil];
    } else if (self.moveDirection == RedEnvelopeLoadingDirection_Right) {
        [self.leftDotLabel.layer addAnimation:[self leftAnimationWithClosewiseFlag:NO] forKey:nil];
        [self.rightDotLabel.layer addAnimation:[self rightAnimationWithClosewiseFlag:NO] forKey:nil];
    }
}



/*
- (CAAnimationGroup *)getLeft2MiddleAnimation
{
//    CGFloat dotWH = (self.width - _dotsSpace) / 2.0;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    CABasicAnimation *leftToMiddle = [CABasicAnimation animation];
    leftToMiddle.keyPath = @"position.x";// 中心点的x
    leftToMiddle.toValue = @(self.width / 2.0);
//    translateToMiddle.keyPath = @"transform.translation.x";// 左边的x
//    translateToMiddle.toValue = @(self.width / 2.0 - dotWH / 2.0);
    
    group.animations = @[[self getScaleToSmallAnimation], leftToMiddle];
    group.duration = kHalfDuration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    return group;
}

- (CAAnimationGroup *)getMiddle2RightAnimation
{
    CGFloat dotWH = (self.width - _dotsSpace) / 2.0;
    CAAnimationGroup *group = [CAAnimationGroup animation];

    CABasicAnimation *middleToRight = [CABasicAnimation animation];
    //    middleToRight.keyPath = @"position.x";// 中心点的x
    //    middleToRight.toValue = @(self.width - dotWH / 2.0);
    middleToRight.keyPath = @"transform.translation.x";// 左边的x
    middleToRight.toValue = @(self.width - dotWH);
    
    group.animations = @[[self getScaleToBigAnimation], middleToRight];
    group.duration = kHalfDuration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    return group;
}

- (CABasicAnimation *)getScaleToSmallAnimation
{
    CABasicAnimation *scaleToSmall = [CABasicAnimation animation];
    scaleToSmall.keyPath = @"transform.scale";
    scaleToSmall.toValue = @(0.5);
    return scaleToSmall;
}

- (CABasicAnimation *)getScaleToBigAnimation
{
    CABasicAnimation *scaleToBig = [CABasicAnimation animation];
    scaleToBig.keyPath = @"transform.scale";
    scaleToBig.toValue = @(1.0);
    return scaleToBig;
}
 */

@end
