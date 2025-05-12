//
//  Renderer7.m
//  TestMetal
//
//  Created by youdun on 2023/9/6.
//

#import "Renderer7.h"
#import "ShaderTypes7.h"

// The max number of frames in flight
/**
 "MaxFramesInFlight" 是一个用于控制图形渲染帧率和性能的参数
 它指的是同时存在于内存中的渲染帧的最大数量。
 
 在计算机图形渲染中，每一帧都包括了从场景数据生成图像到显示在屏幕上的整个过程。
 每帧都要进行几何变换、光照计算、像素着色等操作。为了实现流畅的渲染并充分利用硬件资源，通常会使用多帧渲染技术。
 
 "MaxFramesInFlight" 参数控制了在任何给定时间点，可以同时存在于内存中的渲染帧的最大数量。
 
 通常情况下，如果你将 "MaxFramesInFlight" 设置为较小的值，例如2或3，那么应用程序会更快地循环渲染新的帧，但这可能会导致一些帧被丢弃，因为它们还没有完成渲染。
 */
static const NSUInteger MaxFramesInFlight = 3;

@implementation Renderer7
{
    dispatch_semaphore_t _inFlightSemaphore;
    
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    
    id<MTLRenderPipelineState> _renderPipelineState;
    
    // When using an indirect command buffer encoded by the CPU, buffer updated by the CPU must be blit into a seperate buffer that is set in the indirect command buffer.
    id<MTLBuffer> _indirectFrameStateBuffer;
    
    // The indirect command buffer encoded and executed
    id<MTLIndirectCommandBuffer> _indirectCommandBuffer;
    
    // Array of Metal buffers storing vertex data for each rendered object
    id<MTLBuffer> _vertexBuffer[NumObjects];
    // The Metal buffer storing per object parameters for each rendered object
    id<MTLBuffer> _objectParameters;
    // The Metal buffers storing per frame uniform data
    id<MTLBuffer> _frameStateBuffer[MaxFramesInFlight];
    
    // Number of frames rendered
    NSUInteger _frameNumber;
    // Index into per frame uniforms to use for the current frame
    /**
     "uniforms"（统一变量）是一种用于向着色器传递数据的机制。这些数据通常是在渲染过程中保持不变的，因此被称为 "uniforms"。
     "uniforms" 在图形渲染中扮演了关键的角色，因为它们允许你在顶点着色器和片元着色器之间共享信息，以及在不同渲染阶段之间传递数据。
     */
    NSUInteger _inFlightIndex;
    
    vector_float2 _aspectScale;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
    self = [super init];
    if (self) {
        _device = mtkView.device;
        mtkView.clearColor = MTLClearColorMake(0.0, 0.0, 0.5, 1.0f);
        mtkView.depthStencilPixelFormat = MTLPixelFormatDepth32Float;
        mtkView.sampleCount = 1;
        
        _inFlightSemaphore = dispatch_semaphore_create(MaxFramesInFlight);

        // Create the command queue
        _commandQueue = [_device newCommandQueue];
        
        // Load the shaders from default library
        id <MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        id <MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader7"];
        id <MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader7"];
        
        // Create a reusable pipeline state
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"Render Pipeline";
        pipelineStateDescriptor.sampleCount = mtkView.sampleCount;
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        pipelineStateDescriptor.depthAttachmentPixelFormat = mtkView.depthStencilPixelFormat;
        // Needed for this pipeline state to be used in indirect command buffers.
        pipelineStateDescriptor.supportIndirectCommandBuffers = YES;
        
        NSError *error = nil;
        _renderPipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                       error:&error];
        NSAssert(_renderPipelineState, @"Failed to create pipeline state: %@", error);
        
        // MARK: - _vertexBuffer
        for (int objectIdx = 0; objectIdx < NumObjects; objectIdx++) {
            /**
             Choose parameters to generate a mesh for this object so that each mesh is unique and looks diffent than the mesh it's next to in the grid drawn
             */
            uint32_t numTeeth = (objectIdx < 8) ? objectIdx + 3 : objectIdx * 3;

            // Create a vertex buffer, and initialize it with a unique 2D gear mesh
            _vertexBuffer[objectIdx] = [self newGearMeshWithNumTeeth:numTeeth];
            _vertexBuffer[objectIdx].label = [[NSString alloc] initWithFormat:@"Object %i Buffer", objectIdx];
        }
        
        // MARK: - ###_objectParameters###
        /// Create and fill array containing parameters for each object
        NSUInteger objectParameterArraySize = NumObjects * sizeof(ObjectPerameters7);
        _objectParameters = [_device newBufferWithLength:objectParameterArraySize options:0];
        _objectParameters.label = @"Object Parameters Array";
        ObjectPerameters7 *params = (ObjectPerameters7 *)_objectParameters.contents;
        // 5, 3
        static const vector_float2 gridDimensions = { GridWidth, GridHeight };
        const vector_float2 offset = (ObjecDistance / 2.0) * (gridDimensions-1);
        
        for (int objectIdx = 0; objectIdx < NumObjects; objectIdx++) {
            // Calculate position of each object such that each occupies a space in a grid
            vector_float2 gridPos = (vector_float2){objectIdx % GridWidth, objectIdx / GridWidth};
            vector_float2 position = -offset + gridPos * ObjecDistance;

            // Write the position of each object to the object parameter buffer
            params[objectIdx].position = position;
        }
        
        // MARK: - ###_frameStateBuffer###
        for (int i = 0; i < MaxFramesInFlight; i++) {
            _frameStateBuffer[i] = [_device newBufferWithLength:sizeof(FrameState7)
                                                        options:MTLResourceStorageModeShared];
            _frameStateBuffer[i].label = [NSString stringWithFormat:@"Frame state buffer %d", i];
        }
        
        // MARK: - _indirectFrameStateBuffer
        /**
         When encoding commands with the CPU, the app sets this indirect frame state buffer dynamically in the indirect command buffer.
         Each frame data will be blit from the _frameStateBuffer that has just been updated by the CPU to this buffer.
         This allow a synchronous update of values set by the CPU.
         */
        _indirectFrameStateBuffer = [_device newBufferWithLength:sizeof(FrameState7)
                                                         options:MTLResourceStorageModePrivate];

        _indirectFrameStateBuffer.label = @"Indirect Frame State Buffer";
        
        // MARK: - Create an Indirect Command Buffer
        /**
         The sample creates _indirectCommandBuffer from a MTLIndirectCommandBufferDescriptor, which defines the features and limits of an indirect command buffer.
         
         The sample specifies the types of commands, commandTypes, and the maximum number of commands, maxCount, so that Metal reserves enough space in memory for the sample to encode _indirectCommandBuffer successfully (with the CPU or GPU).
         */
        MTLIndirectCommandBufferDescriptor* icbDescriptor = [MTLIndirectCommandBufferDescriptor new];

        // Indicate that the only draw commands will be standard (non-indexed) draw commands.
        icbDescriptor.commandTypes = MTLIndirectCommandTypeDraw;

        // Indicate that buffers will be set for each command IN the indirect command buffer.
        icbDescriptor.inheritBuffers = NO;

        // Indicate that a max of 3 buffers will be set for each command.
        /**
         icbDescriptor.maxVertexBufferBindCount:
         Metal ignores this property if inheritBuffers is YES or if you configured commandTypes for compute commands.
         Metal must reserve enough memory in each command to store this many arguments.
         Use the smallest value that works for all commands you plan to encode into the indirect command buffer.
         */
        icbDescriptor.maxVertexBufferBindCount = 3;
        icbDescriptor.maxFragmentBufferBindCount = 0;

#if defined TARGET_MACOS || defined(__IPHONE_13_0)
        /**
         Indicate that the render pipeline state object will be set in the render command encoder (not by the indirect command buffer).
         On iOS, this property only exists on iOS 13 and later.  It defaults to YES in earlier versions
         
         A Boolean value that determines where commands in the indirect command buffer get their pipeline state from when you execute them.
         */
        if (@available(iOS 13.0, *)) {
            icbDescriptor.inheritPipelineState = YES;
        }
#endif
        
        _indirectCommandBuffer = [_device newIndirectCommandBufferWithDescriptor:icbDescriptor
                                                                 maxCommandCount:NumObjects
                                                                         options:0];
        _indirectCommandBuffer.label = @"ICB";
        
        // MARK: - Encode an Indirect Command Buffer with the CPU
        /**
         From the CPU, the sample encodes commands into _indirectCommandBuffer with a MTLIndirectRenderCommand object.
         For each shape to be rendered, the sample encodes two setVertexBuffer:offset:atIndex: commands and one drawPrimitives:vertexStart:vertexCount:instanceCount:baseInstance: command.
         
         The sample performs this encoding only once, before encoding any subsequent render commands. _indirectCommandBuffer contains a total of 16 draw calls, one for each shape to be rendered.
         Each draw call references the same transformation data, _uniformBuffers, but different vertex data, _vertexBuffers[indx].
         Although the CPU encodes data only once, the sample issues 16 draw calls per frame.
         */
        // Encode a draw command for each object drawn in the indirect command buffer.
        for (int objIndex = 0; objIndex < NumObjects; objIndex++) {
            id<MTLIndirectRenderCommand> ICBCommand =
                [_indirectCommandBuffer indirectRenderCommandAtIndex:objIndex];
            
            [ICBCommand setVertexBuffer:_vertexBuffer[objIndex]
                                 offset:0
                                atIndex:VertexBufferIndex7Vertices];

            [ICBCommand setVertexBuffer:_indirectFrameStateBuffer
                                 offset:0
                                atIndex:VertexBufferIndex7FrameState];

            [ICBCommand setVertexBuffer:_objectParameters
                                 offset:0
                                atIndex:VertexBufferIndex7ObjectParams];
            
            const NSUInteger vertexCount = _vertexBuffer[objIndex].length/sizeof(Vertex7);

            // MTLPrimitiveTypeTriangleStrip
            [ICBCommand drawPrimitives:MTLPrimitiveTypeTriangle
                           vertexStart:0
                           vertexCount:vertexCount
                         instanceCount:1
                          baseInstance:objIndex];
        }
    }
    return self;
}

