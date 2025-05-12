//
//  Renderer11.m
//  TestMetal
//
//  Created by youdun on 2023/9/22.
//

#import "Renderer11.h"
#import "CommonShaderTypes.h"
#import <stdlib.h> // for random()

// MARK: - ###
/**
 In this sample, you learned how to combine argument buffers with arrays of resources and resource heaps
 */

/**
 This sample can be run both with and without using a resource heap to demonstrate the difference between the two methods of resource management when used in conjunction with argument buffers
 */
#define ENABLE_RESOURCE_HEAP 1

@implementation Renderer11
{
    id <MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    
    // The Metal buffer storing vertex data
    id<MTLBuffer> _vertexBuffer;
    
    // Render pipeline used to draw all quads
    id<MTLRenderPipelineState> _renderPipelineState;
    
    // The number of vertices in the vertex buffer
    NSUInteger _numVertices;
    
    // Metal texture object to be referenced via an argument buffer
    id<MTLTexture> _texture[CommonNumTextureArguments];

    // Metal buffer object containing data and referenced by the shader via an argument buffer
    id<MTLBuffer> _dataBuffer[CommonNumBufferArguments];
    
    // Buffer containing encoded arguments for our fragment shader
    id<MTLBuffer> _fragmentShaderArgumentBuffer;
    
    // Resource Heap to contain all resources encoded in our argument buffer
    id<MTLHeap> _heap;

    // Viewport to maintain 1:1 aspect ratio
    MTLViewport _viewport;
}


- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
    self = [super init];
    if (self) {
        _device = mtkView.device;
        // Create the command queue
        _commandQueue = [_device newCommandQueue];
        mtkView.clearColor = MTLClearColorMake(0.0, 0.5, 0.5, 1.0f);
        
        // Set up a MTLBuffer with the textures coordinates and per-vertex colors
        static const CommonVertexPosition_TexCoord vertexData[] =
        {
            //      Vertex      |  Texture    |
            //     Positions    | Coordinates |
            { {  .75f,  -.75f }, { 1.f, 0.f } },
            { { -.75f,  -.75f }, { 0.f, 0.f } },
            { { -.75f,   .75f }, { 0.f, 1.f } },
            { {  .75f,  -.75f }, { 1.f, 0.f } },
            { { -.75f,   .75f }, { 0.f, 1.f } },
            { {  .75f,   .75f }, { 1.f, 1.f } }
        };
        // Create a vertex buffer, and initialize it with our generics array
        _vertexBuffer = [_device newBufferWithBytes:vertexData
                                             length:sizeof(vertexData)
                                            options:MTLResourceStorageModeShared];
        _vertexBuffer.label = @"Vertices Buffer";

        // Load data for resources
        [self loadResources];
        
#if ENABLE_RESOURCE_HEAP

        // Create a heap large enough to contain all resources
        [self createHeap];

        /// Move resources loaded into heap
        [self moveResourcesToHeap];

#endif
        // Load the shader function from the library
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        id <MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader11"];
        id <MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader11"];
        
        // Create a pipeline state object
        NSError *error;
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"RenderPipelineDescriptor";
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        _renderPipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                       error:&error];
        NSAssert(_renderPipelineState, @"Failed to create pipeline state, error %@", error);
        
        id <MTLArgumentEncoder> argumentEncoder =
            [fragmentFunction newArgumentEncoderWithBufferIndex:CommonFragmentBufferInputIndexArguments];
        
        NSUInteger argumentBufferLength = argumentEncoder.encodedLength;
        _fragmentShaderArgumentBuffer = [_device newBufferWithLength:argumentBufferLength options:0];
        _fragmentShaderArgumentBuffer.label = @"Argument Buffer Fragment Shader";
        [argumentEncoder setArgumentBuffer:_fragmentShaderArgumentBuffer offset:0];
        // MARK: - Encode Array Elements into an Argument Buffer
        /**
         This sample encodes array elements into an argument buffer by matching the index parameter of each
         setTexture:atIndex:,
         setBuffer:offset:atIndex:,
         and constantDataAtIndex: method call to the element’s corresponding index value,
         defined by the [[ id(n) ]] attribute qualifier in the argument buffer.
         */
        for (uint32_t i = 0; i < CommonNumTextureArguments; i++)
        {
            [argumentEncoder setTexture:_texture[i]
                                atIndex:CommonArgumentBufferIDTextures + i];
        }

        for (uint32_t i = 0; i < CommonNumBufferArguments; i++)
        {
            [argumentEncoder setBuffer:_dataBuffer[i]
                                offset:0
                                atIndex:CommonArgumentBufferIDBuffers + i];

            uint32_t *elementCountAddress =
                [argumentEncoder constantDataAtIndex:CommonArgumentBufferIDConstants + i];
            
            *elementCountAddress = (uint32_t)_dataBuffer[i].length / 4;
            
            NSLog(@"elementCount = %u", *elementCountAddress);
        }
    }
    return self;
}

