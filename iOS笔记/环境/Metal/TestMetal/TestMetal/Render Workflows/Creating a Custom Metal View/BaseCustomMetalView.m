//
//  BaseCustomMetalView.m
//  TestMetal
//
//  Created by youdun on 2023/9/21.
//

#import "BaseCustomMetalView.h"

@implementation BaseCustomMetalView

// MARK: - Configure the View With a Metal Layer
/**
 For Metal to render to the view, the view must be backed by a CAMetalLayer.

 All views in UIKit are layer backed. To indicate the type of layer backing, the view implements the layerClass class method.
 To indicate that your view should be backed by a CAMetalLayer, you must return the CAMetalLayer class type.
 */
+ (Class)layerClass {
    return [CAMetalLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initCommon];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initCommon];
    }
    return self;
}

- (void)initCommon {
    _metalLayer = (CAMetalLayer *)self.layer;
    self.layer.delegate = self;
}

#pragma mark - Render Loop Control
#if ANIMATION_RENDERING

- (void)stopRenderLoop
{
    // Subclasses need to implement this method.
}

- (void)dealloc
{
    [self stopRenderLoop];
    NSLog(@"BaseCustomMetalView dealloc");
}

#else
// MARK: - Override methods needed to handle event-based rendering

- (void)displayLayer:(CALayer *)layer
{
    [self renderOnEvent];
}

- (void)drawLayer:(CALayer *)layer
        inContext:(CGContextRef)ctx
{
    [self renderOnEvent];
}

- (void)drawRect:(CGRect)rect
{
    [self renderOnEvent];
}

- (void)renderOnEvent
{
#if RENDER_ON_MAIN_THREAD
    [self render];
#else
    // Dispatch rendering on a concurrent queue
    dispatch_queue_t globalQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_async(globalQueue, ^(){
        [self render];
    });
#endif
}

#endif

#pragma mark - Resizing

#if AUTOMATICALLY_RESIZE

- (void)resizeDrawable:(CGFloat)scaleFactor
{
    CGSize newSize = self.bounds.size;
    newSize.width *= scaleFactor;
    newSize.height *= scaleFactor;

    if (newSize.width <= 0 || newSize.width <= 0)
    {
        return;
    }

#if RENDER_ON_MAIN_THREAD

    // _metalLayer.drawableSize: This property controls the pixel dimensions of the returned drawable objects.
    if (newSize.width == _metalLayer.drawableSize.width &&
        newSize.height == _metalLayer.drawableSize.height)
    {
        return;
    }

    _metalLayer.drawableSize = newSize;

    [_delegate drawableResize:newSize];
    
#else
    @synchronized(_metalLayer)
    {
        if (newSize.width == _metalLayer.drawableSize.width &&
            newSize.height == _metalLayer.drawableSize.height)
        {
            return;
        }

        _metalLayer.drawableSize = newSize;

        [_delegate drawableResize:newSize];
    }
#endif
}

#endif


#pragma mark - Drawing
- (void)render
{
#if RENDER_ON_MAIN_THREAD
    [_delegate renderToMetalLayer:_metalLayer];
#else
    /**
     Must synchronize if rendering on background thread to ensure resize operations from the main thread are complete before rendering which depends on the size occurs.
     */
    @synchronized(_metalLayer)
    {
        [_delegate renderToMetalLayer:_metalLayer];
    }
#endif
}

@end
