//
//  Renderer5.h
//  TestMetal
//
//  Created by youdun on 2023/9/1.
//

@import MetalKit;

NS_ASSUME_NONNULL_BEGIN

@interface Renderer5 : NSObject <MTKViewDelegate>

// Clip-space depth value of each of the triangle's three vertices.
@property (nonatomic, assign) CGFloat topVertexDepth;
@property (nonatomic, assign) CGFloat leftVertexDepth;
@property (nonatomic, assign) CGFloat rightVertexDepth;

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;

@end

NS_ASSUME_NONNULL_END
