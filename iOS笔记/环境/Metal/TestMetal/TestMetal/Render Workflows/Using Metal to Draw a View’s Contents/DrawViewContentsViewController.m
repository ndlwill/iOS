//
//  DrawViewContentsViewController.m
//  TestMetal
//
//  Created by youdun on 2023/8/24.
//

#import "DrawViewContentsViewController.h"

#import "Renderer.h"
/**
 MetalKit 是在 Metal 之上构建的一个高级框架，为开发者提供了更高层次的抽象和便利性
 它简化了许多常见的图形编程任务，同时仍然保留了 Metal 的性能优势。
 
 MetalKit 的目标是帮助开发者更轻松地使用 Metal 进行图形编程，而无需处理太多底层细节。
 */
@import MetalKit;

@interface DrawViewContentsViewController ()

@end

// MARK: - Using Metal to Draw a View’s Contents
/**
 Create a MetalKit view and a render pass to draw the view’s contents.
 
 You’ll use the MetalKit framework to create a view that uses Metal to draw the contents of the view.
 Then, you’ll encode commands for a render pass that erases the view to a background color.
 */
@implementation DrawViewContentsViewController
{
    MTKView *_mtkView;
    Renderer *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.Prepare a MetalKit View to Draw
    _mtkView = (MTKView *)self.view;
//    _mtkView.paused = NO;
    // it only draws when the contents need to be updated
    _mtkView.enableSetNeedsDisplay = YES;
    // first step is to set the view’s device property to an existing MTLDevice.
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    _mtkView.device = device;
    _mtkView.clearColor = MTLClearColorMake(0.0, 0.5, 1.0, 1.0);
    
    _renderer = [[Renderer alloc] initWithDevice:device];
    if(!_renderer) {
        NSLog(@"Renderer initialization failed");
        return;
    }
    // 2.Delegate Drawing Responsibilities
    /**
     MTKView relies on your app to issue commands to Metal to produce visual content.
     */
    _mtkView.delegate = _renderer;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"===width = %lf height = %lf", self.view.bounds.size.width, self.view.bounds.size.height);
    NSLog(@"width = %lf height = %lf", _mtkView.bounds.size.width, _mtkView.bounds.size.height);
}

@end
