//
//  Renderer4.h
//  TestMetal
//
//  Created by youdun on 2023/8/30.
//

@import MetalKit;

NS_ASSUME_NONNULL_BEGIN

@interface Renderer4 : NSObject <MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;

@end

NS_ASSUME_NONNULL_END
