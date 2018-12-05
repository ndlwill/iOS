//
//  LocalNotificationUtils.m
//  NDL_Category
//
//  Created by dzcx on 2018/11/6.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "LocalNotificationUtils.h"
#import <UserNotifications/UserNotifications.h>

@implementation LocalNotificationUtils

// target >= iOS8
+ (void)presentLocalNotificationWithContent:(NSString *)contentStr soundNamed:(NSString *)soundNamed
{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *userNotificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        // content
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.body = [NSString localizedUserNotificationStringForKey:contentStr arguments:nil];
        // sound
        UNNotificationSound *sound = [UNNotificationSound soundNamed:soundNamed];
        content.sound = sound;
        // trigger
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0 repeats:NO];
        // request
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"LocalNotification" content:content trigger:trigger];
        [userNotificationCenter addNotificationRequest:request withCompletionHandler:nil];
        
        // 移除本地通知
//        [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
//        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[]];
    } else {// iOS8.0-10.0
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = contentStr;
        localNotification.soundName = soundNamed;
        [Application presentLocalNotificationNow:localNotification];
        
        // 移除本地通知
//        [Application cancelLocalNotification:localNotification];
//        [Application cancelAllLocalNotifications];
    }
}

@end
