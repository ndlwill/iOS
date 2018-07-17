//
//  DrawLib.m
//  DrawLib
//
//  Created by dzcx on 2018/7/17.
//

#import "DrawLib.h"

@implementation DrawLib

+ (void)drawDashedLineInContext:(CGContextRef)context
                      lineWidth:(CGFloat)lineWidth
                        lineCap:(CGLineCap)lineCap
                lineDashPattern:(CGFloat *)lengthArray
                lineStrokeColor:(CGColorRef)lineStrokeColor
                 lineBeginPoint:(CGPoint)lineBeginPoint
                   lineEndPoint:(CGPoint)lineEndPoint
{
    // setting
    // 设置线的粗细
    CGContextSetLineWidth(context, lineWidth);
    // 设置线的样式
    CGContextSetLineCap(context, lineCap);
    // 设置线的颜色
    CGContextSetStrokeColorWithColor(context, lineStrokeColor);
    
    // lengthArray:虚线线段的长度和后面空白的长度
    // phase参数表示在第一个虚线绘制的时候跳过多少个点
    CGContextSetLineDash(context, 0, lengthArray, sizeof(lengthArray) / sizeof(CGFloat));
    
    // 开始绘制
    CGContextBeginPath(context);
    // 设置虚线的起点
    CGContextMoveToPoint(context, lineBeginPoint.x, lineBeginPoint.y);
    // 绘制虚线的终点
    CGContextAddLineToPoint(context, lineEndPoint.x, lineEndPoint.y);
    // 绘制路径
    CGContextStrokePath(context);
}

@end
