//
//  EncodingIndirectCommandBuffersOnCPUViewController.m
//  TestMetal
//
//  Created by youdun on 2023/9/4.
//

#if defined(TARGET_IOS)

#endif

#if TARGET_OS_SIMULATOR

#endif

#import "EncodingIndirectCommandBuffersOnCPUViewController.h"
#import <TargetConditionals.h>
#import "Renderer7.h"

// MARK: - Encoding Indirect Command Buffers on the CPU
/**
 Reduce CPU overhead and simplify your command execution by reusing commands.
 
 This sample does not have simulator support and must be built for a device.
 
 This sample app provides an introduction to indirect command buffers (ICB), which enable you to store repeated commands for later use.
 Because Metal discards a normal command buffer and its commands after Metal executes them, use ICBs to save expensive allocation, deallocation, and encoding time for your app’s common instructions. Additionally, you benefit when using ICBs with:
 A reduction in rendering tasks because you execute an ICB with a single call.
 By creating ICBs at initialization, it moves expensive command management out of your app’s critical path at rendering or compute-time.

 An example of where ICBs are effective is with a game’s head-up display (HUD), because:
 You render HUDs every frame.
 The appearance of the HUD is usually static across frames.
 
 ICBs are also useful to render static objects in typical 3D scenes.
 Because encoded commands typically result in lightweight data structures, ICBs are suitable for saving complex draws, too.
 
 This sample demonstrates how to set up an ICB to repeatedly render a series of shapes.
 While it’s possible to gain even more instruction-parallelism by encoding the ICB on the GPU, this sample encodes an ICB on the CPU for simplicity.
 
 This sample contains macOS and iOS targets.
 Run the iOS scheme on a physical device because Metal isn’t supported in the simulator.
 ICBs are supported by GPUs of family greater than or equal to:
 MTLFeatureSet_iOS_GPUFamily3_v4
 MTLFeatureSet_macOS_GPUFamily2_v1
 
 ###
 You check the GPU that you choose at runtime if it supports ICBs using MTLDevice’s supportsFeatureSet(_:):
 ###
 
 #if TARGET_IOS
     supportICB = [_view.device supportsFeatureSet:MTLFeatureSet_iOS_GPUFamily3_v4];
 #else
     supportICB = [_view.device supportsFeatureSet:MTLFeatureSet_macOS_GPUFamily2_v1];
 #endif
 
 This sample calls ‘supportsFeatureSet:’ for this purpose within its view controller’s viewDidLoad: callback.
 */

// MARK: - Individual Commands Versus Indirect Command Buffers
/**
 Metal apps, particularly games, typically contain multiple render commands, each associated with a set of render states, buffers, and draw calls.
 To execute these commands for a render pass, apps first encode them into a render command encoder within a command buffer.
 
 You encode individual commands into a render command encoder by calling MTLRenderCommandEncoder methods such as setVertexBuffer:offset:atIndex: or drawPrimitives:vertexStart:vertexCount:vertexCount:instanceCount:baseInstance:.
 
 Recreating draws that were equivalent to ones you did in a previous queue can be tedious from a coding perspective and non-performant at runtime.
 Instead, move your repeated draws and their data buffers into an MTLIndirectCommandBuffer object using MTLIndirectRenderCommand, thereby filling the ICB with commands.
 When you’re ready to use the ICB, encode individual executions of it by calling MTLRenderCommandEnoder’s executeCommandsInBuffer:withRange:.
 
 Note
 To access individual buffers referenced by an indirect command buffer, you must call the useResource:usage: method for each buffer that you want to use.
 For more information, see the “Execute an Indirect Command Buffer” section.
 */

// MARK: - Define Render Commands and Inherited Render State
/**
 For the indirect command buffer, _indirectCommandBuffer, the sample defines render commands that:
 Set a vertex buffer using unique vertex data for each mesh
 Set another vertex buffer using common transformation data for all meshes
 Set another vertex buffer containing an array of parameters for each mesh
 Draw the mesh’s triangles
 
 The sample encodes these commands differently for the CPU or the GPU.
 However, these commands are still encoded into both versions of the indirect command buffer.
 */
@interface EncodingIndirectCommandBuffersOnCPUViewController ()

@end

@implementation EncodingIndirectCommandBuffersOnCPUViewController
{
    MTKView *_mtkView;
    Renderer7 *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mtkView = (MTKView *)self.view;
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    _mtkView.device = device;
    NSAssert(_mtkView.device, @"Metal is not supported on this device");
    
    /*
    BOOL supportICB = NO;
#if TARGET_IOS
    supportICB = [_mtkView.device supportsFeatureSet:MTLFeatureSet_iOS_GPUFamily3_v4];
#else
//    supportICB = [_mtkView.device supportsFeatureSet:MTLFeatureSet_macOS_GPUFamily2_v1];
#endif
    NSAssert(supportICB, @"Sample requires macOS_GPUFamily2_v1 or iOS_GPUFamily3_v4 for Indirect Command Buffers");
     */
    
    _renderer = [[Renderer7 alloc] initWithMetalKitView:_mtkView];
    NSAssert(_renderer, @"Renderer failed initialization");
    
    [_renderer mtkView:_mtkView drawableSizeWillChange:_mtkView.drawableSize];

    _mtkView.delegate = _renderer;
}

@end
