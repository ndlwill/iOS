//
//  Shaders3.metal
//  TestMetal
//
//  Created by youdun on 2023/8/29.
//

#include "ShaderTypes3.h"
#include <metal_stdlib>
using namespace metal;

#pragma mark - Shaders for simple pipeline used to render triangle to renderable texture
// Vertex shader outputs and fragment shader inputs for simple pipeline
struct SimplePipelineRasterizerData3
{
    float4 position [[position]];
    float4 color;
};

// Vertex shader which passes position and color through to rasterizer.
vertex SimplePipelineRasterizerData3
simpleVertexShader3(const uint vertexID [[ vertex_id ]],
                   const device SimpleVertex3 *vertices [[ buffer(VertexInputIndex3Vertices) ]])
{
    SimplePipelineRasterizerData3 out;

    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);
    out.position.xy = vertices[vertexID].position.xy;

    out.color = vertices[vertexID].color;

    return out;
}

// Fragment shader that just outputs color passed from rasterizer.
fragment float4 simpleFragmentShader3(SimplePipelineRasterizerData3 in [[stage_in]])
{
    return in.color;
}

#pragma mark - Shaders for pipeline used texture from renderable texture when rendering to the drawable.

// Vertex shader outputs and fragment shader inputs for texturing pipeline.
struct TexturePipelineRasterizerData3
{
    float4 position [[position]];
    float2 texcoord;
};

// Vertex shader which adjusts positions by an aspect ratio and passes texture coordinates through to the rasterizer.
vertex TexturePipelineRasterizerData3
textureVertexShader3(const uint vertexID [[ vertex_id ]],
                    const device TextureVertex3 *vertices [[ buffer(VertexInputIndex3Vertices) ]],
                    constant float &aspectRatio [[ buffer(VertexInputIndex3AspectRatio) ]])
{
    TexturePipelineRasterizerData3 out;

    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);

    out.position.x = vertices[vertexID].position.x * aspectRatio;
    out.position.y = vertices[vertexID].position.y;

    out.texcoord = vertices[vertexID].texcoord;

    return out;
}
// Fragment shader that samples a texture and outputs the sampled color.
fragment float4 textureFragmentShader3(TexturePipelineRasterizerData3 in [[stage_in]],
                                      texture2d<float> texture [[ texture(TextureInputIndex3Color) ]])
{
    sampler simpleSampler;

    // Sample data from the texture.
    float4 colorSample = texture.sample(simpleSampler, in.texcoord);

    // Return the color sample as the final color.
    return colorSample;
}
