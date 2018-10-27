//
//  AuthorityManager.m
//  NDL_Category
//
//  Created by dzcx on 2018/5/21.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "AuthorityManager.h"

#import "PhotoAuthority.h"
#import "CameraAuthority.h"
#import "ContactsAuthority.h"
#import "ReminderAuthority.h"
#import "CalendarAuthority.h"
#import "MicrophoneAuthority.h"
#import "HealthAuthority.h"
#import "LocationAuthority.h"
#import "NetworkDataAuthority.h"

@implementation AuthorityManager

+ (BOOL)authorizedWithType:(AuthorityType)type
{
    switch (type) {
        case AuthorityType_Location:
        {
            return [LocationAuthority authorized];
        }
            break;
        case AuthorityType_Camera:
        {
            return [CameraAuthority authorized];
        }
            break;
        case AuthorityType_Photo:
        {
            return [PhotoAuthority authorized];
        }
            break;
        case AuthorityType_Contacts:
        {
            return [ContactsAuthority authorized];
        }
            break;
        case AuthorityType_Reminder:
        {
            return [ReminderAuthority authorized];
        }
            break;
        case AuthorityType_Calendar:
        {
            return [CalendarAuthority authorized];
        }
            break;
        case AuthorityType_Microphone:
        {
            return [MicrophoneAuthority authorized];
        }
            break;
        case AuthorityType_Health:
        {
            return [HealthAuthority authorized];
        }
            break;
        case AuthorityType_DataNetwork:
            break;
        default:
            break;
    }
    
    return NO;
}

+ (void)authorizedWithType:(AuthorityType)type completion:(void (^)(BOOL granted))completion
{
    switch (type) {
        case AuthorityType_Location:
        {
            return [LocationAuthority authorizeWithCompletion:completion];
        }
            break;
        case AuthorityType_Camera:
        {
            return [CameraAuthority authorizeWithCompletion:completion];
        }
            break;
        case AuthorityType_Photo:
        {
            return [PhotoAuthority authorizeWithCompletion:completion];
        }
            break;
        case AuthorityType_Contacts:
        {
            return [ContactsAuthority authorizeWithCompletion:completion];
        }
            break;
        case AuthorityType_Reminder:
        {
            return [ReminderAuthority authorizeWithCompletion:completion];
        }
            break;
        case AuthorityType_Calendar:
        {
            return [CalendarAuthority authorizeWithCompletion:completion];
        }
            break;
        case AuthorityType_Microphone:
        {
            return [MicrophoneAuthority authorizeWithCompletion:completion];
        }
            break;
        case AuthorityType_Health:
        {
            return [HealthAuthority authorizeWithCompletion:completion];
        }
            break;
        case AuthorityType_DataNetwork:
        {
            return [NetworkDataAuthority authorizeWithCompletion:completion];
        }
            break;
        default:
            break;
    }
}

@end
