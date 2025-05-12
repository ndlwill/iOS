//
//  DHVectorDiagram.h
//  LunarLander
//
//  Created by DreamHack on 16-4-14.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 构造方法中的数值全为抽象长度
// 比如一个顶点为(1,2)，单位长度unitLength为50，那么最终显示在屏幕上的这个顶点的坐标为(50, 100)
@interface DHVectorDiagram : NSObject

@property (nonatomic, strong) NSArray * vertexBuffers;

@property (nonatomic, strong) UIColor * strokeColor;

@property (nonatomic, strong) UIColor * fillColor;

// 单位长度，将抽象长度转换为像素长度
// 默认1
@property (nonatomic, assign) CGFloat unitLength;

@property (nonatomic, strong, readonly) NSMutableArray * worldVertexBuffers;

@property (nonatomic, assign, readonly) CGSize scale;
@property (nonatomic, assign, readonly) CGFloat radian;
@property (nonatomic, assign, readonly) CGPoint translation;

// 数组内容必须是NSValue封装的CGPoint

- (instancetype)initWithVertexBuffers:(NSArray *)vertexBuffers;

- (void)renderInContext:(CGContextRef)context;

@end

// 旋转平移缩放，操作的是抽象长度
@interface DHVectorDiagram (Transform)

// 平移
- (void)translateWithDeltaX:(CGFloat)dx deltaY:(CGFloat)dy;
// 缩放
- (void)scaleWithScalingFactorX:(CGFloat)sx scalingFactorY:(CGFloat)sy;
// 旋转
- (void)rotateWithRadian:(CGFloat)radian;

@end


@interface DHVectorDiagram (SepciallizedGraphs)

/**
 *  直接构造一个等边三角形矢量图
 *
 *  @param length 等边三角形的边长
 *
 *  @return 等边三角形
 */
+ (instancetype)equilateralTriangleWithLength:(CGFloat)length;

/**
 *  直接构造一个正方形矢量图
 *
 *  @param length 正方形的边长
 *
 *  @return 正方形
 */
+ (instancetype)squareWithLength:(CGFloat)length;

/**
 *  直接构造一个五角星矢量图
 *
 *  @param length 五角星边长
 *
 *  @return 五角星
 */
+ (instancetype)pentastarWithLength:(CGFloat)length;

/**
 *  直接构造一个矩形矢量图
 *
 *  @param size 矩形的长和宽
 *
 *  @return 矩形
 */
+ (instancetype)rectangleWithSize:(CGSize)size;

/**
 *  直接构造一个平行四边形矢量图
 *
 *  @param size   平行四边形的两组对边的长度（width是底边长，height是斜边长）
 *  @param radian 一个底角的大小（左下角那个）
 *
 *  @return 平行四边形
 */
+ (instancetype)parallelogramWithSize:(CGSize)size cornerRadian:(CGFloat)radian;

/**
 *  直接构造一个任意正多边形，并且其中一条边（比如正三角形的底边）和屏幕水平方向平行
 *
 *  @param edgeCount 正几边形（必须大于等于3）
 *  @param length    边长（抽象长度）
 *
 *  @return 正多边形
 */
+ (instancetype)regularPolygon:(int)edgeCount edgeLength:(CGFloat)length;


@end