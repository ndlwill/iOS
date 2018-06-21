//
//  CameraAuthority.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/15.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "CameraAuthority.h"

@implementation CameraAuthority

+ (BOOL)authorized
{
//    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//        
//    }];
    return ([self authorizationStatus] == AVAuthorizationStatusAuthorized);
}

+ (AVAuthorizationStatus)authorizationStatus
{
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];// iOS 7.0
    } else {
        // Prior to iOS 7 all apps were authorized.
        return AVAuthorizationStatusAuthorized;
    }
}

+ (void)authorizeWithCompletion:(void (^)(BOOL granted))completion
{
    // iOS 7.0
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusAuthorized:
            {
                if (completion) {
                    completion(YES);
                }
            }
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
            {
                if (completion) {
                    completion(NO);
                }
            }
                break;
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(granted);
                        });
                    }
                }];
            }
                break;
            default:
                break;
        }
    }
}

@end
