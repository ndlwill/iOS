//
//  XLogManager.h
//  NDL_Category
//
//  Created by dzcx on 2019/5/24.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 对于数据量比较大的应用，可以采用分步加载数据的方式，或者采用 mmap 方式。mmap 是使用逻辑内存对磁盘文件进行映射，中间只是进行映射没有任何拷贝操作，避免了写文件的数据拷贝。 操作内存就相当于在操作文件，避免了内核空间和用户空间的频繁切换，能够提供高性能的写入速度。此外，mmap 可以保持数据的一致性，即使在对应的用户进程崩溃后，内存映射的文件仍然可以落盘。参见：mmap 实现数据一致性https://stackoverflow.com/questions/5902629/mmap-msync-and-linux-process-termination。因为，用户进程崩溃后，内核会托管 mmap 的交换区，保证对应的数据能够存盘。sqlite 里也使用 mmap 提高性能防止丢数据
 */

// 高级iOS 原理机制
// https://satanwoo.github.io/tags/iOS/

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    XLogLevelAll = 0,
    XLogLevelVerbose = 0,
    XLogLevelDebug,    // Detailed information on the flow through the system.
    XLogLevelInfo,     // Interesting runtime events (startup/shutdown), should be conservative and keep to a minimum.
    XLogLevelWarn,     // Other runtime situations that are undesirable or unexpected, but not necessarily "wrong".
    XLogLevelError,    // Other runtime errors or unexpected conditions.
    XLogLevelFatal,    // Severe errors that cause premature termination.
    XLogLevelNone,     // Special level used to disable all log messages.
} XLogLevel;

@interface XLogManager : NSObject

+ (void)openWithLogDirName:(NSString *)logDirName
             logNamePrefix:(NSString *)logNamePrefix;

//+ (void)logWithLevel:(XLogLevel)level format:(NSString *)format, ... ;
//+ (void)logWithLevel:(XLogLevel)level string:(NSString *)string;
+ (void)logWithLevel:(XLogLevel)level
          moduleName:(NSString *)moduleName
            fileName:(NSString *)fileName
          lineNumber:(int)lineNumber
            funcName:(const char *)funcName format:(NSString *)format, ... ;

// flush log into file immediately
+ (void)flushLog:(void(^)(void))finishBlock;

+ (void)setLogAliveDuration:(long)aliveDuration;

+ (void)close;

@end

NS_ASSUME_NONNULL_END
