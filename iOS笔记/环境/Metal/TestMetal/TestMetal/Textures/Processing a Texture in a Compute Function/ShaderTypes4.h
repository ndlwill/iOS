//
//  ShaderTypes4.h
//  TestMetal
//
//  Created by youdun on 2023/8/30.
//

#ifndef ShaderTypes4_h
#define ShaderTypes4_h

typedef enum VertexInputIndex4
{
    VertexInputIndex4Vertices     = 0,
    VertexInputIndex4ViewportSize = 1,
} VertexInputIndex4;

/**
 Texture index values shared between the Metal shader and C code ensure the shader buffer inputs match the Metal API texture set calls.
 */
typedef enum TextureIndex4
{
    TextureIndex4Input  = 0,
    TextureIndex4Output = 1,
} TextureIndex4;

typedef struct {
    // The position for the vertex, in pixel space; a value of 100 indicates 100 pixels from the origin/center.
    vector_float2 position;

    // The 2D texture coordinate for this vertex.
    vector_float2 textureCoordinate;
} Vertex4;


#endif /* ShaderTypes4_h */
