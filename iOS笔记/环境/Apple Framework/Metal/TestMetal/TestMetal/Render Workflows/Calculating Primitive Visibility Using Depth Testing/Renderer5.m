//
//  Renderer5.m
//  TestMetal
//
//  Created by youdun on 2023/9/1.
//

#import "Renderer5.h"
#import "ShaderTypes5.h"

@implementation Renderer5
{
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    
    id<MTLRenderPipelineState> _renderPipelineState;
    
    // Combined depth and stencil state object.
    id<MTLDepthStencilState> _depthState;
    
    // The current size of the view, used as an input to the vertex shader.
    vector_uint2 _viewportSize;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
    self = [super init];
    if (self) {
        _device = mtkView.device;
        // Set a black clear color.
        mtkView.clearColor = MTLClearColorMake(0, 0, 0, 1);
        
        // MARK: - Create a Depth Texture
        /**
         By default, MTKView doesn’t create depth textures.
         To add them, set the depthStencilPixelFormat property to the data format you want to use for depth textures.
         The view creates and manages them for you automatically.
         
         This sample uses a 32-bit floating-point depth value for each pixel.
         Pick a format that has the range and precision you need for your intended use case.
         */
        // Indicate that each pixel in the depth buffer is a 32-bit floating point value.
        mtkView.depthStencilPixelFormat = MTLPixelFormatDepth32Float;
        
        // MARK: - Clear the Depth Texture at the Start of the Render Pass
        // Indicate that Metal should clear all values in the depth buffer to `1.0` when you create a render command encoder with the MetalKit view's `currentRenderPassDescriptor` property.
        mtkView.clearDepth = 1.0;
        
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader5"];
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader5"];
        
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"Render Pipeline";
        pipelineStateDescriptor.sampleCount = mtkView.sampleCount;
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        // MARK: - Specify the Depth Format in the Render Pipeline
        /**
         To enable depth testing for a render pipeline, set the depthAttachmentPixelFormat property on the descriptor when you create the render pipeline, as shown below:
         
         As with color formats, the render pipeline needs information about the format of the depth texture so that it can read or write values in the texture.
         Specify the same depth format that you used to configure your view.
         When you add a depth texture, Metal enables additional stages on the render pipeline:
         */
        pipelineStateDescriptor.depthAttachmentPixelFormat = mtkView.depthStencilPixelFormat;
        pipelineStateDescriptor.vertexBuffers[VertexInputIndex5Vertices].mutability = MTLMutabilityImmutable;
        
        NSError *error;
        _renderPipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        NSAssert(_renderPipelineState, @"Failed to create pipeline state: %@", error);
        
        // MARK: - Configure the Depth Test
        /**
         Note
         Metal combines depth testing with a stencil test, which performs a similar test using a count stored for each pixel, typically the number of times that fragments pass the depth test. Stencil operations are useful for implementing certain 3D algorithms. By default, the stencil test is disabled, and this sample doesn’t enable it.
         
         In Metal, you configure depth testing independently from the render pipeline, so you can mix and match combinations of render pipelines and depth tests.
         The depth test is represented by a MTLDepthStencilState object, and like you do with a render pipeline, you usually create this object when you initialize your app, and keep a reference to it as long as you need to execute that test.
         
         the depth test passes when a new depth value is smaller than the existing value for the target pixel in the depth texture, indicating that the fragment is closer to the viewer than whatever was previously rendered there.
         When the depth test passes, the fragment’s color values are written to the color render attachments, and the new depth value is written to the depth attachment.
         This code shows how to configure the depth test:
         */
        MTLDepthStencilDescriptor *depthDescriptor = [MTLDepthStencilDescriptor new];
        depthDescriptor.depthCompareFunction = MTLCompareFunctionLessEqual;
        depthDescriptor.depthWriteEnabled = YES;
        _depthState = [_device newDepthStencilStateWithDescriptor:depthDescriptor];
        
        // Create the command queue.
        _commandQueue = [_device newCommandQueue];
    }
    return self;
}

- (void)drawInMTKView:(MTKView *)view {
    NSLog(@"%s", __FUNCTION__);
    
    // Create a new command buffer for each rendering pass to the current drawable.
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"Command Buffer";
    
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil) {
        // Create a render command encoder to encode the rendering pass.
        id<MTLRenderCommandEncoder> renderEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"Render Command Encoder";
        
        // Encode the render pipeline state object.
        [renderEncoder setRenderPipelineState:_renderPipelineState];
        
        [renderEncoder setDepthStencilState:_depthState];
        
        // Encode the viewport size so it can be accessed by the vertex shader.
        [renderEncoder setVertexBytes:&_viewportSize
                               length:sizeof(_viewportSize)
                              atIndex:VertexInputIndex5Viewport];
        
        // Initialize and encode the vertex data for the gray quad. Set the vertex depth values to `0.5` (z component).
        const Vertex5 quadVertices[] =
        {
            // Pixel positions (x, y) and clip depth (z),        RGBA colors.
            { {                 100,                 100, 0.5 }, { 0.5, 0.5, 0.5, 1 } },
            { {                 100, _viewportSize.y-100, 0.5 }, { 0.5, 0.5, 0.5, 1 } },
            { { _viewportSize.x-100, _viewportSize.y-100, 0.5 }, { 0.5, 0.5, 0.5, 1 } },
            
            { {                 100,                 100, 0.5 }, { 0.5, 0.5, 0.5, 1 } },
            { { _viewportSize.x-100, _viewportSize.y-100, 0.5 }, { 0.5, 0.5, 0.5, 1 } },
            { { _viewportSize.x-100,                 100, 0.5 }, { 0.5, 0.5, 0.5, 1 } },
        };
        
        [renderEncoder setVertexBytes:quadVertices
                               length:sizeof(quadVertices)
                              atIndex:VertexInputIndex5Vertices];
        
        // Encode the draw command for the gray quad.
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:6];
        
        // Initialize and encode the vertex data for the white triangle. Set the UI control values to the vertex depth values (z component).
        const Vertex5 triangleVertices[] =
        {
            // Pixel positions (x, y) and clip depth (z),                           RGBA colors.
            { {                    200, _viewportSize.y - 200, _leftVertexDepth  }, { 1, 1, 1, 1 } },
            { {  _viewportSize.x / 2.0,                   200, _topVertexDepth   }, { 1, 1, 1, 1 } },
            { {  _viewportSize.x - 200, _viewportSize.y - 200, _rightVertexDepth }, { 1, 1, 1, 1 } }
        };
        
        [renderEncoder setVertexBytes:triangleVertices
                               length:sizeof(triangleVertices)
                              atIndex:VertexInputIndex5Vertices];
        
        // Encode the draw command for the white triangle.
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:3];
        
        
        // Finalize encoding.
        [renderEncoder endEncoding];
        
        // Schedule a drawable's presentation after the rendering pass is complete.
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    
    // Finalize CPU work and submit the command buffer to the GPU.
    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    NSLog(@"%s width = %lf height = %lf", __FUNCTION__, size.width, size.height);
    
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

@end
