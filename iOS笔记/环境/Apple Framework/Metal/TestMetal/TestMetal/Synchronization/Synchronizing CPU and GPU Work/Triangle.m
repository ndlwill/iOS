//
//  Triangle.m
//  TestMetal
//
//  Created by youdun on 2023/9/20.
//

#import "Triangle.h"

@implementation Triangle

+ (const CommonVertex2 *)vertices {
    const float triangleSize = 64;
    static const CommonVertex2 triangleVertices[] =
    {
        // Pixel Positions,                              RGBA colors.
        { { -0.5 * triangleSize, -0.5 * triangleSize },  { 1, 1, 1, 1 } },
        { {  0.0 * triangleSize,  0.5 * triangleSize },  { 1, 1, 1, 1 } },
        { {  0.5 * triangleSize, -0.5 * triangleSize },  { 1, 1, 1, 1 } }
    };
    return triangleVertices;
}

+ (NSUInteger)vertexCount {
    return 3;
}

@end
