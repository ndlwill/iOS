//
//  Renderer6.h
//  TestMetal
//
//  Created by youdun on 2023/9/4.
//

@import MetalKit;
#import "TGAImage.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct PixelBGRA8Unorm {
    uint8_t blue;
    uint8_t green;
    uint8_t red;
    uint8_t alpha;
} PixelBGRA8Unorm;

@interface Renderer6 : NSObject <MTKViewDelegate>

@property (nonatomic, assign) BOOL drawOutline;
@property (nonatomic, assign) CGRect outlineRect;

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;

- (nonnull TGAImage *)renderAndReadPixelsFromView:(nonnull MTKView*)mtkView
                                       withRegion:(CGRect)region;

@end

NS_ASSUME_NONNULL_END
