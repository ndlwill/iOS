//
//  Shaders11.metal
//  TestMetal
//
//  Created by youdun on 2023/9/22.
//

#include "../../CommonShaderTypes.h"
#include <metal_stdlib>
using namespace metal;

struct RasterizerData11
{
    float4 position [[ position ]];
    float2 texCoord;
};

// MARK: - Arrays of Arguments in the Metal Shading Language
/**
 Arrays can be used as parameters to graphics or compute functions.
 When a function takes an array as a parameter, the index of the first resource in the array is equal to the base index of the array parameter itself.
 Thus, each subsequent resource in the array is automatically assigned a subsequent index value, counting incrementally from the base index value.
 
 For example, the following fragment function, exampleFragmentFunction, has a parameter, textureParameters, that’s an array of 10 textures with a base index value of 5.
 fragment float4
 exampleFragmentFunction(array<texture2d<float>, 10> textureParameters [[ texture(5) ]])
 
 Because textureParameters has a [[ texture(5) ]] attribute qualifier, the corresponding Metal framework method to set this parameter is setFragmentTexture:atIndex:, where the values for index begin at 5.
 Thus, the texture at array index 0 is set at index number 5, the texture at array index 1 is set at index number 6, and so on.
 The last texture in the array, at array index 9, is set at index number 14.
 */

// MARK: - Define Argument Buffers with Arrays
/**
 Arrays can also be used as elements of an argument buffer structure.
 In this case, the [[ id(n) ]] attribute qualifier of an argument buffer behaves the same way as the [[ texture(n) ]] attribute qualifier of a function parameter,
 where n is the base index value of the array.
 However, you don’t call the setFragmentTexture:atIndex: method, of a MTLRenderCommandEncoder object, to set a texture from the array.
 Instead, you call the setTexture:atIndex: method, of a MTLArgumentEncoder object, to encode a texture from the array into the argument buffer,
 where index corresponds to the base index value, n, plus the index of the texture within the array.
 
 The argument buffer in this sample is declared as a FragmentShaderArguments structure, and this is its definition:
 
 Each element of this structure uses the array<T, N> template, which defines the element as an array of a certain type, T, and number of elements, N.
 This argument buffer contains the following resources:
 textures, an array of 32 2D textures with a base index value of 0.
 buffers, an array of 32 float buffers with a base index value of 100.
 _constants, an array of 32 uint32_t constants with a base index value of 200.
 */
struct FragmentShaderArguments {
    array<texture2d<float>, CommonNumTextureArguments> textures   [[ id(CommonArgumentBufferIDTextures) ]];
    array<device float *,  CommonNumBufferArguments>   buffers    [[ id(CommonArgumentBufferIDBuffers)  ]];
    array<uint32_t, CommonNumBufferArguments>          _constants [[ id(CommonArgumentBufferIDConstants) ]];
};


vertex RasterizerData11
vertexShader11(uint                                        vertexID [[ vertex_id ]],
               const device CommonVertexPosition_TexCoord *vertices [[ buffer(CommonVertexBufferInputIndexVertices) ]])
{
    RasterizerData11 out;

    float2 position = vertices[vertexID].position;

    out.position.xy = position;
    out.position.z  = 0.0;
    out.position.w  = 1.0;

    out.texCoord = vertices[vertexID].texCoord;

    return out;
}

/**
 The fragmentShader function contains an if-else condition that evaluates the x component of texCoord to determine which side of the quad the fragment is on. If the fragment is on the left side of the quad, the function samples each texture in the exampleTextures array and adds the sampled values to determine the final output color.

 If the fragment is on right side of the quad, the function reads a value from the exampleBuffers array.
 The function uses the x component of texCoord to determine which buffer to read from and then uses the y component of texCoord to determine where in the buffer to read from.
 The value in the buffer determines the final output color.
 */
fragment float4
fragmentShader11(       RasterizerData11        in                  [[ stage_in ]],
                 device FragmentShaderArguments &fragmentShaderArgs [[ buffer(CommonFragmentBufferInputIndexArguments) ]])
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    
    float4 color = float4(0, 0, 0, 1);

    // If on the left side of the quad...
    if (in.texCoord.x < 0.5)
    {
        // MARK: - Access Array Elements in an Argument Buffer
        /**
         Within a function, accessing elements of an array encoded in an argument buffer is the same as accessing elements of a standard array.
         In this sample, the textures, buffers, and _constants arrays are accessed via the fragmentShaderArgs parameter of the fragmentShader function.
         Each array element is accessed with the [n] subscript syntax, where n is the index of the element within the array.
         */
        // ...use accumulated values from each of the 19 textures
        for (uint32_t textureToSample = 0; textureToSample < CommonNumTextureArguments; textureToSample++)
        {
            float4 textureValue = fragmentShaderArgs.textures[textureToSample].sample(textureSampler, in.texCoord);

            color += textureValue;
        }
    } else { // if on right side of the quad...
        //...use values from a buffer
        
        // Use texCoord.x to select the buffer to read from
        uint32_t bufferToRead = (in.texCoord.x - 0.5) * 2.0 * (CommonNumBufferArguments - 1);
        
        // Retrieve the number of elements for the selected buffer from the array of constants in the argument buffer
        uint32_t numElements = fragmentShaderArgs._constants[bufferToRead];
        
        // Determine the index used to read from the buffer
        uint32_t indexToRead = in.texCoord.y * (numElements - 1);
        
        // Retrieve the buffer to read from by accessing the array of buffers in the argument buffer
        device float* buffer = fragmentShaderArgs.buffers[bufferToRead];
        
        // Read from the buffer and assign the value to the output color
        color = buffer[indexToRead];
    }
    
    return color;
}

// MARK: - Encoding Argument Buffers on the GPU
// you’ll learn how to encode resources into argument buffers with a graphics or compute function.
// https://developer.apple.com/documentation/metal/buffers/encoding_argument_buffers_on_the_gpu
