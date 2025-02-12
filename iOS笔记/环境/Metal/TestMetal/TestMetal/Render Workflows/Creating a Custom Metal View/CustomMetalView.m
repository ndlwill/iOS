//
//  CustomMetalView.m
//  TestMetal
//
//  Created by youdun on 2023/9/21.
//

#import "CustomMetalView.h"

@implementation CustomMetalView
{
    CADisplayLink *_displayLink;

#if !RENDER_ON_MAIN_THREAD
    // Secondary thread containing the render loop
    NSThread *_renderThread;

    // Flag to indcate rendering should cease on the main thread
    BOOL _continueRunLoop;
#endif
}

// MARK: - overrides
- (void)didMoveToWindow {
    [super didMoveToWindow];
    NSLog(@"CustomMetalView didMoveToWindow");
    
#if ANIMATION_RENDERING
    if(self.window == nil)
    {
        // If moving off of a window destroy the display link.
        [_displayLink invalidate];
        _displayLink = nil;
        return;
    }

    [self setupCADisplayLinkForScreen:self.window.screen];
    
#if RENDER_ON_MAIN_THREAD
    /**
     CADisplayLink callbacks are associated with an 'NSRunLoop'.
     The currentRunLoop is the the main run loop (since 'didMoveToWindow' is always executed from the main thread.
     */
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
#else
    // Protect _continueRunLoop with a `@synchronized` block since it is accessed by the seperate animation thread
    @synchronized(self) {
        // Stop animation loop allowing the loop to complete if it's in progress.
        _continueRunLoop = NO;
    }
    
    _renderThread =  [[NSThread alloc] initWithTarget:self selector:@selector(runThread) object:nil];
    _continueRunLoop = YES;
    [_renderThread start];
#endif
#endif
    
    /**
     Perform any actions which need to know the size and scale of the drawable.
     When UIKit calls didMoveToWindow after the view initialization, this is the first opportunity to notify components of the drawable's size
     */
#if AUTOMATICALLY_RESIZE
    [self resizeDrawable:self.window.screen.nativeScale];
#else
    // Notify delegate of default drawable size when it can be calculated
    CGSize defaultDrawableSize = self.bounds.size;
    defaultDrawableSize.width *= self.layer.contentsScale;
    defaultDrawableSize.height *= self.layer.contentsScale;
    [self.delegate drawableResize:defaultDrawableSize];
#endif
    
}

#pragma mark - Render Loop Control
#if ANIMATION_RENDERING

- (void)setPaused:(BOOL)paused
{
    super.paused = paused;

    _displayLink.paused = paused;
}

// MARK: - Implement a Render Loop
/**
 To animate the view, the sample sets up a display link.
 The display link calls the view at the specified interval, synchronizing updates to the display’s refresh interval.
 The view calls the renderer object to render a new frame of animation.

 CustomMetalView creates a CADisplayLink in the setupCADisplayLinkForScreen method.
 Because you need to know which screen the window is on before creating the display link, you call this method when UIKit calls your view’s didMoveToWindow() method. UIKit calls this method the first time the view is added to a window and when the view is moved to another screen.
 The code below stops the render loop and initializes a new display link.
 */
- (void)setupCADisplayLinkForScreen:(UIScreen *)screen
{
    [self stopRenderLoop];

    _displayLink = [screen displayLinkWithTarget:self selector:@selector(render)];
    _displayLink.paused = self.paused;
    _displayLink.preferredFramesPerSecond = 60;
}

- (void)stopRenderLoop
{
    [_displayLink invalidate];
}

// MARK: - NSThread selector
#if !RENDER_ON_MAIN_THREAD
- (void)runThread
{
    // Set the display link to the run loop of this thread so its call back occurs on this thread
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [_displayLink addToRunLoop:runLoop forMode:@"CustomDisplayLinkMode"];

    // The '_continueRunLoop' ivar is set outside this thread, so it must be synchronized.  Create a
    // 'continueRunLoop' local var that can be set from the _continueRunLoop ivar in a @synchronized block
    BOOL continueRunLoop = YES;

    // Begin the run loop
    while (continueRunLoop)
    {
        // Create autorelease pool for the current iteration of loop.
        @autoreleasepool
        {
            // Run the loop once accepting input only from the display link.
            [runLoop runMode:@"CustomDisplayLinkMode" beforeDate:[NSDate distantFuture]];
        }

        // Synchronize this with the _continueRunLoop ivar which is set on another thread
        @synchronized(self)
        {
            // Anything accessed outside the thread such as the '_continueRunLoop' ivar
            // is read inside the synchronized block to ensure it is fully/atomically written
            continueRunLoop = _continueRunLoop;
        }
    }
}
#endif

#endif

#pragma mark - Resizing

#if AUTOMATICALLY_RESIZE
// Override all methods which indicate the view's size has changed

- (void)setContentScaleFactor:(CGFloat)contentScaleFactor
{
    [super setContentScaleFactor:contentScaleFactor];
    [self resizeDrawable:self.window.screen.nativeScale];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self resizeDrawable:self.window.screen.nativeScale];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resizeDrawable:self.window.screen.nativeScale];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self resizeDrawable:self.window.screen.nativeScale];
}

#endif

@end
