//
//  AnnoAnimationView.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/29.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "AnnoAnimationView.h"

static CGFloat const kEdgeGap = 5.0;
static CGFloat const kAnimationDuration = 0.42;
//static CGFloat const kAnimationDuration = 4.2;

@interface AnnoAnimationView ()

@property (nonatomic, weak) CAShapeLayer *ovalShapeLayer;
@property (nonatomic, weak) CAShapeLayer *lineLayer;
@property (nonatomic, weak) CAShapeLayer *circleLayer;

@property (nonatomic, assign) CGFloat topCircleWidth;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat ovalHeight;


@end

@implementation AnnoAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat topCircleWidth = self.width - 2 * kEdgeGap;// 50
        self.topCircleWidth = topCircleWidth;
        CGFloat circleStrokeWidth = (topCircleWidth - 14.0) / 2.0;
        
        // ===test layer===
//        CALayer *centerYLayer = [CALayer layer];
//        centerYLayer.backgroundColor = [UIColor redColor].CGColor;
//        centerYLayer.frame = CGRectMake(0, self.height / 2.0 - 0.5, self.width, 1.0);
//        [self.layer addSublayer:centerYLayer];
        
        // circleLayer
        CGRect circleFrame = CGRectMake(kEdgeGap, kEdgeGap, topCircleWidth, topCircleWidth);
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(circleStrokeWidth / 2.0, circleStrokeWidth / 2.0, topCircleWidth - circleStrokeWidth, topCircleWidth - circleStrokeWidth)];
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.frame = circleFrame;
        circleLayer.lineWidth = circleStrokeWidth;
        circleLayer.strokeColor = [UIColor blackColor].CGColor;
        circleLayer.fillColor = [UIColor whiteColor].CGColor;
        circleLayer.path = circlePath.CGPath;
        [self.layer addSublayer:circleLayer];
        self.circleLayer = circleLayer;
        
        // ovalShapeLayer
        CGFloat ovalWidth = 10.0;
        self.ovalHeight = 8.0;
        CGFloat ovalX = self.width / 2.0 - ovalWidth / 2.0;
        CGFloat ovalY = self.height - kEdgeGap - self.ovalHeight;
        CGRect ovalFrame = CGRectMake(ovalX, ovalY, ovalWidth, self.ovalHeight);
        
        UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ovalWidth, self.ovalHeight)];
        CAShapeLayer *ovalShapeLayer = [CAShapeLayer layer];
        ovalShapeLayer.frame = ovalFrame;
        ovalShapeLayer.path = ovalPath.CGPath;
        ovalShapeLayer.fillColor = [UIColor lightGrayColor].CGColor;
        [self.layer addSublayer:ovalShapeLayer];
        self.ovalShapeLayer = ovalShapeLayer;
        
        // lineLayer
        CGFloat lineWidth = 4.0;
        self.lineHeight = self.height - 2 * kEdgeGap - topCircleWidth - self.ovalHeight / 2.0;
        CGFloat lineX = self.width / 2.0 - lineWidth / 2.0;
        CGFloat lineY = self.height - kEdgeGap - self.ovalHeight / 2.0 - self.lineHeight;
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(lineWidth / 2.0, 0.0)];
        [linePath addLineToPoint:CGPointMake(lineWidth / 2.0, self.lineHeight)];
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.frame = CGRectMake(lineX, lineY, lineWidth, self.lineHeight);
        lineLayer.lineWidth = lineWidth;
//        lineLayer.lineCap = kCALineCapRound;
//        lineLayer.strokeColor = [UIColor blackColor].CGColor;
        lineLayer.strokeColor = [UIColor cyanColor].CGColor;
        lineLayer.path = linePath.CGPath;
        [self.layer addSublayer:lineLayer];
        self.lineLayer = lineLayer;
    }
    return self;
}

