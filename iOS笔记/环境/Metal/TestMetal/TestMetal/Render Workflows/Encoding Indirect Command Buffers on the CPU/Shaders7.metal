//
//  Shaders7.metal
//  TestMetal
//
//  Created by youdun on 2023/9/6.
//

#include "ShaderTypes7.h"
#include <metal_stdlib>
using namespace metal;

struct RasterizerData7
{
    float4 position [[position]];
    float2 tex_coord;
};

vertex RasterizerData7
vertexShader7(uint                           vertexID       [[ vertex_id ]],
              uint                           objectIndex    [[ instance_id ]],
              const device Vertex7           *vertices      [[ buffer(VertexBufferIndex7Vertices) ]],
              const device ObjectPerameters7 *object_params [[ buffer(VertexBufferIndex7ObjectParams) ]],
              constant FrameState7           *frame_state   [[ buffer(VertexBufferIndex7FrameState) ]])
{
    RasterizerData7 out;

    float2 worldObjectPostion  = object_params[objectIndex].position;
    float2 modelVertexPosition = vertices[vertexID].position;
    float2 worldVertexPosition = modelVertexPosition + worldObjectPostion;
    float2 clipVertexPosition  = frame_state->aspectScale * ViewScale * worldVertexPosition;

    out.position = float4(clipVertexPosition.x, clipVertexPosition.y, 0, 1);
    out.tex_coord = float2(vertices[vertexID].texcoord);

    return out;
}


fragment float4
fragmentShader7(RasterizerData7 in [[ stage_in ]])
{
    float4 output_color = float4(in.tex_coord.x, in.tex_coord.y, 0, 1);

    return output_color;
}
