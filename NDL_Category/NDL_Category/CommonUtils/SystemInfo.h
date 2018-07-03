//
//  SystemInfo.h
//  NDL_Category
//
//  Created by ndl on 2017/11/2.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

/*
 IMEI(International Mobile Equipment Identity)是国际移动设备身份码的缩写，国际移动装备辨识码
 是由15位数字组成的”电子串号”，它与每台手机一一对应，而且该码是全世界唯一的
 */

// 系统信息
@interface SystemInfo : NSObject

/// 获取设备名称 
//+ (NSString *)deviceName;

/// 当前系统名称
//+ (NSString *)systemName;

/// 当前系统版本号
//+ (NSString *)systemVersion;

/// 获取电池电量 0-1.0
//+ (CGFloat)batteryLevel;

// Universally Unique Identifier 通用唯一标识符 一个32位的十六进制序列，使用小横线来连接8-4-4-4-12
// identifierForVendor是一种应用加设备绑定产生的标识符
/// 通用唯一识别码UUID Z(identifierForVendor) = X(某应用) + Y(某设备) identifierForVendor是应用和设备两者都有关的
+ (NSString *)uuid;

/// 获取app版本号
+ (NSString *)appVersion;

/// 获取当前设备IP
+ (NSString *)deviceIPAdress;

/// 获取总内存大小
+ (long long)totalMemorySize;

/// 获取可用内存大小
+ (long long)availableMemorySize;

/// 获取精准电池电量
+ (CGFloat)currentBatteryLevel;

/// 获取电池当前的状态，共有4种状态
+ (NSString *)batteryState;

/// 获取当前语言
+ (NSString *)deviceLanguage;

@end
