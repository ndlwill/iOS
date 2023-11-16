//
//  Renderer6.m
//  TestMetal
//
//  Created by youdun on 2023/9/4.
//

#import "Renderer6.h"
#import "ShaderTypes6.h"

@implementation Renderer6
{
    MTKView *_mtkView;
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    
    id<MTLRenderPipelineState> _renderPipelineState;
    
    vector_uint2 _viewportSize;
    
    // A flag indicating that the app already drew the scene to read the pixel data.
    BOOL _drewSceneForReadThisFrame;
    
    // Buffer to contain pixels blit from drawable.
    id<MTLBuffer> _readBuffer;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
    self = [super init];
    if (self) {
        _mtkView = mtkView;
        _device = mtkView.device;
        _commandQueue = [_device newCommandQueue];
        
        // 0 = NO
        NSLog(@"_drewSceneForReadThisFrame = %d", _drewSceneForReadThisFrame);
        
        // MARK: - Configure the Drawable Texture for Read Access
        /**
         By default, MetalKit views create drawable textures for rendering only, so other Metal commands can’t access the texture.
         The code below creates a view whose textures include read access.
         Because the sample needs to get a texture whenever the user selects part of the view, the code configures the view’s Metal layer to wait indefinitely for a new drawable.
         
         Because configuring the drawable textures for read access means that Metal may not apply some optimizations, only change the drawable configuration when necessary.
         For similar reasons, don’t configure the view to wait indefinitely in performance-sensitive apps.
         */
        
        /**
         framebufferOnly:
         A Boolean value that determines whether the drawable’s textures are used only for rendering.
         If the value is YES (the default), the underlying CAMetalLayer object allocates its textures with only the MTLTextureUsageRenderTarget usage flag.
         Core Animation can then optimize the textures for display purposes.
         However, you may not sample, read from, or write to those textures.
         If the value is NO, you can sample or perform read/write operations on the textures, but at a cost to performance.
         */
        _mtkView.framebufferOnly = NO;
        ((CAMetalLayer *)_mtkView.layer).allowsNextDrawableTimeout = NO;
        _mtkView.colorPixelFormat = MTLPixelFormatBGRA8Unorm;
        _mtkView.clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1.0);
        
        {
            id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];

            MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
            pipelineStateDescriptor.label = @"Render Pipeline";
            pipelineStateDescriptor.vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader6"];;
            pipelineStateDescriptor.fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader6"];;
            pipelineStateDescriptor.colorAttachments[0].pixelFormat = _mtkView.colorPixelFormat;

            NSError *error;
            _renderPipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                           error:&error];
            NSAssert(_renderPipelineState, @"Failed to create pipeline state, error: %@", error);
        }
    }
    return self;
}

// main thread
- (void)drawInMTKView:(MTKView *)view {
//    NSLog(@"%s", __FUNCTION__);
    
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    NSLog(@"commandBuffer1 = %@", commandBuffer);
    
    commandBuffer.label = @"Command Buffer";
    
    if (!_drewSceneForReadThisFrame)
    {
        [self drawScene:view withCommandBuffer:commandBuffer];
    } else {
        NSLog(@"_drewSceneForReadThisFrame = YES");
    }

    /**
     You can only call this method before calling the command buffer’s commit method.
     
     This convenience method calls the drawable’s present method after the command queue schedules the command buffer for execution.
     The command buffer does this by adding a completion handler by calling its own addScheduledHandler: method for you.
     */
    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];

    _drewSceneForReadThisFrame = NO;
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    NSLog(@"%s width = %lf height = %lf", __FUNCTION__, size.width, size.height);
    
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

