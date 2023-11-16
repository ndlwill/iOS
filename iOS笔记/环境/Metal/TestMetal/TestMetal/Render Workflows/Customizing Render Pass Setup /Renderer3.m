//
//  Renderer3.m
//  TestMetal
//
//  Created by youdun on 2023/8/28.
//

#import "Renderer3.h"
#import "ShaderTypes3.h"

@implementation Renderer3
{
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    
    id<MTLRenderPipelineState> _pipelineState;
    
    // Texture to render to and then sample from.
    id<MTLTexture> _renderTargetTexture;
    // Render pass descriptor to draw to the texture
    MTLRenderPassDescriptor* _renderToTextureRenderPassDescriptor;
    // A pipeline object to render to the screen.
    id<MTLRenderPipelineState> _drawableRenderPipeline;
    // A pipeline object to render to the offscreen texture.
    id<MTLRenderPipelineState> _renderToTextureRenderPipeline;
    
    // Ratio of width to height to scale positions in the vertex shader.
    float _aspectRatio;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
    self = [super init];
    if (self) {
        _device = mtkView.device;
        mtkView.clearColor = MTLClearColorMake(1.0, 0.0, 0.0, 1.0);
        
        _commandQueue = [_device newCommandQueue];
        
        // MARK: - Create a Texture for the Offscreen Render Pass
        /**
         An MTKView object automatically creates drawable textures to render into.
         The sample also needs a texture to render into during the offscreen render pass.
         To create that texture, it first creates a MTLTextureDescriptor object and configures its properties.
         
         The sample configures the usage property to state exactly how it intends to use the new texture.
         It needs to render data into the texture in the offscreen render pass and read from it in the second pass.
         The sample specifies this usage by setting the renderTarget and shaderRead flags.
         
         Setting usage flags precisely can improve performance, because Metal can configure the texture’s underlying data only for the specified uses.
         */
        // Set up a texture for rendering to and sampling from
        MTLTextureDescriptor *texDescriptor = [MTLTextureDescriptor new];
        // The default value is MTLTextureType2D.
        texDescriptor.textureType = MTLTextureType2D;
        texDescriptor.width = 512;
        texDescriptor.height = 512;
        texDescriptor.pixelFormat = MTLPixelFormatRGBA8Unorm;
        // The default value for this property is MTLTextureUsageShaderRead.
        texDescriptor.usage = MTLTextureUsageRenderTarget | MTLTextureUsageShaderRead;
        
        _renderTargetTexture = [_device newTextureWithDescriptor:texDescriptor];
        
        
        // MARK: - MTLRenderPassDescriptor
        /**
         MTLRenderPassDescriptor 是一个用于配置渲染通道的对象，用于描述一次图形渲染的各个方面，如颜色附件、深度和模板附件等
         
         colorAttachments 是 MTLRenderPassDescriptor 中的一个属性，用于配置颜色附件的相关信息。
         颜色附件（Color Attachment）是指用于存储渲染结果的图像或纹理，即渲染操作的输出。
         在 MTLRenderPassDescriptor 中，colorAttachments 数组允许您配置多个颜色附件，每个颜色附件都有自己的属性和设置。
         每个颜色附件可以配置的属性包括：
         texture：指定用于存储渲染结果的纹理。
         loadAction：指定渲染前是否需要将纹理清空。
         storeAction：指定渲染后是否需要将纹理内容保存。
         clearColor：在 loadAction 设置为 MTLLoadActionClear 时，用于指定清空颜色的值。
         
         通过配置不同的颜色附件，您可以实现多渲染目标（MRT，Multiple Render Targets）等渲染技术，从而在单次渲染中将输出渲染到多个目标中。
         let renderPassDescriptor = MTLRenderPassDescriptor()

         if let colorAttachment = renderPassDescriptor.colorAttachments[0] {
             colorAttachment.texture = colorTexture
             colorAttachment.loadAction = .clear
             colorAttachment.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
             colorAttachment.storeAction = .store
         }
         在此示例中，colorTexture 是一个用于存储渲染结果的纹理，配置了加载和存储操作，以及清空颜色。
         每个 colorAttachment 都会在渲染过程中处理不同的颜色附件。
         */
        
        // MARK: - Set Up the Offscreen Render Pass Descriptor
        /**
         To render to the offscreen texture, the sample configures a new render pass descriptor.
         It creates a MTLRenderPassDescriptor object and configures its properties.
         This sample renders to a single color texture, so it sets colorAttachment[0].texture to point to the offscreen texture
         
         A load action determines the initial contents of the texture at the start of the render pass, before the GPU executes any drawing commands.
         Similarly, a store action runs after the render pass completes, and determines whether the GPU writes the final image back to the texture.
         The sample configures a load action to erase the render target’s contents, and a store action that stores the rendered data back to the texture.
         It needs to do the latter because the drawing commands in the second render pass will sample this data.
         
         Metal uses load and store actions to optimize how the GPU manages texture data.
         Large textures consume lots of memory, and working on those textures can consume lots of memory bandwidth.
         Setting the render target actions correctly can reduce the amount of memory bandwidth the GPU uses to access the texture, improving performance and battery life.
         */
        // To render to the offscreen texture, the sample configures a new render pass descriptor. It creates a MTLRenderPassDescriptor object and configures its properties.
        _renderToTextureRenderPassDescriptor = [MTLRenderPassDescriptor new];
        // This sample renders to a single color texture, so it sets colorAttachment[0].texture to point to the offscreen texture:
        _renderToTextureRenderPassDescriptor.colorAttachments[0].texture = _renderTargetTexture;
        _renderToTextureRenderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        _renderToTextureRenderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1);
        _renderToTextureRenderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
        
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        // This sample creates one render pipeline for each render pass, using the following code for the offscreen render pipeline:
        NSError *error;
        
        // MARK: - Create the Render Pipelines
        /**
         A render pipeline specifies how to execute a drawing command, including the vertex and fragment functions to execute, and the pixel formats of any render targets it acts upon.
         Later, when the sample creates the custom render pass, it must use the same pixel formats.
         */
        // MARK: - MTLRenderPipelineDescriptor
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"Drawable Render Pipeline";
        /**
         The default value is 1.
         This value is only used if the pipeline render targets support multisampling.
         If the render targets do not support multisampling, then this value must be 1.
         
         When a MTLRenderCommandEncoder object is created, the sampleCount value of all the render target textures must match this sampleCount value.
         
         Furthermore, the texture type of all render target textures must be MTLTextureType2DMultisample.
         Support for different sample count values varies by device.
         Call the supportsTextureSampleCount: method to determine if your desired sample count value is supported.
         */
        pipelineStateDescriptor.sampleCount = mtkView.sampleCount;
        pipelineStateDescriptor.vertexFunction =  [defaultLibrary newFunctionWithName:@"textureVertexShader3"];
        pipelineStateDescriptor.fragmentFunction =  [defaultLibrary newFunctionWithName:@"textureFragmentShader3"];
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        pipelineStateDescriptor.vertexBuffers[VertexInputIndex3Vertices].mutability = MTLMutabilityImmutable;
        
        _drawableRenderPipeline = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        NSAssert(_drawableRenderPipeline, @"Failed to create pipeline state to render to screen: %@", error);
        
        // Set up pipeline for rendering to the offscreen texture. Reuse the descriptor and change properties that differ.
        pipelineStateDescriptor.label = @"Offscreen Render Pipeline";
        // The default value is 1.
        pipelineStateDescriptor.sampleCount = 1;
        pipelineStateDescriptor.vertexFunction =  [defaultLibrary newFunctionWithName:@"simpleVertexShader3"];
        pipelineStateDescriptor.fragmentFunction =  [defaultLibrary newFunctionWithName:@"simpleFragmentShader3"];
        // _renderTargetTexture.pixelFormat: The MTLPixelFormat that is used to interpret this texture's contents.
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = _renderTargetTexture.pixelFormat;
        
        _renderToTextureRenderPipeline = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        NSAssert(_renderToTextureRenderPipeline, @"Failed to create pipeline state to render to texture: %@", error);
    }
    return self;
}

