//
//  DrawLib.h
//  DrawLib
//
//  Created by dzcx on 2018/7/17.
//

#import <Foundation/Foundation.h>

@interface DrawLib : NSObject

// 绘制虚线 还可以通过CAShapeLayer
+ (void)drawDashedLineInContext:(CGContextRef)context
                      lineWidth:(CGFloat)lineWidth // 线的粗细
                        lineCap:(CGLineCap)lineCap
                lineDashPattern:(CGFloat *)lengthArray
                lineStrokeColor:(CGColorRef)lineStrokeColor
                 lineBeginPoint:(CGPoint)lineBeginPoint
                   lineEndPoint:(CGPoint)lineEndPoint;

@end
