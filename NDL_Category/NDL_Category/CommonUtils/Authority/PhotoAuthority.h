//
//  PhotoAuthority.h
//  NDL_Category
//
//  Created by dzcx on 2018/5/21.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoAuthority : NSObject

+ (BOOL)authorized;

+ (NSInteger)authorizationStatus;

+ (void)authorizeWithCompletion:(void (^)(BOOL granted))completion;

@end
