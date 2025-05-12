//
//  CustomizingRenderPassSetupViewController.m
//  TestMetal
//
//  Created by youdun on 2023/8/28.
//

#import "CustomizingRenderPassSetupViewController.h"
#import "Renderer3.h"

// MARK: - Customizing Render Pass Setup
/**
 Render into an offscreen texture by creating a custom render pass.
 
 A render pass is a sequence of rendering commands that draw into a set of textures.
 This sample executes a pair of render passes to render a view’s contents.
 For the first pass, the sample creates a custom render pass to render an image into a texture.
 This pass is an offscreen render pass, because the sample renders to a normal texture, rather than one created by the display subsystem.
 The second render pass uses a render pass descriptor, provided by the MTKView object, to render and display the final image.
 The sample uses the texture from the offscreen render pass as source data for the drawing command in the second render pass.
 
 Offscreen render passes are fundamental building blocks for larger or more complicated renderers.
 For example, many lighting and shadow algorithms require an offscreen render pass to render shadow information and a second pass to calculate the final scene lighting. Offscreen render passes are also useful when performing batch processing of data that doesn’t need to be displayed onscreen.
 */
@interface CustomizingRenderPassSetupViewController ()

@end

@implementation CustomizingRenderPassSetupViewController
{
    MTKView *_mtkView;
    Renderer3 *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mtkView = (MTKView *)self.view;
    
    // _mtkView.width = 390.000000 _mtkView.height = 844.000000
    NSLog(@"_mtkView.width = %lf _mtkView.height = %lf", _mtkView.frame.size.width, _mtkView.frame.size.height);
    NSLog(@"_mtkView.colorPixelFormat = %lu", _mtkView.colorPixelFormat);// 80
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    _mtkView.device = device;
    NSAssert(_mtkView.device, @"Metal is not supported on this device");
    
    _renderer = [[Renderer3 alloc] initWithMetalKitView:_mtkView];
    NSAssert(_renderer, @"Renderer failed initialization");

    _mtkView.delegate = _renderer;
}

@end
