//
//  YouKuPlayButton.m
//  NDL_Category
//
//  Created by dzcx on 2018/8/28.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "YouKuPlayButton.h"

// Animation TimeLine
/*
 0  1/4 1/2 3/4  1 ratio
 |---|---|---|---| kAnimationDuration
 |---|---|         LineLayer
 |---|---|---|---| ArcLayer
     |---|---|---| Rotation
         |---|---| Alpha
 */

#define LineLayerColor [UIColor colorWithRed:62/255.0 green:157/255.0 blue:254/255.0 alpha:1]
#define ArcLayerColor [UIColor colorWithRed:87/255.0 green:188/255.0 blue:253/255.0 alpha:1]

#define CenterColor [UIColor colorWithRed:228/255.0 green:35/255.0 blue:6/255.0 alpha:0.8]

#define LineWidthRatio 0.18

static const CGFloat kAnimationDuration = 0.35f;

@interface YouKuPlayButton ()
{
    CAShapeLayer *_leftLineLayer;
    CAShapeLayer *_rightLineLayer;
    
    CAShapeLayer *_leftArcLayer;
    CAShapeLayer *_rightArcLayer;
    
    CALayer *_triangleContainerLayer;
    
    BOOL _isAnimating;
}

@end

@implementation YouKuPlayButton

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame state:(YouKuButtonState)buttonState
{
    if (self = [super initWithFrame:frame]) {
        [self _setupUI];
        
        self.buttonState = buttonState;
    }
    return self;
}

#pragma mark - Private
- (void)_setupUI
{
    [self _addLeftArcLayer];
    [self _addRightArcLayer];
    
    [self _addLeftLineLayer];
    [self _addRightLineLayer];
    
    [self _addCenterLayer];
}

// bottom是起点
- (void)_addLeftLineLayer
{
    CGFloat wh = self.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // line的水平中心点在point的位置
    [path moveToPoint:CGPointMake(wh * 0.2, wh * 0.9 - [self _roundLineCapLength])];
    [path addLineToPoint:CGPointMake(wh * 0.2, wh * 0.1 + [self _roundLineCapLength])];
    
    _leftLineLayer = [self _lineLayerWithPath:path];
    [self.layer addSublayer:_leftLineLayer];
}

// top是起点
- (void)_addRightLineLayer
{
    CGFloat wh = self.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(wh * 0.8, wh * 0.1 + [self _roundLineCapLength])];
    [path addLineToPoint:CGPointMake(wh * 0.8, wh * 0.9 - [self _roundLineCapLength])];
    
    _rightLineLayer = [self _lineLayerWithPath:path];
    [self.layer addSublayer:_rightLineLayer];
}

- (CAShapeLayer *)_lineLayerWithPath:(UIBezierPath *)path
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = [self _lineWidth];
    layer.lineCap = kCALineCapRound;
//    layer.lineJoin = kCALineJoinRound;
    layer.strokeColor = LineLayerColor.CGColor;
    return layer;
}

- (void)_addLeftArcLayer
{
    CGFloat wh = self.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(wh * 0.2, wh * 0.9 - [self _roundLineCapLength])];
    // 对边
    CGFloat subtense = (0.5 - 0.2) * wh;
    // 邻边
    CGFloat adjacent = (0.9 * wh - [self _roundLineCapLength]) - 0.5 * wh;
    // 斜边
    CGFloat hypotenuse = sqrt(pow(subtense, 2) + pow(adjacent, 2));
    CGFloat radius = hypotenuse;
    CGFloat startAngle = acos(adjacent / hypotenuse) + M_PI_2;
    CGFloat endAngle = startAngle - M_PI;
    [path addArcWithCenter:CGPointMake(wh * 0.5, wh * 0.5) radius:radius startAngle:startAngle endAngle:endAngle clockwise:NO];
    
    _leftArcLayer = [self _arcLayerWithPath:path];
    [self.layer addSublayer:_leftArcLayer];
}

- (void)_addRightArcLayer
{
    CGFloat wh = self.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(wh * 0.8, wh * 0.1 + [self _roundLineCapLength])];
    // 对边
    CGFloat subtense = (0.8 - 0.5) * wh;
    // 邻边
    CGFloat adjacent = 0.5 * wh - (0.1 * wh + [self _roundLineCapLength]);
    // 斜边
    CGFloat hypotenuse = sqrt(pow(subtense, 2) + pow(adjacent, 2));
    CGFloat radius = hypotenuse;
    CGFloat startAngle = -acos(adjacent / hypotenuse);
    CGFloat endAngle = startAngle - M_PI;
    [path addArcWithCenter:CGPointMake(wh * 0.5, wh * 0.5) radius:radius startAngle:startAngle endAngle:endAngle clockwise:NO];
    
    _rightArcLayer = [self _arcLayerWithPath:path];
    [self.layer addSublayer:_rightArcLayer];
}

- (CAShapeLayer *)_arcLayerWithPath:(UIBezierPath *)path
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = [self _lineWidth];
    layer.lineCap = kCALineCapRound;
//    layer.lineJoin = kCALineJoinRound;
    layer.strokeColor = ArcLayerColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeEnd = 0;
    return layer;
}

