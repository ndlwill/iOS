//
//  UncatchedExceptionHandler.m
//  NDL_Category
//
//  Created by dzcx on 2019/5/21.
//  Copyright © 2019 ndl. All rights reserved.
//

// 《OS X Internal: A System Approach》
// 《OS X and iOS Kernel Programming》


// APM 博客
// http://sindrilin.com/

/*
 性能监控:
 
 有十种应用性能问题危害最大，分别为：连接超时、闪退、卡顿、崩溃、黑白屏、网络劫持、交互性能差、CPU 使用率问题、内存泄露、不良接口
 */

/*
 crash分别存在mach exception、signal以及NSException三种类型，每一种类型表示不同分层上的crash，也拥有各自的捕获方式:
 
 NSException发生在CoreFoundation以及更高抽象层，在CoreFoundation层操作发生异常时，会通过__cxa_throw函数抛出异常。在通过NSSetUncaughtExceptionHandler注册NSException的捕获函数之后，崩溃发生时会调用这个捕获函数。 如果在捕获函数中没有进行操作终止应用，最终异常会通过abort()来抛出一个SIGABRT信号
 由于NSException的抽象层次足够高，相比较其他的crash类型，NSException是可以被人为的阻止crash的。比如@try-catch机制能够捕获块中发生的异常，避免应用被杀死。但由于try-catch的开销和回报不成正比，往往不会使用这种机制
 
 NSException在未被捕获的情况下会调用abort抛出信号
 
 由于crash的捕获机制只会保存最后一个注册的handle，因此如果项目中残留或者存在另外的第三方框架采集crash信息时，经常性的会存在冲突。解决冲突的做法是在注册自己的handle之前保存已注册的处理函数，便于发生崩溃后能将crash信息连续的传递下去
 */

/*
 字段
 含义
 
 Incident Identifier
 当前crash的 id，可以区分不同的crash事件
 
 CrashReporter Key
 当前设备的id，可以判断crash在某一设备上出现的频率
 
 Hardware Model
 设备型号
 
 Process
 当前应用的名称，后面中括号中为当前的应用在系统中的进程id
 
 Path
 当前应用在设备中的路径
 
 Identifier
 bundle id
 
 Version
 应用版本号
 
 Code Type
 还不清楚
 
 Date/Time
 crash事件 时间(后面跟的应该是时区)
 
 OS Version
 当前系统版本
 
 Exception Type
 异常类型
 
 Exception Codes
 异常出错的代码（常见代码有以下几种)0x8badf00d错误码：Watchdog超时，意为“ate bad food”。 0xdeadfa11错误码：用户强制退出，意为“dead fall”。0xbaaaaaad错误码：用户按住Home键和音量键，获取当前内存状态，不代表崩溃。0xbad22222错误码：VoIP应用（因为太频繁？）被iOS干掉。0xc00010ff错误码：因为太烫了被干掉，意为“cool off”。0xdead10cc错误码：因为在后台时仍然占据系统资源（比如通讯录）被干掉，意为“dead lock”。
 
 Triggered by Thread
 在某一个线程出了问题导致crash，Thread 0  为主线程、其它的都为子线程
 
 Last Exception Backtrace
 最后异常回溯，一般根据这个代码就能找到crash的具体问题
 */

// Mach异常处理会先于Unix信号处理发生，如果Mach异常的handler让程序exit了，那么Unix信号就永远不会到达这个进程了
#import "UncatchedExceptionHandler.h"

@implementation UncatchedExceptionHandler



@end

/*
 Jetsam:
 由于iOS设备不存在交换区导致的内存受限，所以iOS内核不得不把一些优先级不高或者占用内存过大的杀掉。这些JetsamEvent就是系统在杀掉App后记录的一些数据信息
 JetsamEvent是一种另类的Crash事件，但是在常规的Crash捕获工具中，由于iOS上能捕获的信号量的限制，所以因为内存导致App被杀掉是无法被捕获的
 MacOS/iOS是一个从BSD衍生而来的系统。其内核是Mach，但是对于上层暴露的接口一般都是基于BSD层对于Mach包装后的。虽然说Mach是个微内核的架构，真正的虚拟内存管理是在其中进行，但是BSD对于内存管理提供了相对较为上层的接口，同时，各种常见的JetSam事件也是由BSD产生，所以，我们从bsd_init这个函数作为入口，来探究下原理
 
 BSD (Berkeley Software Distribution，伯克利软件套件)是Unix的衍生系统
 
 怎么处理JetSam事件？
 BSD层起了一个内核优先级最高的线程VM_memorystatus，这个线程会在维护两个列表，一个是我们之前提到的基于进程优先级的进程列表，还有一个是所谓的内存快照列表，即保存了每个进程消耗的内存页memorystatus_jetsam_snapshot
 */
