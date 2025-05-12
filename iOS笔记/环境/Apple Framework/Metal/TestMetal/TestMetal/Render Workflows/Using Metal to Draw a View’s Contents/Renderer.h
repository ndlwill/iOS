//
//  Renderer.h
//  TestMetal
//
//  Created by youdun on 2023/8/24.
//

// 能在头文件中@class，就不在头文件中#import
// @import是iOS 7之后的新特性语法，这种方式叫Modules(模块导入),通过@import语法来导入任何的framework
/**
 而且你也可以只加载framework里面的submodules
 @import MapKit.MKAnnotation
 */
@import MetalKit;

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Renderer : NSObject <MTKViewDelegate>

- (nonnull instancetype)initWithDevice:(nonnull id<MTLDevice>)device;

@end

NS_ASSUME_NONNULL_END
