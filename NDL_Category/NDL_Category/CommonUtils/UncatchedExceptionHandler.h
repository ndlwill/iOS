//
//  UncatchedExceptionHandler.h
//  NDL_Category
//
//  Created by dzcx on 2019/5/21.
//  Copyright © 2019 ndl. All rights reserved.
//

// 逆向工具Monkey Dev

// ==源码分析==
// https://github.com/draveness/analyze

// swift
// https://swift.org/

// ###今日头条大神 APM###
// https://www.jianshu.com/u/9c51a213b02e

// iOS监控
// https://github.com/aozhimin/iOS-Monitor-Platform

// 流量监控
// Reqeust 总流量（上行流量），Reponse 总流量（下行流量）
// http://zhoulingyu.com/2018/05/30/ios-network-traffic/

// ##大厂blog## 付费订阅
// https://xiaozhuanlan.com/u/4021400432

// ===监控=== 付费订阅
// https://xiaozhuanlan.com/u/1234800777
// https://github.com/zixun/GodEye

// Mars-日志模块xlog for iOS
/*
 四大模块
 comm：可以独立使用的公共库，包括 socket、线程、消息队列、协程等；
 xlog：高可靠性高性能的运行期日志组件；
 SDT： 网络诊断组件；
 STN： 信令分发网络模块，也是 Mars 最主要的部分
 
 python build_ios.py
 NameError: name 'raw_input' is not defined
 raw_input是2.x版本的输入函数，在新版本环境下会报错，该函数未定义。在3.x版本中应该用input()代替raw_input()
 */
// https://github.com/Tencent/mars

/*
 监控体系:
 APM 的全称是Application performance management，即应用性能管理，通过对应用的可靠性、稳定性等方面的监控，进而达到可以快速修复问题、提高用户体验的目的
 */

// https://github.com/Tencent/OOMDetector // oom 定位
/*
 OOM:
 OOM 的全称是 Out-Of-Memory，是由于 iOS 的 Jetsam 机制造成的一种“另类” Crash，它不同于常规的 Crash，通过 Signal 捕获等 Crash 监控方案无法捕获到 OOM 事件
 */

/*
 前台内存耗尽闪退(FOOM):
 iOS使用的是低内存处理机制Jetsam，这是一个基于优先级队列的机制
 Jetsam可以简单的抽象为：前台应用程序，在触发某个或多个条件时，触发系统事件，被系统kill掉。而OOM也就是因为触发了内存相关的系统事件，被系统kill掉了
 Footprint是苹果推荐的内存度量及优化的指标。而Memory Footprint的值达到Limit line时，就会触发内存警告，并进一步导致OOM
 
 Xcode的console中有memory issuer的提示
 */

// symbolicatecrash:
// find /Applications/Xcode.app -name symbolicatecrash -type f
// .ipa文件 右键 -> 打开方式 -> 归档实用工具(就是解压缩) 得到Payload文件夹 获取.dSYM文件
// export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
// ./symbolicatecrash /Users/xxxx/Desktop/crash/InOrder.crash /Users/xxxx/Desktop/crash/InOrder.app.dSYM > Control_symbol.crash

/*
 如果同时有多方通过NSSetUncaughtExceptionHandler注册异常处理程序，和平的作法是：后注册者通过NSGetUncaughtExceptionHandler将先前别人注册的handler取出并备份，在自己handler处理完后自觉把别人的handler注册回去，规规矩矩的传递。不传递强行覆盖的后果是，在其之前注册过的日志收集服务写出的Crash日志就会因为取不到NSException而丢失Last Exception Backtrace等信息
 */

/*
 很多内存错误、访问错误的地址产生的crash则需要利用unix标准的signal机制，注册SIGABRT, SIGBUS, SIGSEGV等信号发生时的处理函数
 */