// MARK: - Drawing and Reading Methods
// Encode drawing commands to the given command buffer.
- (void)drawScene:(MTKView*)view withCommandBuffer:(id<MTLCommandBuffer>)commandBuffer {
    NSLog(@"%s", __FUNCTION__);
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;

    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    renderEncoder.label = @"Render Encoder";
    
    // Encode the render pipeline state and viewport for the scene.
    [renderEncoder setRenderPipelineState:_renderPipelineState];

    [renderEncoder setVertexBytes:&_viewportSize
                           length:sizeof(_viewportSize)
                          atIndex:VertexInputIndex6Viewport];
    
    // Encode the draw commands for the colored quad.
    {
        const Vertex6 quadVertices[] =
        {
            //         Positions,                    Colors
            { {                0,               0 }, { 1, 0, 0, 1 } },
            { {  _viewportSize.x,               0 }, { 0, 1, 0, 1 } },
            { {  _viewportSize.x, _viewportSize.y }, { 0, 0, 1, 1 } },

            { {  _viewportSize.x, _viewportSize.y }, { 0, 0, 1, 1 } },
            { {                0, _viewportSize.y }, { 1, 1, 1, 1 } },
            { {                0,               0 }, { 1, 0, 0, 1 } },
        };

        [renderEncoder setVertexBytes:quadVertices
                               length:sizeof(quadVertices)
                              atIndex:VertexInputIndex6Vertices];

        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:6];
    }
    
    // Set up the state and encode the draw command.
    if (_drawOutline)
    {
        const float x = _outlineRect.origin.x;
        const float y = _outlineRect.origin.y;
        const float w = _outlineRect.size.width;
        const float h = _outlineRect.size.height;
        const Vertex6 outlineVertices[] =
        {
            // Positions,     Colors (all white)
            { {   x,   y },  { 1, 1, 1, 1 } }, // Lower-left corner.
            { {   x, y+h },  { 1, 1, 1, 1 } }, // Upper-left corner.
            { { x+w, y+h },  { 1, 1, 1, 1 } }, // Upper-right corner.
            { { x+w,   y },  { 1, 1, 1, 1 } }, // Lower-right corner.
            { {   x,   y },  { 1, 1, 1, 1 } }, // Lower-left corner (to complete the line strip).
        };

        [renderEncoder setVertexBytes:outlineVertices
                               length:sizeof(outlineVertices)
                              atIndex:VertexInputIndex6Vertices];

        [renderEncoder drawPrimitives:MTLPrimitiveTypeLineStrip
                          vertexStart:0
                          vertexCount:5];
    }
    
    /**
     Declares that all command generation from the encoder is completed.
     
     After endEncoding is called, the command encoder has no further use. You cannot encode any other commands with this encoder.
     */
    [renderEncoder endEncoding];
}

// MARK: - Render the Pixel Data
/**
 When the user selects a rectangle in the view, the view controller calls the renderAndReadPixelsFromView:withRegion method to render the drawable’s contents and copy them to a Metal buffer.
 */
// Set this to print the pixels obtained by reading the texture.
#define PRINT_PIXELS_READ 0

- (nonnull TGAImage *)renderAndReadPixelsFromView:(nonnull MTKView*)mtkView
                                       withRegion:(CGRect)region {
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    NSLog(@"commandBuffer2 = %@", commandBuffer);
    
    // Encode a render pass to render the image to the drawable texture.
    NSLog(@"=====before renderAndReadPixelsFromView=====");
    [self drawScene:mtkView withCommandBuffer:commandBuffer];
    NSLog(@"=====after renderAndReadPixelsFromView=====");
    _drewSceneForReadThisFrame = YES;
    
    id<MTLTexture> readTexture = mtkView.currentDrawable.texture;

    MTLOrigin readOrigin = MTLOriginMake(region.origin.x, region.origin.y, 0);
    MTLSize readSize = MTLSizeMake(region.size.width, region.size.height, 1);
    
    /**
     After encoding the render pass, it calls another method to encode commands to copy a section of the rendered texture.
     The sample encodes the commands to copy the pixel data before presenting the drawable texture because the system discards the texture’s contents after presenting it.
     */
    const id<MTLBuffer> pixelBuffer = [self readPixelsWithCommandBuffer:commandBuffer
                                                            fromTexture:readTexture
                                                               atOrigin:readOrigin
                                                               withSize:readSize];
    
    // MARK: - Read the Pixels From the Buffer
    /**
     The app calls the buffer’s contents() method to get a pointer to the pixel data.
     
     The sample copies the buffer’s data into an NSData object and passes it to another method to initialize an TGAImage object.
     
     The renderer returns this image object to the view controller for further processing.
     The view controller’s behavior varies depending on the operating system.
     In MacOS, the sample writes the image to the file ~/Desktop/ReadPixelsImage.tga, while in iOS, the sample adds the image to the Photos library.
     */
    PixelBGRA8Unorm *pixels = (PixelBGRA8Unorm *)pixelBuffer.contents;
    
#if PRINT_PIXELS_READ
    // Process the pixel data.
    printf("Pixels read: wh[%d %d] at xy[%d %d].\n",
        (int)readSize.width, (int)readSize.height,
        (int)readOrigin.x,   (int)readOrigin.y);

    PixelBGRA8Unorm *row = pixels;

    for (int yy = 0;  yy < readSize.height;  yy++)
    {
        for (int xx = 0;  xx < MIN(5, readSize.width);  xx++)
        {
            unsigned int pixel = *(unsigned int *)&row[xx];
            printf("[%4d=x, %4d=y] x%8X\n", (int)readOrigin.x + xx, (int)readOrigin.y + yy, pixel);
        }
        printf("\n");
        row += readSize.width;  // Advance to the next row.
    }
#endif
    
    /**
     Create an `NSData` object and initialize it with the pixel data.
     Use the CPU to copy the pixel data from the `pixelBuffer.contents` pointer to `data`.
     */
    NSData *data = [[NSData alloc] initWithBytes:pixels length:pixelBuffer.length];
    
    // Create a new image from the pixel data.
    TGAImage *image = [[TGAImage alloc] initWithBGRA8UnormData:data
                                                         width:readSize.width
                                                        height:readSize.height];

    return image;
}

