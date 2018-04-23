//
//  ArcToCircleLayer.m
//  NDL_Category
//
//  Created by dzcx on 2018/4/10.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "ArcToCircleLayer.h"

@implementation ArcToCircleLayer

@dynamic progress;
// @dynamic不会自动生成_color
@dynamic color;

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor cyanColor].CGColor;
    }
    return self;
}

// 属性改变，redraw  属性变化触发重绘
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"progress"]) {
        return YES;
    } else if ([key isEqualToString:@"color"]) {
        NSLog(@"color ===###");
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

// 重绘弧的方案可以理解为:我们不停的创建新的path，每条path的起点和终点不一样，来形成动画
- (void)drawInContext:(CGContextRef)ctx
{
    NSLog(@"=====ArcToCircleLayer Redraw===== progress = %lf", self.progress);
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.0 - kLineWidth / 2.0;
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // origin
    CGFloat originStart = 7 * M_PI / 2;
    CGFloat originEnd = 2 * M_PI;
    CGFloat originCur = originStart - (originStart - originEnd) * self.progress;
    
    // destination
    CGFloat destStart = 3 * M_PI;
    CGFloat destEnd = 0;
    CGFloat destCur = destStart - (destStart - destEnd) * self.progress;
    
    // 角度 0:rightX 90:bottomY(参照顺时针)      NO:逆时针
    [path addArcWithCenter:centerPoint radius:radius startAngle:originCur endAngle:destCur clockwise:NO];
    
    CGContextBeginPath(ctx);
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, kLineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextStrokePath(ctx);
}

@end
