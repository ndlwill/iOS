//
//  CreatingAndSamplingTexturesViewController.m
//  TestMetal
//
//  Created by youdun on 2023/8/28.
//

#import "CreatingAndSamplingTexturesViewController.h"
#import "Renderer2.h"

// MARK: - Creating and Sampling Textures
/**
 Load image data into a texture and apply it to a quadrangle.
 
 You use textures to draw and process images in Metal.
 A texture is a structured collection of texture elements, often called texels or pixels.
 The exact configuration of these texture elements depends on the type of texture.
 This sample uses a texture structured as a 2D array of elements, each of which contains color data, to hold an image.
 The texture is drawn onto geometric primitives through a process called texture mapping.
 The fragment function generates colors for each fragment by sampling the texture.
 
 Textures are managed by MTLTexture objects.
 A MTLTexture object defines the texture’s format, including the size and layout of elements, the number of elements in the texture, and how those elements are organized.
 Once created, a texture’s format and organization never change.
 However, you can change the contents of the texture, either by rendering to it or copying data into it.
 
 The Metal framework doesn’t provide an API to directly load image data from a file to a texture.
 Metal itself only allocates texture resources and provides methods that copy data to and from the texture.
 Metal apps rely on custom code or other frameworks, like MetalKit, Image I/O, UIKit, or AppKit, to handle image files.
 For example, you can use MTKTextureLoader to perform simple texture loading.
 This sample shows how to write a custom texture loader.
 */
@interface CreatingAndSamplingTexturesViewController ()

@end

@implementation CreatingAndSamplingTexturesViewController
{
    MTKView *_mtkView;
    Renderer2 *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mtkView = (MTKView *)self.view;
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    _mtkView.device = device;
    NSAssert(_mtkView.device, @"Metal is not supported on this device");
    
    _renderer = [[Renderer2 alloc] initWithMetalKitView:_mtkView];
    NSAssert(_renderer, @"Renderer failed initialization");

    _mtkView.delegate = _renderer;
}

@end
