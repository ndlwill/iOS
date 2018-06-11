//
//  SpeechRecognitionAnimationView.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/11.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "SpeechRecognitionAnimationView.h"

static CGFloat const kDotWH = 8.0;

static CGFloat const kPerAnimationDuration = 1.0;

static NSInteger const kInstanceCount = 3;

@implementation SpeechRecognitionAnimationView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self _setupSubLayer];
    }
    return self;
}

#pragma mark - Private Methods
- (void)_setupSubLayer
{
    CGFloat replicatorLayerWH = 5 * kDotWH;
    
    // 重复layer
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds = CGRectMake(0, 0, replicatorLayerWH, replicatorLayerWH);
    replicatorLayer.position = CGPointMake(self.width / 2.0, self.height / 2.0);
    replicatorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:replicatorLayer];
    
    // 第一个圆点layer
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kDotWH / 2, kDotWH / 2) radius:kDotWH / 2 startAngle:0 endAngle:2 * M_PI clockwise:YES];// dotPath相对于dotLayer的bounds
    
    CAShapeLayer *dotLayer = [CAShapeLayer layer];
    dotLayer.bounds = CGRectMake(0, 0, kDotWH, kDotWH);
    dotLayer.position = CGPointMake(kDotWH / 2, replicatorLayerWH / 2);
    dotLayer.backgroundColor = [UIColor clearColor].CGColor;
    dotLayer.path = dotPath.CGPath;
    dotLayer.fillColor = [UIColor cyanColor].CGColor;
    [replicatorLayer addSublayer:dotLayer];
    
    // dotAnimation
    CAKeyframeAnimation *dotAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    dotAnimation.values = @[@(replicatorLayerWH / 2), @(replicatorLayerWH / 2 - kDotWH), @(replicatorLayerWH / 2), @(replicatorLayerWH / 2 + kDotWH), @(replicatorLayerWH / 2)];
    dotAnimation.duration = kPerAnimationDuration;
    dotAnimation.repeatCount = MAXFLOAT;
    dotAnimation.removedOnCompletion = NO;
    [dotLayer addAnimation:dotAnimation forKey:nil];
    
    replicatorLayer.instanceCount = kInstanceCount;
    replicatorLayer.instanceDelay = kPerAnimationDuration / kInstanceCount;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(2 * kDotWH, 0, 0);
}

@end
