//
//  ReadingPixelDataFromDrawableTextureViewController.m
//  TestMetal
//
//  Created by youdun on 2023/9/4.
//

@import MetalKit;
#import "ReadingPixelDataFromDrawableTextureViewController.h"
#import "Renderer6.h"
#import "ShaderTypes6.h"
#if TARGET_IOS

#endif

// Include the Photos framework to save images to the user's photo library.
#import <Photos/Photos.h>



// MARK: - Reading Pixel Data from a Drawable Texture
/**
 Access texture data from the CPU by copying it to a buffer.
 
 Metal optimizes textures for fast access by the GPU, but it doesn’t allow you to directly access a texture’s contents from the CPU.
 When your app code needs to change or read a texture’s contents, you use Metal to copy data between textures and CPU-accessible memory — either system memory or a Metal buffer allocated using shared storage.
 This sample configures drawable textures for read access and copies rendered pixel data from those textures to a Metal buffer.
 
 Run the sample, then tap or click on a single point to read the pixel data stored at that point.
 Alternatively, drag out a rectangle to capture pixel data for a region on the screen. The sample converts your selection to a rectangle in the drawable texture’s coordinate system.
 Next, it renders an image to the texture.
 Finally, it copies the pixel data from the selected rectangle into a buffer for the sample to process further.
 */
@interface ReadingPixelDataFromDrawableTextureViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation ReadingPixelDataFromDrawableTextureViewController
{
    MTKView *_mtkView;
    Renderer6 *_renderer;
    CGPoint _readRegionBegin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
#if TARGET_MACOS
    
#else
    _infoLabel.text = @"Touch and optionally drag to read pixels.\n";
#endif
    _infoLabel.hidden = NO;
    
    _mtkView = (MTKView *)self.view;
    
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    _mtkView.device = device;
    NSAssert(_mtkView.device, @"Metal is not supported on this device");
    
    _renderer = [[Renderer6 alloc] initWithMetalKitView:_mtkView];
    NSAssert(_renderer, @"Renderer failed initialization");
    
    // MARK: - 必须调用
    // Initialize the renderer with the view size.
    [_renderer mtkView:_mtkView drawableSizeWillChange:_mtkView.drawableSize];

    _mtkView.delegate = _renderer;
}

