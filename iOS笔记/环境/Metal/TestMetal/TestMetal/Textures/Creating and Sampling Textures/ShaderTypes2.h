//
//  ShaderTypes1.h
//  TestMetal
//
//  Created by youdun on 2023/8/28.
//

#include <simd/simd.h>

#ifndef ShaderTypes2_h
#define ShaderTypes2_h

/**
 Buffer index values shared between shader and C code to ensure Metal shader buffer inputs match Metal API buffer set calls.
 */
typedef enum VertexInputIndex2
{
    VertexInputIndex2Vertices     = 0,
    VertexInputIndex2ViewportSize = 1
} VertexInputIndex2;

/**
 Texture index values shared between shader and C code to ensure Metal shader buffer inputs match Metal API texture set calls
 */
typedef enum TextureIndex2
{
    TextureIndex2BaseColor = 0,
} TextureIndex2;

/**
 This structure defines the layout of vertices sent to the vertex shader.
 This header is shared between the .metal shader and C code, to guarantee that the layout of the vertex array in the C code matches the layout that the .metal vertex shader expects.
 
 Add a field to the vertex format to hold texture coordinates
 */
typedef struct
{
    // Positions in pixel space. A value of 100 indicates 100 pixels from the origin/center.
    vector_float2 position;
    // 2D texture coordinate
    vector_float2 textureCoordinate;
} CustomVertex2;


#endif /* ShaderTypes2_h */
