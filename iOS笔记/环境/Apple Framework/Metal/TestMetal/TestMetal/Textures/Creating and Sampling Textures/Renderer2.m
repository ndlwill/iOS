//
//  Renderer2.m
//  TestMetal
//
//  Created by youdun on 2023/8/28.
//

#import "Renderer2.h"
#import "TGAImage.h"
#import "ShaderTypes2.h"

@implementation Renderer2
{
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    
    id<MTLRenderPipelineState> _pipelineState;
    
    // The Metal texture object
    id<MTLTexture> _texture;
    
    // The Metal buffer that holds the vertex data.
    id<MTLBuffer> _vertices;

    // The number of vertices in the vertex buffer.
    NSUInteger _numVertices;
    
    // The current size of the view, used as an input to the vertex shader.
    vector_uint2 _viewportSize;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
    self = [super init];
    if (self) {
        _device = mtkView.device;
        
        NSURL *imageFileUrl = [[NSBundle mainBundle] URLForResource:@"Image"
                                                      withExtension:@"tga"];
        _texture = [self loadTextureUsingTGAImage:imageFileUrl];
        
        // Set up a simple MTLBuffer with vertices which include texture coordinates
        // In the vertex data, map the quad’s corners to the texture’s corners
        static const CustomVertex2 quadVertices[] =
        {
            // Pixel positions, Texture coordinates
            { {  250,  -250 },  { 1.f, 1.f } },
            { { -250,  -250 },  { 0.f, 1.f } },
            { { -250,   250 },  { 0.f, 0.f } },

            { {  250,  -250 },  { 1.f, 1.f } },
            { { -250,   250 },  { 0.f, 0.f } },
            { {  250,   250 },  { 1.f, 0.f } },
        };
        
        // Create a vertex buffer, and initialize it with the quadVertices array
        _vertices = [_device newBufferWithBytes:quadVertices
                                         length:sizeof(quadVertices)
                                        options:MTLResourceStorageModeShared];
        
        // Calculate the number of vertices by dividing the byte length by the size of each vertex
        _numVertices = sizeof(quadVertices) / sizeof(CustomVertex2);
        
        // MARK: - Create the render pipeline.
        // Load the shaders from the default library
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertex2Shader"];
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"samplingShader"];

        // Set up a descriptor for creating a pipeline state object
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"Texturing Pipeline";
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        MTLPixelFormat pixelFormat = mtkView.colorPixelFormat;
        NSLog(@"mtkView.colorPixelFormat = %lu", pixelFormat);
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = pixelFormat;

        NSError *error = nil;
        _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                 error:&error];

        NSAssert(_pipelineState, @"Failed to create pipeline state: %@", error);
        _commandQueue = [_device newCommandQueue];
    }
    return self;
}

// MARK: - Create a Texture from a Texture Descriptor
/**
 Use a MTLTextureDescriptor object to configure properties like texture dimensions and pixel format for a MTLTexture object.
 Then call the newTextureWithDescriptor: method to create a texture.
 
 Metal creates a MTLTexture object and allocates memory for the texture data.
 This memory is uninitialized when the texture is created, so the next step is to copy your data into the texture.
 */
