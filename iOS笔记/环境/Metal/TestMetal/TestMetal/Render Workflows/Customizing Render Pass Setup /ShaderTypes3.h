//
//  ShaderTypes3.h
//  TestMetal
//
//  Created by youdun on 2023/8/28.
//

#ifndef ShaderTypes3_h
#define ShaderTypes3_h

#include <simd/simd.h>

typedef enum VertexInputIndex3
{
    VertexInputIndex3Vertices    = 0,
    VertexInputIndex3AspectRatio = 1,
} VertexInputIndex3;

typedef struct
{
    vector_float2 position;
    vector_float4 color;
} SimpleVertex3;

typedef enum TextureInputIndex3
{
    TextureInputIndex3Color = 0,
} TextureInputIndex3;

typedef struct
{
    vector_float2 position;
    vector_float2 texcoord;
} TextureVertex3;


#endif /* ShaderTypes3_h */
