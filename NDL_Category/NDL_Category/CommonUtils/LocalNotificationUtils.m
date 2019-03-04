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
        // title
        content.title = [NSString localizedUserNotificationStringForKey:@"===title===" arguments:nil];
        // body
        content.body = [NSString localizedUserNotificationStringForKey:contentStr arguments:nil];
        // sound
        if (soundNamed) {
            UNNotificationSound *sound = [UNNotificationSound soundNamed:soundNamed];
            content.sound = sound;
        } else {
            content.sound = [UNNotificationSound defaultSound];
        }
        //
        // badge
        content.badge = @(1);
        /*
         有4种触发器:
         UNPushNotificationTrigger 触发APNS服务，系统自动设置（这是区分本地通知和远程通知的标识）
         UNTimeIntervalNotificationTrigger 一段时间后触发 app被kill收不到
         UNCalendarNotificationTrigger 指定日期触发
         UNLocationNotificationTrigger 根据位置触发
         */
        // trigger
//        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.hour = 15;
        dateComponents.minute = 40;
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:YES];
        // request
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"LocalNotification" content:content trigger:trigger];// 根据trigger触发
        
//        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"LocalNotification" content:content trigger:nil];// 立即触发
        // 方法在 id 不变的情况下重新添加，就可以刷新原有的推送
        [userNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"UNUserNotificationCenter addNotificationRequest complete");
        }];
        
        // 移除本地通知
//        [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
//        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[]];
        
    } else {// iOS8.0-10.0
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = contentStr;
        if (soundNamed) {
            localNotification.soundName = soundNamed;
        } else {
            localNotification.soundName = UILocalNotificationDefaultSoundName;
        }
        localNotification.applicationIconBadgeNumber = 1;
        [Application presentLocalNotificationNow:localNotification];// 现在发送
        
        // 定时发送
//        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60];
//        localNotification.repeatInterval = NSCalendarUnitDay;
//        [Application scheduleLocalNotification:localNotification];
        
        // 移除本地通知
//        [Application cancelLocalNotification:localNotification];
//        [Application cancelAllLocalNotifications];
    }
}

@end
