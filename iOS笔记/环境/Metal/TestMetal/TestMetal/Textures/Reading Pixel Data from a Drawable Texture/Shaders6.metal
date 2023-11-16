//
//  Shaders6.metal
//  TestMetal
//
//  Created by youdun on 2023/9/4.
//

#include "ShaderTypes6.h"
#include <metal_stdlib>
using namespace metal;


struct RasterizerData6 {
    float4 clipSpacePosition [[position]];

    float4 color;
};

vertex RasterizerData6
vertexShader6(uint                    vertexID  [[ vertex_id ]],
              const device Vertex6    *vertices [[ buffer(VertexInputIndex6Vertices) ]],
              constant vector_uint2   &viewport [[ buffer(VertexInputIndex6Viewport) ]])
{
    RasterizerData6 out;

    out.clipSpacePosition = vector_float4(0.0, 0.0, 0.0, 1.0);

    float2 pixelPosition = vertices[vertexID].position;

    const vector_float2 floatViewport = vector_float2(viewport);

    const vector_float2 topDownClipSpacePosition = (pixelPosition.xy / (floatViewport.xy / 2.0)) - 1.0;

    out.clipSpacePosition.y = -1 * topDownClipSpacePosition.y;
    out.clipSpacePosition.x = topDownClipSpacePosition.x;

    out.color = vertices[vertexID].color;

    return out;
}

fragment float4 fragmentShader6(RasterizerData6 in [[stage_in]])
{
    return in.color;
}
