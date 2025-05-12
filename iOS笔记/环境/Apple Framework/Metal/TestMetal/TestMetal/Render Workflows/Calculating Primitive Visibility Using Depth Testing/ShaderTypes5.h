//
//  ShaderTypes5.h
//  TestMetal
//
//  Created by youdun on 2023/9/1.
//

#ifndef ShaderTypes5_h
#define ShaderTypes5_h

#include <simd/simd.h>

typedef enum VertexInputIndex5
{
    VertexInputIndex5Vertices = 0,
    VertexInputIndex5Viewport = 1,
} VertexInputIndex5;

typedef struct
{
    vector_float3 position;
    vector_float4 color;
} Vertex5;

#endif /* ShaderTypes5_h */
