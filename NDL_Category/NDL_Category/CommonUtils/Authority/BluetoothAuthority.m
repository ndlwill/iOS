//
//  BluetoothAuthority.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/19.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "BluetoothAuthority.h"

@implementation BluetoothAuthority

+ (BOOL)authorized
{
    return ([self authorizationStatus] == CBPeripheralManagerAuthorizationStatusAuthorized);
}

+ (CBPeripheralManagerAuthorizationStatus)authorizationStatus
{
    return [CBPeripheralManager authorizationStatus];
}

+ (void)authorizeWithCompletion:(void (^)(BOOL granted))completion
{
    CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
    
    switch (status) {
        case CBPeripheralManagerAuthorizationStatusAuthorized:
        {
            if (completion) {
                completion(YES);
            }
        }
            break;
        case CBPeripheralManagerAuthorizationStatusDenied:
        case CBPeripheralManagerAuthorizationStatusRestricted:
        {
            if (completion) {
                completion(NO);
            }
        }
            break;
        case CBPeripheralManagerAuthorizationStatusNotDetermined:
        {
            if (completion) {
                completion(NO);
            }
        }
            break;
        default:
            break;
    }
}

@end
