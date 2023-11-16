//
//  Renderer4.m
//  TestMetal
//
//  Created by youdun on 2023/8/30.
//

#import "Renderer4.h"
#import "TGAImage.h"
#import "ShaderTypes4.h"

@implementation Renderer4
{
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    
    id<MTLComputePipelineState> _computePipelineState;
    id<MTLRenderPipelineState> _renderPipelineState;
    
    // Texture object that serves as the source for image processing.
    id<MTLTexture> _inputTexture;
    // Texture object that serves as the output for image processing.
    id<MTLTexture> _outputTexture;
    
    // The current size of the view, used as an input to the vertex shader.
    vector_uint2 _viewportSize;
    
    // Compute kernel dispatch parameters
    MTLSize _threadgroupSize;
    MTLSize _threadgroupCount;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
    self = [super init];
    if (self) {
        NSError *error = nil;

        _device = mtkView.device;
        /**
         MTLPixelFormatBGRA8Unorm:
         Ordinary format with four 8-bit normalized unsigned integer components in BGRA order.

         MTLPixelFormatBGRA8Unorm_sRGB:
         Ordinary format with four 8-bit normalized unsigned integer components in BGRA order with conversion between sRGB and linear space.
         
         sRGB 颜色空间是一种广泛应用于显示设备的颜色空间，它能更好地适应人眼对亮度和颜色的感知，从而提供更准确的颜色表示。
         当使用这个格式进行纹理贴图或渲染时，Metal 会自动将颜色值从线性空间转换到 sRGB 颜色空间，以提供更接近人眼感知的颜色。
         */
        mtkView.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
        
        // Load all the shader files with a .metal file extension in the project.
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        // Load the image processing function from the library and create a pipeline from it.
        id<MTLFunction> kernelFunction = [defaultLibrary newFunctionWithName:@"grayscaleKernel4"];
        _computePipelineState = [_device newComputePipelineStateWithFunction:kernelFunction
                                                                       error:&error];
        /**
         Compute pipeline state creation could fail if kernelFunction failed to load from the library.
         If the Metal API validation is enabled, you automatically get more information about what went wrong.
         (Metal API validation is enabled by default when you run a debug build from Xcode.)
         */
        NSAssert(_computePipelineState, @"Failed to create compute pipeline state: %@", error);
        
        // Load the vertex and fragment functions, and use them to configure a render pipeline.
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader4"];
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"samplingShader4"];
        
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"Simple Render Pipeline";
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        _renderPipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                       error:&error];
        NSAssert(_renderPipelineState, @"Failed to create render pipeline state: %@", error);
        
        NSURL *imageFileUrl = [[NSBundle mainBundle] URLForResource:@"Image"
                                                      withExtension:@"tga"];
        TGAImage *image = [[TGAImage alloc] initWithTGAFileFromUrl:imageFileUrl];
        if (!image) {
            return nil;
        }
        
        MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
        textureDescriptor.textureType = MTLTextureType2D;
        // Indicate that each pixel has a Blue, Green, Red, and Alpha channel, each in an 8-bit unnormalized value (0 maps to 0.0, while 255 maps to 1.0)
        textureDescriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;
        textureDescriptor.width = image.width;
        textureDescriptor.height = image.height;
        // The image kernel only needs to read the incoming image data.
        textureDescriptor.usage = MTLTextureUsageShaderRead;
        _inputTexture = [_device newTextureWithDescriptor:textureDescriptor];
        // The output texture needs to be written by the image kernel and sampled by the rendering code.
        textureDescriptor.usage = MTLTextureUsageShaderWrite | MTLTextureUsageShaderRead ;
        _outputTexture = [_device newTextureWithDescriptor:textureDescriptor];
        
        MTLRegion region = {{ 0, 0, 0 }, {textureDescriptor.width, textureDescriptor.height, 1}};

        NSUInteger bytesPerRow = 4 * textureDescriptor.width;

        // Copy the bytes from the data object into the texture.
        [_inputTexture replaceRegion:region
                         mipmapLevel:0
                           withBytes:image.data.bytes
                         bytesPerRow:bytesPerRow];
        NSAssert(_inputTexture && !error, @"Failed to create inpute texture: %@", error);
        
        /**
         To dispatch the compute command, the sample needs to determine how large a grid to create when it executes the kernel, and the sample calculates this at initialization time.
         As described earlier, this sample uses a grid where each thread corresponds to a pixel in the texture, so the grid must be at least as large as the 2D image.
         For simplicity, the sample uses a 16 x 16 threadgroup size, which is small enough to be used by any GPU.
         In practice, however, selecting an efficient threadgroup size depends on both the size of the data and the capabilities of a specific device object.
         */
        // Set the compute kernel's threadgroup size to 16 x 16.
        _threadgroupSize = MTLSizeMake(16, 16, 1);
        // Calculate the number of rows and columns of threadgroups given the size of the input image. Ensure that the grid covers the entire image (or more).
        _threadgroupCount.width  = (_inputTexture.width  + _threadgroupSize.width -  1) / _threadgroupSize.width;
        _threadgroupCount.height = (_inputTexture.height + _threadgroupSize.height - 1) / _threadgroupSize.height;
        // The image data is 2D, so set depth to 1.
        _threadgroupCount.depth = 1;
        
        // Create the command queue.
        _commandQueue = [_device newCommandQueue];
    }
    return self;
}


