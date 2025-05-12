//
//  Renderer3.h
//  TestMetal
//
//  Created by youdun on 2023/8/28.
//

@import MetalKit;

NS_ASSUME_NONNULL_BEGIN

@interface Renderer3 : NSObject <MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;

@end

NS_ASSUME_NONNULL_END
