//
//  ReminderAuthority.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/15.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "ReminderAuthority.h"

@implementation ReminderAuthority

+ (BOOL)authorized
{
//    [[[EKEventStore alloc] init] requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
//        
//    }];
    return ([self authorizationStatus] == EKAuthorizationStatusAuthorized);
}

+ (EKAuthorizationStatus)authorizationStatus
{
    return [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
}

@end
