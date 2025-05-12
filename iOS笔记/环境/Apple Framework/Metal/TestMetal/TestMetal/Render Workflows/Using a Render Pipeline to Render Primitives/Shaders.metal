//
//  Shaders.metal
//  TestMetal
//
//  Created by youdun on 2023/8/25.
//

#include <metal_stdlib>
using namespace metal;

#include "ShaderTypes.h"

// Vertex shader outputs and fragment shader inputs
/**
 You need to tell Metal which field in the rasterization data provides position data, because Metal doesn’t enforce any particular naming convention for fields in your struct. Annotate the position field with the [[position]] attribute qualifier to declare that this field holds the output position.

 The fragment function simply passes the rasterization stage’s data to later stages so it doesn’t need any additional arguments.
 */
struct RasterizerData
{
    /**
     The output position must be defined as a vector_float4.
     
     The [[position]] attribute of this member indicates that this value is the clip space position of the vertex when this structure is returned from the vertex function.
     */
    float4 position [[position]];

    /**
     Since this member does not have a special attribute, the rasterizer interpolates its value with the values of the other triangle vertices and then passes the interpolated value to the fragment shader for each fragment in the triangle.
     */
    float4 color;
};

// Declare the Vertex Function
/**
 Declare the vertex function, including its input arguments and the data it outputs. Much like compute functions were declared using the kernel keyword, you declare a vertex function using the vertex keyword.
 
 The first argument, vertexID, uses the [[vertex_id]] attribute qualifier, which is another Metal keyword.
 When you execute a render command, the GPU calls your vertex function multiple times, generating a unique value for each vertex.
 
 The second argument, vertices, is an array that contains the vertex data, using the CustomVertex struct previously defined.
 
 To transform the position into Metal’s coordinates, the function needs the size of the viewport (in pixels) that the triangle is being drawn into, so this is stored in the viewportSizePointer argument.
 
 The second and third arguments have the [[buffer(n)]] attribute qualifier.
 By default, Metal assigns slots in the argument table for each parameter automatically.
 When you add the [[buffer(n)]] qualifier to a buffer argument, you tell Metal explicitly which slot to use. Declaring slots explicitly can make it easier to revise your shaders without also needing to change your app code.
 Declare the constants for the two indicies in the shared header file.

 The function’s output is a RasterizerData struct.
 
 Write the Vertex Function:
 Vertex functions must provide position data in clip-space coordinates, which are 3D points specified using a four-dimensional homogenous vector (x,y,z,w).
 The rasterization stage takes the output position and divides the x,y, and z coordinates by w to generate a 3D point in normalized device coordinates. Normalized device coordinates are independent of viewport size.
 
 "Left-handed coordinate system"（左手坐标系）
 X 轴：正方向是从左向右。
 Y 轴：正方向是从下向上。
 Z 轴：正方向是从前向后（屏幕内）。
 左手坐标系的名称来源于在空间中用左手的食指指向 X 轴的正方向，大拇指指向 Z 轴的正方向，而剩下的三指指向 Y 轴的正方向，这种手势可以形成一个类似于坐标轴的形状。
 
 "Right-handed coordinate system"（右手坐标系）
 X 轴：正方向是从左向右。
 Y 轴：正方向是从下向上。
 Z 轴：正方向是从前向后（屏幕外）。
 与左手坐标系不同，右手坐标系的名称来源于在空间中用右手的食指指向 X 轴的正方向，大拇指指向 Z 轴的正方向，而剩下的三指指向 Y 轴的正方向。
 
 Normalized device coordinates use a left-handed coordinate system and map to positions in the viewport.
 Primitives are clipped to a box in this coordinate system and then rasterized.
 The lower-left corner of the clipping box is at an (x,y) coordinate of (-1.0,-1.0) and the upper-right corner is at (1.0,1.0).
 Positive-z values point away from the camera (into the screen.) The visible portion of the z coordinate is between 0.0 (the near clipping plane) and 1.0 (the far clipping plane).
 */
vertex RasterizerData
vertexShader(uint vertexID [[vertex_id]],
             constant CustomVertex *vertices [[buffer(VertexInputIndexVertices)]],
             constant vector_uint2 *viewportSizePointer [[buffer(VertexInputIndexViewportSize)]])
{
    RasterizerData out;

    /**
     Index into the array of positions to get the current vertex.
     The positions are specified in pixel dimensions (i.e. a value of 100 is 100 pixels from the origin).
     */
    float2 pixelSpacePosition = vertices[vertexID].position.xy;

    // Get the viewport size and cast to float.
    vector_float2 viewportSize = vector_float2(*viewportSizePointer);
    
    /**
     To convert from positions in pixel space to positions in clip-space, divide the pixel coordinates by half the size of the viewport.
     */
    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);
    out.position.xy = pixelSpacePosition / (viewportSize / 2.0);

    // copy the color value into the out.color return value. Pass the input color directly to the rasterizer.
    out.color = vertices[vertexID].color;

    return out;
}

// Write a Fragment Function
/**
 A fragment is a possible change to the render targets.
 The rasterizer determines which pixels of the render target are covered by the primitive.
 Only fragments whose pixel centers are inside the triangle are rendered.
 
 A fragment function processes incoming information from the rasterizer for a single position and calculates output values for each of the render targets.
 These fragment values are processed by later stages in the pipeline, eventually being written to the render targets.
 
 Note
 The reason a fragment is called a possible change is because the pipeline stages after the fragment stage can be configured to reject some fragments or change what gets written to the render targets.
 In this sample, all values calculated by the fragment stage are written as-is to the render target.
 
 The fragment shader in this sample receives the same parameters that were declared in the vertex shader’s output.
 Declare the fragment function using the fragment keyword.
 It takes a single argument, the same RasterizerData structure that was provided by the vertex stage.
 Add the [[stage_in]] attribute qualifier to indicate that this argument is generated by the rasterizer.
 
 If your fragment function writes to multiple render targets, it must declare a struct with fields for each render target.
 Because this sample only has a single render target, you specify a floating-point vector directly as the function’s output.
 This output is the color to be written to the render target.

 The rasterization stage calculates values for each fragment’s arguments and calls the fragment function with them.
 The rasterization stage calculates its color argument as a blend of the colors at the triangle’s vertices.
 The closer a fragment is to a vertex, the more that vertex contributes to the final color.
 */
fragment float4 fragmentShader(RasterizerData in [[stage_in]])
{
    // Return the interpolated color.
    return in.color;
}