// MARK: - private methods
// Loads textures from the asset catalog and programmatically generates buffer objects
- (void)loadResources {
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:_device];

    NSError *error;
    
    for (NSUInteger i = 0; i < CommonNumTextureArguments; i++) {
        NSString *textureName = [[NSString alloc] initWithFormat:@"Texture%lu", i];

        _texture[i] = [textureLoader newTextureWithName:textureName
                                            scaleFactor:1.0
                                                 bundle:nil
                                                options:nil
                                                  error:&error];
        if (!_texture[i])
        {
            [NSException raise:NSGenericException
                        format:@"Could not load texture with name %@: %@", textureName, error.localizedDescription];
        }

        _texture[i].label = textureName;
    }
    
    // Seed random number generator used to create data for our buffers
    srandom(32420934);
    
    uint32_t elementCounts[CommonNumBufferArguments];
    
    // Create buffers which will be accessed indirectly via the argument buffer
    for (NSUInteger i = 0; i < CommonNumBufferArguments; i++)
    {
        // Randomly choose the number of 32-bit floating-point values we'll sorce in each buffer
        uint32_t elementCount = random() % 384 + 128;

        // Save the element count in order to store it in the argument buffer later as a constant for shader access in the future
        elementCounts[i] = elementCount;

        NSUInteger bufferSize = elementCount * sizeof(float);

        _dataBuffer[i] = [_device newBufferWithLength:bufferSize
                                              options:MTLResourceStorageModeShared];

        _dataBuffer[i].label = [[NSString alloc] initWithFormat:@"DataBuffer%lu", i];

        /**
         Generate floating-point values for the buffer that modulates between 0 and 1  in a sin wave just so there is something interesting to see in each buffer
         */
        float *elements = (float *)_dataBuffer[i].contents;

        for (NSUInteger k = 0; k < elementCount; k++)
        {
            // Calculate where in the wave this element is
            float point = (k * 2 * M_PI) / elementCount;

            // Generate wave and convert from [-1, 1] to [0, 1]
            elements[k] = sin(point * i) * 0.5 + 0.5;
        }

        // Save the element count in order to store it in the argument buffer
        // as a constant and access in the shader
        elementCounts[i] = elementCount;
    }
}

/// Creates a texture descriptor from a texture object.  Used to create a texture object in a heap
/// for the given texture
+ (nonnull MTLTextureDescriptor*)newDescriptorFromTexture:(nonnull id<MTLTexture>)texture
                                              storageMode:(MTLStorageMode)storageMode
{
    MTLTextureDescriptor *descriptor = [MTLTextureDescriptor new];
    descriptor.textureType      = texture.textureType;
    descriptor.pixelFormat      = texture.pixelFormat;
    descriptor.width            = texture.width;
    descriptor.height           = texture.height;
    descriptor.depth            = texture.depth;
    // For a buffer-backed or multisample texture, the value is 1.
    descriptor.mipmapLevelCount = texture.mipmapLevelCount;
    descriptor.arrayLength      = texture.arrayLength;
    descriptor.sampleCount      = texture.sampleCount;
    descriptor.storageMode      = storageMode;
    return descriptor;
}

// MARK: - Combine Argument Buffers with Resource Heaps
/**
 The fragment function accesses 19 textures and 30 buffers via the argument buffer, totaling 49 different resources overall.
 If memory for each of these resources was allocated individually, despite residing in arrays, Metal would need to validate the memory of 49 individual resources before making these resources accessible to the GPU.
 
 Instead, this sample allocates resources from a MTLHeap object.
 A heap is a single memory region from which multiple resources can be allocated.
 Therefore, the sample can make the heap’s entire memory, including the memory of all the resources within the heap, accessible to the GPU by calling the useHeap: method once.

 The sample implements a loadResources method that loads the resource data into temporary MTLTexture and MTLBuffer objects.
 Then, the sample implements a createHeap method that calculates the total size required to store the resource data in the heap and creates the heap itself.
 
 The sample implements a moveResourcesToHeap method that creates permanent MTLTexture and MTLBuffer objects allocated from the heap.
 Then, the method uses a MTLBlitCommandEncoder to copy the resource data from the temporary objects to the permanent objects.
 */

