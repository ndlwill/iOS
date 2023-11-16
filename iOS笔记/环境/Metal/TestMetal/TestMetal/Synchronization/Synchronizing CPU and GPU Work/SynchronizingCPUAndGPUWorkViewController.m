//
//  SynchronizingCPUAndGPUWorkViewController.m
//  TestMetal
//
//  Created by youdun on 2023/9/12.
//

#import "SynchronizingCPUAndGPUWorkViewController.h"
#import "Renderer9.h"

// MARK: - Synchronizing CPU and GPU Work
/**
 Avoid stalls between CPU and GPU work by using multiple instances of a resource.
 
 In this sample code project, you learn how to manage data dependencies and avoid processor stalls between the CPU and the GPU.

 The project continuously renders triangles along a sine wave.
 In each frame, the sample updates the position of each triangle’s vertices and then renders a new image.
 These dynamic data updates create an illusion of motion, where the triangles appear to move along the sine wave.
 
 The sample stores the triangle vertices in a buffer that’s shared between the CPU and the GPU.
 The CPU writes data to the buffer and the GPU reads it.
 */

// MARK: - Understand the Solution to Data Dependencies and Processor Stalls
/**
 Resource sharing creates a data dependency between the processors; the CPU must finish writing to the resource before the GPU reads it.
 If the GPU reads the resource before the CPU writes to it, the GPU reads undefined resource data.
 If the GPU reads the resource while the CPU is writing to it, the GPU reads incorrect resource data.
 These data dependencies create processor stalls between the CPU and the GPU; each processor must wait for the other to finish its work before beginning its own work.
 
 However, because the CPU and GPU are separate processors, you can make them work simultaneously by using multiple instances of a resource.
 Each frame, you must provide the same arguments to your shaders, but this doesn’t mean you need to reference the same resource object.
 Instead, you create a pool of multiple instances of a resource and use a different one each time you render a frame.
 For example, as shown below, the CPU can write position data to a buffer used for frame n+1, at the same time that the GPU reads position data from a buffer used for frame n.
 By using multiple instances of a buffer, the CPU and the GPU can work continuously and avoid stalls as long as you keep rendering frames.


 */
@interface SynchronizingCPUAndGPUWorkViewController ()

@end

@implementation SynchronizingCPUAndGPUWorkViewController
{
    MTKView *_mtkView;
    Renderer9 *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mtkView = (MTKView *)self.view;
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    _mtkView.device = device;
    NSAssert(_mtkView.device, @"Metal is not supported on this device");
    
    _renderer = [[Renderer9 alloc] initWithMetalKitView:_mtkView];
    NSAssert(_renderer, @"Renderer failed initialization");
    
    [_renderer mtkView:_mtkView drawableSizeWillChange:_mtkView.drawableSize];

    _mtkView.delegate = _renderer;
}

@end
