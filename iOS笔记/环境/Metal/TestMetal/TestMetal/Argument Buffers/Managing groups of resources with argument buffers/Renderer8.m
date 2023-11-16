//
//  Renderer8.m
//  TestMetal
//
//  Created by youdun on 2023/9/8.
//

#import "Renderer8.h"
#import "ShaderTypes8.h"
#import "CommonShaderTypes.h"

// MARK: - Combine argument buffers with a resource heap
/**
 https://developer.apple.com/documentation/metal/buffers/using_argument_buffers_with_resource_heaps
 
 The Using Argument Buffers with Resource Heaps sample code project demonstrates how to combine argument buffers with arrays of resources and resource heaps.
 This further reduces CPU overhead.
 */
@implementation Renderer8
{
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    
    id<MTLRenderPipelineState> _renderPipelineState;
    
    // The Metal buffers for storing the vertex data.
    id<MTLBuffer> _vertexBuffer;
    // The number of vertices in the vertex buffer.
    NSUInteger _numVertices;
    
    // The Metal texture object to reference with an argument buffer.
    id<MTLTexture> _texture;
    // The Metal sampler object to reference with an argument buffer.
    id<MTLSamplerState> _sampler;
    // The Metal buffer object to reference with an argument buffer.
    id<MTLBuffer> _indirectBuffer;
    
    // The buffer that contains arguments for the fragment shader.
    id<MTLBuffer> _fragmentShaderArgumentBuffer;
    
    // The viewport to maintain 1:1 aspect ratio.
    MTLViewport _viewport;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
    self = [super init];
    if (self) {
        _device = mtkView.device;
        mtkView.clearColor = MTLClearColorMake(0.0, 0.5, 0.5, 1.0f);

        // Create a vertex buffer, and initialize it with the generics array.
        {
            static const CommonVertex vertexData[] =
            {
                //      Vertex      |  Texture    |         Vertex
                //     Positions    | Coordinates |         Colors
                { {  .75f,  -.75f }, { 1.f, 0.f }, { 0.f, 1.f, 0.f, 1.f } },
                { { -.75f,  -.75f }, { 0.f, 0.f }, { 1.f, 1.f, 1.f, 1.f } },
                { { -.75f,   .75f }, { 0.f, 1.f }, { 0.f, 0.f, 1.f, 1.f } },
                { {  .75f,  -.75f }, { 1.f, 0.f }, { 0.f, 1.f, 0.f, 1.f } },
                { { -.75f,   .75f }, { 0.f, 1.f }, { 0.f, 0.f, 1.f, 1.f } },
                { {  .75f,   .75f }, { 1.f, 1.f }, { 1.f, 1.f, 1.f, 1.f } },
            };

            _vertexBuffer = [_device newBufferWithBytes:vertexData
                                                 length:sizeof(vertexData)
                                                options:MTLResourceStorageModeShared];
            _vertexBuffer.label = @"Vertices";
        }
        
        // Create texture to apply to the quad.
        {
            NSError *error;

            MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:_device];

            _texture = [textureLoader newTextureWithName:@"Text"
                                             scaleFactor:1.0
                                                  bundle:nil
                                                 options:nil
                                                   error:&error];

            NSAssert(_texture, @"Could not load foregroundTexture: %@", error);
            _texture.label = @"Text";
        }
        
        // Create a sampler to use for texturing/
        {
            MTLSamplerDescriptor *samplerDesc = [MTLSamplerDescriptor new];
            samplerDesc.minFilter = MTLSamplerMinMagFilterLinear;
            samplerDesc.magFilter = MTLSamplerMinMagFilterLinear;
            samplerDesc.mipFilter = MTLSamplerMipFilterNotMipmapped;
            samplerDesc.normalizedCoordinates = YES;
            samplerDesc.supportArgumentBuffers = YES;

            _sampler = [_device newSamplerStateWithDescriptor:samplerDesc];
        }
        
        uint16_t bufferElements = 256;
        // Create buffers for making a pattern on the quad.
        {
            _indirectBuffer = [_device newBufferWithLength:sizeof(float) * bufferElements
                                                   options:MTLResourceStorageModeShared];

            float * const patternArray = (float *) _indirectBuffer.contents;

            for(uint16_t i = 0; i < bufferElements; i++) {
                // 设置i % 16的话，就是均匀分布的线条
                patternArray[i] = ((i % 24) < 3) * 1.0;
            }

            _indirectBuffer.label = @"Indirect Buffer";
        }
        
        // Create the render pipeline state.
        {
            id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
            id <MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader8"];
            id <MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader8"];
            
            NSError *error;
            // Set up a descriptor for creating a pipeline state object.
            MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
            pipelineStateDescriptor.label = @"Render Pipeline";
            pipelineStateDescriptor.vertexFunction = vertexFunction;
            pipelineStateDescriptor.fragmentFunction = fragmentFunction;
            pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
            
            _renderPipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                           error:&error];
            NSAssert(_renderPipelineState, @"Failed to create pipeline state: %@", error);
        }

        // Create the argument buffer.
