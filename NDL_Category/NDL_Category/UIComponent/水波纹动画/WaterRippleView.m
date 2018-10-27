//
//  WaterRippleView.m
//  NDL_Category
//
//  Created by dzcx on 2018/9/7.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "WaterRippleView.h"

@interface WaterRippleView ()

// for test
@property (nonatomic, weak) CAShapeLayer *shapeLayer;

@end

@implementation WaterRippleView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame originWH:(CGFloat)originWH
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _originWH = originWH;
        [self _initialConfiguration];
        
        // 方案1:
//        [self _setupLayerWithOriginWH:originWH];
        // 方案2:
        [self _setupReplicatorLayer];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"###WaterRippleView Dealloc###");
}

// 你离开了应用后(比如进入了后台),所有的动画都从他们的layer上移除了:因为系统调用了removeAllAnimations,针对所有的layer
#pragma mark - overrides
- (void)didMoveToWindow
{
    /*
     initWithFrame中不写下面 动画被移除了(没有动画执行) 动画为nil
     //    groupAnimation.removedOnCompletion = NO;
     //    groupAnimation.fillMode = kCAFillModeForwards;
     */
    NSLog(@"===WaterRippleView didMoveToWindow = %@ animKeys = %@ anim = %@===", self.window, [self.shapeLayer animationKeys], [self.shapeLayer animationForKey:@"WaterRipple"]);
    [super didMoveToWindow];
    // 方案1:
//    [self _setupLayerWithOriginWH:_originWH];
    
    // 方案2:
}

#pragma mark - private methods
- (void)_initialConfiguration
{
    _rippleStrokeColor = [UIColor blackColor];
    _rippleLineWidth = 1.0;
    _duration = 2.0;
}

// 方案2:CAReplicatorLayer
- (void)_setupReplicatorLayer
{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = self.bounds;
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceDelay = _duration / 3;
    [self.layer addSublayer:replicatorLayer];
    
    CGFloat originX = self.width / 2.0 - _originWH / 2.0;
    CGFloat originY = self.height / 2.0 - _originWH / 2.0;
    UIBezierPath *originPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(originX, originY, _originWH, _originWH)];
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    
    CAShapeLayer *shapeLayer = [self _layerWithPath:originPath];
    shapeLayer.frame = self.bounds;
    shapeLayer.opacity = 0.0;
    [replicatorLayer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id _Nullable)(originPath.CGPath);
    pathAnimation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[pathAnimation, opacityAnimation];
    groupAnimation.duration = _duration;
    groupAnimation.repeatCount = HUGE_VALF;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeForwards;
    
    [shapeLayer addAnimation:groupAnimation forKey:@"WaterRipple"];
}

// 方案1:
- (void)_setupLayerWithOriginWH:(CGFloat)originWH
{
    CGFloat originX = self.width / 2.0 - originWH / 2.0;
    CGFloat originY = self.height / 2.0 - originWH / 2.0;
    UIBezierPath *originPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(originX, originY, originWH, originWH)];
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    
    CAShapeLayer *layer1 = [self _layerWithPath:originPath];
    layer1.frame = self.bounds;
//    layer1.opacity = 0.0;
    [self.layer addSublayer:layer1];
    
    CAShapeLayer *layer2 = [self _layerWithPath:originPath];
    layer2.frame = self.bounds;
    layer2.opacity = 0.0;
    [self.layer addSublayer:layer2];
    
    CAShapeLayer *layer3 = [self _layerWithPath:originPath];
    layer3.frame = self.bounds;
    layer3.opacity = 0.0;
    [self.layer addSublayer:layer3];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id _Nullable)(originPath.CGPath);
    pathAnimation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1);
    opacityAnimation.toValue = @(0);

    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[pathAnimation, opacityAnimation];
    groupAnimation.duration = _duration;
    groupAnimation.repeatCount = HUGE_VALF;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeForwards;
    
    [layer1 addAnimation:groupAnimation forKey:nil];
    groupAnimation.beginTime = CACurrentMediaTime() + _duration / 3.0;// 延迟_duration的1/3
    [layer2 addAnimation:groupAnimation forKey:nil];
    groupAnimation.beginTime = CACurrentMediaTime() + 2 * _duration / 3.0;// 延迟_duration的2/3
    [layer3 addAnimation:groupAnimation forKey:nil];
}

- (CAShapeLayer *)_layerWithPath:(UIBezierPath *)path
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.strokeColor = _rippleStrokeColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = _rippleLineWidth;
    // shadow
    layer.shadowRadius = 2.0;
    layer.shadowColor = [UIColor redColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, -2);
    layer.shadowOpacity = 0.8;
    return layer;
}

@end
