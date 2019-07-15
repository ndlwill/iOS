//
//  GradientRingView.m
//  NDL_Category
//
//  Created by dzcx on 2019/6/12.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "GradientRingView.h"

@interface GradientRingView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation GradientRingView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame ringWidth:(CGFloat)ringWidth ringColors:(NSArray *)ringColors;
{
    if (self = [super initWithFrame:frame]) {
        [self _setupLayerWithRingWidth:ringWidth ringColors:ringColors];
    }
    return self;
}

#pragma mark - private methods
- (void)_setupLayerWithRingWidth:(CGFloat)ringWidth ringColors:(NSArray *)ringColors
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = ringColors;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [self.layer addSublayer:gradientLayer];

    CGFloat halfRingWidth = ringWidth / 2.0;
    CGFloat radius = self.width / 2.0 - halfRingWidth;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width / 2.0, self.height / 2.0) radius:radius startAngle:-M_PI_2 endAngle:3 * M_PI clockwise:YES];
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.lineWidth = ringWidth;
    self.shapeLayer.path = path.CGPath;
    gradientLayer.mask = self.shapeLayer;
}

//- (void)_setupLayerWithRingWidth:(CGFloat)ringWidth ringColors:(NSArray *)ringColors
//{
//    CALayer *containerLayer = [CALayer layer];
//    containerLayer.frame = self.bounds;
//    [self.layer addSublayer:containerLayer];
//
//    CAGradientLayer *leftGradientLayer = [CAGradientLayer layer];
//    leftGradientLayer.frame = CGRectMake(0, 0, self.width / 2.0, self.height);
//    leftGradientLayer.colors = @[(__bridge id)[UIColor greenColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor];
//    leftGradientLayer.startPoint = CGPointMake(0, 0);
//    leftGradientLayer.endPoint = CGPointMake(0, 1);
//    [containerLayer addSublayer:leftGradientLayer];
//
//    CAGradientLayer *rightGradientLayer = [CAGradientLayer layer];
//    rightGradientLayer.frame = CGRectMake(self.width / 2.0, 0, self.width / 2.0, self.height);
//    rightGradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor];
//    rightGradientLayer.startPoint = CGPointMake(0, 0);
//    rightGradientLayer.endPoint = CGPointMake(0, 1);
//    [containerLayer addSublayer:rightGradientLayer];
//
//    CGFloat halfRingWidth = ringWidth / 2.0;
//    CGFloat radius = self.width / 2.0 - halfRingWidth;
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width / 2.0, self.height / 2.0) radius:radius startAngle:-M_PI_2 endAngle:3 * M_PI clockwise:YES];
//    self.shapeLayer = [CAShapeLayer layer];
//    self.shapeLayer.strokeColor = [UIColor blackColor].CGColor;
//    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    self.shapeLayer.lineWidth = ringWidth;
//    self.shapeLayer.path = path.CGPath;
//    containerLayer.mask = self.shapeLayer;
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"strokeEnd";
    animation.duration = 2.0;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    [self.shapeLayer addAnimation:animation forKey:nil];
}

@end
