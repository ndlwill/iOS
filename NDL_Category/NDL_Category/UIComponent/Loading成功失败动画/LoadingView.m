//
//  LoadingView.m
//  NDL_Category
//
//  Created by dzcx on 2018/4/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "LoadingView.h"

#import "ArcToCircleLayer.h"


static CGFloat const kRadius = 50;// (1 / 4)宽度

static CGFloat const kStep3LayerWidth = 3.0;// thinLineWidth
static CGFloat const kStep3LayerHeight = 15.0;

static CGFloat const kStep4ThickLineWidth = 6.0;

static CGFloat const kStep4Scale = 0.8;

static CGFloat const kStep1AnimationDuration = 1.0;
static CGFloat const kStep2AnimationDuration = 0.5;
static CGFloat const kStep3AnimationDuration = 0.15;
static CGFloat const kStep4AnimationDuration = 0.25;
static CGFloat const kStep5AnimationDuration = 3;

static NSString * const kStep1AnimationKey = @"step1Animation";
static NSString * const kStep2AnimationKey = @"step2Animation";
static NSString * const kStep3AnimationKey = @"step3Animation";
static NSString * const kStep4_1AnimationKey = @"step4_1Animation";


@interface LoadingView () <CAAnimationDelegate>
{
    CGFloat _step2CircleTopOffsetStep1CircleTop;
}

@property (nonatomic, strong) ArcToCircleLayer *step1Layer;
@property (nonatomic, strong) CAShapeLayer *step2Layer;
@property (nonatomic, strong) CALayer *step3Layer;

@property (nonatomic, strong) CAShapeLayer *step4_2Layer;// 细线消失
@property (nonatomic, strong) CAShapeLayer *step4_3Layer;// 粗线出现

@end

// 200 * 200
@implementation LoadingView

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"===LoadingView Dealloc===");
}

#pragma mark - Public Methods
- (void)startAnimation
{
    [self reset];
    [self startStep1Animation];
}

#pragma mark - Private Methods
- (void)reset
{
    [self.step1Layer removeFromSuperlayer];
    [self.step2Layer removeFromSuperlayer];
    [self.step3Layer removeFromSuperlayer];
    [self.step4_2Layer removeFromSuperlayer];
    [self.step4_3Layer removeFromSuperlayer];
}

// execute执行
- (void)startStep1Animation
{
    self.step1Layer = [ArcToCircleLayer layer];
//    self.step1Layer.contentsScale = [UIScreen mainScreen].scale;
    self.step1Layer.color = [UIColor lightGrayColor];
    [self.layer addSublayer:self.step1Layer];
    
    CGFloat wh = 2 * kRadius;
    self.step1Layer.bounds = CGRectMake(0, 0, wh, wh);
    self.step1Layer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    self.step1Layer.progress = 1.0;// modelLayer status(end status)
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = kStep1AnimationDuration;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.delegate = self;
//    animation.removedOnCompletion = YES;// default : YES
    
    [animation setValue:kStep1AnimationKey forKey:@"name"];// kvc
    [self.step1Layer addAnimation:animation forKey:nil];
    
    
//    [self.step1Layer addAnimation:animation forKey:kStep1AnimationKey];
//    // 这边获取有值
//    NSLog(@"===step1Anim = %@===", [self.step1Layer animationForKey:kStep1AnimationKey]);
}

- (void)startStep2Animation
{
    self.step2Layer = [CAShapeLayer layer];
    self.step2Layer.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    [self.layer addSublayer:self.step2Layer];
    self.step2Layer.frame = self.layer.bounds;
    
    UIBezierPath *step2Path = [UIBezierPath bezierPath];
    // 控件的中心点
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat step2CircleCenterOffsetStep1CircleLeft = kRadius / 2;
    // step2中心点
    CGPoint step2Center = CGPointMake(center.x - kRadius - step2CircleCenterOffsetStep1CircleLeft, center.y);
    // 斜边(step2半径)
    CGFloat hypotenuse = 2 * kRadius + step2CircleCenterOffsetStep1CircleLeft;
    _step2CircleTopOffsetStep1CircleTop = kRadius;
    // 对边
    CGFloat subtense = kRadius + _step2CircleTopOffsetStep1CircleTop;
    // 邻边 : adjacent side
    CGFloat startAngle = 2 * M_PI;
    CGFloat endAngle = 2 * M_PI - asin(subtense / hypotenuse);
    [step2Path addArcWithCenter:step2Center radius:hypotenuse startAngle:startAngle endAngle:endAngle clockwise:NO];
    
    self.step2Layer.path = step2Path.CGPath;
    self.step2Layer.lineWidth = 3;
    self.step2Layer.strokeColor = [UIColor greenColor].CGColor;
    self.step2Layer.fillColor = NULL;
    
    
    CGFloat strokeStartFrom = 0;
    CGFloat strokeStartTo = 0.9;
    
    CGFloat strokeEndFrom = 0.1;
    CGFloat strokeEndTo = 1.0;
    
    // 默认 strokeStart = 0, strokeEnd = 1
    // endStatus
    self.step2Layer.strokeStart = strokeStartTo;
    self.step2Layer.strokeEnd = strokeEndTo;
    
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = @(strokeStartFrom);
    startAnimation.toValue = @(strokeStartTo);
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(strokeEndFrom);
    endAnimation.toValue = @(strokeEndTo);
    
    CAAnimationGroup *step2Animation = [CAAnimationGroup animation];
    step2Animation.animations = @[startAnimation, endAnimation];
    step2Animation.duration = kStep2AnimationDuration;
    step2Animation.delegate = self;
    step2Animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [step2Animation setValue:kStep2AnimationKey forKey:@"name"];
    [self.step2Layer addAnimation:step2Animation forKey:nil];
}