/*
 所有Mach异常都在host层被ux_exception转换为相应的Unix信号，并通过threadsignal将信号投递到出错的线程.EXC_BAD_ACCESS(SIGSEGV)表示的意思是：Mach层的EXC_BAD_ACCESS异常，在host层被转换成SIGSEGV信号投递到出错的线程
 
 NSException发生在CoreFoundation以及更高抽象层级，会通过__cxa_throw函数抛出异常。如果没有人为进行捕获或者在捕获回调函数中没有进行操作终止应用，那么最终会通过abort()函数来向进程抛出一个SIGABRT的信号
 NSException可以直接通过iOS的@try-@catch机制轻松捕获，避免应用crash。但由于@try-@catch的性能开销比较大，所以在iOS开发中也并不是非常受到推崇
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// uncaught 未捕获
@interface UncatchedExceptionHandler : NSObject

@end

NS_ASSUME_NONNULL_END

/*
 序 号    信号    发出信号原因
 1    SIGHUP    本信号在用户终端连接(正常或非正常)结束时发出, 通常是在终端的控制进程结束时, 通知同一session内的各个作业, 这时它们与控制终端不再关联。
 登录Linux时，系统会分配给登录用户一个终端(Session)。在这个终端运行的所有程序，包括前台进程组和后台进程组，一般都属于这个 Session。当用户退出Linux登录时，前台进程组和后台有对终端输出的进程将会收到SIGHUP信号。这个信号的默认操作为终止进程，因此前台进 程组和后台有终端输出的进程就会中止。不过可以捕获这个信号，比如wget能捕获SIGHUP信号，并忽略它，这样就算退出了Linux登录， wget也 能继续下载。
 此外，对于与终端脱离关系的守护进程，这个信号用于通知它重新读取配置文件。
 2    SIGINT    程序终止(interrupt)信号, 在用户键入INTR字符(通常是Ctrl-C)时发出，用于通知前台进程组终止进程。
 3    SIGQUIT    和SIGINT类似, 但由QUIT字符(通常是Ctrl-)来控制. 进程在因收到SIGQUIT退出时会产生core文件, 在这个意义上类似于一个程序错误信号。
 4    SIGILL    执行了非法指令. 通常是因为可执行文件本身出现错误, 或者试图执行数据段. 堆栈溢出时也有可能产生这个信号。
 5    SIGTRAP    由断点指令或其它trap指令产生. 由debugger使用。
 6    SIGABRT    调用abort函数生成的信号。
 7    SIGBUS    非法地址, 包括内存地址对齐(alignment)出错。比如访问一个四个字长的整数, 但其地址不是4的倍数。它与SIGSEGV的区别在于后者是由于对合法存储地址的非法访问触发的(如访问不属于自己存储空间或只读存储空间)。
 8    SIGFPE    在发生致命的算术运算错误时发出. 不仅包括浮点运算错误, 还包括溢出及除数为0等其它所有的算术的错误。
 9    SIGKILL    用来立即结束程序的运行. 本信号不能被阻塞、处理和忽略。如果管理员发现某个进程终止不了，可尝试发送这个信号。
 10    SIGUSR1    留给用户使用
 11    SIGSEGV    试图访问未分配给自己的内存, 或试图往没有写权限的内存地址写数据.
 12    SIGUSR2    留给用户使用
 13    SIGPIPE    管道破裂。这个信号通常在进程间通信产生，比如采用FIFO(管道)通信的两个进程，读管道没打开或者意外终止就往管道写，写进程会收到SIGPIPE信号。此外用Socket通信的两个进程，写进程在写Socket的时候，读进程已经终止。
 14    SIGALRM    时钟定时信号, 计算的是实际的时间或时钟时间. alarm函数使用该信号.
 15    SIGTERM    程序结束(terminate)信号, 与SIGKILL不同的是该信号可以被阻塞和处理。通常用来要求程序自己正常退出，shell命令kill缺省产生这个信号。如果进程终止不了，我们才会尝试SIGKILL。
 17    SIGCHLD    子进程结束时, 父进程会收到这个信号。
 如果父进程没有处理这个信号，也没有等待(wait)子进程，子进程虽然终止，但是还会在内核进程表中占有表项，这时的子进程称为僵尸进程。这种情 况我们应该避免(父进程或者忽略SIGCHILD信号，或者捕捉它，或者wait它派生的子进程，或者父进程先终止，这时子进程的终止自动由init进程 来接管)。
 18    SIGCONT    让一个停止(stopped)的进程继续执行. 本信号不能被阻塞. 可以用一个handler来让程序在由stopped状态变为继续执行时完成特定的工作. 例如, 重新显示提示符
 19    SIGSTOP    停止(stopped)进程的执行. 注意它和terminate以及interrupt的区别:该进程还未结束, 只是暂停执行. 本信号不能被阻塞, 处理或忽略.
 20    SIGTSTP    停止进程的运行, 但该信号可以被处理和忽略. 用户键入SUSP字符时(通常是Ctrl-Z)发出这个信号
 21    SIGTTIN    当后台作业要从用户终端读数据时, 该作业中的所有进程会收到SIGTTIN信号. 缺省时这些进程会停止执行.
 22    SIGTTOU    类似于SIGTTIN, 但在写终端(或修改终端模式)时收到.
 23    SIGURG    有”紧急”数据或out-of-band数据到达socket时产生.
 24    SIGXCPU    超过CPU时间资源限制. 这个限制可以由getrlimit/setrlimit来读取/改变。
 25    SIGXFSZ    当进程企图扩大文件以至于超过文件大小资源限制。
 26    SIGVTALRM    虚拟时钟信号. 类似于SIGALRM, 但是计算的是该进程占用的CPU时间.
 27    SIGPROF    类似于SIGALRM/SIGVTALRM, 但包括该进程用的CPU时间以及系统调用的时间.
 28    SIGWINCH    窗口大小改变时发出.
 29    SIGIO    文件描述符准备就绪, 可以开始进行输入/输出操作.
 30    SIGPWR    Power failure
 31    SIGSYS    非法的系统调用。
 */