// Creates a resource heap to store texture and buffer object
- (void)createHeap {
    MTLHeapDescriptor *heapDescriptor = [MTLHeapDescriptor new];
    heapDescriptor.storageMode = MTLStorageModePrivate;
    heapDescriptor.size =  0;
    
    // Build a descriptor for each texture and calculate the size required to store all textures in the heap
    for (uint32_t i = 0; i < CommonNumTextureArguments; i++)
    {
        // Create a descriptor using the texture's properties
        MTLTextureDescriptor *descriptor = [Renderer11 newDescriptorFromTexture:_texture[i]
                                                                    storageMode:heapDescriptor.storageMode];

        // Determine the size required for the heap for the given descriptor
        MTLSizeAndAlign sizeAndAlign = [_device heapTextureSizeAndAlignWithDescriptor:descriptor];
        if (i == 0) {
            NSLog(@"===berore size = %lu align = %lu", sizeAndAlign.size, sizeAndAlign.align);
        }

        // Align the size so that more resources will fit in the heap after this texture
        sizeAndAlign.size += (sizeAndAlign.size & (sizeAndAlign.align - 1)) + sizeAndAlign.align;
        if (i == 0) {
            NSLog(@"===after size = %lu align = %lu", sizeAndAlign.size, sizeAndAlign.align);
        }

        // Accumulate the size required to store this texture in the heap
        heapDescriptor.size += sizeAndAlign.size;
    }
    
    // Calculate the size required to store all buffers in the heap
    for (uint32_t i = 0; i < CommonNumBufferArguments; i++)
    {
        // Determine the size required for the heap for the given buffer size
        MTLSizeAndAlign sizeAndAlign = [_device heapBufferSizeAndAlignWithLength:_dataBuffer[i].length
                                                                         options:MTLResourceStorageModePrivate];

        // Align the size so that more resources will fit in the heap after this buffer
        sizeAndAlign.size +=  (sizeAndAlign.size & (sizeAndAlign.align - 1)) + sizeAndAlign.align;

        // Accumulate the size required to store this buffer in the heap
        heapDescriptor.size += sizeAndAlign.size;
    }
    
    // Create a heap large enough to store all resources
    _heap = [_device newHeapWithDescriptor:heapDescriptor];
}

// Moves texture and buffer data from their original objects to objects in the heap
- (void)moveResourcesToHeap {
    // Create a command buffer and blit encoder to copy data from the existing resources to the new resources created from the heap
    id <MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"Heap Copy Command Buffer";
    
    id <MTLBlitCommandEncoder> blitEncoder = commandBuffer.blitCommandEncoder;
    blitEncoder.label = @"Heap Transfer Blit Encoder";
    
    // Create new textures from the heap and copy the contents of the existing textures to the new textures
    for (uint32_t i = 0; i < CommonNumTextureArguments; i++)
    {
        // Create a descriptor using the texture's properties
        MTLTextureDescriptor *descriptor = [Renderer11 newDescriptorFromTexture:_texture[i]
                                                                    storageMode:_heap.storageMode];

        // Create a texture from the heap
        id<MTLTexture> heapTexture = [_heap newTextureWithDescriptor:descriptor];

        heapTexture.label = _texture[i].label;

        [blitEncoder pushDebugGroup:[NSString stringWithFormat:@"%@ Blits", heapTexture.label]];

        // Blit every slice of every level from the existing texture to the new texture
        MTLRegion region = MTLRegionMake2D(0, 0, _texture[i].width, _texture[i].height);
        
        if (i == 0) {
            NSLog(@"==========mipmapLevelCount = %lu arrayLength = %lu",
                  _texture[0].mipmapLevelCount,
                  _texture[0].arrayLength);
        }
        
        // mipmapLevelCount 指定了纹理包含的Mipmap级别的数量，包括原始纹理。
        for (NSUInteger level = 0; level < _texture[i].mipmapLevelCount; level++)
        {

            [blitEncoder pushDebugGroup:[NSString stringWithFormat:@"Level %lu Blit", level]];

            // arrayLength: The value of this property ranges from 1 to 2048, inclusive. If the texture type is not an array, this value is 1.
            /**
             在 Metal 中，纹理可以是单一纹理（非数组）或纹理数组。纹理数组允许您存储多个相似但可能不同的纹理切片，每个切片都有唯一的索引。
             arrayLength 表示纹理数组的切片数量，即数组中有多少个纹理切片。这对于一次性加载和管理多个相关的纹理数据非常有用。
             
             例如，一个纹理数组可以包含多个地形纹理，每个纹理切片代表不同类型的地形，如草地、岩石、泥土等。游戏引擎可以根据场景中的需要选择不同的纹理切片，以实现各种地形的渲染。
             */
            for (NSUInteger slice = 0; slice < _texture[i].arrayLength; slice++)
            {
                [blitEncoder copyFromTexture:_texture[i]
                                 sourceSlice:slice
                                 sourceLevel:level
                                sourceOrigin:region.origin
                                  sourceSize:region.size
                                   toTexture:heapTexture
                            destinationSlice:slice
                            destinationLevel:level
                           destinationOrigin:region.origin];
            }
            region.size.width /= 2;
            region.size.height /= 2;
            if(region.size.width == 0) region.size.width = 1;
            if(region.size.height == 0) region.size.height = 1;

            [blitEncoder popDebugGroup];
        }

        [blitEncoder popDebugGroup];

        // Replace the existing texture with the new texture
        _texture[i] = heapTexture;
    }
    
    // Create new buffers from the heap and copy the contents of existing buffers to the new buffers
    for (uint32_t i = 0; i < CommonNumBufferArguments; i++)
    {
        // Create a buffer from the heap
        id<MTLBuffer> heapBuffer = [_heap newBufferWithLength:_dataBuffer[i].length
                                                      options:MTLResourceStorageModePrivate];

        heapBuffer.label = _dataBuffer[i].label;

        // Blit contents of the original buffer to the new buffer
        [blitEncoder copyFromBuffer:_dataBuffer[i]
                       sourceOffset:0
                           toBuffer:heapBuffer
                  destinationOffset:0
                               size:heapBuffer.length];

        // Replace the existing buffer with the new buffer
        _dataBuffer[i] = heapBuffer;
    }

    [blitEncoder endEncoding];
    [commandBuffer commit];
}

