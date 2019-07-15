//
//  XLogManager.m
//  NDL_Category
//
//  Created by dzcx on 2019/5/24.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "XLogManager.h"
#import <mars/xlog/appender.h>
#import <mars/xlog/xlogger.h>
#import <mars/xlog/xloggerbase.h>
#import <sys/xattr.h>

/*
 现如今、几乎所有的操作系统在管理内存的时候，基本采用了页式管理的策略。即将连续的内存空间（注意空间，不是地址）换成了一个个页式大小。这样的好处有几点:
 1.按页这种大小进行管理、可以有效的减少内存碎片的粒度。
 2.按页加载，可以充分利用磁盘上的交换空间，使得程序使用的空间能大大超过内存限制
 iOS设备上不存在交换空间，但是也依然按照页式结构进行内存管理
 
 为什么写磁盘会慢?
 我们一般会把内存中的数据进行持久化储存到磁盘上。但是写入磁盘并不是你想写就立刻写的，数据是通过flush的方式从内存写回到磁盘，一般有如下几种情况:
 1.通过页的flag标记为有改动，操作系统定时将这种脏页写回到磁盘上，时机不可控。
 2##.调用用户态的写接口->触发内核态的sys_write->文件系统将数据写回磁盘。
 
 2##其包含两个非常明显的问题: (1)文件系统处于效率不会立刻将数据写回到磁盘（比如磁道寻址由于机械操作的原因相对非常耗时），而是以Block块的形式缓存在队列中，经过排序、合并到达一定比例之后再写回磁盘。
 (2)这种方式在将数据写回到磁盘时，需要经历两次拷贝。一次是把数据从用户态拷贝到内核态，需要经历上下文切换；还有一次是内核空间到硬盘上真正的数据拷贝。当切换次数过于频繁，整体性能也会下降
 
 xlog采用了mmap的方案进行日志系统的设计:
 mmap是使用逻辑内存对磁盘文件进行映射，中间只是进行映射没有任何拷贝操作，避免了写文件的数据拷贝。操作内存就相当于在操作文件，避免了内核空间和用户空间的频繁切换
 使用mmap还能保证日志的完整性，因为如下这些情况下会自动回写磁盘:
 内存不足
 进程 crash
 调用 msync 或者 munmap
 不设置 MAP_NOSYNC 情况下 30s-60s(仅限FreeBSD)
 */

// 整个日志的主要策略就是利用mmap将日志写入到磁盘映射上，当超过三分之一的时候通知异步线程去写日志
/*
 mmap （一种内存映射文件的方法）:
 mmap将一个文件或者其它对象映射进内存。文件被映射到多个页上，如果文件的大小不是所有页的大小之和，最后一个页不被使用的空间将会清零。mmap在用户空间映射调用系统中作用很大。
 头文件 <sys/mman.h>
 void* mmap(void* start,size_t length,int prot,int flags,int fd,off_t offset);
 int munmap(void* start,size_t length);
 mmap()必须以PAGE_SIZE为单位进行映射
 而内存也只能以页为单位进行映射，若要映射非PAGE_SIZE整数倍的地址范围，要先进行内存对齐，强行以PAGE_SIZE的倍数大小进行映射
 mmap()系统调用使得进程之间通过映射同一个普通文件实现共享内存。
 普通文件被映射到进程地址空间后，进程可以像访问普通内存一样对文件进行访问，不必再调用read()，write（）等操作
 */
@implementation XLogManager

 /*
 解压解密日志文件:
 1.下载https://github.com/yann2192/pyelliptic/releases/tag/1.5.7
 并解压执行：python setup.py install
 2.在 mars\log\crypt 下执行python gen_key.py 如果能生成成功则表示配置成功。 python gen_key.py会生成private key 和public key,把pulic key作为appender_open 函数参数设置进去，private key务必保存在安全的位置，防止泄露。并把这两个key设置到 mars\log\crypt 中 decode_mars_crypt_log_file.py脚本中
 3.日志解压方法：
 cd到/mars-master/mars/log/crypt
 python + python解压脚本 + .xlog文件
 =>生成.log文件
 
 解压脚本:
 解压未加密文件：decode_mars_nocrypt_log_file.py
 解压加密文件：decode_mars_crypt_log_file.py
 */
+ (void)openWithLogDirName:(NSString *)logDirName
             logNamePrefix:(NSString *)logNamePrefix
{
    NSString* marsLogPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:logDirName];
    NSLog(@"marsLogPath = %@", marsLogPath);
    // 不备份日志路径
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    setxattr([marsLogPath UTF8String], attrName, &attrValue, sizeof(attrValue), 0, 0);

#if DEBUG
    xlogger_SetLevel(kLevelDebug);
    appender_set_console_log(true);
#else
    xlogger_SetLevel(kLevelInfo);
    appender_set_console_log(false);
#endif
    // pubkey设置后才会对日志进行加密，若Debug模式下不希望加密，可以设置空""，pubkey在decode_mars_crypt_log_file.py脚本中
    appender_open(kAppednerAsync, [marsLogPath UTF8String], [logNamePrefix UTF8String], "");
}

//+ (void)logWithLevel:(XLogLevel)level format:(NSString *)format, ... {
//    if ([self shouldLogWithLevel:level]) {
//        XLoggerInfo info;
//        info.level = (TLogLevel)level;
//
//        va_list args;
//        va_start(args, format);
//        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
//        va_end(args);
//
//        va_start(args, format);
//        xlogger_Write(&info, [message UTF8String]);
//        va_end(args);
//    }
//}
//
//+ (void)logWithLevel:(XLogLevel)level string:(NSString *)string
//{
//    if ([self shouldLogWithLevel:level]) {
//        XLoggerInfo info;
//        info.level = (TLogLevel)level;
//        xlogger_Write(&info, [string UTF8String]);
//    }
//}

+ (void)logWithLevel:(XLogLevel)level
          moduleName:(NSString *)moduleName
            fileName:(NSString *)fileName
          lineNumber:(int)lineNumber
            funcName:(const char *)funcName format:(NSString *)format, ... {
    if ([self shouldLogWithLevel:level]) {
        XLoggerInfo info;
        info.level = (TLogLevel)level;
        info.tag = [moduleName UTF8String];
        info.filename = [fileName UTF8String];
        info.func_name = funcName;
        info.line = lineNumber;
        gettimeofday(&info.timeval, NULL);
        info.pid = xlogger_pid();
        info.tid = xlogger_tid();
        info.maintid = xlogger_maintid();
        
        va_list args;
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        va_start(args, format);
        xlogger_Write(&info, [message UTF8String]);
        va_end(args);
    }
}

+ (void)flushLog:(void(^)(void))finishBlock
{
    [self logWithLevel:XLogLevelInfo moduleName:@"Manager" fileName:NSStringFromClass([self class]) lineNumber:__LINE__ funcName:__FUNCTION__ format:@"====================flush===================="];
    appender_flush();
    finishBlock();
}

// Max alive duration of a single log file in seconds, default is 10 days
// 60 * 60 * 24 = 1day
+ (void)setLogAliveDuration:(long)aliveDuration
{
    appender_set_max_alive_duration(aliveDuration);
}

+ (void)close
{
    // appender: 附加器
    appender_close();
}

#pragma mark - private class methods
+ (BOOL)shouldLogWithLevel:(XLogLevel)level
{
    if ((TLogLevel)level >= xlogger_Level()) {
        NSLog(@"=====start write=====");
        return YES;
    }
    return NO;
}

@end
