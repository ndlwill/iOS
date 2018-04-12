//
//  DrawUtils.m
//  NDL_Category
//
//  Created by dzcx on 2018/3/26.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "DrawUtils.h"

@implementation DrawUtils

#pragma mark - Public Methods
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
    CGContextAddLineToPoint(context, lineBeginPoint.x, lineEndPoint.y);
    // 绘制路径
    CGContextStrokePath(context);
}

+ (void)drawClockInContext:(CGContextRef)context
                 lineWidth:(CGFloat)lineWidth
           lineStrokeColor:(CGColorRef)lineStrokeColor
                    radius:(CGFloat)radius
               centerPoint:(CGPoint)centerPoint
            hourHandLength:(CGFloat)hourHandLength// 时针长度
             hourHandValue:(CGFloat)hourHandValue// 时针数值 1-12
          minuteHandLength:(CGFloat)minuteHandLength
           minuteHandValue:(CGFloat)minuteHandValue
{
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineStrokeColor);
    
    // 上面绘制的path都无效 除非CGContextBeginPath之前调用CGContextStrokePath(context);
    CGContextBeginPath(context);
    // 绘制圆
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, 2 * M_PI, 1);
    
    CGFloat totalValue = 12.0;
    // 绘制时针
    CGContextMoveToPoint(context, centerPoint.x, centerPoint.y);
    CGFloat hourRadian = 2 * M_PI / totalValue * hourHandValue;//时针的弧度
    CGPoint hourEndPoint = [self pointWithCenterPoint:centerPoint radian:hourRadian segmentLength:hourHandLength];
    CGContextAddLineToPoint(context, hourEndPoint.x, hourEndPoint.y);
    // 绘制分针
    CGContextMoveToPoint(context, centerPoint.x, centerPoint.y);
    CGFloat minuteRadian = 2 * M_PI / totalValue * minuteHandValue;
    CGPoint minuteEndPoint = [self pointWithCenterPoint:centerPoint radian:minuteRadian segmentLength:minuteHandLength];
    CGContextAddLineToPoint(context, minuteEndPoint.x, minuteEndPoint.y);
    
    CGContextStrokePath(context);
}

+ (void)drawDeletePatternInContext:(CGContextRef)context
                         lineWidth:(CGFloat)lineWidth
                   lineStrokeColor:(CGColorRef)lineStrokeColor
                            radius:(CGFloat)radius
                       centerPoint:(CGPoint)centerPoint
{
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineStrokeColor);
    
    CGContextBeginPath(context);
    // 绘制圆
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, 2 * M_PI, 1);//1 逆时针
    // 绘制中间的直线 直线长度默认为半径的长度
    CGContextMoveToPoint(context, centerPoint.x - radius / 2, centerPoint.y);
    CGContextAddLineToPoint(context, centerPoint.x + radius / 2, centerPoint.y);
    
    CGContextStrokePath(context);
}

+ (void)drawDotInContext:(CGContextRef)context
               fillColor:(CGColorRef)fillColor
             centerPoint:(CGPoint)centerPoint
                  radius:(CGFloat)radius
{
    CGContextSetFillColorWithColor(context, fillColor);
    CGContextBeginPath(context);
    // 绘制圆点
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, 2 * M_PI, 1);
    CGContextFillPath(context);
}

+ (void)drawBubbleFrameWithTriangleInContext:(CGContextRef)context
                                        rect:(CGRect)rect
                                   lineWidth:(CGFloat)lineWidth
                             lineStrokeColor:(CGColorRef)lineStrokeColor
                                   fillColor:(CGColorRef)fillColor
                                cornerRadius:(CGFloat)cornerRadius
                              arrowDirection:(BubbleFrameArrowDirection)arrowDirection
                                 arrowHeight:(CGFloat)arrowHeight
                                controlPoint:(CGPoint)controlPoint
                      controlPointOffsetLeft:(CGFloat)controlPointOffsetLeft
                     controlPointOffsetRight:(CGFloat)controlPointOffsetRight
{
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineStrokeColor);
    if (fillColor == NULL) {
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);// 默认
    } else {
        CGContextSetFillColorWithColor(context, fillColor);
    }
    
    CGContextBeginPath(context);
    
    CGFloat minX = 0.0, maxX = 0.0;
    CGFloat minY = 0.0, maxY = 0.0;
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    switch (arrowDirection) {
        case BubbleFrameArrowDirection_Top:
        {
            
        }
            break;
        case BubbleFrameArrowDirection_Left:
        {
            startPoint = CGPointMake(arrowHeight, controlPoint.y - controlPointOffsetLeft);
            endPoint = CGPointMake(arrowHeight, controlPoint.y + controlPointOffsetRight);
            CGContextMoveToPoint(context, startPoint.x, startPoint.y);
            CGContextAddLineToPoint(context, controlPoint.x, controlPoint.y);
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
            
            minX = arrowHeight;
            maxX = CGRectGetMaxX(rect) - lineWidth / 2;
            minY = CGRectGetMinY(rect) + lineWidth / 2;
            maxY = CGRectGetMaxY(rect) - lineWidth / 2;
            
            CGContextAddArcToPoint(context, minX, maxY, maxX, maxY, cornerRadius);
            CGContextAddArcToPoint(context, maxX, maxY, maxX, minY, cornerRadius);
            CGContextAddArcToPoint(context, maxX, minY, minX, minY, cornerRadius);
            CGContextAddArcToPoint(context, minX, minY, minX, maxY, cornerRadius);
        }
            break;
        case BubbleFrameArrowDirection_Bottom:
        {
            
        }
            break;
        case BubbleFrameArrowDirection_Right:
        {
            
        }
            break;
        default:
            break;
    }
    CGContextClosePath(context);// 连接起点和当前点
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - Private Methods
// 线段长度以中心点为起点
+ (CGPoint)pointWithCenterPoint:(CGPoint)centerPoint radian:(CGFloat)radian segmentLength:(CGFloat)segmentLength
{
    CGFloat x = sin(radian) * segmentLength;
    CGFloat y = cos(radian) * segmentLength;
    return CGPointMake(centerPoint.x + x, centerPoint.y - y);
}

@end
