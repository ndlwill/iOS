//
//  Renderer9.h
//  TestMetal
//
//  Created by youdun on 2023/9/19.
//

@import MetalKit;
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Renderer9 : NSObject <MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;

@end

NS_ASSUME_NONNULL_END
