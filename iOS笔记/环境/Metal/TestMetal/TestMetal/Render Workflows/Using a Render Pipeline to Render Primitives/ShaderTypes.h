//
//  ShaderTypes.h
//  TestMetal
//
//  Created by youdun on 2023/8/25.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

/**
 Buffer index values shared between shader and C code to ensure Metal shader buffer inputs match Metal API buffer set calls.
 */
typedef enum VertexInputIndex
{
    VertexInputIndexVertices     = 0,
    VertexInputIndexViewportSize = 1
} VertexInputIndex;

/**
 This structure defines the layout of vertices sent to the vertex shader.
 This header is shared between the .metal shader and C code, to guarantee that the layout of the vertex array in the C code matches the layout that the .metal vertex shader expects.
 */
typedef struct
{
    // Positions in pixel space. A value of 100 indicates 100 pixels from the origin/center.
    vector_float2 position;
    vector_float4 color;
} CustomVertex;

#endif /* ShaderTypes_h */
