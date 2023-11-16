//
//  Renderer8.h
//  TestMetal
//
//  Created by youdun on 2023/9/8.
//

@import MetalKit;

NS_ASSUME_NONNULL_BEGIN

@interface Renderer8 : NSObject <MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;

@end

NS_ASSUME_NONNULL_END
