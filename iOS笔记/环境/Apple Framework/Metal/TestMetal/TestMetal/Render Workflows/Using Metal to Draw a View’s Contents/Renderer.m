//
//  Renderer.m
//  TestMetal
//
//  Created by youdun on 2023/8/24.
//

#import "Renderer.h"

//@import simd;
@import MetalKit;

@interface Renderer ()

@end

@implementation Renderer
{
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
}

- (nonnull instancetype)initWithDevice:(nonnull id<MTLDevice>)device {
    self = [super init];
    if (self) {
        _device = device;
        _commandQueue = [_device newCommandQueue];
    }
    return self;
}

/**
 In this method, you create a command buffer, encode commands that tell the GPU what to draw and when to display it onscreen, and enqueue that command buffer to be executed by the GPU.
 This is sometimes referred to as drawing a frame.
 You can think of a frame as all of the work that goes into producing a single image that gets displayed on the screen.
 In an interactive app, like a game, you might draw many frames per second.
 */
- (void)drawInMTKView:(MTKView *)view {
    NSLog(@"%s", __FUNCTION__);
    
    // 3.Create a Render Pass Descriptor
    // The render pass descriptor references the texture into which Metal should draw
    /**
     When you draw, the GPU stores the results into textures, which are blocks of memory that contain image data and are accessible to the GPU.
     In this sample, the MTKView creates all of the textures you need to draw into the view.
     It creates multiple textures so that it can display the contents of one texture while you render into another.
     
     A render pass descriptor describes the set of render targets, and how they should be processed at the start and end of the render pass.
     The view returns a render pass descriptor with a single color attachment that points to one of the view’s textures, and otherwise configures the render pass based on the view’s properties.
     
     By default, this means that at the start of the render pass, the render target is erased to a solid color that matches the view’s clearColor property, and at the end of the render pass, all changes are stored back to the texture.
     
     Because a view’s render pass descriptor might be nil, you should test to make sure the render pass descriptor object is non-nil before creating the render pass.
     */
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor == nil) {
        NSLog(@"renderPassDescriptor == nil");
        return;
    }
    
    // MTLCommandBuffer: A container that stores a sequence of GPU commands that you encode into it.
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    
    // 4.Create a Render Pass
    /**
     You create the render pass by encoding it into the command buffer using a MTLRenderCommandEncoder object.
     
     In this sample, you don’t encode any drawing commands, so the only thing the render pass does is erase the texture. Call the encoder’s endEncoding method to indicate that the pass is complete.
     */
    // Create a render pass and immediately end encoding, causing the drawable to be cleared
    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    [commandEncoder endEncoding];
    
    // 5.Present a Drawable to the Screen
    /**
     ##
     In Metal, textures that can be displayed onscreen are managed by drawable objects, and to display the content, you present the drawable.
     ##
     
     ##
     MTKView automatically creates drawable objects to manage its textures.
     ##
     Read the currentDrawable property to get the drawable that owns the texture that is the render pass’s target.
     The view returns a CAMetalDrawable object, an object connected to Core Animation.
     */
    // Get the drawable that will be presented at the end of the frame
    /**
     The drawable to be used for the current frame.
     currentDrawable is updated at the end -draw (i.e. after the delegate's drawInMTKView method is called)
     */
    id<MTLDrawable> drawable = view.currentDrawable;
    // Request that the drawable texture be presented by the windowing system once drawing is done
    /**
     This method tells Metal that when the command buffer is scheduled for execution, Metal should coordinate with Core Animation to display the texture after rendering completes.
     When Core Animation presents the texture, it becomes the view’s new contents.
     In this sample, this means that the erased texture becomes the new background for the view.
     The change happens alongside any other visual updates that Core Animation makes for onscreen user interface elements.
     */
    [commandBuffer presentDrawable:drawable];
    
    // 6.Commit the Command Buffer
    // Now that you’ve issued all the commands for the frame, commit the command buffer.
    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    NSLog(@"%s width = %lf height = %lf", __FUNCTION__, size.width, size.height);
}

@end
