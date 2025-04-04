//
//  CalendarAuthority.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/15.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "CalendarAuthority.h"

@implementation CalendarAuthority

+ (BOOL)authorized
{
    //    [[[EKEventStore alloc] init] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
    //
    //    }];
    return ([self authorizationStatus] == EKAuthorizationStatusAuthorized);
}

+ (EKAuthorizationStatus)authorizationStatus
{
    return [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
}

+ (void)authorizeWithCompletion:(void (^)(BOOL granted))completion
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status) {
        case EKAuthorizationStatusAuthorized:
        {
            if (completion) {
                completion(YES);
            }
        }
            break;
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            if (completion) {
                completion(NO);
            }
        }
            break;
        case EKAuthorizationStatusNotDetermined:
        {
            [[[EKEventStore alloc] init] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(granted);
                    }
                });
            }];
        }
            break;
        default:
            break;
    }
}

@end
