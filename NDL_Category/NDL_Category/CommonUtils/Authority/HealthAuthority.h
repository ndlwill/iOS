//
//  HealthAuthority.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/15.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthAuthority : NSObject

+ (BOOL)authorized;

+ (BOOL)isHealthDataAvailable;

+ (NSInteger)authorizationStatus;

+ (void)authorizeWithCompletion:(void (^)(BOOL granted))completion;

@end