#ifdef USE_METAL3
        // MARK: - Set resource handles in an argument buffer with Metal 3
        /**
         With Metal 3, the renderer writes GPU resource handles directly into a buffer’s contents.

         Because the sample code defines the FragmentShaderArguments structure in a header it shares with the Renderer8 source, the renderer determines the size necessary for the buffer by using the sizeof operator on the structure.
         
         The following example writes to the buffer’s contents using the gpuResourceID property of the MTLTexture and MTLSampler objects, and the gpuHandle property of the MTLBuffer object.
         */
        {
            NSAssert(_device.argumentBuffersSupport != MTLArgumentBuffersTier1,
                     @"Metal 3 argument buffers are suppported only on Tier2 devices");
            
            NSUInteger argumentBufferLength = sizeof(FragmentShaderArguments);

            _fragmentShaderArgumentBuffer = [_device newBufferWithLength:argumentBufferLength options:0];
            
            FragmentShaderArguments *argumentStructure = (FragmentShaderArguments *)_fragmentShaderArgumentBuffer.contents;
            argumentStructure->exampleTexture = _texture.gpuResourceID;
            argumentStructure->exampleBuffer = (float *)_indirectBuffer.gpuAddress;
            argumentStructure->exampleSampler = _sampler.gpuResourceID;
            argumentStructure->exampleConstant = bufferElements;
        }
#else
        // MARK: - Encode resources into an argument buffer with Metal 2
        {
            /**
             With Metal 2, the renderer encodes individual resources into an argument buffer before a buffer accesses it.
             It accomplishes this by creating a MTLArgumentBufferEncoder from a MTLFunction that uses an argument buffer.

             The following example creates a MTLArgumentBufferEncoder from the fragmentShader function, which contains the fragmentShaderArgs parameter:
             */
            id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
            id <MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader8"];
            id <MTLArgumentEncoder> argumentEncoder =
                [fragmentFunction newArgumentEncoderWithBufferIndex:CommonFragmentBufferInputIndexArguments];

            /**
             The encodedLength property of argumentEncoder determines the size, in bytes, necessary to contain all the resources in the argument buffer.
             This example uses that value to create a new buffer, _fragmentShaderArgumentBuffer, with a length parameter that matches the required size for the argument buffer:
             */
            NSUInteger argumentBufferLength = argumentEncoder.encodedLength;
            _fragmentShaderArgumentBuffer = [_device newBufferWithLength:argumentBufferLength options:0];
            _fragmentShaderArgumentBuffer.label = @"Argument Buffer";
            
            /**
             The following example calls the setArgumentBuffer:offset: method to specify that _fragmentShaderArgumentBuffer is an argument buffer that the renderer can encode resources into:
             */
            [argumentEncoder setArgumentBuffer:_fragmentShaderArgumentBuffer offset:0];

            /**
             The example below encodes individual resources into the argument buffer by:
             Calling specific methods for each resource type, such as setTexture:atIndex:, setSamplerState:atIndex:, and setBuffer:offset:atIndex.

             Matching the value of the index parameter to the value of the [[id(n)]] attribute qualifier the shader code declares for each element of the FragmentShaderArguments structure.
             */
            [argumentEncoder setTexture:_texture atIndex:ArgumentBufferID8Texture];
            [argumentEncoder setSamplerState:_sampler atIndex:ArgumentBufferID8Sampler];
            [argumentEncoder setBuffer:_indirectBuffer offset:0 atIndex:ArgumentBufferID8Buffer];
            /**
             The renderer encodes constants a bit differently.
             It embeds constant data directly into the argument buffer, instead of storing the data in another object that the argument buffer points to.
             The renderer calls the constantDataAtIndex: method to retrieve the address in the argument buffer where the constant resides.
             Then, it sets the actual value of the constant, bufferElements, at the retrieved address.
             */
            uint32_t *numElementsAddress =  (uint32_t *)[argumentEncoder constantDataAtIndex:ArgumentBufferID8Constant];
            *numElementsAddress = bufferElements;
        }
