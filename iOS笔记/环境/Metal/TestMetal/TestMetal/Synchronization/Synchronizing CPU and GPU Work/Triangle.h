//
//  Triangle.h
//  TestMetal
//
//  Created by youdun on 2023/9/20.
//

#import "CommonShaderTypes.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// provides an interface to a default triangle, which is made up of 3 vertices
@interface Triangle : NSObject

@property (nonatomic, assign) vector_float2 position;
@property (nonatomic, assign) vector_float4 color;

+ (const CommonVertex2 *)vertices;
+ (NSUInteger)vertexCount;

@end

NS_ASSUME_NONNULL_END
