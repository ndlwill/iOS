//
//  EncodingIndirectCommandBuffersOnGPUViewController.m
//  TestMetal
//
//  Created by youdun on 2023/9/22.
//

#import "EncodingIndirectCommandBuffersOnGPUViewController.h"
#import "Renderer12.h"

// MARK: - Encoding Indirect Command Buffers on the GPU
/**
 ###
 Run the iOS scheme on a physical device because Metal isn’t supported in the simulator.
 ###
 
 Maximize CPU to GPU parallelization by generating render commands on the GPU.
 
 This sample app demonstrates how to use indirect command buffers (ICB) to issue rendering instructions from the GPU.
 When you have a rendering algorithm that runs in a compute kernel, use ICBs to generate draw calls based on your algorithm’s results.
 The sample app uses a compute kernel to remove invisible objects submitted for rendering, and generates draw commands only for the objects currently visible in the scene.
 
 Without ICBs, you couldn’t submit rendering commands on the GPU.
 Instead, the CPU would wait for your compute kernel’s results before generating the render commands.
 Then, the GPU would wait for the rendering commands to make it across the CPU to GPU bridge, which amounts to a round trip slow path
 
 The sample code project, Encoding Indirect Command Buffers on the CPU introduces ICBs by creating a single ICB to reuse its commands every frame.
 While the former sample saved expensive command-encoding time by reusing commands, this sample uses ICBs to effect a GPU-driven rendering pipeline.
 
 The techniques shown by this sample include issuing draw calls from the GPU, and the process of executing a select set of draws.
 
 The sample uses MTLDebugComputeCommandEncoder dispatchThreads:threadsPerThreadgroup: which is supported by GPUs of family greater than or equal to:
 MTLFeatureSet_iOS_GPUFamily4_v2
 MTLFeatureSet_macOS_GPUFamily2_v1
 */
@interface EncodingIndirectCommandBuffersOnGPUViewController ()

@end

@implementation EncodingIndirectCommandBuffersOnGPUViewController
{
    MTKView *_mtkView;
    Renderer12 *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mtkView = (MTKView *)self.view;
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    _mtkView.device = device;
    NSAssert(_mtkView.device, @"Metal is not supported on this device");
    
    BOOL supportICB = NO;
#if TARGET_OS_IOS
    supportICB = [_mtkView.device supportsFeatureSet:MTLFeatureSet_iOS_GPUFamily4_v2];
#else
    supportICB = [_mtkView.device supportsFeatureSet:MTLFeatureSet_macOS_GPUFamily2_v1];
#endif
    NSAssert(supportICB, @"Sample requires macOS_GPUFamily2_v1 or iOS_GPUFamily3_v4 for Indirect Command Buffers");
    
    _renderer = [[Renderer12 alloc] initWithMetalKitView:_mtkView];
    NSAssert(_renderer, @"Renderer failed initialization");
    
    [_renderer mtkView:_mtkView drawableSizeWillChange:_mtkView.drawableSize];

    _mtkView.delegate = _renderer;
}

@end
