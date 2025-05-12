//
//  DepthTestingViewController.m
//  TestMetal
//
//  Created by youdun on 2023/8/31.
//

#import "DepthTestingViewController.h"
#import "TestMetal-Swift.h"
#import "Renderer5.h"
@import MetalKit;

// MARK: - Calculating Primitive Visibility Using Depth Testing
/**
 Determine which pixels are visible in a scene by using a depth texture.
 
 When graphics primitives overlap each other, by default, Metal renders them in the order in which you submitted them.
 This method for determining visibility is referred to as the painter’s algorithm because of its similarity to how paint is applied to a surface: The last coat is always the one that you’ll see. However, this method is insufficient to render complex 3D scenes.
 To determine visibility independently from the submission order, you need to add hidden-surface removal.
 Metal provides depth testing as a way to determine visibility for each fragment as it is rendered.
 
 Depth is a measure of the distance from a viewing position to a specific pixel.
 When using depth testing, you add a depth texture (sometimes called a depth buffer) to your render pass.
 A depth texture stores a depth value for each pixel in the same way that a color texture holds a color value.
 You determine how depth values are calculated for each fragment, usually by calculating the depth for each vertex and letting the hardware interpolate these depth values.
 The GPU tests new fragments to see if they are closer to the viewing position than the current value stored in the depth texture.
 If a fragment is farther away, the GPU discards the fragment. Otherwise, it updates the pixel data, including the new depth value.
 Because the GPU tests the depth of all fragments, it renders triangles correctly even when the triangles are partially obscured.
 
 This sample demonstrates depth testing by showing a triangle and letting you change the depth value of each of its vertices.
 The depth of each fragment is interpolated between the depth values you set for the triangle’s vertices, and the app configures the GPU to perform the depth test as described above.
 Each time a render pass is executed, it clears the depth texture’s data, then renders a gray square at the halfway point.
 Finally, the render pass renders the triangle. Only the fragments closer to the viewer than the gray square are visible.

 This sample only demonstrates how to use depth testing.

 */
@interface DepthTestingViewController ()

@property (weak, nonatomic) IBOutlet UISlider *topSlider;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UISlider *leftSlider;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UISlider *rightSlider;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation DepthTestingViewController
{
    MTKView *_mtkView;
    Renderer5 *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mtkView = (MTKView *)self.view;
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    _mtkView.device = device;
    NSAssert(_mtkView.device, @"Metal is not supported on this device");
    
    _renderer = [[Renderer5 alloc] initWithMetalKitView:_mtkView];
    NSAssert(_renderer, @"Renderer failed initialization");

    _mtkView.delegate = _renderer;
    
    _renderer.topVertexDepth = _topSlider.value;
    _topLabel.text = [NSString stringWithFormat:@"%.2f", _renderer.topVertexDepth];
    
    _renderer.rightVertexDepth = _rightSlider.value;
    _rightLabel.text = [NSString stringWithFormat:@"%.2f", _renderer.rightVertexDepth];
    
    _renderer.leftVertexDepth = _leftSlider.value;
    _leftLabel.text = [NSString stringWithFormat:@"%.2f", _renderer.leftVertexDepth];
}

- (IBAction)setTopVertexDepth:(UISlider *)slider {
    _renderer.topVertexDepth = slider.value;
    _topLabel.text =  [NSString stringWithFormat:@"%.2f", _renderer.topVertexDepth];
}

- (IBAction)setLeftVertexDepth:(UISlider *)slider {
    _renderer.leftVertexDepth = slider.value;
    _leftLabel.text =  [NSString stringWithFormat:@"%.2f", _renderer.leftVertexDepth];
}

- (IBAction)setRightVertexDepth:(UISlider *)slider {
    _renderer.rightVertexDepth = slider.value;
    _rightLabel.text =  [NSString stringWithFormat:@"%.2f", _renderer.rightVertexDepth];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*
    AppDelegate *delegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    delegate.interfaceOrientationMask = UIInterfaceOrientationMaskLandscape;
    if (@available(iOS 16, *)) {
        
    } else {
        
    }
     */
}

/*
- (BOOL)shouldAutorotate {
    NSLog(@"shouldAutorotate");
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    NSLog(@"supportedInterfaceOrientations");
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    NSLog(@"preferredInterfaceOrientationForPresentation");
    return UIInterfaceOrientationLandscapeRight;
}
 */

@end
