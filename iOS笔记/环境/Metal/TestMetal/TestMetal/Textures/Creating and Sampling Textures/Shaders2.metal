//
//  Shaders2.metal
//  TestMetal
//
//  Created by youdun on 2023/8/28.
//

#include <metal_stdlib>
#include "ShaderTypes2.h"
using namespace metal;

// To send the texture coordinates to the fragment shader, add a textureCoordinate value to the RasterizerData data structure
struct RasterizerData
{
    /**
     The [[position]] attribute qualifier of this member indicates this value is the clip space position of the vertex when this structure is returned from the vertex shader
     */
    float4 position [[position]];

    /**
     Since this member does not have a special attribute qualifier, the rasterizer will interpolate its value with values of other vertices making up the triangle and pass that interpolated value to the fragment shader for each fragment in that triangle.
     
     In the vertex shader, pass the texture coordinates to the rasterizer stage by writing them into the textureCoordinate field.
     The rasterizer stage interpolates these coordinates across the quad’s triangle fragments.
     */
    float2 textureCoordinate;

};

// Vertex Function
vertex RasterizerData
vertex2Shader(uint vertexID [[ vertex_id ]],
              constant CustomVertex2 *vertexArray [[ buffer(VertexInputIndex2Vertices) ]],
              constant vector_uint2 *viewportSizePointer [[ buffer(VertexInputIndex2ViewportSize) ]])
{
    RasterizerData out;

    /**
     Index into the array of positions to get the current vertex.Positions are specified in pixel dimensions (i.e. a value of 100 is 100 pixels from the origin)
     */
    float2 pixelSpacePosition = vertexArray[vertexID].position.xy;

    // Get the viewport size and cast to float.
    float2 viewportSize = float2(*viewportSizePointer);

    /**
     To convert from positions in pixel space to positions in clip-space, divide the pixel coordinates by half the size of the viewport. Z is set to 0.0 and w to 1.0 because this is 2D sample.
     
     "将像素空间中的位置转换为裁剪空间中的位置" 是指从屏幕或图像的像素坐标系转换为裁剪空间的坐标系。
     这是在图形渲染中的一个重要步骤，涉及到将图像或物体的位置从图像空间（像素坐标）映射到裁剪空间（规范化设备坐标）。
     
     在图形渲染管线中，通常会有一系列变换将对象从其原始位置变换到最终显示位置。
     这些变换包括模型变换、视图变换和投影变换。
     其中，投影变换会将物体的坐标从世界坐标系转换到裁剪空间，这是一个规范化的坐标系，其范围通常在[-1, 1]之间。
     
     这是渲染管线中非常重要的步骤，用于确保渲染出的图像在屏幕上正确显示。
     
     视图变换（View Transformation）是计算机图形学中的一个概念，用于将场景中的物体从世界坐标系（World Coordinates）转换到相机或观察者的坐标系，通常称为观察坐标系（View Coordinates）。
     视图变换通常包括以下操作：
     平移（Translation）：将物体沿着相机坐标系的轴移动，以模拟相机的位置。
     旋转（Rotation）：根据相机的朝向，对物体进行旋转，使物体在相机坐标系中的朝向与相机的朝向一致。
     缩放（Scale）：根据需要，可以对物体进行缩放，以适应相机的视野。
     
     模型变换（Model Transformation）是计算机图形学中的一个概念，用于将场景中的物体从物体的本地坐标系（或模型坐标系）转换到世界坐标系，从而实现物体在场景中的位置、旋转和缩放等变换。
     模型变换通常包括以下操作：
     平移（Translation）：将物体在本地坐标系中沿着各轴移动，改变物体的位置。
     旋转（Rotation）：绕物体的原点或其他轴进行旋转，改变物体的朝向。
     缩放（Scale）：沿着各轴对物体进行缩放，改变物体的大小。
     */
    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);
    out.position.xy = pixelSpacePosition / (viewportSize / 2.0);

    /**
     Pass the input textureCoordinate straight to the output RasterizerData. This value will be interpolated with the other textureCoordinate values in the vertices that make up the triangle.
     */
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;

    return out;
}

// MARK: - Calculate a Color from a Location in the Texture
/**
 You sample a texture to calculate a color from a location in the texture.
 To sample the texture data, the fragment function needs the texture coordinates and a reference to the texture to sample.
 In addition to the arguments passed in from the rasterizer stage, pass in a colorTexture argument with a texture2d type and the [[texture(index)]] attribute qualifier.
 This argument is a reference to a MTLTexture object to be sampled.

 Use the built-in texture sample() function to sample texel data.
 The sample() function takes two arguments: a sampler (textureSampler) that describes how you want to sample the texture, and texture coordinates (in.textureCoordinate) that describe the position in the texture to sample.
 The sample() function fetches one or more pixels from the texture and returns a color calculated from those pixels.
 
 When the area being rendered to isn’t the same size as the texture, the sampler can use different algorithms to calculate exactly what texel color the sample() function should return.
 Set the mag_filter mode to specify how the sampler should calculate the returned color when the area is larger than the size of the texture, and the min_filter mode to specify how the sampler should calculate the returned color when the area is smaller than the size of the texture.
 Setting a linear mode for both filters makes the sampler average the color of pixels surrounding the given texture coordinate, resulting in a smoother output image.
 
 Note
 Try increasing or decreasing the size of the quad to see how filtering works.
 */
// Fragment function
fragment float4
samplingShader(RasterizerData in [[stage_in]],
               texture2d<half> colorTexture [[ texture(TextureIndex2BaseColor) ]])
{
    constexpr sampler textureSampler (mag_filter::linear, min_filter::linear);

    // Sample the texture to obtain a color
    const half4 colorSample = colorTexture.sample(textureSampler, in.textureCoordinate);

    // return the color of the texture
    return float4(colorSample);
}