// MARK: - Copy Pixel Data to a Buffer
/**
 The renderer’s readPixelsWithCommandBuffer:fromTexture:atOrigin:withSize: method encodes the commands to copy the texture.
 Because the sample passes the same command buffer into this method, Metal encodes these new commands after the render pass.
 Metal automatically manages the dependencies on the destination texture, and ensures that rendering completes before copying the texture data.
 
 First, the method allocates a Metal buffer to hold the pixel data.
 It calculates the size of the buffer by multiplying the size of one pixel in bytes by the region’s width and height.
 Similarly, the code calculates the number of bytes per row, which the code needs later when copying the data.
 The sample doesn’t add any padding at the end of rows.
 Then, it calls the Metal device object to create the new Metal buffer, specifying a shared storage mode so that the app can read the buffer’s contents afterwards.
 
 Next, the method creates a MTLBlitCommandEncoder, which provides commands that copy data between Metal resources, fill resources with data, and perform other similar resource-related tasks that don’t directly involve computation or rendering.
 The sample encodes a blit command to copy the texture data to the beginning of the new buffer. It then ends the blit pass.
 
 Finally, it commits the command buffer and calls waitUntilCompleted to immediately wait for the GPU to finish executing the rendering and blit commands.
 After this call returns control to the method, the buffer contains the requested pixel data.
 In a real-time app, synchronizing commands unnecessarily reduces parallelism between the CPU and GPU; this sample synchronizes in this way to simplify the code.
 */
- (id<MTLBuffer>)readPixelsWithCommandBuffer:(id<MTLCommandBuffer>)commandBuffer
                                 fromTexture:(id<MTLTexture>)texture
                                    atOrigin:(MTLOrigin)origin
                                    withSize:(MTLSize)size {
    MTLPixelFormat pixelFormat = texture.pixelFormat;
    NSLog(@"pixelFormat = %lu", pixelFormat);
    switch (pixelFormat)
    {
        case MTLPixelFormatBGRA8Unorm:
        case MTLPixelFormatR32Uint:
            break;
        default:
            NSAssert(0, @"Unsupported pixel format: 0x%X.", (uint32_t)pixelFormat);
    }
    
    /**
     Check for attempts to read pixels outside the texture.
     In this sample, the calling code validates the region, so just assert.
     */
    NSAssert(origin.x >= 0, @"Reading outside the left texture bounds.");
    NSAssert(origin.y >= 0, @"Reading outside the top texture bounds.");
    NSAssert((origin.x + size.width)  < texture.width,  @"Reading outside the right texture bounds.");
    NSAssert((origin.y + size.height) < texture.height, @"Reading outside the bottom texture bounds.");
    NSAssert(!((size.width == 0) || (size.height == 0)), @"Reading zero-sized area: %dx%d.", (uint32_t)size.width, (uint32_t)size.height);
    
    NSUInteger bytesPerPixel = sizeofPixelFormat(texture.pixelFormat);
    NSUInteger bytesPerRow   = size.width * bytesPerPixel;
    NSUInteger bytesPerImage = size.height * bytesPerRow;
    
    _readBuffer = [texture.device newBufferWithLength:bytesPerImage options:MTLResourceStorageModeShared];
    NSAssert(_readBuffer, @"Failed to create buffer for %zu bytes.", bytesPerImage);
    
    // Copy the pixel data of the selected region to a Metal buffer with a shared storage mode, which makes the buffer accessible to the CPU.
    id <MTLBlitCommandEncoder> blitEncoder = [commandBuffer blitCommandEncoder];
    [blitEncoder copyFromTexture:texture
                     sourceSlice:0
                     sourceLevel:0
                    sourceOrigin:origin
                      sourceSize:size
                        toBuffer:_readBuffer
               destinationOffset:0
          destinationBytesPerRow:bytesPerRow
        destinationBytesPerImage:bytesPerImage];
    
    [blitEncoder endEncoding];

    [commandBuffer commit];
    // The app must wait for the GPU to complete the blit pass before it can read data from _readBuffer.
    [commandBuffer waitUntilCompleted];
    
    /**
     Calling waitUntilCompleted blocks the CPU thread until the blit operation completes on the GPU.
     This is generally undesirable as apps should maximize parallelization between CPU and GPU execution.
     Instead of blocking here, you could process the pixels in a completion handler using: [commandBuffer addCompletedHandler:...];
     */
    
    NSLog(@"=====after waitUntilCompleted=====");
    
    return _readBuffer;
}

// The sample only supports the `MTLPixelFormatBGRA8Unorm` and `MTLPixelFormatR32Uint` formats.
static inline uint32_t sizeofPixelFormat(NSUInteger format)
{
    return ((format) == MTLPixelFormatBGRA8Unorm ? 4 : (format) == MTLPixelFormatR32Uint ? 4 : 0);
}

@end
