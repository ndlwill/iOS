//
//  HighlightGradientProgressView.m
//  NDL_Category
//
//  Created by dzcx on 2019/6/12.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "HighlightGradientProgressView.h"

@interface HighlightGradientProgressView ()

@property (nonatomic, weak) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) CALayer *maskLayer;

@end

// 在动画的过程中，每一帧都是对layer的属性进行新的赋值
@implementation HighlightGradientProgressView

- (instancetype)initWithFrame:(CGRect)frame gradientColors:(NSArray *)gradientColors
{
    if (self = [super initWithFrame:frame]) {
        [self _setupLayerWithGradientColors:gradientColors];
    }
    return self;
}

- (void)_setupLayerWithGradientColors:(NSArray *)gradientColors
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = gradientColors;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(-1.0), @(-0.5), @(0), @(0.5), @(1.0)];
    [self.layer addSublayer:gradientLayer];
    self.gradientLayer = gradientLayer;
    
    self.maskLayer = [CALayer layer];
    self.maskLayer.frame = self.bounds;
    self.maskLayer.anchorPoint = CGPointMake(0, 0.5);
    // 改变锚点，position还是原先锚点的position，所以也得改变
    self.maskLayer.position = CGPointMake(0, self.height / 2.0);
    self.maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.gradientLayer.mask = self.maskLayer;
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // gradientLayer.anchorPoint && gradientLayer.position 注释的情况下
//        // gradientLayer.position: {150, 10}
//        NSLog(@"gradientLayer.position = %@", NSStringFromCGPoint(gradientLayer.position));
//    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"locations";
    animation.duration = 2.0;
    animation.fromValue = @[@(-1.0), @(-0.5), @(0), @(0.5), @(1.0)];
    animation.toValue = @[@(0), @(0.5), @(1.0), @(1.5), @(2.0)];
    animation.repeatCount = CGFLOAT_MAX;
    [self.gradientLayer addAnimation:animation forKey:nil];
    
    CABasicAnimation *boundsAnimation = [CABasicAnimation animation];
    boundsAnimation.keyPath = @"bounds";
    boundsAnimation.duration = 10.0;
    boundsAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 0, self.height)];
    // 根据modelLayer和presentationLayer的关系，我们不设置toValue则系统会自动把modelLayer的值作为toValue
    [self.maskLayer addAnimation:boundsAnimation forKey:nil];
}

@end
