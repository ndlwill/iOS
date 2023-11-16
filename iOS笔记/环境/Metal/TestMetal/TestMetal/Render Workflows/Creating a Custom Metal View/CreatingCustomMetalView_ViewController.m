//
//  CreatingCustomMetalView_ViewController.m
//  TestMetal
//
//  Created by youdun on 2023/9/21.
//

#import "CreatingCustomMetalView_ViewController.h"
#import "Renderer10.h"
#import "CustomMetalView.h"

// MARK: - Creating a Custom Metal View
/**
 While MetalKit’s MTKView provides significant functionality, allowing you to quickly get started writing Metal code,
 sometimes you want more control over how your Metal content is rendered.
 This sample app demonstrates how to create a simple Metal view derived directly from an NSView or UIView.
 It uses a CAMetalLayer object to hold the view’s contents.
 */
@interface CreatingCustomMetalView_ViewController () <BaseCustomMetalViewDelegate>

@end

@implementation CreatingCustomMetalView_ViewController
{
    Renderer10 *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();

    CustomMetalView *view = (CustomMetalView *)self.view;

    // metalLayer.device: This property determines which MTLDevice the MTLTexture objects for the drawables will be created from.
    // Set the device for the layer so the layer can create drawable textures that can be rendered to on this device.
    view.metalLayer.device = device;

    // Set this class as the delegate to receive resize and render callbacks.
    view.delegate = self;

    view.metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;

    _renderer = [[Renderer10 alloc] initWithMetalDevice:device
                                    drawablePixelFormat:view.metalLayer.pixelFormat];
}

- (void)drawableResize:(CGSize)size
{
    [_renderer drawableResize:size];
}

- (void)renderToMetalLayer:(nonnull CAMetalLayer *)layer
{
    [_renderer renderToMetalLayer:layer];
}

@end