#endif
        // Create the command queue.
        _commandQueue = [_device newCommandQueue];
    }
    return self;
}

// MARK: - MTKViewDelegate
- (void)drawInMTKView:(MTKView *)view {
    NSLog(@"%s", __FUNCTION__);
    
    // Create a new command buffer for each render pass to the current drawable.
    id <MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"Command Buffer";

    // Obtain a renderPassDescriptor with the view's drawable texture.
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;

    if (renderPassDescriptor != nil) {
        // Create a render command encoder to render with.
        id <MTLRenderCommandEncoder> renderEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"Render Command Encoder";

        [renderEncoder setViewport:_viewport];
        
        // MARK: - Enable the GPU memory of resources in the argument buffer
        /**
         Metal efficiently manages memory accessed by the GPU. However, before the GPU uses any resource, Metal needs to ensure that the GPU has access to the resource’s memory. Setting resources individually by calling MTLRenderCommandEncoder methods, such as setVertexBuffer:offset:atIndex: or setFragmentTexture:atIndex:, ensures that the resource’s memory is accessible to the GPU.
         
         However, when the renderer encodes resources into an argument buffer, setting the argument buffer doesn’t set each of its resources individually.
         Metal doesn’t inspect argument buffers to determine which encoded resources they contain because that expensive operation would negate the performance benefits of argument buffers.
         Therefore, Metal can’t determine what resource’s memory to make accessible to the GPU.
         Instead, the renderer calls the useResource:usage: method to explicitly instruct a MTLRenderCommandEncoder to make a specific resource’s memory accessible to the GPU.

         Note
         Best practice is to call the useResource:usage: method once for each resource during the lifetime of a MTLRenderCommandEncoder, even when using the resource in multiple draw calls.
         The useResource:usage: method is specific to argument buffers, but calling it is far less expensive than setting each resource individually.
         */

        // MARK: - Set argument buffers
        /**
         The following example calls the useResource:usage: method for the _texture and _indirectBuffer encoded resources in the argument buffer.
         These calls specify MTLResourceUsage values that further indicate which GPU operations to perform on each resource (the GPU samples the texture and reads the buffer):
         
         Note
         The useResource:usage: method doesn’t apply to samplers or constants because they’re not MTLResource objects.
         */
        // Indicate to Metal that the GPU accesses these resources, so they need to map to the GPU's address space.
        [renderEncoder useResource:_texture usage:MTLResourceUsageRead stages:MTLRenderStageFragment];
        [renderEncoder useResource:_indirectBuffer usage:MTLResourceUsageRead stages:MTLRenderStageFragment];

        [renderEncoder setRenderPipelineState:_renderPipelineState];

        [renderEncoder setVertexBuffer:_vertexBuffer
                                offset:0
                               atIndex:CommonVertexBufferInputIndexVertices];

        /**
         The following example sets only _fragmentShaderArgumentBuffer as an argument to the fragment function.
         It doesn’t set the _texture, _indirectBuffer, _sampler, or bufferElements resources individually.
         This command allows the fragment function to access the argument buffer and its encoded resources:
         */
        [renderEncoder setFragmentBuffer:_fragmentShaderArgumentBuffer
                                  offset:0
                                 atIndex:CommonFragmentBufferInputIndexArguments];

        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:6];

        [renderEncoder endEncoding];

        // Schedule a present after the framebuffer is complete using the current drawable.
        [commandBuffer presentDrawable:view.currentDrawable];
    }

    // Finalize rendering here and push the command buffer to the GPU.
    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    NSLog(@"%s width = %lf height = %lf", __FUNCTION__, size.width, size.height);

    // Calculate a viewport so that it's always square and in the middle of the drawable.

    if(size.width < size.height) {
        _viewport.originX = 0;
        _viewport.originY = (size.height - size.width) / 2.0;;
        _viewport.width = _viewport.height = size.width;
        _viewport.zfar = 1.0;
        _viewport.znear = -1.0;
    } else {
        _viewport.originX = (size.width - size.height) / 2.0;
        _viewport.originY = 0;
        _viewport.width = _viewport.height = size.height;
        _viewport.zfar = 1.0;
        _viewport.znear = -1.0;
    }
}

// MARK: -

@end