#pragma mark - Region Selection and Reading Methods
// MARK: - Determine Which Pixels to Copy
/**
 The AAPLViewController class manages user interaction.
 When a user interacts with a view, AppKit and UIKit send events with positions specified in the view’s coordinate system.
 To determine which pixels to copy from the Metal drawable texture, the app transforms these view coordinates into Metal’s texture coordinate system.
 
 Because of differences in graphics coordinate systems and APIs, the code to convert between view coordinates and texture coordinates varies by platform.
 In macOS, the code calls the pointToBacking: method on the view to convert a position into a pixel location in the backing store, and then applies a coordinate transformation to adjust the origin and the y-axis.
 CGPoint bottomUpPixelPosition = [_view convertPointToBacking:event.locationInWindow];
 CGPoint topDownPixelPosition = CGPointMake(bottomUpPixelPosition.x,
                                            _view.drawableSize.height - bottomUpPixelPosition.y);
 
 
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self beginReadRegion:[self pointToBacking:[touch locationInView:_mtkView]]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self moveReadRegion:[self pointToBacking:[touch locationInView:_mtkView]]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self endReadRegion:[self pointToBacking:[touch locationInView:_mtkView]]];
}

- (void)beginReadRegion:(CGPoint)point
{
    _readRegionBegin = point;
    _renderer.outlineRect = CGRectMake(_readRegionBegin.x, _readRegionBegin.y, 1, 1);
    _renderer.drawOutline = YES;
}

- (void)moveReadRegion:(CGPoint)point
{
    _renderer.outlineRect = validateSelectedRegion(_readRegionBegin, point, _mtkView.drawableSize);
}

- (void)endReadRegion:(CGPoint)point {
    _renderer.drawOutline = NO;
    CGRect readRegion = validateSelectedRegion(_readRegionBegin, point, _mtkView.drawableSize);
    
    NSLog(@"=====endReadRegion=====");
    // Perform read with the selected region.
    TGAImage *image = [_renderer renderAndReadPixelsFromView:_mtkView
                                                   withRegion:readRegion];
    
    // Output pixels to file or Photos library.
    {
        // In iOS, store the read pixels in an image file and save it to the user's photo library.
        NSURL *location;
        
        PHPhotoLibrary *photoLib = [PHPhotoLibrary sharedPhotoLibrary];
        PHAuthorizationStatus status;
        if (@available(iOS 14.0, *)) {
            status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
        } else {
            status = [PHPhotoLibrary authorizationStatus];
        }
        
        if (status == PHAuthorizationStatusNotDetermined) {
            // Request access to the user's photo library. Request access only once and retrieve the user's authorization status afterward.
            dispatch_semaphore_t authorizeSemaphore = dispatch_semaphore_create(0);

            if (@available(iOS 14.0, *)) {
                [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite
                                                           handler:^(PHAuthorizationStatus status) {
                    dispatch_semaphore_signal(authorizeSemaphore);
                }];
            } else {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    dispatch_semaphore_signal(authorizeSemaphore);
                }];
            }

            // Block the thread until the user completes the authorization request and the semaphore value is greater than 0.
            dispatch_semaphore_wait(authorizeSemaphore, DISPATCH_TIME_FOREVER); // Wait until > 0.
        }
        
        NSAssert(status == PHAuthorizationStatusAuthorized,
                 @"You didn't authorize writing to the Photos library. Change status in Settings.\n");
        
        location = [[NSFileManager defaultManager] temporaryDirectory];
        location = [location URLByAppendingPathComponent:@"ReadPixelsImage.tga"];
        [image saveToTGAFileAtLocation:location];
        
        NSError *error;
        [photoLib performChangesAndWait:^{ [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:location]; }
                                  error:&error];
        
        if (error) {
            NSAssert(0, @"Couldn't add image with to Photos library: %@", error);
        } else {
            NSMutableString *labelText =
                [[NSMutableString alloc] initWithFormat:@"%d x %d pixels read at (%d, %d)\n"
                 "Saved image to Photos library",
                 (uint32_t)readRegion.size.width,
                 (uint32_t)readRegion.size.height,
                 (uint32_t)readRegion.origin.x,
                 (uint32_t)readRegion.origin.y];

            _infoLabel.text = labelText;
            _infoLabel.textColor = [UIColor whiteColor];
            _infoLabel.numberOfLines = 0;
        }
    }
    NSLog(@"=====after endReadRegion=====");
}

/**
 Convert raw touch point coordinates to drawable texture pixel coordinates.
 The view coordinates origin is in the upper-left corner of the view.
 Texture coordinates origin is also in the upper-left corner.
 
 pointToBacking 用于将逻辑坐标（通常以点为单位）转换为物理像素坐标（通常以点/像素为单位）。
 
 In iOS, the app reads the view’s contentScaleFactor and applies a scaling transform to the view coordinate.
 iOS views and Metal textures use the same coordinate conventions, so the code doesn’t move the origin or change the y-axis orientation.
 */
- (CGPoint)pointToBacking:(CGPoint)point {
    CGFloat scale = _mtkView.contentScaleFactor;

    CGPoint pixel;

    pixel.x = point.x * scale;
    pixel.y = point.y * scale;

    // Round the pixel values down to put them on a well-defined grid.
    pixel.x = (int64_t)pixel.x;
    pixel.y = (int64_t)pixel.y;

    // Add .5 to move to the center of the pixel.
    pixel.x += 0.5f;
    pixel.y += 0.5f;

    return pixel;
}

CGRect validateSelectedRegion(CGPoint begin, CGPoint end, CGSize drawableSize) {
    CGRect region;

    // Ensure that the end point is within the bounds of the drawable.
    if (end.x < 0) {
        end.x = 0;
    } else if (end.x > drawableSize.width) {
        end.x = drawableSize.width;
    }

    if (end.y < 0) {
        end.y = 0;
    } else if (end.y > drawableSize.height) {
        end.y = drawableSize.height;
    }
    
    // Ensure that the lower-right corner is always larger than the upper-left corner.
    CGPoint lowerRight;
    lowerRight.x = begin.x > end.x ? begin.x : end.x;
    lowerRight.y = begin.y > end.y ? begin.y : end.y;
    
    CGPoint upperLeft;
    upperLeft.x = begin.x < end.x ? begin.x : end.x;
    upperLeft.y = begin.y < end.y ? begin.y : end.y;

    region.origin = upperLeft;
    region.size.width = lowerRight.x - upperLeft.x;
    region.size.height = lowerRight.y - upperLeft.y;
    
    // Ensure that the width and height are at least 1.
    if (region.size.width < 1) {
        region.size.width = 1;
    }

    if (region.size.height < 1) {
        region.size.height = 1;
    }

    return region;
}

@end
