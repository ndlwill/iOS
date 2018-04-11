//
//  SystemInfo.m
//  NDL_Category
//
//  Created by ndl on 2017/11/2.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import "SystemInfo.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

#import <mach/mach.h>

#import <objc/runtime.h>

@implementation SystemInfo

/// 获取设备名称
+ (NSString *)deviceName
{
    return [UIDevice currentDevice].name;
}

/// 当前系统名称
+ (NSString *)systemName
{
    return [UIDevice currentDevice].systemName;
}

/// 当前系统版本号
+ (NSString *)systemVersion
{
    return [UIDevice currentDevice].systemVersion;
}

/// 获取电池电量 0-1.0
+ (CGFloat)batteryLevel
{
    return [UIDevice currentDevice].batteryLevel;
}

+ (NSString *)uuid
{
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

/// 获取app版本号
+ (NSString *)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)deviceIPAdress
{
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}

/// 获取总内存大小
+ (long long)totalMemorySize
{
    return [NSProcessInfo processInfo].physicalMemory;
}

/// 获取可用内存大小
+ (long long)availableMemorySize
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
}

/// 获取精准电池电量
+ (CGFloat)currentBatteryLevel
{
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationState == UIApplicationStateActive || app.applicationState == UIApplicationStateInactive) {
        Ivar ivar = class_getInstanceVariable([app class], "_statusBar");
        id status  = object_getIvar(app, ivar);
        for (id aview in [status subviews]) {
            int batteryLevel = 0;
            for (id bview in [aview subviews]) {
                if ([NSStringFromClass([bview class]) caseInsensitiveCompare:@"UIStatusBarBatteryItemView"] == NSOrderedSame&&[[[UIDevice currentDevice] systemVersion] floatValue] >=6.0) {
                    
                    Ivar ivar=  class_getInstanceVariable([bview class],"_capacity");
                    if(ivar) {
                        batteryLevel = ((int (*)(id, Ivar))object_getIvar)(bview, ivar);
                        if (batteryLevel > 0 && batteryLevel <= 100) {
                            return batteryLevel;
                        } else {
                            return 0;
                        }
                    }
                }
            }
        }
    }
    
    return 0;
}

/// 获取电池当前的状态，共有4种状态
+ (NSString *)batteryState
{
    UIDevice *device = [UIDevice currentDevice];
    if (device.batteryState == UIDeviceBatteryStateUnknown) {
        return @"UnKnow";
    } else if (device.batteryState == UIDeviceBatteryStateUnplugged){
        return @"Unplugged";
    } else if (device.batteryState == UIDeviceBatteryStateCharging){
        return @"Charging";
    } else if (device.batteryState == UIDeviceBatteryStateFull){
        return @"Full";
    }
    return nil;
}

/// 获取当前语言
+ (NSString *)deviceLanguage
{
    return [NSLocale preferredLanguages].firstObject;
}

@end
