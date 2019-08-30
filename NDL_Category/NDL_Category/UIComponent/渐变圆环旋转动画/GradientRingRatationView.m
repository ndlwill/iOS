//
//  GradientRingRatationView.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/29.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "GradientRingRatationView.h"

@implementation GradientRingRatationView

- (instancetype)initWithFrame:(CGRect)frame arcWidth:(CGFloat)arcWidth gradienColor:(UIColor *)gradienColor
{
    if (self = [super initWithFrame:frame]) {
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        
        CALayer *wrapperLayer = [CALayer layer];
        wrapperLayer.frame = self.bounds;
        [self.layer addSublayer:wrapperLayer];
        
        CGFloat radius = MIN(frame.size.width / 2.0, frame.size.height / 2.0);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius - (arcWidth / 2.0) startAngle:0 endAngle:2.0 * M_PI clockwise:YES];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineWidth = arcWidth;
        shapeLayer.path = path.CGPath;
        
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        CGFloat halfWidth = width / 2.0;
        CGFloat halfHeight = height / 2.0;
        
        CAGradientLayer *rtGradientLayer = [CAGradientLayer layer];
        rtGradientLayer.frame = CGRectMake(halfWidth, 0, halfWidth, halfHeight);
        rtGradientLayer.colors = @[(__bridge id)gradienColor.CGColor, (__bridge id)[gradienColor colorWithAlphaComponent:0.75].CGColor];
        rtGradientLayer.startPoint = CGPointMake(0, 0);
        rtGradientLayer.endPoint = CGPointMake(1.0, 1.0);
        [wrapperLayer addSublayer:rtGradientLayer];
        
        CAGradientLayer *rbGradientLayer = [CAGradientLayer layer];
        rbGradientLayer.frame = CGRectMake(halfWidth, halfHeight, halfWidth, halfHeight);
        rbGradientLayer.colors = @[(__bridge id)[gradienColor colorWithAlphaComponent:0.75].CGColor, (__bridge id)[gradienColor colorWithAlphaComponent:0.5].CGColor];
        rbGradientLayer.startPoint = CGPointMake(1.0, 0);
        rbGradientLayer.endPoint = CGPointMake(0, 1.0);
        [wrapperLayer addSublayer:rbGradientLayer];
        
        CAGradientLayer *lbGradientLayer = [CAGradientLayer layer];
        lbGradientLayer.frame = CGRectMake(0, halfHeight, halfWidth, halfHeight);
        lbGradientLayer.colors = @[(__bridge id)[gradienColor colorWithAlphaComponent:0.5].CGColor, (__bridge id)[gradienColor colorWithAlphaComponent:0.25].CGColor];
        lbGradientLayer.startPoint = CGPointMake(1.0, 1.0);
        lbGradientLayer.endPoint = CGPointMake(0, 0);
        [wrapperLayer addSublayer:lbGradientLayer];
        
        CAGradientLayer *ltGradientLayer = [CAGradientLayer layer];
        ltGradientLayer.frame = CGRectMake(0, 0, halfWidth, halfHeight);
        ltGradientLayer.colors = @[(__bridge id)[gradienColor colorWithAlphaComponent:0.25].CGColor, (__bridge id)[UIColor clearColor].CGColor];
        ltGradientLayer.startPoint = CGPointMake(0, 1.0);
        ltGradientLayer.endPoint = CGPointMake(1.0, 0);
        [wrapperLayer addSublayer:ltGradientLayer];
        
        wrapperLayer.mask = shapeLayer;
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = @(0);
        rotationAnimation.toValue = @(2 * M_PI);
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.duration = 1.0;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [wrapperLayer addAnimation:rotationAnimation forKey:@"rotationAnnimation"];
    }
    return self;
}

@end
