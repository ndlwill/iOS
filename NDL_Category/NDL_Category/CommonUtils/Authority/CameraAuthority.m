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

@end
