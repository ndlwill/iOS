//
//  BaseCustomMetalView.h
//  TestMetal
//
//  Created by youdun on 2023/9/21.
//

#import <UIKit/UIKit.h>
#import "Config.h"

NS_ASSUME_NONNULL_BEGIN

// Protocol to provide resize and redraw callbacks to a delegate
@protocol BaseCustomMetalViewDelegate <NSObject>

- (void)drawableResize:(CGSize)size;

- (void)renderToMetalLayer:(nonnull CAMetalLayer *)metalLayer;

@end

@interface BaseCustomMetalView : UIView <CALayerDelegate>

@property (nonatomic, strong, nonnull, readonly) CAMetalLayer *metalLayer;

@property (nonatomic, assign, getter=isPaused) BOOL paused;

@property (nonatomic, weak, nullable) id<BaseCustomMetalViewDelegate> delegate;

- (void)initCommon;

#if AUTOMATICALLY_RESIZE
- (void)resizeDrawable:(CGFloat)scaleFactor;
#endif

#if ANIMATION_RENDERING
- (void)stopRenderLoop;
#endif

- (void)render;

@end

NS_ASSUME_NONNULL_END
