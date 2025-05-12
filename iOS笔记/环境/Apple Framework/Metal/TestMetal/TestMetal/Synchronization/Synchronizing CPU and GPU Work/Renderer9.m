//
//  Renderer9.m
//  TestMetal
//
//  Created by youdun on 2023/9/19.
//

#import "Renderer9.h"
#import "CommonShaderTypes.h"
#import "Triangle.h"

// The maximum number of frames in flight.
static const NSUInteger kMaxFramesInFlight = 3;

// The number of triangles in the scene, determined to fit the screen.
static const NSUInteger kNumTriangles = 50;

@implementation Renderer9
{
    // A semaphore used to ensure that buffers read by the GPU are not simultaneously written by the CPU.
    dispatch_semaphore_t _inFlightSemaphore;
    
    // A series of buffers containing dynamically-updated vertices.
    id<MTLBuffer> _vertexBuffers[kMaxFramesInFlight];
    // The index of the Metal buffer in _vertexBuffers to write to for the current frame.
    NSUInteger _currentBuffer;
    
    id<MTLDevice> _device;

    id<MTLCommandQueue> _commandQueue;

    id<MTLRenderPipelineState> _renderPipelineState;
    
    vector_uint2 _viewportSize;
    
    NSArray<Triangle*> *_triangles;
    NSUInteger _totalVertexCount;
    
    float _wavePosition;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
    self = [super init];
    if (self) {
        _device = mtkView.device;

        _inFlightSemaphore = dispatch_semaphore_create(kMaxFramesInFlight);

        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader9"];
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader9"];
        
        MTLRenderPipelineDescriptor *renderPipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        renderPipelineStateDescriptor.label = @"Render Pipeline";
        renderPipelineStateDescriptor.sampleCount = mtkView.sampleCount;
        renderPipelineStateDescriptor.vertexFunction = vertexFunction;
        renderPipelineStateDescriptor.fragmentFunction = fragmentFunction;
        renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        // MARK: - Set the Mutability of Your Buffers
        /**
         Your app performs all per-frame rendering setup on a single thread.
         First it writes data to a buffer instance with the CPU.
         After that, it encodes rendering commands that reference the buffer instance.
         Finally, it commits a command buffer for GPU execution.
         Because these tasks always happen in this order on a single thread, the app guarantees that it finishes writing data to a buffer instance before it encodes a command that references the buffer instance.
         
         This order allows you to mark your buffer instances as immutable.
         When you configure your render pipeline descriptor, set the mutability property of the vertex buffer at the buffer instance index to MTLMutability.immutable:
         
         Metal can optimize the performance of immutable buffers, but not mutable buffers. For best results, use immutable buffers as much as possible.
         */
        renderPipelineStateDescriptor.vertexBuffers[CommonVertexInputIndexVertices].mutability = MTLMutabilityImmutable;
        
        NSError *error;
        _renderPipelineState = [_device newRenderPipelineStateWithDescriptor:renderPipelineStateDescriptor
                                                                       error:&error];
        NSAssert(_renderPipelineState, @"Failed to create pipeline state: %@", error);
        
        // Create the command queue.
        _commandQueue = [_device newCommandQueue];

        // Generate the triangles rendered by the app.
        [self generateTriangles];
        
        // MARK: - Allocate Data Storage
        /**
         Calculate the total storage size of your triangle vertices.
         Your app renders 50 triangles; each triangle has 3 vertices, totaling 150 vertices, and each vertex is the size of CommonVertex2
         
         Initialize multiple buffers to store multiple copies of your vertex data.
         For each buffer, allocate exactly enough memory to store 150 vertices
         
         Upon initialization, the contents of the buffer instances in the _vertexBuffers array are empty.
         */
        const NSUInteger triangleVertexCount = [Triangle vertexCount];
        _totalVertexCount = triangleVertexCount * _triangles.count;
        const NSUInteger triangleVertexBufferSize = _totalVertexCount * sizeof(CommonVertex2);
        
        for (NSUInteger bufferIndex = 0; bufferIndex < kMaxFramesInFlight; bufferIndex++) {
            _vertexBuffers[bufferIndex] = [_device newBufferWithLength:triangleVertexBufferSize
                                                               options:MTLResourceStorageModeShared];
            _vertexBuffers[bufferIndex].label = [NSString stringWithFormat:@"Vertex Buffer #%lu", (unsigned long)bufferIndex];
        }
    }
    return self;
}

