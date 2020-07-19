//
//  SystemLog.h
//  NDL_Category
//
//  Created by youdone-ndl on 2020/7/13.
//  Copyright © 2020 ndl. All rights reserved.
//

// 通过导入一个头文件以实现开启或关闭Log模式,实现选择Log级别
// 因为它不仅可以在Xcode控制台打印信息,还可能在Mac终端中打印出日志信息
/**
 1. Log模式
 2. Log级别
 */
#include <syslog.h>

#ifndef SystemLog_h
#define SystemLog_h

#pragma mark Select log mode && log level
// Only debug mode will print log
#define NDLModeDebug
// NDLLevelFatal, NDLLevelError, NDLLevelWarn, NDLLevelInfo, NDLLevelDebug
#define NDLLevelDebug

#pragma mark -----start-----
#ifdef NDLModeDebug
static const int kLevelFlagFatal = 0x10;
static const int kLevelFlagError = 0x08;
static const int kLevelFlagWarn  = 0x04;
static const int kLevelFlagInfo  = 0x02;
static const int kLevelFlagDebug = 0x01;

#ifdef NDLLevelFatal
static const int kNDL_LOG_LEVEL = kLevelFlagFatal;
#elif defined(NDLLevelError)
static const int kNDL_LOG_LEVEL = (kLevelFlagFatal | kLevelFlagError);
#elif defined(NDLLevelWarn)
static const int kNDL_LOG_LEVEL = (kLevelFlagFatal | kLevelFlagError | kLevelFlagWarn);
#elif defined(NDLLevelInfo)
static const int kNDL_LOG_LEVEL = (kLevelFlagFatal | kLevelFlagError | kLevelFlagWarn | kLevelFlagInfo);
#elif defined(NDLLevelDebug)
static const int kNDL_LOG_LEVEL = (kLevelFlagFatal | kLevelFlagError | kLevelFlagWarn | kLevelFlagInfo | kLevelFlagDebug);
#endif

#define log4cplus_fatal(category, logFmt, ...) \
if(kNDL_LOG_LEVEL & kLevelFlagFatal) \
syslog(LOG_CRIT, "%s:" logFmt, category,##__VA_ARGS__); \

#define log4cplus_error(category, logFmt, ...) \
if(kNDL_LOG_LEVEL & kLevelFlagError) \
syslog(LOG_ERR, "%s:" logFmt, category,##__VA_ARGS__); \

#define log4cplus_warn(category, logFmt, ...) \
if(kNDL_LOG_LEVEL & kLevelFlagWarn) \
syslog(LOG_WARNING, "%s:" logFmt, category,##__VA_ARGS__); \

#define log4cplus_info(category, logFmt, ...) \
if(kNDL_LOG_LEVEL & kLevelFlagInfo) \
syslog(LOG_WARNING, "%s:" logFmt, category,##__VA_ARGS__); \

#define log4cplus_debug(category, logFmt, ...) \
if(kNDL_LOG_LEVEL & kLevelFlagDebug) \
syslog(LOG_WARNING, "%s:" logFmt, category,##__VA_ARGS__); \

#else

#define log4cplus_fatal(category, logFmt, ...); \
#define log4cplus_error(category, logFmt, ...); \
#define log4cplus_warn(category, logFmt, ...); \
#define log4cplus_info(category, logFmt, ...); \
#define log4cplus_debug(category, logFmt, ...); \

#endif
#pragma mark -----end-----




#endif /* SystemLog_h */
