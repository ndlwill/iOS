//
//  DHVectorDiagram.m
//  LunarLander
//
//  Created by DreamHack on 16-4-14.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import "DHVectorDiagram.h"
#import "DHMatrix.h"
#import "DHVector2D.h"

@interface DHVectorDiagram ()
{
    CGSize _scale;
    CGFloat _radian;
    CGPoint _translation;
    
    DHMatrix _scaleMatrix;
    DHMatrix _rotateMatrix;
    DHMatrix _translationMatrix;
}

@property (nonatomic, strong) NSMutableArray * worldVertexBuffers;

// 变换矩阵，最终的顶点计算将乘以变换矩阵
// 变换矩阵 = 当前所有应用的平移、缩放、旋转矩阵相乘
@property (nonatomic, assign) DHMatrix transformMatrix;

- (void)_updateVertexBuffers;
- (CGPoint)_translatePoint:(CGPoint)point withVector:(CGPoint)vector;

@end

@implementation DHVectorDiagram

- (void)dealloc
{
    // 使用的DHMatrix结构体中的values指针是手动分配的内存，需手动释放
    DHMatrixRelease(_scaleMatrix);
    DHMatrixRelease(_rotateMatrix);
    DHMatrixRelease(_translationMatrix);
    DHMatrixRelease(self.transformMatrix);
}

- (instancetype)initWithVertexBuffers:(NSArray *)vertexBuffers
{
    self = [super init];
    if (self) {
        _scale = CGSizeMake(1, 1);
        _radian = 0;
        _translation = CGPointZero;
        self.vertexBuffers = vertexBuffers;
        self.worldVertexBuffers = [vertexBuffers copy];
        self.unitLength = 1;
        self.transformMatrix = DHMatrixMakeIdentity(3);
        _translationMatrix = DHMatrixMakeIdentity(3);
        _scaleMatrix = DHMatrixMakeIdentity(3);
        _rotateMatrix = DHMatrixMakeIdentity(3);
    }
    return self;
}

