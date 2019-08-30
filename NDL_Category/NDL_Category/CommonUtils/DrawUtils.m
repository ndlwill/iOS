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
 
 如果你持有一个context：参数，那么使用UIKit提供的方法之前，必须将该上下文参数转化为当前上下文。
 调用UIGraphicsPushContext 函数可以方便的将context：参数转化为当前上下文，记住最后别忘了调用UIGraphicsPopContext函数恢复上下文环境
 
 图片类型的上下文:
 UIGraphicsBeginImageContextWithOptions
 UIGraphicsGetImageFromCurrentImageContext函数可从当前上下文中获取一个UIImage对象
 UIGraphicsEndImageContext函数关闭图形上下文
 
 利用cocoa为你生成的图形上下文。
 当你子类化了一个UIView并实现了自己的drawRect：方法后，一旦drawRect：方法被调用，Cocoa就会为你创建一个图形上下文
 UIGraphicsGetCurrentContext
 
 CGImage:
 原始的本地坐标系统（坐标原点在左上角）与目标上下文（坐标原点在左下角）
 一个CGImage对象可以让你获取原始图片中指定区域的图片:
 CGImageCreateWithImageInRect
 CGContextDrawImage
 对于UIImage来说，在加载原始图片时使用imageNamed:方法，它会自动根据所在设备的分辨率类型选择图片，并且UIImage通过设置用来适配的scale属性补偿图片的两倍尺寸。但是一个CGImage对象并没有scale属性
 2.你可以在绘图之前将CGImage包装进UIImage中
 当UIImage绘图时它会自动修复倒置问题
 CGImage转化为Uimage: imageWithCGImage:scale:orientation,生成CGImage作为对缩放性的补偿
 
 因为Core Graphics源于Mac OS X系统，在Mac OS X中，坐标原点在左下方并且正y坐标是朝上的，而在iOS中，原点坐标是在左上方并且正y坐标是朝下的
 但是创建和绘制一个CGImage对象时就会暴露出倒置问题
 
 
 图形上下文提供了一个用来持有状态的栈。调用CGContextSaveGState函数，上下文会将完整的当前状态压入栈顶；调用CGContextRestoreGState函数，上下文查找处在栈顶的状态，并设置当前上下文状态为栈顶状态
 绘图的一般过程是先设定好图形上下文参数，然后绘图
 裁剪区域:在裁剪区域外绘图不会被实际的画出来
 路径的另一用处是遮蔽区域，以防对遮蔽区域进一步绘图。这种用法被称为裁剪。裁剪区域外的图形不会被绘制到。默认情况下，一个图形上下文的裁剪区域是整个图形上下文。你可在上下文中的任何地方绘图
 
 变换（或称为“CTM“，意为当前变换矩阵): 改变你随后指定的绘图命令中的点如何被映射到画布的物理空间
 // 设置:
 线条的宽度和线条的虚线样式
 CGContextSetLineWidth
 CGContextSetLineDash
 线帽和线条联接点样式
 CGContextSetLineCap
 CGContextSetLineJoin
 CGContextSetMiterLimit
 线条颜色和线条模式
 CGContextSetRGBStrokeColor
 CGContextSetGrayStrokeColor
 CGContextSetStrokeColorWithColor
 CGContextSetStrokePattern
 填充颜色和模式
 CGContextSetRGBFillColor
 CGContextSetGrayFillColor
 CGContextSetFillColorWithColor
 CGContextSetFillPattern
 阴影
 CGContextSetShadow
 CGContextSetShadowWithColor
 混合模式
 CGContextSetBlendMode（决定你当前绘制的图形与已经存在的图形如何被合成）
 整体透明度
 CGContextSetAlpha
 文本属性
 CGContextSelectFont
 CGContextSetFont
 CGContextSetFontSize
 CGContextSetTextDrawingMode
 CGContextSetCharacterSpacing
 是否开启反锯齿和字体平滑
 CGContextSetShouldAntialias
 CGContextSetShouldSmoothFonts
 
 路径与绘图:
 // path:
 UIBezierPath:
 bezierPathWithRoundedRect：cornerRadius：，它可用于绘制带有圆角的矩形，如果是使用Core Graphics就相当冗长乏味了。还可以只让圆角出现在左上角和右上角
 UIKit的UIBezierPath类包装了CGPath:
 moveToPoint
 addLineToPoint
 setLineWidth
 stroke
 [[UIColor redColor] set];
 removeAllPoints
 fill
 fillWithBlendMode
 
 如果一段路径需要重用或共享，你可以将路径封装为CGPath（具体类型是CGPathRef）。你可以创建一个新的CGMutablePathRef对象并使用多个类似于图形的路径函数的CGPath函数构造路径，或者使用CGContextCopyPath函数复制图形上下文的当前路径。有许多CGPath函数可用于创建基于简单几何形状的路径（CGPathCreateWithRect、CGPathCreateWithEllipseInRect）或基于已存在路径（CGPathCreateCopyByStrokingPath、CGPathCreateCopyDashingPath、CGPathCreateCopyByTransformingPath）
 
 CGContextClearRect
 函数的功能是擦除一个区域。这个函数会擦除一个矩形内的所有已存在的绘图；并对该区域执行裁剪
 如果图片上下文是透明的（UIGraphicsBeginImageContextWithOptions第二个参数为NO），那么CGContextClearRect函数执行擦除后的颜色为透明，反之则为黑色
 当在一个视图中直接绘图（使用drawRect：或drawLayer：inContext：方法），如果视图的背景颜色为nil或颜色哪怕有一点点透明度，那么CGContextClearRect的矩形区域将会显示为透明的，打出的孔将穿过视图包括它的背景颜色。如果背景颜色完全不透明，那么CGContextClearRect函数的结果将会是黑色。这是因为视图的背景颜色决定了是否视图的图形上下文是透明的还是不透明的
 
 一段路径是被合成的，意思是它是由多条独立的路径组成
 CGContextBeginPath:指定你绘制的路径是一条独立的路径
 定位当前点
 CGContextMoveToPoint
 描画一条线
 CGContextAddLineToPoint
 CGContextAddLines
 描画一段圆弧
 CGContextAddArc
 CGContextAddArcToPoint
 描画一个椭圆或圆形
 CGContextAddEllipseInRect
 描画一个矩形
 CGContextAddRect
 CGContextAddRects
 通过一到两个控制点描画一段贝赛尔曲线
 CGContextAddQuadCurveToPoint
 CGContextAddCurveToPoint
 关闭当前路径
 CGContextClosePath(context);这将从路径的终点到起点追加一条线。如果你打算填充一段路径，那么就不需要使用该命令，因为该命令会被自动调用
 描边或填充当前路径
 CGContextStrokePath
 CGContextFillPath
 CGContextEOFillPath
 CGContextDrawPath(context, kCGPathFillStroke);
 对当前路径描边或填充会清除掉路径。如果你只想使用一条命令完成描边和填充任务，可以使用CGContextDrawPath命令，因为如果你只是使用CGContextStrokePath对路径描边，路径就会被清除掉，你就不能再对它进行填充了
 
 创建路径并描边路径或填充路径只需一条命令就可完成的函数：
 CGContextStrokeLineSegments
 CGContextStrokeRect
 CGContextStrokeRectWithWidth
 CGContextFillRect
 CGContextFillRects
 CGContextStrokeEllipseInRect
 CGContextFillEllipseInRect
 // 绘制:
 [UIImage对象 drawAtPoint]
 [UIImage对象 drawInRect]

 // 裁剪:
 使用CGContextEOCllip设置裁剪区域然后进行绘图
 
 // 在上下文裁剪区域中挖一个三角形状的孔
 CGContextMoveToPoint(con, 90, 100);
 CGContextAddLineToPoint(con, 100, 90);
 CGContextAddLineToPoint(con, 110, 100);
 CGContextClosePath(con);
 CGContextAddRect(con, CGContextGetClipBoundingBox(con));
 // 使用奇偶规则，裁剪区域为矩形减去三角形区域
 CGContextEOClip(con);
 
 渐变:
 CGContextRef con = UIGraphicsGetCurrentContext();
 
 CGContextSaveGState(con);
 
 // 在上下文裁剪区域挖一个三角形孔
 
 CGContextMoveToPoint(con, 90, 100);
 
 CGContextAddLineToPoint(con, 100, 90);
 
 CGContextAddLineToPoint(con, 110, 100);
 
 CGContextClosePath(con);
 
 CGContextAddRect(con, CGContextGetClipBoundingBox(con));
 
 CGContextEOClip(con);
 
 //绘制一个垂线，让它的轮廓形状成为裁剪区域
 
 CGContextMoveToPoint(con, 100, 100);
 
 CGContextAddLineToPoint(con, 100, 19);
 
 CGContextSetLineWidth(con, 20);
 
 // 使用路径的描边版本替换图形上下文的路径
 
 CGContextReplacePathWithStrokedPath(con);
 
 // 对路径的描边版本实施裁剪
 
 CGContextClip(con);
 
 // 绘制渐变
 
 CGFloat locs[3] = { 0.0, 0.5, 1.0 };
 
 CGFloat colors[12] = {
 
 0.3,0.3,0.3,0.8, // 开始颜色，透明灰
 
 0.0,0.0,0.0,1.0, // 中间颜色，黑色
 
 0.3,0.3,0.3,0.8 // 末尾颜色，透明灰
 
 };
 
 CGColorSpaceRef sp = CGColorSpaceCreateDeviceGray();
 
 CGGradientRef grad = CGGradientCreateWithColorComponents (sp, colors, locs, 3);
 
 CGContextDrawLinearGradient(con, grad, CGPointMake(89,0), CGPointMake(111,0), 0);
 
 CGColorSpaceRelease(sp);
 
 CGGradientRelease(grad);
 
 CGContextRestoreGState(con); // 完成裁剪
 
 // 绘制红色箭头
 
 CGContextSetFillColorWithColor(con, [[UIColor redColor] CGColor]);
 
 CGContextMoveToPoint(con, 80, 25);
 
 CGContextAddLineToPoint(con, 100, 0);
 
 CGContextAddLineToPoint(con, 120, 25);
 
 CGContextFillPath(con); 
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
