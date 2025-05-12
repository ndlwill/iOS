//
//  Renderer7.h
//  TestMetal
//
//  Created by youdun on 2023/9/6.
//

@import MetalKit;

NS_ASSUME_NONNULL_BEGIN

@interface Renderer7 : NSObject <MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;

@end

NS_ASSUME_NONNULL_END