- (void)drawInMTKView:(MTKView *)view {
    NSLog(@"%s", __FUNCTION__);
    
    // Wait to ensure only MaxFramesInFlight are getting processed by any stage in the Metal pipeline (App, Metal, Drivers, GPU, etc)
    dispatch_semaphore_wait(_inFlightSemaphore, DISPATCH_TIME_FOREVER);
    
    [self updateState];
    
    // Create a new command buffer for each render pass to the current drawable
    id <MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"Frame Command Buffer";
    
    /**
     Add completion hander which signals _inFlightSemaphore when Metal and the GPU has fully finished processing the commands encoded this frame.
     This indicates when the dynamic _frameStateBuffer, that written by the CPU in this frame, has been read by Metal and the GPU meaning we can change the buffer contents without corrupting the rendering
     */
    NSLog(@"=====before addCompletedHandler");
    __block dispatch_semaphore_t block_sema = _inFlightSemaphore;
    [commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> buffer) {
        NSLog(@"=====complete addCompletedHandler");
        dispatch_semaphore_signal(block_sema);
    }];
    NSLog(@"=====after addCompletedHandler");
    
    // Encode blit commands to update the buffer holding the frame state.
    id<MTLBlitCommandEncoder> blitEncoder = [commandBuffer blitCommandEncoder];

    [blitEncoder copyFromBuffer:_frameStateBuffer[_inFlightIndex]
                   sourceOffset:0
                       toBuffer:_indirectFrameStateBuffer
              destinationOffset:0
                           size:_indirectFrameStateBuffer.length];

    [blitEncoder endEncoding];
    
    // Obtain a renderPassDescriptor generated from the view's drawable textures
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;

    // If we've gotten a renderPassDescriptor we can render to the drawable, otherwise we'll skip any rendering this frame because we have no drawable to draw to
    if (renderPassDescriptor != nil) {
        // Create a render command encoder so we can render into something
        id <MTLRenderCommandEncoder> renderEncoder =
            [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"Main Render Encoder";
        
        [renderEncoder setCullMode:MTLCullModeBack];

        [renderEncoder setRenderPipelineState:_renderPipelineState];
        
        // Make a useResource call for each buffer needed by the indirect command buffer.
        for (int i = 0; i < NumObjects; i++) {
            [renderEncoder useResource:_vertexBuffer[i] usage:MTLResourceUsageRead];
        }

        [renderEncoder useResource:_objectParameters usage:MTLResourceUsageRead];

        [renderEncoder useResource:_indirectFrameStateBuffer usage:MTLResourceUsageRead];
        
        // MARK: - Execute an Indirect Command Buffer
        /**
         Draw everything in the indirect command buffer.
         
         The sample calls the executeCommandsInBuffer:withRange: method to execute the commands in _indirectCommandBuffer.
         
         Similar to the arguments in an argument buffer,
         the sample calls the useResource:usage: method to indicate that the GPU can access the resources within an indirect command buffer.
         
         The sample continues to execute _indirectCommandBuffer each frame.
         */
        [renderEncoder executeCommandsInBuffer:_indirectCommandBuffer withRange:NSMakeRange(0, NumObjects)];

        // We're done encoding commands
        [renderEncoder endEncoding];

        // Schedule a present once the framebuffer is complete using the current drawable
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    
    // Finalize rendering here & push the command buffer to the GPU
    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    NSLog(@"%s width = %lf height = %lf", __FUNCTION__, size.width, size.height);
    
    /**
     Calculate scale for quads so that they are always square when working with the default viewport and sending down clip space corrdinates.
     */
    _aspectScale.x = (float)size.height / (float)size.width;
    _aspectScale.y = 1.0;
}

// MARK: - private methods
/// Create a Metal buffer containing a 2D "gear" mesh
- (id<MTLBuffer>)newGearMeshWithNumTeeth:(uint32_t)numTeeth {
    NSAssert(numTeeth >= 3, @"Can only build a gear with at least 3 teeth");

    static const float innerRatio = 0.8;
    static const float toothWidth = 0.25;
    static const float toothSlope = 0.2;
    
    /**
     For each tooth, this function generates 2 triangles for tooth itself,
     1 triangle to fill the inner portion of the gear from bottom of the tooth to the center of the gear, and 1 triangle to fill the inner portion of the gear below the groove beside the tooth.
     Hence, the buffer needs 4 triangles or 12 vertices for each tooth.
     */
    uint32_t numVertices = numTeeth * 12;
    uint32_t bufferSize = sizeof(Vertex7) * numVertices;
    id<MTLBuffer> metalBuffer = [_device newBufferWithLength:bufferSize options:0];
    metalBuffer.label = [[NSString alloc] initWithFormat:@"%d Toothed Cog Vertices", numTeeth];
    
    Vertex7 *meshVertices = (Vertex7 *)metalBuffer.contents;
    const double angle = 2.0 * M_PI / (double)numTeeth;
    
    static const packed_float2 origin = (packed_float2){0.0, 0.0};
    int vtx = 0;

    // Build triangles for teeth of gear
    for(int tooth = 0; tooth < numTeeth; tooth++)
    {
        // Calculate angles for tooth and groove
        const float toothStartAngle = tooth * angle;
        const float toothTip1Angle  = (tooth+toothSlope) * angle;
        const float toothTip2Angle  = (tooth+toothSlope+toothWidth) * angle;;
        const float toothEndAngle   = (tooth+2*toothSlope+toothWidth) * angle;
        const float nextToothAngle  = (tooth+1.0) * angle;

        // Calculate positions of vertices needed for the tooth
        const packed_float2 groove1    = { sin(toothStartAngle)*innerRatio, cos(toothStartAngle)*innerRatio };
        const packed_float2 tip1       = { sin(toothTip1Angle), cos(toothTip1Angle) };
        const packed_float2 tip2       = { sin(toothTip2Angle), cos(toothTip2Angle) };
        const packed_float2 groove2    = { sin(toothEndAngle)*innerRatio, cos(toothEndAngle)*innerRatio };
        const packed_float2 nextGroove = { sin(nextToothAngle)*innerRatio, cos(nextToothAngle)*innerRatio };

        // Right top triangle of tooth
        meshVertices[vtx].position = groove1;
        meshVertices[vtx].texcoord = (groove1 + 1.0) / 2.0;
        vtx++;

        meshVertices[vtx].position = tip1;
        meshVertices[vtx].texcoord = (tip1 + 1.0) / 2.0;
        vtx++;

        meshVertices[vtx].position = tip2;
        meshVertices[vtx].texcoord = (tip2 + 1.0) / 2.0;
        vtx++;

        // Left bottom triangle of tooth
        meshVertices[vtx].position = groove1;
        meshVertices[vtx].texcoord = (groove1 + 1.0) / 2.0;
        vtx++;

        meshVertices[vtx].position = tip2;
        meshVertices[vtx].texcoord = (tip2 + 1.0) / 2.0;
        vtx++;

        meshVertices[vtx].position = groove2;
        meshVertices[vtx].texcoord = (groove2 + 1.0) / 2.0;
        vtx++;

        // Slice of circle from bottom of tooth to center of gear
        meshVertices[vtx].position = origin;
        meshVertices[vtx].texcoord = (origin + 1.0) / 2.0;
        vtx++;

        meshVertices[vtx].position = groove1;
        meshVertices[vtx].texcoord = (groove1 + 1.0) / 2.0;
        vtx++;

        meshVertices[vtx].position = groove2;
        meshVertices[vtx].texcoord = (groove2 + 1.0) / 2.0;
        vtx++;

        // Slice of circle from the groove to the center of gear
        meshVertices[vtx].position = origin;
        meshVertices[vtx].texcoord = (origin + 1.0) / 2.0;
        vtx++;

        meshVertices[vtx].position = groove2;
        meshVertices[vtx].texcoord = (groove2 + 1.0) / 2.0;
        vtx++;

        meshVertices[vtx].position = nextGroove;
        meshVertices[vtx].texcoord = (nextGroove + 1.0) / 2.0;
        vtx++;
    }

    return metalBuffer;
}

// MARK: - Update the Data Used by an ICB
/**
 Updates non-Metal state for the current frame including updates to uniforms used in shaders
 
 To update data that’s fed to the GPU, you typically cycle through a set of buffers such that the CPU updates one while the GPU reads another (see Synchronizing CPU and GPU Work).
 You can’t apply that pattern literally with ICBs, however, because you can’t update an ICB’s buffer set after you encode its commands, but you follow a two-step process to blit data updates from the CPU.
 First, update a single buffer in your dynamic buffer array on the CPU:
 
 Then, blit the CPU-side buffer set to the location that’s accessible to the ICB (see _indirectFrameStateBuffer):
 */
- (void)updateState
{
    _frameNumber++;

    _inFlightIndex = _frameNumber % MaxFramesInFlight;

    FrameState7 *frameState = _frameStateBuffer[_inFlightIndex].contents;

    frameState->aspectScale = _aspectScale;
}

@end
