//
//  LGProxy.m
//  003---强引用问题
//
//  Created by cooci on 2019/1/17.
//  Copyright © 2019 cooci. All rights reserved.
//

#import "LGProxy.h"

@interface LGProxy()
@property (nonatomic, weak) id object;
@end

@implementation LGProxy
+ (instancetype)proxyWithTransformObject:(id)object{
    LGProxy *proxy = [LGProxy alloc];
    proxy.object = object;
    return proxy;
}

// sel - imp -
// 消息转发 self.object
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.object methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    [invocation invokeWithTarget:self.object];
}

@end
