//
//  ShaderTypes7.h
//  TestMetal
//
//  Created by youdun on 2023/9/6.
//

#ifndef ShaderTypes7_h
#define ShaderTypes7_h
#include <simd/simd.h>

#define NumObjects    15

#define GridWidth     5
#define GridHeight    ((NumObjects+GridWidth-1)/GridWidth)

// Scale of each object when drawn
#define ViewScale    0.25

// Because the objects are centered at origin, the scale appliced
#define ObjectSize    2.0

// Distance between each object
#define ObjecDistance 2.1

typedef struct
{
    packed_float2 position;
    packed_float2 texcoord;
} Vertex7;

// Structure defining the layout of variable changing once (or less) per frame
typedef struct FrameState7
{
    vector_float2 aspectScale;
} FrameState7;

// Structure defining parameters for each rendered object
typedef struct ObjectPerameters7
{
    packed_float2 position;
} ObjectPerameters7;

// Buffer index values shared between the vertex shader and C code
typedef enum VertexBufferIndex7
{
    VertexBufferIndex7Vertices,
    VertexBufferIndex7ObjectParams,
    VertexBufferIndex7FrameState
} VertexBufferIndex7;


/*
// Buffer index values shared between the compute kernel and C code
typedef enum KernelBufferIndex7
{
    KernelBufferIndex7FrameState,
    KernelBufferIndex7ObjectParams,
    KernelBufferIndex7Arguments
} KernelBufferIndex7;

typedef enum ArgumentBufferBufferID7
{
    ArgumentBufferID7CommandBuffer,
    ArgumentBufferID7ObjectMesh
} ArgumentBufferBufferID7;
 */

#endif /* ShaderTypes7_h */