- (id<MTLTexture>)loadTextureUsingTGAImage:(NSURL *)url {
    TGAImage *image = [[TGAImage alloc] initWithTGAFileFromUrl:url];
    NSAssert(image, @"Failed to create the image from %@", url.absoluteString);

    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
    
    // Indicate that each pixel has a blue, green, red, and alpha channel, where each channel is an 8-bit unsigned normalized value (i.e. 0 maps to 0.0 and 255 maps to 1.0)
    textureDescriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;
    // Set the pixel dimensions of the texture
    textureDescriptor.width = image.width;
    textureDescriptor.height = image.height;
    
    // Create the texture from the device by using the descriptor
    id<MTLTexture> texture = [_device newTextureWithDescriptor:textureDescriptor];
    
    // Calculate the number of bytes per row in the image.
    NSUInteger bytesPerRow = 4 * image.width;
    
    // MARK: - Copy the Image Data into the Texture
    /**
     Metal manages memory for textures and doesn’t provide you direct access to it.
     So you can’t get a pointer to the texture data in memory and copy the pixels yourself.
     Instead, you call methods on a MTLTexture object to copy data from memory you can access into the texture and vice versa.

     In this sample, the TGAImage object allocated memory for the image data, so you’ll tell the texture object to copy this data.

     Use a MTLRegion structure to identify which part of the texture you want to update.
     This sample populates the entire texture with image data; so create a region that covers the entire texture.
     
     Image data is typically organized in rows, and you need to tell Metal the offset between rows in the source image.
     The image loading code creates image data in a tightly packed format, so the data of subsequent pixel rows immediately follows the previous row.
     Calculate the offset between rows to be the exact length (in bytes) of a row — the number of bytes per pixel multiplied by the image width.

     Call the replaceRegion:mipmapLevel:withBytes:bytesPerRow: method on the texture to copy pixel data from the TGAImage object into the texture.
     */
    /**
     MTLRegion:
     Metal has many object types that represent arrays of discrete elements.
     For example, a texture has an array of pixel elements, and a thread grid has an array of computational threads.
     Use MTLRegion instances to describe subsets of these objects.
     
     The origin is the front upper-left corner of the region, and its extents go towards the back lower-right corner.
     Conceptually, when using a MTLRegion instance to describe a subset of an object, treat the object as a 3D array of elements, even if it has fewer dimensions. For a 2D object, set the z coordinate of the origin to 0 and the depth to 1.
     For a 1D object, set the y and z coordinates of the origin to 0 and the height and depth to 1.
     */
    MTLRegion region = {
        {0, 0, 0},                   // MTLOrigin
        {image.width, image.height, 1} // MTLSize
    };
    
    // Copy the bytes from the data object into the texture
    [texture replaceRegion:region
                mipmapLevel:0
                  withBytes:image.data.bytes
                bytesPerRow:bytesPerRow];
    return texture;
}

// MARK: - Map the Texture Onto a Geometric Primitive
/**
 You can’t render a texture on its own; you must map it onto geometric primitives (in this example, a pair of triangles) that are output by the vertex stage and turned into fragments by the rasterizer.
 Each fragment needs to know which part of the texture should be applied to it.
 You define this mapping with texture coordinates: floating-point positions that map locations on a texture image to locations on the geometric surface.
 
 For 2D textures, normalized texture coordinates are values from 0.0 to 1.0 in both x and y directions.
 A value of (0.0, 0.0) specifies the texel at the first byte of the texture data (the top-left corner of the image).
 A value of (1.0, 1.0) specifies the texel at the last byte of the texture data (the bottom-right corner of the image).
 */
- (void)drawInMTKView:(MTKView *)view {
    NSLog(@"%s", __FUNCTION__);
    
    // Create a new command buffer for each render pass to the current drawable
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"CommandBufferLabel";

    // Obtain a renderPassDescriptor generated from the view's drawable textures
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    
    if (renderPassDescriptor != nil) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"RenderEncoderLabel";

        // Set the region of the drawable to draw into.
        // The values for znear and zfar must be between 0.0 and 1.0. Flipping is allowed.
        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewportSize.x, _viewportSize.y, -1.0, 1.0 }];

        [renderEncoder setRenderPipelineState:_pipelineState];

        [renderEncoder setVertexBuffer:_vertices
                                offset:0
                              atIndex:VertexInputIndex2Vertices];

        [renderEncoder setVertexBytes:&_viewportSize
                               length:sizeof(_viewportSize)
                              atIndex:VertexInputIndex2ViewportSize];

        /**
         Set the texture object.
         The TextureIndexBaseColor enum value corresponds to the 'colorMap' argument in the 'samplingShader' function because its texture attribute qualifier also uses TextureIndexBaseColor for its index.
         */
        [renderEncoder setFragmentTexture:_texture
                                  atIndex:TextureIndex2BaseColor];

        // Draw the triangles.
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:_numVertices];

        [renderEncoder endEncoding];

        // Schedule a present once the framebuffer is complete using the current drawable
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    
    // Finalize rendering here & push the command buffer to the GPU
    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    NSLog(@"%s width = %lf height = %lf", __FUNCTION__, size.width, size.height);
    
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

@end
