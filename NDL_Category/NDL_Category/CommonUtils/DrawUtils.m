//
//  DrawUtils.m
//  NDL_Category
//
//  Created by dzcx on 2018/3/26.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "DrawUtils.h"

/*
 ###Core Graphics###
 Core Graphics Framework是一套基于C的API框架，使用了Quartz作为绘图引擎(QuartZ 2D).QuartZ 2D是苹果公司开发的一套API
 
 ##Core Graphics API所有的操作都在一个上下文中进行##
 
 图片类型的上下文:
 UIGraphicsBeginImageContextWithOptions
 UIGraphicsGetImageFromCurrentImageContext函数可从当前上下文中获取一个UIImage对象
 UIGraphicsEndImageContext函数关闭图形上下文
 
 利用cocoa为你生成的图形上下文。
 当你子类化了一个UIView并实现了自己的drawRect：方法后，一旦drawRect：方法被调用，Cocoa就会为你创建一个图形上下文
 UIGraphicsGetCurrentContext
 
 // 设置:
 CGContextSetLineWidth
 CGContextSetLineCap
 CGContextSetLineDash
 CGContextSetStrokeColorWithColor
 CGContextSetFillColorWithColor
 CGContextSetShadowWithColor
 // path:
 CGContextBeginPath
 
 CGContextMoveToPoint
 CGContextAddLineToPoint
 CGContextAddArc
 CGContextAddEllipseInRect
 // 绘制:
 CGContextStrokePath
 
 CGContextFillPath
 
 CGContextClosePath(context);
 CGContextDrawPath(context, kCGPathFillStroke);
 */

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
    CGContextAddLineToPoint(context, lineEndPoint.x, lineEndPoint.y);
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

+ (void)drawRightAngleBubbleFrameInContext:(CGContextRef)context
                                    inRect:(CGRect)inRect
                                 lineWidth:(CGFloat)lineWidth
                           lineStrokeColor:(CGColorRef)lineStrokeColor
                                 fillColor:(CGColorRef)fillColor
                              cornerRadius:(CGFloat)cornerRadius
                        rightAnglePosition:(BubbleFrameRightAnglePosition)rightAnglePosition
{
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineStrokeColor);
    if (fillColor == NULL) {
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);// 默认
    } else {
        CGContextSetFillColorWithColor(context, fillColor);
    }
    
    CGContextBeginPath(context);
    
    // 边框范围
    CGFloat minX = 0.0, maxX = 0.0;
    CGFloat minY = 0.0, maxY = 0.0;
    
    minX = CGRectGetMinX(inRect) + lineWidth / 2.0;
    minY = CGRectGetMinY(inRect) + lineWidth / 2.0;
    maxX = CGRectGetMaxX(inRect) - lineWidth / 2.0;
    maxY = CGRectGetMaxY(inRect) - lineWidth / 2.0;
    
    switch (rightAnglePosition) {
        case BubbleFrameRightAnglePosition_LB:
        {
            // 顺时针绘制
            CGContextMoveToPoint(context, minX, maxY);
//            CGContextAddLineToPoint(context, minX, minY);
            CGContextAddArcToPoint(context, minX, minY, maxX, minY, cornerRadius);
            CGContextAddArcToPoint(context, maxX, minY, maxX, maxY, cornerRadius);
            CGContextAddArcToPoint(context, maxX, maxY, minX, maxY, cornerRadius);// 需要CGContextClosePath
        }
            break;
        case BubbleFrameRightAnglePosition_LT:
        {
            
        }
            break;
        case BubbleFrameRightAnglePosition_RT:
        {
            
        }
            break;
        case BubbleFrameRightAnglePosition_RB:
        {
            
        }
            break;
        default:
            break;
    }
    
    CGContextClosePath(context);// 连接起点和当前点
    CGContextDrawPath(context, kCGPathFillStroke);
}

+ (void)drawCouponBackgroundInContext:(CGContextRef)context
                                 rect:(CGRect)rect
                         cornerRadius:(CGFloat)cornerRadius
                        separateShape:(CouponBackgroundSeparateShape)separateShape
                  separateShapeCenterXRatio:(CGFloat)separateShapeCenterXRatio
          separateShapeVerticalHeight:(CGFloat)separateShapeVerticalHeight
         separateShapeHorizontalWidth:(CGFloat)separateShapeHorizontalWidth
                            lineWidth:(CGFloat)lineWidth
                      lineStrokeColor:(CGColorRef)lineStrokeColor
                            fillColor:(CGColorRef)fillColor
                           shadowBlur:(CGFloat)shadowBlur
                          shadowColor:(CGColorRef)shadowColor
                         shadowOffset:(CGSize)shadowOffset
{
    // 有分隔形状
    if (separateShape != CouponBackgroundSeparateShape_None) {
        // set
        
        CGFloat realLineWidth = 0.0;
        CGFloat minX = 0.0, minY = 0.0, maxX = 0.0, maxY = 0.0;
        CGFloat realSeparateShapeCenterX = 0.0;
        // 表示有阴影，忽略border(LineWidth,stroke)
        if (shadowBlur > 0) {
            CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextSetShadowWithColor(context, shadowOffset, shadowBlur, shadowColor);
            
            minX = shadowBlur;
            minY = minX;
            maxX = CGRectGetMaxX(rect) - shadowBlur;
            maxY = CGRectGetMaxY(rect) - shadowBlur;
            
            realSeparateShapeCenterX = (rect.size.width - 2 * shadowBlur) * separateShapeCenterXRatio;
        } else {
            realLineWidth = lineWidth;
            CGContextSetStrokeColorWithColor(context, lineStrokeColor);
            
            minX = realLineWidth / 2;
            minY = minX;
            maxX = CGRectGetMaxX(rect) - realLineWidth / 2;
            maxY = CGRectGetMaxY(rect) - realLineWidth / 2;
            
            realSeparateShapeCenterX = (rect.size.width - realLineWidth) * separateShapeCenterXRatio;
        }
        CGContextSetLineWidth(context, realLineWidth);
        if (fillColor == NULL) {
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);// 默认白色
        } else {
            CGContextSetFillColorWithColor(context, fillColor);
        }
        
        // 描述路径
        CGContextBeginPath(context);
        if (CouponBackgroundSeparateShape_SemiCircle == separateShape) {// 半圆
            // 绘制上边的半圆
            CGContextAddArc(context, realSeparateShapeCenterX, minY, separateShapeVerticalHeight, 0.0, M_PI, 0);// 顺时针绘制半圆
            // 逆时针绘制全部
            CGContextAddArcToPoint(context, minX, minY, minX, maxY, cornerRadius);// minX, maxY其实y只绘制到cornerRadius的长度
            CGContextAddArcToPoint(context, minX, maxY, maxX, maxY, cornerRadius);
            // 绘制下边的半圆
            CGContextAddArc(context, realSeparateShapeCenterX, maxY, separateShapeVerticalHeight, M_PI, 0.0, 0);
            CGContextAddArcToPoint(context, maxX, maxY, maxX, minY, cornerRadius);
            CGContextAddArcToPoint(context, maxX, minY, minX, minY, cornerRadius);
            CGContextClosePath(context);
        } else if (CouponBackgroundSeparateShape_Triangle == separateShape) {
            // TODO:
        }
        
        // 渲染上下文
        if (shadowBlur > 0) {
            CGContextDrawPath(context, kCGPathFill);
        } else {
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    } else {
        // TODO:
    }
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
