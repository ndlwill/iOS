//
//  LocalNotificationUtils.h
//  NDL_Category
//
//  Created by dzcx on 2018/11/6.
//  Copyright © 2018年 ndl. All rights reserved.
//

/*
 远程推送:需要联网,用户的设备会于苹果APNS服务器形成一个长连接,用户设备会发送uuid和Bundle idenidentifier给苹果服务器,苹果服务器会加密生成一个deviceToken给用户设备,然后设备会将deviceToken发送给APP的服务器,服务器会将deviceToken存进他们的数据库,这时候如果有人发送消息给我,服务器端就会去查询我的deviceToken,然后将deviceToken和要发送的信息发送给苹果服务器,苹果服务器通过deviceToken找到我的设备并将消息推送到我的设备上,这里还有个情况是如果APP在线,那么APP服务器会于APP产生一个长连接,这时候APPF服务器会直接通过deviceToken将消息推送到设备上
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalNotificationUtils : NSObject

// 显示本地通知
+ (void)presentLocalNotificationWithContent:(NSString *)contentStr soundNamed:(NSString *)soundNamed;

@end

NS_ASSUME_NONNULL_END
