//
//  LGProxy.h
//  003---强引用问题
//
//  Created by cooci on 2019/1/17.
//  Copyright © 2019 cooci. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGProxy : NSProxy
+ (instancetype)proxyWithTransformObject:(id)object;
@end

NS_ASSUME_NONNULL_END
