//
//  PieView.m
//  NDL_Category
//
//  Created by ndl on 2018/2/24.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "PieView.h"
#import "UIColor+NDLExtension.h"

@interface PieView ()

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *values;

@end

@implementation PieView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor cyanColor];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame values:(NSArray<NSNumber *> *)values titles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor cyanColor];
        
        _titles = [titles copy];
        _values = [values copy];
        
        [self drawPieLayer];
    }
    return self;
}

// 贝塞尔曲线的每一个顶点都有两个控制点，用于控制在该顶点两侧的曲线的弧度
// 曲线的定义有四个点：起始点、终止点（也称锚点）以及两个相互分离的中间点,滑动两个中间点，贝塞尔曲线的形状会发生变化
// UIBezierPath对象是CGPathRef数据类型的封装
- (void)drawPieLayer
{
    CGFloat halfWidth = self.frame.size.width / 2;
    CGFloat halfHeight = self.frame.size.height / 2;
    CGPoint centerPoint = CGPointMake(halfWidth, halfHeight);
    CGFloat radius = MIN(halfWidth, halfHeight);
    
    CGFloat totalValue = 0.0;
    for (NSInteger i = 0; i < _values.count; i++) {
        totalValue += [_values[i] doubleValue];
    }
    
    // 第一个弧形的范围
    CGFloat startAngle = 0.0;
    CGFloat endAngle = 2 * M_PI * ([_values.firstObject doubleValue] / totalValue);
    
    for (NSInteger i = 0; i < _values.count; i++) {
        UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [arcPath addLineToPoint:centerPoint];//
        
        // 弧形
        CAShapeLayer *arcLayer = [CAShapeLayer layer];
        arcLayer.lineWidth = 5.0;
        arcLayer.strokeColor = [UIColor blackColor].CGColor;
//        arcLayer.strokeStart = 0.0;
//        arcLayer.strokeEnd = 0.5;
        arcLayer.fillColor = [UIColor ndl_randomColor].CGColor;
        arcLayer.path = arcPath.CGPath;
        [self.layer addSublayer:arcLayer];
        
        
        // 计算下个arc的start-end
        if (i != _values.count - 1) {
            startAngle = endAngle;
            endAngle += 2 * M_PI * ([_values[i + 1] doubleValue] / totalValue);
        }
    }
    
    
    // 中间的圆
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius * 0.3 startAngle:0.0 endAngle:2 * M_PI clockwise:YES];
//    CGFloat circleRadius = radius * 0.3;
//    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(halfWidth - circleRadius, halfHeight - circleRadius, 2 * circleRadius, 2 * circleRadius)];
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = 1.0;
    circleLayer.fillColor = [UIColor whiteColor].CGColor;
    circleLayer.path = circlePath.CGPath;
    [self.layer addSublayer:circleLayer];
}



@end
