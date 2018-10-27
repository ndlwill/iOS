//
//  MicrophoneAuthority.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/15.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

// 录音
@interface MicrophoneAuthority : NSObject

+ (BOOL)authorized;

+ (NSInteger)authorizationStatus;

+ (void)authorizeWithCompletion:(void (^)(BOOL granted))completion;

@end