- (void)startStep3Animation
{
    [self.step2Layer removeFromSuperlayer];
    
    self.step3Layer = [CALayer layer];
    self.step3Layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:self.step3Layer];
    self.step3Layer.bounds = CGRectMake(0, 0, kStep3LayerWidth, kStep3LayerHeight);
    self.step3Layer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - kRadius - _step2CircleTopOffsetStep1CircleTop + kStep3LayerHeight / 2);
    
    CGPoint startPoint = self.step3Layer.position;
    CGPoint endPoint = CGPointMake(startPoint.x, CGRectGetMidY(self.bounds) - kRadius - kStep3LayerHeight / 2);
    
    // endStatus (值真正改变了)
    self.step3Layer.position = endPoint;
    
    CABasicAnimation *step3Animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    step3Animation.fromValue = @(startPoint.y);
    step3Animation.toValue = @(endPoint.y);
    step3Animation.duration = kStep3AnimationDuration;
    step3Animation.delegate = self;
    
    // endStatus (值没有被改变)
//    step3Animation.removedOnCompletion = NO;
//    step3Animation.fillMode = kCAFillModeForwards;
    
    [step3Animation setValue:kStep3AnimationKey forKey:@"name"];
    [self.step3Layer addAnimation:step3Animation forKey:nil];
}

- (void)startStep4Animation
{
    [self startStep4_1Animation];
    [self.step3Layer removeFromSuperlayer];
    [self startStep4_2Animation];
    [self startStep4_3Animation];
}

// 小圆变椭圆
- (void)startStep4_1Animation
{
    self.step1Layer.color = [UIColor redColor];
    CGRect originFrame = self.step1Layer.frame;
    self.step1Layer.anchorPoint = CGPointMake(0.5, 1.0);
    self.step1Layer.frame = originFrame;
    // frame是根据bounds、anchorPoint和position这3个属性算出来的,改变了anchorPoint，frame自然也跟着变了
    // 我们给frame指定新值，layer会自动调整position和bounds
    
    // yScale
    CGFloat yScaleFrom = 1.0;
    CGFloat yScaleTo = kStep4Scale;
    
    // xScale
    CGFloat xScaleFrom = 1.0;
    CGFloat xScaleTo = 1.1;
    
    // endStatus
    self.step1Layer.transform = CATransform3DMakeScale(xScaleTo, yScaleTo, 1.0);
    
    CABasicAnimation *yScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    yScaleAnimation.fromValue = @(yScaleFrom);
    yScaleAnimation.toValue = @(yScaleTo);
    
    CABasicAnimation *xScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    xScaleAnimation.fromValue = @(xScaleFrom);
    xScaleAnimation.toValue = @(xScaleTo);
    
    CAAnimationGroup *animation4_1 = [CAAnimationGroup animation];
    animation4_1.animations = @[yScaleAnimation, xScaleAnimation];
    animation4_1.duration = kStep4AnimationDuration;
//    animation4_1.autoreverses = YES;
    animation4_1.delegate = self;
    [animation4_1 setValue:kStep4_1AnimationKey forKey:@"name"];
    [self.step1Layer addAnimation:animation4_1 forKey:nil];
}

