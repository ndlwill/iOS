//
//  Shaders5.metal
//  TestMetal
//
//  Created by youdun on 2023/9/1.
//

#include "ShaderTypes5.h"
#include <metal_stdlib>
using namespace metal;

struct RasterizerData5
{
    float4 clipSpacePosition [[position]];
    float4 color;
};

// Vertex shader.
vertex RasterizerData5
vertexShader5(uint                     vertexID      [[ vertex_id ]],
             const device Vertex5      *vertices     [[ buffer(VertexInputIndex5Vertices) ]],
             constant vector_uint2     &viewportSize [[ buffer(VertexInputIndex5Viewport) ]])
{
    RasterizerData5 out;
    
    // Initialize the output clip space position.
    out.clipSpacePosition = vector_float4(0.0, 0.0, 0.0, 1.0);
    
    // Input positions are specified in 2D pixel dimensions relative to the upper-left corner of the viewport.
    float2 pixelPosition = float2(vertices[vertexID].position.xy);
    
    // Use a float viewport to translate input positions from pixel space coordinates into a [-1, 1] coordinate range.
    const vector_float2 floatViewport = vector_float2(viewportSize);

    // Initialize the output clip-space position.
    out.clipSpacePosition = vector_float4(0.0, 0.0, 0.0, 1.0);
    
    // Convert upper-left relative pixel space positions into normalized clip space positions.
    const vector_float2 topDownClipSpacePosition = (pixelPosition.xy / (floatViewport.xy / 2.0)) - 1.0;
    
    /**
     Input positions increase downward (top-down) to match Metal blit regions which are also top-down.
     Clip space always increases upward, so you negate the y coordinate of `topDownClipSpacePosition` to output a correct `clipSpacePosition` value.
     */
    out.clipSpacePosition.y = -1 * topDownClipSpacePosition.y;
    out.clipSpacePosition.x = topDownClipSpacePosition.x;
    
    // MARK: - Generate Depth Values in Your Shaders
    /**
     Metal’s Normalized Device Coordinate (NDC) system uses four-dimensional coordinates, and that your vertex shader must provide a position for each vertex.
     to implement the depth test, you need to provide a value for the z coordinate.
     
     In this sample, you configure the z values in the user interface, and those values are passed down to the vertex shader.
     The shader then takes the z values on the input data and passes them through to the output’s z component.
     
     When the rasterizer calculates the data to send to the fragment shader, it interpolates between these z values
     
     Your fragment function can read the z value, ignore it, or modify it, as needed.
     If you don’t modify the value calculated by the rasterizer, a GPU can sometimes perform additional optimizations.
     For example, it may be able to execute the z test before running the fragment shader, so that it doesn’t run the fragment shader for hidden fragments.
     If you change the depth value in the fragment shader, you may incur a performance penalty because the GPU must execute the fragment shader first.
     */
    out.clipSpacePosition.z = vertices[vertexID].position.z;
    
    // Pass the input color straight to the output color.
    out.color = vertices[vertexID].color;
    
    return out;
}

// Fragment shader.
fragment float4 fragmentShader5(RasterizerData5 in [[stage_in]])
{
    // Return the color that set in the vertex shader.
    return in.color;
}
