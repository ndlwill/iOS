//
//  FVDNSResolverState.m
//  AiJiaSuClientIos
//
//  Created by youdun on 2025/9/25.
//  Copyright © 2025 AiJiaSu Inc. All rights reserved.
//

#import "FVDNSResolverState.h"

@implementation FVDNSResolverState
// Xcode 16.4 编译，iOS 16.5 运行时报
// dyld: Symbol not found: ___res_9_state
+ (struct __res_9_state *)create {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_18_4
    return &_res;
#else
    return __res_9_state();
#endif
}

@end
