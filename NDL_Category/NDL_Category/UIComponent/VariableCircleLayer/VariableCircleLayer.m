//
//  VariableCircleLayer.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/24.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "VariableCircleLayer.h"

typedef NS_ENUM(NSInteger, MovePoint) {
    MovePoint_None,
    MovePoint_B,// 移动右边的点,左边的点不移动
    MovePoint_D
};

@interface VariableCircleLayer ()

//@property (nonatomic, assign) CGFloat lastProgress;

@property (nonatomic, assign) MovePoint movePoint;

@property (nonatomic, assign) CGRect circleRect;

@end

@implementation VariableCircleLayer

#pragma mark - init
- (instancetype)init
{
    if (self = [super init]) {
//        _lastProgress = 0.5;
        _circleRadius = 50.0;
    }
    return self;
}

#pragma mark - Overrides
- (void)drawInContext:(CGContextRef)ctx
{
    // A(top)-B(right)-C-D
    // A-C1-C2-B-C3-C4-C-C5-C6-D-C7-C8
    
    // 当设置为正方形边长的1/3.6倍时，画出来的圆弧完美贴合圆形
    CGFloat offset = self.circleRect.size.width / 3.6;
    // 系数为滑块偏离中点0.5的绝对值再乘以2.当滑到两端的时候，movedDistance为最大值：「外接矩形宽度的1/5」.
    CGFloat moveDistance = (self.circleRect.size.width / 5) * fabs(self.progress - 0.5) * 2;
    
    CGPoint rectCenter = CGPointMake(self.circleRect.origin.x + self.circleRect.size.width / 2.0, self.circleRect.origin.y + self.circleRect.size.height / 2.0);
    
    CGPoint pointA = CGPointMake(rectCenter.x, self.circleRect.origin.y + moveDistance);
    CGPoint pointB = CGPointMake(self.movePoint == MovePoint_D ? rectCenter.x + self.circleRect.size.width / 2.0 : rectCenter.x + self.circleRect.size.width / 2.0 + 2 * moveDistance, rectCenter.y);
    CGPoint pointC = CGPointMake(rectCenter.x, rectCenter.y + self.circleRect.size.height / 2.0 - moveDistance);
    CGPoint pointD = CGPointMake(self.movePoint == MovePoint_D ? self.circleRect.origin.x - 2 * moveDistance : self.circleRect.origin.x, rectCenter.y);
    
    CGPoint c1 = CGPointMake(pointA.x + offset, pointA.y);
    CGPoint c2 = CGPointMake(pointB.x, self.movePoint == MovePoint_D ? pointB.y - offset : pointB.y - offset + moveDistance);
    
    CGPoint c3 = CGPointMake(pointB.x, self.movePoint == MovePoint_D ? pointB.y + offset : pointB.y + offset - moveDistance);
    CGPoint c4 = CGPointMake(pointC.x + offset, pointC.y);
    
    CGPoint c5 = CGPointMake(pointC.x - offset, pointC.y);
    CGPoint c6 = CGPointMake(pointD.x, self.movePoint == MovePoint_D ? pointD.y + offset - moveDistance : pointD.y + offset);
    
    CGPoint c7 = CGPointMake(pointD.x, self.movePoint == MovePoint_D ? pointD.y - offset + moveDistance : pointD.y - offset);
    CGPoint c8 = CGPointMake(pointA.x - offset, pointA.y);
    
//    CGContextSaveGState(ctx);// 为了下面不使用虚线
    // circleRect虚线
    UIBezierPath *circleRectPath = [UIBezierPath bezierPathWithRect:self.circleRect];
    CGContextAddPath(ctx, circleRectPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    CGFloat lengths[] = {5.0, 5.0};
    CGContextSetLineDash(ctx, 0.0, lengths, 2);
    CGContextStrokePath(ctx);
//    CGContextRestoreGState(ctx);
    
    // 通过4条曲线 绘制椭圆(圆)
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:pointA];
    [ovalPath addCurveToPoint:pointB controlPoint1:c1 controlPoint2:c2];
    [ovalPath addCurveToPoint:pointC controlPoint1:c3 controlPoint2:c4];
    [ovalPath addCurveToPoint:pointD controlPoint1:c5 controlPoint2:c6];
    [ovalPath addCurveToPoint:pointA controlPoint1:c7 controlPoint2:c8];
    [ovalPath closePath];
    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor cyanColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineDash(ctx, 0.0, NULL, 0);// 不绘制虚线
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    // 绘制// A-C1-C2-B-C3-C4-C-C5-C6-D-C7-C8点
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    NSArray *points = @[[NSValue valueWithCGPoint:pointA], [NSValue valueWithCGPoint:pointB], [NSValue valueWithCGPoint:pointC], [NSValue valueWithCGPoint:pointD], [NSValue valueWithCGPoint:c1], [NSValue valueWithCGPoint:c2], [NSValue valueWithCGPoint:c3], [NSValue valueWithCGPoint:c4], [NSValue valueWithCGPoint:c5], [NSValue valueWithCGPoint:c6], [NSValue valueWithCGPoint:c7], [NSValue valueWithCGPoint:c8]];
    [self drawPoint:points withContext:ctx];
    
    // 绘制辅助线
    UIBezierPath *helperline = [UIBezierPath bezierPath];
    [helperline moveToPoint:pointA];
    [helperline addLineToPoint:c1];
    [helperline addLineToPoint:c2];
    [helperline addLineToPoint:pointB];
    [helperline addLineToPoint:c3];
    [helperline addLineToPoint:c4];
    [helperline addLineToPoint:pointC];
    [helperline addLineToPoint:c5];
    [helperline addLineToPoint:c6];
    [helperline addLineToPoint:pointD];
    [helperline addLineToPoint:c7];
    [helperline addLineToPoint:c8];
    [helperline closePath];
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGFloat helperLineLengths[] = {2.0, 2.0};
    CGContextSetLineDash(ctx, 0.0, helperLineLengths, 2);
    CGContextAddPath(ctx, helperline.CGPath);
    CGContextStrokePath(ctx); //给辅助线条填充颜色
}

#pragma mark - Private Methods
-(void)drawPoint:(NSArray *)points withContext:(CGContextRef)ctx
{
    for (NSValue *pointValue in points) {
        CGPoint point = [pointValue CGPointValue];
        CGContextFillRect(ctx, CGRectMake(point.x - 2, point.y - 2, 4, 4));
    }
}

#pragma mark - Setter
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    if (progress < 0.5) {
        self.movePoint = MovePoint_B;
    } else if (progress == 0.5) {
        self.movePoint = MovePoint_None;
    } else {// > 0.5
        self.movePoint = MovePoint_D;
    }
    
    CGFloat originX = (self.width - 2 * _circleRadius) / 2.0 + (self.width - 2 * _circleRadius) * (progress - 0.5);
    CGFloat originY = (self.height - 2 * _circleRadius) / 2.0;
    self.circleRect = CGRectMake(originX, originY, 2 * _circleRadius, 2 * _circleRadius);
    
    [self setNeedsDisplay];
}

@end