// Initialize multiple triangle vertices with a position and a color, and store them in an array of triangles, _triangles:
- (void)generateTriangles {
    const vector_float4 Colors[] =
    {
        { 1.0, 0.0, 0.0, 1.0 },  // Red
        { 0.0, 1.0, 0.0, 1.0 },  // Green
        { 0.0, 0.0, 1.0, 1.0 },  // Blue
        { 1.0, 0.0, 1.0, 1.0 },  // Magenta
        { 0.0, 1.0, 1.0, 1.0 },  // Cyan
        { 1.0, 1.0, 0.0, 1.0 },  // Yellow
    };
    
    const NSUInteger kNumColors = sizeof(Colors) / sizeof(vector_float4);
    
    // Horizontal spacing between each triangle.
    const float kHorizontalSpacing = 16;
    
    NSMutableArray *triangles = [[NSMutableArray alloc] initWithCapacity:kNumTriangles];
    
    // Initialize each triangle.
    for (NSUInteger t = 0; t < kNumTriangles; t++)
    {
        vector_float2 trianglePosition;

        // Determine the starting position of the triangle in a horizontal line.
        trianglePosition.x = ((-((float)kNumTriangles) / 2.0) + t) * kHorizontalSpacing;
        trianglePosition.y = 0.0;
        
        // Create the triangle, set its properties, and add it to the array.
        Triangle *triangle = [Triangle new];
        triangle.position = trianglePosition;
        triangle.color = Colors[t % kNumColors];
        [triangles addObject:triangle];
    }
    
    _triangles = triangles;
}

// MARK: - Update Data with the CPU
/**
 Updates the position of each triangle and also updates the vertices for each triangle in the current buffer.
 
 In each frame, at the start of the draw(in:) render loop, use the CPU to update the contents of one buffer instance in the updateState method
 
 After you update a buffer instance, you don’t access its data with the CPU for the rest of the frame.

 Note
 You must finalize all CPU writes to one buffer instance before you commit a command buffer that references it.
 Otherwise, the GPU may begin reading the buffer instance while the CPU is still writing to it.
 */
- (void)updateState {
    // Simplified wave properties.
    const float waveMagnitude = 128.0;  // Vertical displacement.
    const float waveSpeed     = 0.05;   // Displacement change from the previous frame.
    
    // Increment wave position from the previous frame
    _wavePosition += waveSpeed;
    
    // Vertex data for a single default triangle.
    const CommonVertex2 *triangleVertices = [Triangle vertices];
    const NSUInteger triangleVertexCount = [Triangle vertexCount];
    
    // Vertex data for the current triangles.
    CommonVertex2 *currentTriangleVertices = _vertexBuffers[_currentBuffer].contents;
    
    // Update each triangle.
    for (NSUInteger triangle = 0; triangle < kNumTriangles; triangle++)
    {
        vector_float2 trianglePosition = _triangles[triangle].position;
        
        // Displace the y-position of the triangle using a sine wave.
        trianglePosition.y = (sin(trianglePosition.x / waveMagnitude + _wavePosition) * waveMagnitude);
        
        // Update the position of the triangle.
        _triangles[triangle].position = trianglePosition;
        
        // Update the vertices of the current vertex buffer with the triangle's new position.
        for (NSUInteger vertex = 0; vertex < triangleVertexCount; vertex++)
        {
            NSUInteger currentVertex = vertex + (triangle * triangleVertexCount);
            currentTriangleVertices[currentVertex].position = triangleVertices[vertex].position + _triangles[triangle].position;
            currentTriangleVertices[currentVertex].color = _triangles[triangle].color;
        }
    }
}

