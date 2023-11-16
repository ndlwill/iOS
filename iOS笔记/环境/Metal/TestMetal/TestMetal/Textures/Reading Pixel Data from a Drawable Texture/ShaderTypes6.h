//
//  ShaderTypes6.h
//  TestMetal
//
//  Created by youdun on 2023/9/4.
//

#ifndef ShaderTypes6_h
#define ShaderTypes6_h

#import <simd/simd.h>

typedef enum VertexInputIndex6
{
    VertexInputIndex6Vertices = 0,
    VertexInputIndex6Viewport = 1,
} VertexInputIndex6;

typedef struct Vertex6
{
    // Positions of the shader input vertices.
    vector_float2 position;

    // Floating point RGBA colors.
    vector_float4 color;
} Vertex6;

#endif /* ShaderTypes6_h */