// 细线逐渐消失
- (void)startStep4_2Animation
{
    self.step4_2Layer = [CAShapeLayer layer];
    self.step4_2Layer.frame = self.bounds;
    [self.layer addSublayer:self.step4_2Layer];
    
    UIBezierPath *step4_2Path = [UIBezierPath bezierPath];
    CGFloat startY = CGRectGetMidY(self.bounds) - kRadius - kStep3LayerHeight;
    CGPoint startPoint = CGPointMake(CGRectGetMidX(self.bounds), startY);
    CGFloat pathHeight = kStep3LayerHeight + 2 * kRadius * (1.0 - kStep4Scale);
    CGPoint endPoint = CGPointMake(CGRectGetMidX(self.bounds), startY + pathHeight);
    [step4_2Path moveToPoint:startPoint];
    [step4_2Path addLineToPoint:endPoint];
    
    self.step4_2Layer.path = step4_2Path.CGPath;
    self.step4_2Layer.lineWidth = kStep3LayerWidth;
    self.step4_2Layer.strokeColor = [UIColor greenColor].CGColor;
    self.step4_2Layer.fillColor = NULL;
    
    CGFloat strokeStartFrom = 0;
    CGFloat strokeStartTo = 1.0;
    
    CGFloat strokeEndFrom = kStep3LayerHeight / pathHeight;
    CGFloat strokeEndTo = 1.0;
    
    // endStatus
    self.step4_2Layer.strokeStart = strokeStartTo;
    self.step4_2Layer.strokeEnd = strokeEndTo;
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(strokeStartFrom);
    strokeStartAnimation.toValue = @(strokeStartTo);
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(strokeEndFrom);
    strokeEndAnimation.toValue = @(strokeEndTo);
    
    CAAnimationGroup *step4_2Animation = [CAAnimationGroup animation];
    step4_2Animation.animations = @[strokeStartAnimation, strokeEndAnimation];
    step4_2Animation.duration = kStep4AnimationDuration;
    [self.step4_2Layer addAnimation:step4_2Animation forKey:nil];
}
// 粗线逐渐出现
- (void)startStep4_3Animation
{
    self.step4_3Layer = [CAShapeLayer layer];
    self.step4_3Layer.frame = self.bounds;
    [self.layer addSublayer:self.step4_3Layer];
    
    UIBezierPath *step4_3Path = [UIBezierPath bezierPath];
    CGFloat startY = CGRectGetMidY(self.bounds) - kRadius;
    CGPoint startPoint = CGPointMake(CGRectGetMidX(self.bounds), startY);
    CGFloat endY = CGRectGetMidY(self.bounds);
    CGPoint endPoint = CGPointMake(CGRectGetMidX(self.bounds), endY);
    [step4_3Path moveToPoint:startPoint];
    [step4_3Path addLineToPoint:endPoint];
    
    self.step4_3Layer.path = step4_3Path.CGPath;
    self.step4_3Layer.lineWidth = kStep4ThickLineWidth;
    self.step4_3Layer.strokeColor = [UIColor blueColor].CGColor;
    self.step4_3Layer.fillColor = NULL;
    
    CGFloat strokeStartFrom = 0;
    CGFloat strokeStartTo = (1 - kStep4Scale) * 2;
    
    CGFloat strokeEndFrom = 0;
    CGFloat strokeEndTo = 1.0;
    
    // endStatus
    self.step4_3Layer.strokeStart = strokeStartTo;
    self.step4_3Layer.strokeEnd = strokeEndTo;
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(strokeStartFrom);
    strokeStartAnimation.toValue = @(strokeStartTo);
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(strokeEndFrom);
    strokeEndAnimation.toValue = @(strokeEndTo);
    
    CAAnimationGroup *step4_3Animation = [CAAnimationGroup animation];
    step4_3Animation.animations = @[strokeStartAnimation, strokeEndAnimation];
    step4_3Animation.duration = kStep4AnimationDuration;
    [self.step4_3Layer addAnimation:step4_3Animation forKey:nil];
}

- (void)startStep5Animation
{
    
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // 上面这么设置的话[self.step1Layer addAnimation:animation forKey:kStep1AnimationKey]; animation.removedOnCompletion = YES; 如果animation.removedOnCompletion = NO;下边获取不为nil
    //[self.step1Layer animationForKey:kStep1AnimationKey];// 这边获取为nil

    if ([[anim valueForKey:@"name"] isEqualToString:kStep1AnimationKey]) {
        NSLog(@"Step1 Did Stop  后面还会执行一次Redraw (progress的值)");
        [self startStep2Animation];
    } else if ([[anim valueForKey:@"name"] isEqualToString:kStep2AnimationKey]) {
        [self startStep3Animation];
    } else if ([[anim valueForKey:@"name"] isEqualToString:kStep3AnimationKey]) {
//        NSLog(@"step3-position = %@", NSStringFromCGPoint(self.step3Layer.position));
        [self startStep4Animation];
    } else if ([[anim valueForKey:@"name"] isEqualToString:kStep4_1AnimationKey]) {
        [self startStep5Animation];
    }
}

@end
