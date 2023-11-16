//
//  ManagingGroupsOfResourcesWithArgumentBuffersViewController.m
//  TestMetal
//
//  Created by youdun on 2023/9/7.
//


// MARK: - Managing groups of resources with argument buffers
/**
 Create argument buffers to organize related resources.
 
 An argument buffer represents a group of resources that you can collectively assign as an argument to a graphics or compute function.
 You use argument buffers to reduce CPU overhead, simplify resource management, and implement GPU-driven pipelines.

 This sample code project shows how to specify, encode, set, and access resources in an argument buffer.
 In particular, you can learn about the advantages of managing groups of resources in an argument buffer instead of individual resources.
 The sample app renders a static quad using a texture, sampler, buffer, and constant that the renderer encodes into an argument buffer.

 For each, it specifies targets for a Metal 2 and a Metal 3 version of the app.
 */

// MARK: - Reduce CPU overhead
/**
 Metal commands are efficient, and incur minimal CPU overhead when apps access the GPU.
 However, each command does incur some overhead, so the sample app uses the following strategies to further reduce that amount:
 Perform more GPU work with fewer CPU commands.
 Avoid repeating expensive CPU commands.
 
 Metal’s argument buffer feature reduces the number and performance cost of CPU commands in the sample app’s critical path, such as in the render loop.
 An argument buffer groups and encodes multiple resources within a single buffer instead of encoding each resource individually.
 By using argument buffers, the sample shifts a significant amount of CPU overhead from its critical path to its initial setup.
 */

// MARK: - Pack resources into argument buffersin
/**
 Metal apps, particularly games, typically contain multiple 3D objects, each associated with a set of resources, such as textures, samplers, buffers, and constants.
 To render each object, the Metal apps encode commands that set these resources as arguments to a graphics function before issuing a draw call.
 
 Metal apps set individual resources as arguments by calling MTLRenderCommandEncoder methods, such as setVertexBuffer:offset:atIndex: or setFragmentTexture:atIndex: for each resource.
 
 Commands that set individual resources can become numerous and expensive, especially for large apps or games.
 Instead, the sample app groups related resources into an argument buffer and then sets that entire buffer as a single argument to a graphics function.
 This approach greatly reduces CPU overhead and still provides individual GPU access to the resources.
 
 MTLBuffer objects represent the argument buffers in the sample code.
 The sample code sets the objects as arguments by calling MTLRenderCommandEncoder methods, such as setVertexBuffer:offset:atIndex: or setFragmentBuffer:offset:atIndex: for each argument buffer.
 
 Note
 To access individual resources in an argument buffer, the sample code calls the useResource:usage: method for each resource that it uses.
 */
#import "ManagingGroupsOfResourcesWithArgumentBuffersViewController.h"
#import "Renderer8.h"

@interface ManagingGroupsOfResourcesWithArgumentBuffersViewController ()

@end

@implementation ManagingGroupsOfResourcesWithArgumentBuffersViewController
{
    MTKView *_mtkView;
    Renderer8 *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mtkView = (MTKView *)self.view;
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    _mtkView.device = device;
    NSAssert(_mtkView.device, @"Metal is not supported on this device");

    _renderer = [[Renderer8 alloc] initWithMetalKitView:_mtkView];
    NSAssert(_renderer, @"Renderer failed initialization");
    
    [_renderer mtkView:_mtkView drawableSizeWillChange:_mtkView.drawableSize];

    _mtkView.delegate = _renderer;
}

@end