- (void)renderInContext:(CGContextRef)context
{
    CGColorRef strokeColor = [UIColor blackColor].CGColor;
    if (self.strokeColor) {
        strokeColor = self.strokeColor.CGColor;
    }
    CGContextSetStrokeColorWithColor(context, strokeColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGPoint firstPoint = [self.worldVertexBuffers.firstObject CGPointValue];
    
    CGContextMoveToPoint(context, firstPoint.x * self.unitLength, firstPoint.y * self.unitLength);
    
    for (int i = 1; i < self.vertexBuffers.count; ++i) {
        CGPoint point = [self.worldVertexBuffers[i] CGPointValue];
        CGContextAddLineToPoint(context, point.x * self.unitLength, point.y * self.unitLength);
    }
    
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
}

#pragma mark - private methods

// 利用矩阵乘法生成矢量图的变形矩阵
- (void)_updateVertexBuffers
{
    // 构造一个单位矩阵
    // 然后用单位矩阵乘以缩放矩阵
    // 然后用所得的矩阵乘以旋转矩阵
    // 然后用所得的矩阵乘以平移矩阵
    // 最终所得的矩阵就是整个矢量图的变形矩阵，作用于矢量图的每一个点
    // 平移矩阵必须放到最后一个来乘，如果先平移了那么旋转和缩放就要GG了
    DHMatrix identityMatrix = DHMatrixMakeIdentity(3);
    DHMatrix tempScaleMatrix = DHMatrixMultiplication(identityMatrix, _scaleMatrix);
    DHMatrix tempRotateMatrix = DHMatrixMultiplication(tempScaleMatrix, _rotateMatrix);
    self.transformMatrix = DHMatrixMultiplication(tempRotateMatrix, _translationMatrix);
    
    NSMutableArray * vertexBuffers = [NSMutableArray arrayWithCapacity:0];
    [self.vertexBuffers enumerateObjectsUsingBlock:^(NSValue *  obj, NSUInteger idx, BOOL *stop) {
        
        // 将矢量图的点转换为矩阵表达，然后分别乘以变形矩阵
        CGPoint point = [obj CGPointValue];
        DHMatrix matrix = DHMatrixFromCGPoint(point);
        DHMatrix transformMatrix = DHMatrixMultiplication(matrix, self.transformMatrix);
        
        point = DHMatrixToCGPoint(transformMatrix);
        
        [vertexBuffers addObject:[NSValue valueWithCGPoint:point]];
        
        DHMatrixRelease(matrix);
        DHMatrixRelease(transformMatrix);
    }];
    
    self.worldVertexBuffers = [vertexBuffers copy];
    
    DHMatrixRelease(identityMatrix);
    DHMatrixRelease(tempScaleMatrix);
    DHMatrixRelease(tempRotateMatrix);
}

- (CGPoint)_translatePoint:(CGPoint)point withVector:(CGPoint)vector
{
    return CGPointMake(point.x + vector.x, point.y + vector.y);
}

#pragma mark - setter

#pragma mark - getter
- (CGSize)scale
{
    return _scale;
}

- (CGFloat)radian
{
    return _radian;
}

- (CGPoint)translation
{
    return _translation;
}

@end


@implementation DHVectorDiagram (Transform)

// 平移，根据当前平移量生成平移矩阵

- (void)translateWithDeltaX:(CGFloat)dx deltaY:(CGFloat)dy
{
    _translation = [self _translatePoint:_translation withVector:CGPointMake(dx, dy)];
    
    // 释放之前的平移矩阵
    DHMatrixRelease(_translationMatrix);
    _translationMatrix = DHTranslationMatrix(_translation.x, _translation.y);
    
    [self _updateVertexBuffers];
}

// 缩放，根据当前缩放大小生成缩放矩阵
- (void)scaleWithScalingFactorX:(CGFloat)sx scalingFactorY:(CGFloat)sy
{
    _scale = CGSizeMake(_scale.width * sx, _scale.height * sy);
    
    // 释放之前的缩放矩阵
    DHMatrixRelease(_scaleMatrix);
    _scaleMatrix = DHScaleMatrix(_scale.width, _scale.height);
    [self _updateVertexBuffers];
}

// 旋转，根据当前旋转角度生成旋转矩阵
- (void)rotateWithRadian:(CGFloat)radian
{
    _radian += radian;
    // 释放之前的旋转矩阵
    DHMatrixRelease(_rotateMatrix);
    _rotateMatrix = DHRotationMatrix(_radian);

    [self _updateVertexBuffers];
}

@end


@implementation DHVectorDiagram (SepciallizedGraphs)

+ (instancetype)equilateralTriangleWithLength:(CGFloat)length
{
    CGFloat width = length * (sqrt(3)/2);
    NSValue * vertex1 = [NSValue valueWithCGPoint:CGPointMake(0, -width * 2/3)];
    NSValue * vertex2 = [NSValue valueWithCGPoint:CGPointMake(-length/2, width/3)];
    NSValue * vertex3 = [NSValue valueWithCGPoint:CGPointMake(length/2, width/3)];
    DHVectorDiagram * equilateralTriangleDiagram = [[DHVectorDiagram alloc] initWithVertexBuffers:@[vertex1, vertex2, vertex3]];
    return equilateralTriangleDiagram;
}

+ (instancetype)squareWithLength:(CGFloat)length
{
    NSValue * vertex1 = [NSValue valueWithCGPoint:CGPointMake(-length/2, -length/2)];
    NSValue * vertex2 = [NSValue valueWithCGPoint:CGPointMake(length/2, -length/2)];
    NSValue * vertex3 = [NSValue valueWithCGPoint:CGPointMake(length/2, length/2)];
    NSValue * vertex4 = [NSValue valueWithCGPoint:CGPointMake(-length/2, length/2)];
    DHVectorDiagram * squareDiatram = [[DHVectorDiagram alloc] initWithVertexBuffers:@[vertex1, vertex2, vertex3, vertex4]];
    return squareDiatram;
}

+ (instancetype)pentastarWithLength:(CGFloat)length
{
    // 余弦定理计算五边形边长
    // 五角星五个外围顶点围起来的正五边形边长
    CGFloat pentagonLength = sqrt(pow(length, 2) + pow(length, 2) - 2 * length * length * cos(108.f/180 * M_PI));
    // 五角星五个内顶点围起来的正五边形边长
    CGFloat innerPentagonLength = sqrt(pow(length, 2) + pow(length, 2) - 2 * length * length * cos(36.f/180 * M_PI));
    
    // 五角星连接内部五边形后的边长
    // 同时也是五角星外接矩形的宽
    CGFloat boundingRectWidth = 2 * length + innerPentagonLength;
    
    // 五角星外接矩形高
    CGFloat boundingRectHeight = boundingRectWidth * sin(72.f/180 * M_PI);
    
    CGFloat height1 = pentagonLength * cos(54.f/180 * M_PI);
    CGFloat width2 = boundingRectWidth / 2 -  boundingRectWidth * cos(72.f/180 * M_PI);
    
    CGFloat offsetX = boundingRectHeight/2;
    CGFloat offsetY = tan(54.f/180 * M_PI) * innerPentagonLength / 2 + height1;
    
    NSValue * vertex1 =  [NSValue valueWithCGPoint:CGPointMake(boundingRectWidth/2 - offsetX, -offsetY)];
    NSValue * vertex2 =  [NSValue valueWithCGPoint:CGPointMake(length + innerPentagonLength - offsetX, height1 - offsetY)];
    NSValue * vertex3 =  [NSValue valueWithCGPoint:CGPointMake(boundingRectWidth - offsetX, height1 - offsetY)];
    NSValue * vertex4 =  [NSValue valueWithCGPoint:CGPointMake(boundingRectWidth - length * cos(36.f/180 * M_PI) - offsetX, height1 + length * sin(36.f / 180 * M_PI) - offsetY)];
    NSValue * vertex5 =  [NSValue valueWithCGPoint:CGPointMake(boundingRectWidth - width2 - offsetX, boundingRectHeight - offsetY)];
    NSValue * vertex6 =  [NSValue valueWithCGPoint:CGPointMake(boundingRectWidth/2 - offsetX, boundingRectHeight - length * cos(54.f / 180 * M_PI) - offsetY)];
    NSValue * vertex7 =  [NSValue valueWithCGPoint:CGPointMake(width2 - offsetX, boundingRectHeight - offsetY)];
    NSValue * vertex8 =  [NSValue valueWithCGPoint:CGPointMake(length * cos(36.f/180 * M_PI) - offsetX, height1 + length * sin(36.f / 180 * M_PI) - offsetY)];
    NSValue * vertex9 =  [NSValue valueWithCGPoint:CGPointMake(-offsetX, height1 - offsetY)];
    NSValue * vertex10 = [NSValue valueWithCGPoint:CGPointMake(length - offsetX, height1 - offsetY)];
    
    DHVectorDiagram * pentastarDiagram = [[DHVectorDiagram alloc] initWithVertexBuffers:@[vertex1,vertex2,vertex3,vertex4,vertex5,vertex6,vertex7,vertex8,vertex9,vertex10]];
    
    return pentastarDiagram;
}

+ (instancetype)rectangleWithSize:(CGSize)size
{
    NSValue * vertex1 =  [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    NSValue * vertex2 =  [NSValue valueWithCGPoint:CGPointMake(size.width, 0)];
    NSValue * vertex3 =  [NSValue valueWithCGPoint:CGPointMake(size.width, size.height)];
    NSValue * vertex4 =  [NSValue valueWithCGPoint:CGPointMake(0, size.height)];
    DHVectorDiagram * rectangleDiagram = [[DHVectorDiagram alloc] initWithVertexBuffers:@[vertex1, vertex2, vertex3, vertex4]];
    
    return rectangleDiagram;
}


+ (instancetype)parallelogramWithSize:(CGSize)size cornerRadian:(CGFloat)radian
{
    CGFloat xOffset = size.height * cos(radian);
    CGFloat height = size.height * sin(radian);
    
    CGFloat longer = (size.width + xOffset) / 2;
    CGFloat shorter = (size.width - xOffset) / 2;
    
    NSValue * vertex1 =  [NSValue valueWithCGPoint:CGPointMake(-shorter, -height/2)];
    NSValue * vertex2 =  [NSValue valueWithCGPoint:CGPointMake(longer, -height/2)];
    NSValue * vertex3 =  [NSValue valueWithCGPoint:CGPointMake(shorter, height/2)];
    NSValue * vertex4 =  [NSValue valueWithCGPoint:CGPointMake(-longer, height/2)];
    DHVectorDiagram * parallelogramDiagram = [[DHVectorDiagram alloc] initWithVertexBuffers:@[vertex1, vertex2, vertex3, vertex4]];
    
    return parallelogramDiagram;
}

+ (instancetype)regularPolygon:(int)edgeCount edgeLength:(CGFloat)length
{
    if (edgeCount < 3) {
        return nil;
    }
    
    if (edgeCount == 3) {
        return [self equilateralTriangleWithLength:length];
    }
    
    if (edgeCount == 4) {
        return [self squareWithLength:length];
    }
    
    // 相邻两个顶点和中心点连接后形成的角度
    CGFloat innerAngle = M_PI * 2 / edgeCount;
    
    // 首先计算左下角那个顶点的坐标
    CGFloat x1 = - length/2;
    CGFloat cot = cos(innerAngle/2) / sin(innerAngle/2);
    CGFloat y1 = length/2 * cot;
    
    // 构造初始向量
    DHVector2D * vector = [[DHVector2D alloc] initWithCoordinateExpression:CGPointMake(x1, y1)];
    
    NSMutableArray * vertexes = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < edgeCount; ++i) {
        NSValue * vertex = [NSValue valueWithCGPoint:vector.endPoint];
        [vertexes addObject:vertex];
        
        // 旋转向量
        [vector rotateClockwiselyWithRadian:innerAngle];
    }
    
    DHVectorDiagram * regularPolygon = [[DHVectorDiagram alloc] initWithVertexBuffers:vertexes];
    
    return regularPolygon;
}



@end