- (void)drawInMTKView:(MTKView *)view {
    NSLog(@"%s", __FUNCTION__);
    
    static const Vertex4 quadVertices[] =
    {
        // Pixel positions, Texture coordinates
        { {  250,  -250 },  { 1.f, 1.f } },
        { { -250,  -250 },  { 0.f, 1.f } },
        { { -250,   250 },  { 0.f, 0.f } },

        { {  250,  -250 },  { 1.f, 1.f } },
        { { -250,   250 },  { 0.f, 0.f } },
        { {  250,   250 },  { 1.f, 0.f } },
    };
    
    // Create a new command buffer for each frame.
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"Command Buffer";
    // MARK: - Execute a Compute Pass
    /**
     To process the image, the sample creates an MTLComputeCommandEncoder object.
     */
    // Process the input image.
    id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];
    [computeEncoder setComputePipelineState:_computePipelineState];
    [computeEncoder setTexture:_inputTexture
                       atIndex:TextureIndex4Input];
    [computeEncoder setTexture:_outputTexture
                       atIndex:TextureIndex4Output];
    
    [computeEncoder dispatchThreadgroups:_threadgroupCount
                   threadsPerThreadgroup:_threadgroupSize];

    [computeEncoder endEncoding];
    
    /**
     After finishing the compute pass, the sample encodes a render pass in the same command buffer, passing the output texture from the compute command as the input to the drawing command.

     Metal automatically tracks dependencies between the compute and render passes.
     When the sample sends the command buffer to be executed, Metal detects that the compute pass writes to the output texture and the render pass reads from it, and makes sure the GPU finishes the compute pass before starting the render pass.
     */
    // Use the output image to draw to the view's drawable texture.
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil) {
        // Create the encoder for the render pass.
        id<MTLRenderCommandEncoder> renderEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"Render Encoder";

        // Set the region of the drawable to draw into.
        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewportSize.x, _viewportSize.y, -1.0, 1.0 }];

        [renderEncoder setRenderPipelineState:_renderPipelineState];

        // Encode the vertex data.
        [renderEncoder setVertexBytes:quadVertices
                               length:sizeof(quadVertices)
                              atIndex:VertexInputIndex4Vertices];

        // Encode the viewport data.
        [renderEncoder setVertexBytes:&_viewportSize
                               length:sizeof(_viewportSize)
                              atIndex:VertexInputIndex4ViewportSize];

        // Encode the output texture from the previous stage.
        [renderEncoder setFragmentTexture:_outputTexture
                                  atIndex:TextureIndex4Output];

        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:6];

        [renderEncoder endEncoding];

        [commandBuffer presentDrawable:view.currentDrawable];
    }

    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    NSLog(@"%s width = %lf height = %lf", __FUNCTION__, size.width, size.height);
    
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

@end
