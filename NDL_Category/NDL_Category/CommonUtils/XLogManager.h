//
//  XLogManager.h
//  NDL_Category
//
//  Created by dzcx on 2019/5/24.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

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