// Handles view rendering for a new frame.
- (void)drawInMTKView:(MTKView *)view {
    NSLog(@"%s", __FUNCTION__);
    
    // MARK: - Manage the Rate of CPU and GPU Work
    /**
     When you have multiple instances of a buffer, you can make the CPU start work for frame n+1 with one instance, while the GPU finishes work for frame n with another instance.
     This implementation improves your app’s efficiency by making the CPU and the GPU work simultaneously.
     However, you need to manage your app’s rate of work so you don’t exceed the number of buffer instances available.
     
     To manage your app’s rate of work, use a semaphore to wait for full frame completions in case the CPU is working much faster than the GPU.
     A semaphore is a non-Metal object that you use to control access to a resource that’s shared across multiple processors (or threads).
     The semaphore has an associated counting value, which you decrement or increment, that indicates whether a processor has started or finished accessing a resource.
     In your app, a semaphore controls CPU and GPU access to buffer instances.
     
     You initialize the semaphore with a counting value of MaxFramesInFlight, to match the number of buffer instances.
     This value indicates that your app can simultaneously work on a maximum of 3 frames at any given time:
     _inFlightSemaphore = dispatch_semaphore_create(MaxFramesInFlight);
     
     At the start of the render loop, you decrement the semaphore’s counting value by 1.
     This indicates that you’re ready to work on a new frame.
     However, if the counting value falls below 0, the semaphore makes the CPU wait until you increment the value:
     */
    // Wait to ensure only `MaxFramesInFlight` number of frames are getting processed by any stage in the Metal pipeline (CPU, GPU, Metal, Drivers, etc.).
    dispatch_semaphore_wait(_inFlightSemaphore, DISPATCH_TIME_FOREVER);

    // MARK: - Reuse Multiple Buffer Instances in Your App
    /**
     For each frame, perform the following steps. A full frame’s work is finished when both processors have completed their work.
     1. Write data to a buffer instance.
     2. Encode commands that reference the buffer instance.
     3. Commit a command buffer that contains the encoded commands.
     4. Read data from the buffer instance.
     
     When a frame’s work is finalized, the CPU and the GPU no longer need the buffer instance used in that frame.
     However, discarding a used buffer instance and creating a new one for each frame is expensive and wasteful.
     Instead, as shown below, set up your app to cycle through a first in, first out (FIFO) queue of buffer instances, _vertexBuffers, that you can reuse.
     The maximum number of buffer instances in the queue is defined by the value of MaxFramesInFlight, set to 3:
     
     In each frame, at the start of the render loop, you update the next buffer instance from the _vertexBuffer queue.
     You cycle through the queue sequentially and update only one buffer instance per frame; at the end of every third frame, you return to the start of the queue:
     
     Note
     Core Animation provides optimized displayable resources, commonly referred to as drawables, for you to render content and display it onscreen.
     Drawables are efficient yet expensive system resources, so Core Animation limits the number of drawables that you can use simultaneously in your app.
     The default limit is 3, but you can set it to 2 with the maximumDrawableCount property (2 and 3 are the only supported values).
     Because the maximum number of drawables is 3, this sample creates 3 buffer instances.
     You donʼt need to create more buffer instances than the maximum number of drawables available.
     */
    // Iterate through the Metal buffers, and cycle back to the first when you've written to the last.
    _currentBuffer = (_currentBuffer + 1) % kMaxFramesInFlight;
    NSLog(@"_currentBuffer = %lu", _currentBuffer);

    // Update buffer data.
    [self updateState];
    
    // Create a new command buffer for each rendering pass to the current drawable.
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"Command Buffer";

    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil)
    {
        // Create a render command encoder to encode the rendering pass.
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"Render Command Encoder";

        // Set render command encoder state.
        [renderEncoder setRenderPipelineState:_renderPipelineState];

        // Set the current vertex buffer.
        [renderEncoder setVertexBuffer:_vertexBuffers[_currentBuffer]
                                offset:0
                               atIndex:CommonVertexInputIndexVertices];

        // Set the viewport size.
        [renderEncoder setVertexBytes:&_viewportSize
                               length:sizeof(_viewportSize)
                              atIndex:CommonVertexInputIndexViewportSize];

        // Draw the triangle vertices.
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:_totalVertexCount];

        // Finalize encoding.
        [renderEncoder endEncoding];

        // Schedule a drawable's presentation after the rendering pass is complete.
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    
    NSLog(@"before addCompletedHandler");
    
    /**
     Add a completion handler that signals `_inFlightSemaphore` when Metal and the GPU have fully finished processing the commands that were encoded for this frame.
     
     This completion indicates that the dynamic buffers that were written-to in this frame, are no longer needed by Metal and the GPU;
     therefore, the CPU can overwrite the buffer contents without corrupting any rendering operations.
     
     At the end of the render loop, you register a command buffer completion handler.
     When the GPU completes the command buffer’s execution, it calls this completion handler and you increment the semaphore’s counting value by 1.
     This indicates that you’ve completed all work for a given frame and you can reuse the buffer instance used in that frame:
     
     The addCompletedHandler(_:) method registers a block of code that’s called immediately after the GPU has finished executing the associated command buffer.
     Because you use only one command buffer per frame, receiving the completion callback indicates that the GPU has completed the frame.
     */
    __block dispatch_semaphore_t block_semaphore = _inFlightSemaphore;
    [commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> buffer) {
        NSLog(@"===addCompletedHandler===");
        dispatch_semaphore_signal(block_semaphore);
    }];
    
    NSLog(@"after addCompletedHandler");
    
    // MARK: - Commit and Execute GPU Commands
    /**
     At the end of the render loop, call your command buffer’s commit() method to submit your work to the GPU:
     */
    // Finalize CPU work and submit the command buffer to the GPU.
    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    NSLog(@"%s width = %lf height = %lf", __FUNCTION__, size.width, size.height);

    // Regenerate the triangles.
    [self generateTriangles];

    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

@end