- (void)_addCenterLayer
{
    CGFloat wh = self.width;
    
    CGFloat containerW = 0.3 * wh;
    CGFloat containerH = 0.25 * wh;
    
    _triangleContainerLayer = [CALayer layer];
//    _triangleContainerLayer.backgroundColor = [UIColor cyanColor].CGColor;
    _triangleContainerLayer.bounds = CGRectMake(0, 0, containerW, containerH);
    _triangleContainerLayer.position = CGPointMake(0.5 * wh, 0.5 * wh);
    _triangleContainerLayer.opacity = 0;
    [self.layer addSublayer:_triangleContainerLayer];
    
    // 1.
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointZero];
    [path1 addLineToPoint:CGPointMake(containerW / 2, containerH)];
    
    CAShapeLayer *layer1 = [CAShapeLayer layer];
    layer1.path = path1.CGPath;
    layer1.strokeColor = CenterColor.CGColor;
    layer1.lineWidth = [self _lineWidth];
    layer1.lineCap = kCALineCapRound;
//    layer1.lineJoin = kCALineJoinRound;
    [_triangleContainerLayer addSublayer:layer1];
    
    // 2.
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(containerW, 0)];
    [path2 addLineToPoint:CGPointMake(containerW / 2, containerH)];
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.path = path2.CGPath;
    layer2.strokeColor = CenterColor.CGColor;
    layer2.lineWidth = [self _lineWidth];
    layer2.lineCap = kCALineCapRound;
//    layer2.lineJoin = kCALineJoinRound;
    [_triangleContainerLayer addSublayer:layer2];
}

- (CGFloat)_lineWidth
{
    return self.width * LineWidthRatio;
}

- (CGFloat)_roundLineCapLength
{
    return [self _lineWidth] * 0.5;
}

- (void)_showPauseAnimation
{
    [self _executeStrokeEndAnimationOnLayer:_leftLineLayer fromValue:1 toValue:0 duration:kAnimationDuration / 2];
    [self _executeStrokeEndAnimationOnLayer:_rightLineLayer fromValue:1 toValue:0 duration:kAnimationDuration / 2];
    
    [self _executeStrokeEndAnimationOnLayer:_leftArcLayer fromValue:0 toValue:1 duration:kAnimationDuration];
    [self _executeStrokeEndAnimationOnLayer:_rightArcLayer fromValue:0 toValue:1 duration:kAnimationDuration];
    
    // 旋转动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  kAnimationDuration / 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self _executeRotationAnimationClockwise:NO];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  kAnimationDuration / 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self _executeOpacityAnimationWithDuration:kAnimationDuration / 2 fromValue:0 toValue:1];
    });
}

- (void)_showPlayAnimation
{
    [self _executeStrokeEndAnimationOnLayer:_leftArcLayer fromValue:1 toValue:0 duration:kAnimationDuration];
    [self _executeStrokeEndAnimationOnLayer:_rightArcLayer fromValue:1 toValue:0 duration:kAnimationDuration];
    
    [self _executeOpacityAnimationWithDuration:kAnimationDuration / 2 fromValue:1 toValue:0];
    [self _executeRotationAnimationClockwise:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kAnimationDuration / 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self _executeStrokeEndAnimationOnLayer:_leftLineLayer fromValue:0 toValue:1 duration:kAnimationDuration / 2];
        [self _executeStrokeEndAnimationOnLayer:_rightLineLayer fromValue:0 toValue:1 duration:kAnimationDuration / 2];
    });
}

- (void)_executeStrokeEndAnimationOnLayer:(CALayer *)layer fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration
{
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = duration;
    strokeEndAnimation.fromValue = @(fromValue);
    strokeEndAnimation.toValue = @(toValue);
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.removedOnCompletion = NO;
    [layer addAnimation:strokeEndAnimation forKey:nil];
}

- (void)_executeRotationAnimationClockwise:(BOOL)flag
{
    CGFloat duration = 0.75 * kAnimationDuration;
    
    // 逆时针
    CGFloat startAngle = 0.0;
    CGFloat endAngle = -M_PI_2;
    if (flag) {
        startAngle = -M_PI_2;
        endAngle = 0.0;
    }
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.duration = duration;
    rotationAnimation.fromValue = [NSNumber numberWithFloat:startAngle];
    rotationAnimation.toValue = [NSNumber numberWithFloat:endAngle];
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:rotationAnimation forKey:nil];
}

- (void)_executeOpacityAnimationWithDuration:(CGFloat)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = duration;
    opacityAnimation.fromValue = @(fromValue);
    opacityAnimation.toValue = @(toValue);
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
    [_triangleContainerLayer addAnimation:opacityAnimation forKey:nil];
}

#pragma mark - Setter
- (void)setButtonState:(YouKuButtonState)buttonState
{
    _buttonState = buttonState;
    
    if (_isAnimating) {
        return;
    }
    
    _isAnimating = YES;
    
    if (buttonState == YouKuButtonState_Play) {
        [self _showPlayAnimation];
    } else {
        [self _showPauseAnimation];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  kAnimationDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        _isAnimating = NO;
    });
}

@end
