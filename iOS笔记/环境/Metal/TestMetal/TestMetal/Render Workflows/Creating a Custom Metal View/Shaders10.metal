//
//  Shaders10.metal
//  TestMetal
//
//  Created by youdun on 2023/9/21.
//

#include "../../CommonShaderTypes.h"
#include <metal_stdlib>
using namespace metal;

struct RasterizerData10
{
    float4 clipSpacePosition [[position]];
    float3 color;
};

vertex RasterizerData10
vertexShader10(uint vertexID [[ vertex_id ]],
               constant CommonVertex2 *vertexArray [[ buffer(CommonVertexInputIndexVertices) ]],
               constant CommonUniforms &uniforms  [[ buffer(CommonVertexInputIndexUniforms) ]])

{
    RasterizerData10 out;

    float2 pixelSpacePosition = vertexArray[vertexID].position.xy;

    // Scale the vertex by scale factor of the current frame
    pixelSpacePosition *= uniforms.scale;

    float2 viewportSize = float2(uniforms.viewportSize);

    out.clipSpacePosition.xy = pixelSpacePosition / (viewportSize / 2.0);
    out.clipSpacePosition.z = 0.0;
    out.clipSpacePosition.w = 1.0;

    out.color = vertexArray[vertexID].color.rgb;

    return out;
}

fragment float4
fragmentShader10(RasterizerData10 in [[stage_in]])
{
    return float4(in.color, 1.0);
}