- (void)drawInMTKView:(MTKView *)view {
    NSLog(@"%s", __FUNCTION__);
    
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"Command Buffer";
    
    // MARK: - Render to the Offscreen Texture
    /**
     When an app commits a buffer of commands to a command queue, by default, Metal must act as if it executes commands sequentially.
     To increase performance and to better utilize the GPU, Metal can run commands concurrently, as long as doing so doesn’t generate results inconsistent with sequential execution.
     To accomplish this, when a pass writes to a resource and a subsequent pass reads from it, as in this sample, Metal detects the dependency and automatically delays execution of the later pass until the first one completes.
     So, unlike Synchronizing CPU and GPU Work, where the CPU and GPU needed to be explicitly synchronized, the sample doesn’t need to do anything special.
     It simply encodes the two passes sequentially, and Metal ensures they run in that order.
     
     The sample encodes both render passes into one command buffer, starting with the offscreen render pass.
     It creates a render command encoder using the offscreen render pass descriptor it previously created.
     
     It configures the pipeline and any necessary arguments, then encodes the drawing command.
     After encoding the command, it calls endEncoding() to finish the encoding process.
     
     Multiple passes must be encoded sequentially into a command buffer, so the sample must finish encoding the first render pass before starting the next one.
     */
    {
        static const SimpleVertex3 triVertices[] =
        {
            // Positions     ,  Colors
            { {  0.5,  -0.5 },  { 1.0, 0.0, 0.0, 1.0 } },
            { { -0.5,  -0.5 },  { 0.0, 1.0, 0.0, 1.0 } },
            { {  0.0,   0.5 },  { 0.0, 0.0, 1.0, 0.0 } },
        };

        id<MTLRenderCommandEncoder> renderEncoder =
            [commandBuffer renderCommandEncoderWithDescriptor:_renderToTextureRenderPassDescriptor];
        renderEncoder.label = @"Offscreen Render Pass";
        [renderEncoder setRenderPipelineState:_renderToTextureRenderPipeline];

        [renderEncoder setVertexBytes:&triVertices
                               length:sizeof(triVertices)
                              atIndex:VertexInputIndex3Vertices];

        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:3];

        // End encoding commands for this render pass.
        [renderEncoder endEncoding];
    }
    
    // MARK: - Render to the Drawable Texture
    /**
     The second render pass needs renders the final image.
     The drawable render pipeline’s fragment shader samples data from a texture and returns that sample as the final color

     The code uses the view’s render pass descriptor to create the second render pass, and encodes a drawing command to render a textured quad.
     It specifies the offscreen texture as the texture argument for the command.

     When the sample commits the command buffer, Metal executes the two render passes sequentially.
     In this case, Metal detects that the first render pass writes to the offscreen texture and the second pass reads from it.
     When Metal detects such a dependency, it prevents the subsequent pass from executing until the GPU finishes executing the first pass.
     */
    {
        MTLRenderPassDescriptor *drawableRenderPassDescriptor = view.currentRenderPassDescriptor;
        if (drawableRenderPassDescriptor != nil) {
            static const TextureVertex3 quadVertices[] =
            {
                // Positions     , Texture coordinates
                { {  0.5,  -0.5 },  { 1.0, 1.0 } },
                { { -0.5,  -0.5 },  { 0.0, 1.0 } },
                { { -0.5,   0.5 },  { 0.0, 0.0 } },

                { {  0.5,  -0.5 },  { 1.0, 1.0 } },
                { { -0.5,   0.5 },  { 0.0, 0.0 } },
                { {  0.5,   0.5 },  { 1.0, 0.0 } },
            };
            id<MTLRenderCommandEncoder> renderEncoder =
                [commandBuffer renderCommandEncoderWithDescriptor:drawableRenderPassDescriptor];
            renderEncoder.label = @"Drawable Render Pass";
            
            [renderEncoder setRenderPipelineState:_drawableRenderPipeline];

            [renderEncoder setVertexBytes:&quadVertices
                                   length:sizeof(quadVertices)
                                  atIndex:VertexInputIndex3Vertices];

            [renderEncoder setVertexBytes:&_aspectRatio
                                   length:sizeof(_aspectRatio)
                                  atIndex:VertexInputIndex3AspectRatio];

            // Set the offscreen texture as the source texture.
            [renderEncoder setFragmentTexture:_renderTargetTexture atIndex:TextureInputIndex3Color];

            // Draw quad with rendered texture.
            [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                              vertexStart:0
                              vertexCount:6];

            [renderEncoder endEncoding];

            [commandBuffer presentDrawable:view.currentDrawable];
        }
    }

    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    _aspectRatio =  (float)size.height / (float)size.width;
    
    // width = 1170.000000 height = 2361.000000
    NSLog(@"%s width = %lf height = %lf _aspectRatio = %f", __FUNCTION__, size.width, size.height, _aspectRatio);
}

@end
