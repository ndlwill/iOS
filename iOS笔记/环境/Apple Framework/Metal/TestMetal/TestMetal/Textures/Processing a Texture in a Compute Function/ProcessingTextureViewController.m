//
//  ProcessingTextureViewController.m
//  TestMetal
//
//  Created by youdun on 2023/8/28.
//

#import "ProcessingTextureViewController.h"
#import "Renderer4.h"

// MARK: - Processing a Texture in a Compute Function
/**
 Perform parallel calculations on structured data by placing the data in textures.
 
 This sample processes and displays image data using Metal textures to manage the data.
 The sample takes advantage of Metal’s unified support for compute and graphics processing, first converting a color image to grayscale using a compute pipeline, and then rendering the resulting texture to the screen using a render pipeline.
 You’ll learn how to read and write textures in a compute function and how to determine the work each thread performs.
 */
@interface ProcessingTextureViewController ()

@end

@implementation ProcessingTextureViewController
{
    MTKView *_mtkView;
    Renderer4 *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _mtkView = (MTKView *)self.view;
    
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    _mtkView.device = device;
    NSAssert(_mtkView.device, @"Metal is not supported on this device");
    
    _renderer = [[Renderer4 alloc] initWithMetalKitView:_mtkView];
    NSAssert(_renderer, @"Renderer failed initialization");

    _mtkView.delegate = _renderer;
}

@end