- (void)startAnimation
{
    // kCAFillModeForwards: layer的实际bounds和frame没有改变
    // self.circleLayer.frame = {{5, 5}, {50, 50}}
    // self.lineLayer.frame = {{28, 55}, {4, 20}}
    NSLog(@"self.circleLayer.frame = %@", NSStringFromCGRect(self.circleLayer.frame));
    NSLog(@"self.lineLayer.frame = %@", NSStringFromCGRect(self.lineLayer.frame));
    
    
    CGFloat circleOriginCenterY = kEdgeGap + self.topCircleWidth / 2.0;
    CGFloat lineOriginCenterY = self.height - kEdgeGap - self.ovalHeight / 2.0 - self.lineHeight / 2.0;
    // for debug
//    NSNumber *keyTime1 = @(1 / kAnimationDuration);
//    NSNumber *keyTime2 = @(2 / kAnimationDuration);
//    NSNumber *keyTime3 = @(3 / kAnimationDuration);
    
    NSNumber *keyTime1 = @(0.1 / kAnimationDuration);
    NSNumber *keyTime2 = @(0.2 / kAnimationDuration);
    NSNumber *keyTime3 = @(0.3 / kAnimationDuration);
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    NSArray<CAMediaTimingFunction *> *timingFunctions = @[
                                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
                                                          ];
    
    // 1
    CGFloat circleOffsetY1 = self.topCircleWidth * 0.5;
    // 2
    CGFloat lineFinalHeight2 = 10.0;
    CGFloat circleFinalY2 = self.height / 2.0 - lineFinalHeight2 / 2.0 - self.topCircleWidth / 2.0;
    CGFloat circleOffsetY2 = circleFinalY2 - circleOriginCenterY;
    // 3
    CGFloat lineFinalHeight3 = 10.0;
    CGFloat lineScaleY3 = lineFinalHeight3 / self.lineHeight;
    CGFloat lineTranslationY3 = self.lineHeight / 2.0 - lineFinalHeight3 / 2.0;
    CGFloat circleOffsetY3 = self.height - kEdgeGap - self.ovalHeight / 2.0 - lineFinalHeight3 - self.topCircleWidth / 2.0 - circleOriginCenterY;
    // 4.reset

    CAKeyframeAnimation *circleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    circleAnim.values = @[@(0.0), @(-circleOffsetY1), @(circleOffsetY2), @(circleOffsetY3), @(0.0)];
    circleAnim.duration = kAnimationDuration;
    // Each value in the array is a floating point number in the range [0,1]
    circleAnim.keyTimes = @[@(0), keyTime1, keyTime2, keyTime3, @(1)];
    circleAnim.timingFunction = timingFunction;
//    circleAnim.timingFunctions = timingFunctions;
    circleAnim.fillMode = kCAFillModeForwards;
    circleAnim.removedOnCompletion = NO;
    [self.circleLayer addAnimation:circleAnim forKey:nil];

    // 1
    CGFloat lineFinalHeight1 = self.lineHeight + circleOffsetY1;
    CGFloat lineScaleY1 = lineFinalHeight1 / self.lineHeight;
    CGFloat lineTranslationY1 = circleOffsetY1 / 2.0;
    // 2
    CGFloat lineFinalCenterY2 = self.height / 2.0;
    CGFloat lineScaleY2 = lineFinalHeight2 / self.lineHeight;
    CGFloat lineTranslationY2 = lineOriginCenterY - lineFinalCenterY2;
    // 3
    
    // 4.reset
    

    CAKeyframeAnimation *lineAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    lineAnim.values = @[
                        [NSValue valueWithCATransform3D:CATransform3DIdentity],
                        [NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformMake(1.0, 0, 0, lineScaleY1, 0, -lineTranslationY1))],
                        [NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformMake(1.0, 0, 0, lineScaleY2, 0, -lineTranslationY2))],
                        [NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(CGAffineTransformMake(1.0, 0, 0, lineScaleY3, 0, lineTranslationY3))],
                        [NSValue valueWithCATransform3D:CATransform3DIdentity]
                        ];
    lineAnim.duration = kAnimationDuration;
    lineAnim.keyTimes = @[@(0), keyTime1, keyTime2, keyTime3, @(1)];
    lineAnim.timingFunction = timingFunction;
//    lineAnim.timingFunctions = timingFunctions;
    lineAnim.fillMode = kCAFillModeForwards;
    lineAnim.removedOnCompletion = NO;
    [self.lineLayer addAnimation:lineAnim forKey:nil];
}

- (void)dealloc
{
    NSLog(@"annoAnimationView dealloc");
}

@end