// MARK: - MTKViewDelegate
- (void)drawInMTKView:(MTKView *)view {
    NSLog(@"%s", __FUNCTION__);
    
    // Create a new command buffer for each render pass to the current drawable
    id <MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"Per Frame Commands Buffer";

    // Obtain a renderPassDescriptor generated from the view's drawable textures
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    
    if (renderPassDescriptor != nil) {
        // Create a render command encoder so we can render into something
        id <MTLRenderCommandEncoder> renderEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"Per Frame Render Encoder";

        [renderEncoder setViewport:_viewport];
        
        // Before using these resources, instead of calling the useResource:usage: method once for each resource, the sample calls the useHeap: method once for the entire heap.
#if ENABLE_RESOURCE_HEAP
        /**
         Make a single `useHeap:` call for the entire heap, instead of one `useResource:usage:` call per texture and per buffer
         */
        [renderEncoder useHeap:_heap];
#else
        for (uint32_t i = 0; i < CommonNumTextureArguments; i++)
        {
            /**
             Indicate to Metal that these textures will be accessed by the GPU and therefore must be mapped to the GPU's address space
             */
            [renderEncoder useResource:_texture[i] usage:MTLResourceUsageSample];
        }

        for (uint32_t i = 0; i < CommonNumBufferArguments; i++)
        {
            /**
             Indicate to Metal that these buffers will be accessed by the GPU and therefore must be mapped to the GPU's address space
             */
            [renderEncoder useResource:_dataBuffer[i] usage:MTLResourceUsageRead];
        }
#endif
        
        [renderEncoder setRenderPipelineState:_renderPipelineState];

        [renderEncoder setVertexBuffer:_vertexBuffer
                                offset:0
                               atIndex:CommonVertexBufferInputIndexVertices];

        [renderEncoder setFragmentBuffer:_fragmentShaderArgumentBuffer
                                  offset:0
                                 atIndex:CommonFragmentBufferInputIndexArguments];

        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:6];

        [renderEncoder endEncoding];

        // Schedule a present once the framebuffer is complete using the current drawable
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    
    // Finalize rendering here & push the command buffer to the GPU
    [commandBuffer commit];

    [commandBuffer waitUntilCompleted];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    NSLog(@"%s width = %lf height = %lf", __FUNCTION__, size.width, size.height);
    
    // Calculate a viewport so that it's always square and and in the middle of the drawable

    if (size.width < size.height)
    {
        _viewport.originX = 0;
        _viewport.originY = (size.height - size.width) / 2.0;;
        _viewport.width = _viewport.height = size.width;
        _viewport.zfar = 1.0;
        _viewport.znear = -1.0;
    }
    else
    {
        _viewport.originX = (size.width - size.height) / 2.0;
        _viewport.originY = 0;
        _viewport.width = _viewport.height = size.height;
        _viewport.zfar = 1.0;
        _viewport.znear = -1.0;
    }
}

@end
