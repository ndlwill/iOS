//
//  ShaderTypes12.h
//  TestMetal
//
//  Created by youdun on 2023/9/25.
//

#ifndef ShaderTypes12_h
#define ShaderTypes12_h

#include <simd/simd.h>

// Number of unique meshes/objects in the scene
#define NumObjects12    65536

// The number of objects in a row
#define GridWidth12     256

// The number of object in a column
#define GridHeight12    ((NumObjects12 + GridWidth12 - 1) / GridWidth12)

// Scale of each object when drawn
#define ViewScale12    0.25

// Because the objects are centered at origin, the scale appliced
#define ObjectSize12    2.0

// Distance between each object
#define ObjecDistance12 2.1

typedef struct
{
    packed_float2 position;
    packed_float2 texcoord;
} Vertex12;

// Structure defining parameters for each rendered object
typedef struct ObjectParameters12
{
    packed_float2 position;
    float boundingRadius;
    uint32_t numVertices;
    uint32_t startVertex;
} ObjectParameters12;


#endif /* ShaderTypes12_h */
