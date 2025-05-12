//
//  CommonShaderTypes.h
//  TestMetal
//
//  Created by youdun on 2023/9/8.
//

#ifndef CommonShaderTypes_h
#define CommonShaderTypes_h

#include <simd/simd.h>

typedef struct
{
    float scale;
    vector_uint2 viewportSize;
} CommonUniforms;

// MARK: - position & color
// Each vertex has a position and a color
typedef struct {
    vector_float2 position;
    vector_float4 color;
} CommonVertex2;

// MARK: - position & texCoord
typedef struct {
    vector_float2 position;
    vector_float2 texCoord;
} CommonVertexPosition_TexCoord;

typedef enum CommonVertexInputIndex
{
    CommonVertexInputIndexVertices     = 0,
    CommonVertexInputIndexViewportSize = 1,
    CommonVertexInputIndexUniforms     = 2,
} CommonVertexInputIndex;

typedef struct CommonVertex {
    vector_float2 position;
    vector_float2 texCoord;
    vector_float4 color;
} CommonVertex;

typedef enum CommonVertexBufferInputIndex
{
    CommonVertexBufferInputIndexVertices = 0,
} CommonVertexBufferInputIndex;

typedef enum CommonFragmentBufferInputIndex
{
    CommonFragmentBufferInputIndexArguments = 0,
} CommonFragmentBufferInputIndex;

/**
 Constant values shared between shader and C code which indicate the size of argument arrays in the structure defining the argument buffers
 */
typedef enum CommonNumArguments {
    CommonNumBufferArguments  = 30,
    CommonNumTextureArguments = 19 // 示例有32张图片，测试机只支持31张，调整为只显示一段文字。
} CommonNumArguments;

/**
 Argument buffer indices shared between shader and C code to ensure Metal shader buffer input match Metal API texture set calls
 */
typedef enum CommonArgumentBufferID
{
    CommonArgumentBufferIDTextures  = 0,
    CommonArgumentBufferIDBuffers   = 100,
    CommonArgumentBufferIDConstants = 200
} CommonArgumentBufferID;

#endif /* CommonShaderTypes_h */
