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

#import <sys/sysctl.h>

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

/// 获取电池电量 0-1.0，如果 batteryState 是 UIDeviceBatteryStateUnknown，则电量是 -1.0
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

/*
 一个 task 包含它的线程列表。内核提供了 task_threads API 调用获取指定 task 的线程列表，然后可以通过 thread_info API 调用来查询指定线程的信息，thread_info API 在 thread_act.h 中定义。
 kern_return_t task_threads
 (
 task_t target_task,
 thread_act_array_t *act_list,
 mach_msg_type_number_t *act_listCnt
 );
 task_threads 将 target_task 任务中的所有线程保存在 act_list 数组中，数组中包含 act_listCnt 个条目
 kern_return_t thread_info
 (
 thread_act_t target_act,
 thread_flavor_t flavor,
 thread_info_t thread_info_out,
 mach_msg_type_number_t *thread_info_outCnt
 );
 thread_info 查询 flavor 指定的 thread 信息，将信息返回到长度为 thread_info_outCnt 字节的 thread_info_out 缓存区中
 
 iOS 的线程技术也是基于 Mach 线程技术实现的，在 Mach 层中 thread_basic_info 结构体提供了线程的基本信息。
 struct thread_basic_info {
 time_value_t    user_time;      // user run time
 time_value_t    system_time;    // system run time
 integer_t       cpu_usage;      // scaled cpu usage percentage
 policy_t        policy;         // scheduling policy in effect
 integer_t       run_state;      // run state (see below)
 integer_t       flags;          // various flags (see below)
 integer_t       suspend_count;  // suspend count for thread
 integer_t       sleep_time;     // number of seconds that thread has been sleeping
 };
};
 */
+ (CGFloat)cpu_usage
{
    CGFloat cpu_usage = 0.0;
    kern_return_t krt;
    // 在调用 task_threads API 时，target_task 参数传入的是 mach_task_self()，表示获取当前的 Mach task
    thread_act_array_t threadList;
    mach_msg_type_number_t threadCount;
    krt = task_threads(mach_task_self(), &threadList, &threadCount);
//    NSLog(@"krt = %d threadCount = %u", krt, threadCount);
    if (krt != KERN_SUCCESS) {
        return -1;
    }
    
    thread_info_data_t threadInfo;// 线程信息
    mach_msg_type_number_t threadInfoCount;
    
    thread_basic_info_t threadBasicInfo;
    for (NSUInteger i = 0; i < threadCount; i++) {
        threadInfoCount = THREAD_INFO_MAX;// ?
        // inspect: 检查，查看
        krt = thread_info(threadList[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount);
//        NSLog(@"krt = %d threadInfoCount = %u", krt, threadInfoCount);
        if (krt != KERN_SUCCESS) {
            return -1;
        }
        
        threadBasicInfo = (thread_basic_info_t)threadInfo;
        if (!(threadBasicInfo->flags & TH_FLAGS_IDLE)) {
            cpu_usage += threadBasicInfo->cpu_usage;
        }
    }
    
    cpu_usage = cpu_usage / TH_USAGE_SCALE * 100.0;
    vm_deallocate(mach_task_self(), (vm_address_t)threadList, threadCount * sizeof(thread_t));
    
    return cpu_usage;
}

+ (CGFloat)cpu_usage_1
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < (int)thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

+ (uint64_t)residentMemory
{
    // mach_task_basic_info_data_t
    struct mach_task_basic_info info;
    mach_msg_type_number_t count = MACH_TASK_BASIC_INFO_COUNT;
    
    // mach_task_self()，表示获取当前的 Mach task
    int krt = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &count);
    if (krt == KERN_SUCCESS)
    {
        return info.resident_size;// (bytes)
    }
    else
    {
        return -1;
    }
    
    //    int64_t memoryUsageInByte = 0;
    //    struct task_basic_info taskBasicInfo;
    //    mach_msg_type_number_t size = sizeof(taskBasicInfo);
    //    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskBasicInfo, &size);
    //
    //    if(kernelReturn == KERN_SUCCESS) {
    //        memoryUsageInByte = (int64_t) taskBasicInfo.resident_size;
    //        NSLog(@"Memory in use (in bytes): %lld", memoryUsageInByte);
    //    }
    //
    //    return memoryUsageInByte;
}

+ (int64_t)usedMemory
{
    size_t length = 0;
    int mib[6] = {0};
    
    int pagesize = 0;
    mib[0] = CTL_HW;
    mib[1] = HW_PAGESIZE;
    length = sizeof(pagesize);
    if (sysctl(mib, 2, &pagesize, &length, NULL, 0) < 0)
    {
        return 0;
    }
    
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    
    vm_statistics_data_t vmstat;
    
    if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count) != KERN_SUCCESS)
    {
        return 0;
    }
    
    int wireMem = vmstat.wire_count * pagesize;
    int activeMem = vmstat.active_count * pagesize;
    return wireMem + activeMem;
}

+ (int64_t)memoryUsage
{
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t)vmInfo.phys_footprint;
    }
    return memoryUsageInByte;
}

@end
