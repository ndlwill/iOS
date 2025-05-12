//
//  Shaders8.metal
//  TestMetal
//
//  Created by youdun on 2023/9/8.
//

#include "ShaderTypes8.h"
#include "../../CommonShaderTypes.h"
#include <metal_stdlib>
using namespace metal;

// MARK: - Define argument buffers
/**
 The Metal Shading Language defines argument buffers as custom structures.
 Each structure element represents an individual resource that the shader code declares as a texture, sampler, buffer, or constant data type.
 
 The sample declares the argument buffer as a FragmentShaderArguments structure.
 
 With Metal 2, the sample app associates an integer, which the shader code declares with the [[id(n)]] attribute qualifier to specify the index of the individual resources.
 The Metal 2 target uses these identifiers to encode resources into a buffer.
 
 This argument buffer contains the following resources:
 texture, a 2D texture with an index of 0
 sampler, a sampler with an index of 1
 buffer, a float buffer with an index of 2
 _constant, a uint32_t constant with an index of 3

 With Metal 3, the sample app’s Objective-C code can write the resources directly to a buffer.
 Because of this, the Metal 3 target defines FragmentShaderArguments in a header it shares with the Renderer8 classes’ code.
 template<typename T>
 class texture2d : public MTLResourceID {
 public:
     texture2d(MTLResourceID v) : MTLResourceID(v) {}
 };

 class sampler : public MTLResourceID {
 public:
     sampler(MTLResourceID v) : MTLResourceID(v) {}
 };
 typedef uint16_t half;
 #define DEVICE

 #else

 #define DEVICE device

 #endif

 struct FragmentShaderArguments {
     texture2d<half>  exampleTexture;
     sampler          exampleSampler;
     DEVICE float    *exampleBuffer;
     uint32_t         exampleConstant;
 };
 */

// half: A 16-bit floating-point.
struct FragmentShaderArguments8 {
    texture2d<half> texture   [[ id(ArgumentBufferID8Texture)  ]];
    sampler         sampler   [[ id(ArgumentBufferID8Sampler)  ]];
    device float    *buffer   [[ id(ArgumentBufferID8Buffer)   ]];
    uint32_t        _constant [[ id(ArgumentBufferID8Constant) ]];
};

// The vertex shader outputs and the per-fragment inputs.
struct RasterizerData8
{
    float4 position [[ position ]];
    float2 texCoord;
    half4  color;
};

vertex RasterizerData8
vertexShader8(uint                      vertexID  [[ vertex_id ]],
              const device CommonVertex *vertices [[ buffer(CommonVertexBufferInputIndexVertices) ]])
{
    RasterizerData8 out;

    float2 position = vertices[vertexID].position;

    out.position.xy = position;
    out.position.z  = 0.0;
    out.position.w  = 1.0;

    out.texCoord = vertices[vertexID].texCoord;
    out.color    = (half4)vertices[vertexID].color;

    return out;
}

// MARK: - Access the resources in an argument bufferin page link
/**
 uses the argument buffer as a single parameter
 
 Within a function, accessing encoded resources in an argument buffer is similar to accessing individual resources directly.
 The main difference is that the function accesses the resources as elements of the argument buffer structure.

 In the following example, the fragmentShaderArgs parameter of the fragmentShader function accesses the argument buffer resources:
 
 The example uses all four resources in the argument buffer to produce the final color for each fragment.
 */
fragment float4
fragmentShader8(RasterizerData8 in [[ stage_in ]],
                device FragmentShaderArguments8 &fragmentShaderArgs [[ buffer(CommonFragmentBufferInputIndexArguments) ]])
{
    // Get the encoded sampler from the argument buffer.
    sampler _sampler = fragmentShaderArgs.sampler;

    // Sample the encoded texture in the argument buffer.
    half4 texture = fragmentShaderArgs.texture.sample(_sampler, in.texCoord);

    // Use the fragment position and the encoded constant in the argument buffer to calculate an array index.
    uint32_t index = (uint32_t)in.position.x % fragmentShaderArgs._constant;

    // Index into the encoded buffer in the argument buffer.
    float colorScale = fragmentShaderArgs.buffer[index];

    // Add the sample and color values together and return the result.
    // texture.w 表示从纹理采样操作中获取的纹理像素的 alpha（透明度）值。这是一个范围在 0.0 到 1.0 之间的值，其中 0.0 表示完全透明，1.0 表示完全不透明。
    // 这通常用于执行纹理混合和颜色调整操作
    return float4((1.0 - texture.w) * colorScale * in.color + texture);
}
