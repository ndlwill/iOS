//
//  AlipayPaymentSuccessAnimationView.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/11.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "AlipayPaymentSuccessAnimationView.h"

static CGFloat const kStrokeAnimationDuration = 1.0;
static CGFloat const kSuccessAnimationDuration = 0.4;

static CGFloat const kStrokeLineWidth = 4.0;

@interface AlipayPaymentSuccessAnimationView ()

@property (nonatomic, strong) CAShapeLayer *strokeLayer;
@property (nonatomic, strong) CAShapeLayer *successLayer;

@end

@implementation AlipayPaymentSuccessAnimationView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _setupSubLayer];
    }
    return self;
}

#pragma mark - Private Methods
- (void)_setupSubLayer
{
    // strokeLayer animation
    [self excuteStrokeAnimation];
    // successLayer animation
    [self excuteSuccessAnimation];
}

- (void)excuteStrokeAnimation
{
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    // strokeLayer
    self.strokeLayer = [CAShapeLayer layer];
    self.strokeLayer.bounds = self.bounds;
    self.strokeLayer.position = CGPointMake(width / 2.0, height / 2.0);
    self.strokeLayer.fillColor = [UIColor clearColor].CGColor;
    self.strokeLayer.strokeColor = NDLRGBColor(16, 142, 233).CGColor;
    self.strokeLayer.lineWidth = kStrokeLineWidth;
    self.strokeLayer.lineCap = kCALineCapRound;
    UIBezierPath *strokePath = [UIBezierPath bezierPathWithArcCenter:self.strokeLayer.position radius:((width > height ? height : width) / 2.0 - kStrokeLineWidth / 2.0) startAngle:-M_PI_2 endAngle:3.0 / 2 * M_PI clockwise:YES];
    self.strokeLayer.path = strokePath.CGPath;
    [self.layer addSublayer:self.strokeLayer];
    
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.fromValue = @(0.0);
    strokeAnimation.toValue = @(1.0);
    strokeAnimation.duration = kStrokeAnimationDuration;
    [self.strokeLayer addAnimation:strokeAnimation forKey:nil];
}

- (void)excuteSuccessAnimation
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kStrokeAnimationDuration * 0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGFloat width = self.width;
        CGFloat height = self.height;
        // successLayer
        self.successLayer = [CAShapeLayer layer];
        self.successLayer.bounds = self.bounds;
        self.successLayer.position = CGPointMake(width / 2.0, height / 2.0);
        self.successLayer.fillColor = [UIColor clearColor].CGColor;
        self.successLayer.strokeColor = NDLRGBColor(16, 142, 233).CGColor;
        self.successLayer.lineWidth = kStrokeLineWidth;
        self.successLayer.lineCap = kCALineCapRound;
        self.successLayer.lineJoin = kCALineJoinRound;
        UIBezierPath *successPath = [UIBezierPath bezierPath];
        [successPath moveToPoint:CGPointMake(width * 0.27, height * 0.54)];
        [successPath addLineToPoint:CGPointMake(width * 0.45, height * 0.7)];
        [successPath addLineToPoint:CGPointMake(width * 0.78, height * 0.38)];
        self.successLayer.path = successPath.CGPath;
        [self.layer addSublayer:self.successLayer];
        
        CABasicAnimation *successAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        successAnimation.fromValue = @(0.0);
        successAnimation.toValue = @(1.0);
        successAnimation.duration = kSuccessAnimationDuration;
        [self.successLayer addAnimation:successAnimation forKey:nil];
    });
}

@end
