//
//  UsingArgumentBuffersWithResourceHeapsViewController.m
//  TestMetal
//
//  Created by youdun on 2023/9/21.
//

#import "UsingArgumentBuffersWithResourceHeapsViewController.h"
#import "Renderer11.h"

// MARK: - Using Argument Buffers with Resource Heaps
/**
 Reduce CPU overhead by using arrays inside argument buffers and combining them with resource heaps.
 
 In the ##Managing groups of resources with argument buffers## sample, you learned how to specify, encode, set, and access resources in an argument buffer.
 
 In this sample, you’ll learn how to combine argument buffers with arrays of resources and resource heaps.
 In particular, you’ll learn how to define an argument buffer structure that contains arrays and how to allocate and use resources from a heap.
 The sample renders a static quad that uses multiple resources encoded into an argument buffer.
 
 
 */
@interface UsingArgumentBuffersWithResourceHeapsViewController ()

@end

@implementation UsingArgumentBuffersWithResourceHeapsViewController
{
    MTKView *_mtkView;
    Renderer11 *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    _mtkView = (MTKView *)self.view;
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    _mtkView.device = device;
    NSAssert(_mtkView.device, @"Metal is not supported on this device");

    _renderer = [[Renderer11 alloc] initWithMetalKitView:_mtkView];
    NSAssert(_renderer, @"Renderer failed initialization");
    
    [_renderer mtkView:_mtkView drawableSizeWillChange:_mtkView.drawableSize];

    _mtkView.delegate = _renderer;
}


@end
