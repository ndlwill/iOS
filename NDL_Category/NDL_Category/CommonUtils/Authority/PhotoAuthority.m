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

@end
