//
//  PhotoAuthority.m
//  NDL_Category
//
//  Created by dzcx on 2018/5/21.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "PhotoAuthority.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation PhotoAuthority

+ (BOOL)authorized
{
    // NotDetermined
//    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//
//    }];
    return ([self authorizationStatus] == 3);
}

/*
 0 :NotDetermined
 1 :Restricted
 2 :Denied
 3 :Authorized
 */
+ (NSInteger)authorizationStatus
{
    if (@available(iOS 8.0, *)) {
        return [PHPhotoLibrary authorizationStatus];
    } else {
        return [ALAssetsLibrary authorizationStatus];
    }
}

// 只考虑iOS8.0
+ (void)authorizeWithCompletion:(void (^)(BOOL granted))completion
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status) {
        case PHAuthorizationStatusAuthorized:
        {
            if (completion) {
                completion(YES);
            }
        }
            break;
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
        {
            if (completion) {
                completion(NO);
            }
        }
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                // 回调不在主线程
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(status == PHAuthorizationStatusAuthorized);
                    });
                }
            }];
        }
            break;
        default:
            break;
    }
}

@end
