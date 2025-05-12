//
//  ShaderTypes8.h
//  TestMetal
//
//  Created by youdun on 2023/9/8.
//

#ifndef ShaderTypes8_h
#define ShaderTypes8_h

/**
 The argument buffer indices the shader and C code share to ensure Metal shader buffer inputs match Metal API set calls.
 */
typedef enum ArgumentBufferID8
{
    ArgumentBufferID8Texture,
    ArgumentBufferID8Sampler,
    ArgumentBufferID8Buffer,
    ArgumentBufferID8Constant
} ArgumentBufferID8;


#endif /* ShaderTypes8_h */
