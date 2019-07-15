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

/// 获取总内存大小 (获取设备所有物理内存大小)
+ (long long)totalMemorySize;

/// 获取可用内存大小
+ (long long)availableMemorySize;

/// 获取精准电池电量
+ (CGFloat)currentBatteryLevel;

/// 获取电池当前的状态，共有4种状态
+ (NSString *)batteryState;

/// 获取当前语言
+ (NSString *)deviceLanguage;


/*
 CPU:
 CPU 是移动设备最重要的计算资源，设计糟糕的应用可能会造成 CPU 持续以高负载运行，一方面会导致用户使用过程遭遇卡顿；另一方面也会导致手机发热发烫，电量被快速消耗完，严重影响用户体验
 线程是调度和分配的基本单位，而应用作为进程运行时，包含了多个不同的线程，显然如果我们能获取应用的所有线程占用 CPU 的情况，也就能知道应用的 CPU 占用率
 
 iOS 是基于 Apple Darwin 内核，由 kernel、XNU 和 Runtime 组成，而 XNU 是 Darwin 的内核，它是“X is not UNIX”的缩写，是一个混合内核，由 Mach 微内核和 BSD 组成。Mach 内核是轻量级的平台，只能完成操作系统最基本的职责，比如：进程和线程、虚拟内存管理、任务调度、进程通信和消息传递机制。其他的工作，例如文件操作和设备访问，都由 BSD 层实现
 Mach 作为一个微内核的操作系统
 任务（task）是一种容器（container）对象
 */
// CPU使用率
+ (CGFloat)cpu_usage;// ###
+ (CGFloat)cpu_usage_1;// ###

/*
 Memory:
 物理内存（RAM）
 iOS 没有交换空间作为备选资源,这就使得内存资源尤为重要
 在 iOS 中就有 Jetsam 机制负责处理系统低 RAM 事件，Jetsam 是一种类似 Linux 的 Out-Of-Memory(Killer) 的机制
 mach_task_basic_info 结构体存储了 Mach task 的内存使用信息，其中 resident_size 就是应用使用的物理内存大小，virtual_size 是虚拟内存大小
 #define MACH_TASK_BASIC_INFO     20         // always 64-bit basic info
struct mach_task_basic_info {
    mach_vm_size_t  virtual_size;       // virtual memory size (bytes)
    mach_vm_size_t  resident_size;      // resident memory size (bytes)
    mach_vm_size_t  resident_size_max;  // maximum resident memory size (bytes)
    time_value_t    user_time;          // total user run time for
                                         terminated threads
    time_value_t    system_time;        // total system run time for
                                         terminated threads
    policy_t        policy;             // default policy for new threads
    integer_t       suspend_count;      // suspend count for task
};
 Apple 已经不建议再使用 task_basic_info 结构体
 */
+ (uint64_t)residentMemory;

// 当前设备的 Memory 使用情况
+ (int64_t)usedMemory;
// 当前应用内存使用 Apple 就是用的这个指标
+ (int64_t)memoryUsage;// ###

@end

/*
 冷启动：指的是应用尚未运行，必须加载并构建整个应用，完成初始化的工作，冷启动往往比热启动耗时长，而且每个应用的冷启动耗时差别也很大，所以冷启动存在很大的优化空间，冷启动时间从applicationDidFinishLaunching:withOptions:方法开始计算，很多应用会在该方法对其使用的第三方库初始化。
 
 热启动：应用已经在后台运行（常见的场景是用户按了 Home 按钮），由于某个事件将应用唤醒到前台，应用会在 applicationWillEnterForeground: 方法接收应用进入前台的事件
 */

// FPS(Frames Per Second)
