//
//  FVDNSResolverState.h
//  AiJiaSuClientIos
//
//  Created by youdun on 2025/9/25.
//  Copyright © 2025 AiJiaSu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <resolv.h>

NS_ASSUME_NONNULL_BEGIN

@interface FVDNSResolverState : NSObject

+ (struct __res_9_state *)create;

@end

NS_ASSUME_NONNULL_END
