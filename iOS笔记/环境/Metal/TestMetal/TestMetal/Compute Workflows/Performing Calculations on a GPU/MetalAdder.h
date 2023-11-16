//
//  MetalAdder.h
//  TestMetal
//
//  Created by youdun on 2023/8/24.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetalAdder : NSObject

- (instancetype)initWithDevice:(id<MTLDevice>)device;

- (void)prepareData;

- (void)sendComputeCommand;

@end

NS_ASSUME_NONNULL_END
