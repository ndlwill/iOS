//
//  TestLG_ThreadViewController.m
//  NDL_Category
//
//  Created by ndl on 2020/3/1.
//  Copyright © 2020 ndl. All rights reserved.
//

#import "TestLG_ThreadViewController.h"
#import <pthread.h>
#import <libkern/OSAtomic.h>

typedef NS_ENUM(NSUInteger, LockType) {
    LockTypeOSSpinLock = 0,
    LockTypedispatch_semaphore,
    LockTypepthread_mutex,
    LockTypeNSCondition,
    LockTypeNSLock,
    LockTypepthread_mutex_recursive,
    LockTypeNSRecursiveLock,
    LockTypeNSConditionLock,
    LockTypesynchronized,
    LockTypeCount,
};

NSTimeInterval TimeCosts[LockTypeCount] = {0};
int TimeCount = 0;

@interface TestLG_ThreadViewController ()

@end

// 栈区／常量区的内存操作也挺快. 堆区的内存操作有点慢
// https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1529488045873&di=7c1cc40bec638406ef48717386a08094&imgtype=0&src=http%3A%2F%2Fpic2.ooopic.com%2F12%2F46%2F41%2F95bOOOPIC74_1024.jpg
@implementation TestLG_ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
    pthread_create 创建线程
    参数：
    1. pthread_t：要创建线程的结构体指针，通常开发的时候，如果遇到 C 语言的结构体，类型后缀 `_t / Ref` 结尾
    同时不需要 `*`
    2. 线程的属性，nil(空对象 - OC 使用的) / NULL(空地址，0 ,C 使用的)
    3. 线程要执行的`函数地址`
    void *: 返回类型，表示指向任意对象的指针，和 OC 中的 id 类似
    (*): 函数名
    (void *): 参数类型，void *
    4. 传递给第三个参数(函数)的`参数`
    
    返回值：C 语言框架中非常常见
    int
    0          创建线程成功！成功只有一种可能
    非 0       创建线程失败的错误码，失败有多种可能！
    */
    
    // 1: pthread
    pthread_t threadId = NULL;
    //c字符串
    char *cString = "HelloCode";
    //    NSString *ocString = @"Gavin";
    //延伸到: OC--C的混编 尤其在智能家居,SDK封装
    //抛出一个问题: 在ARC需要这样操作,在MRC不需要
    // OC prethread -- 跨平台
    // 锁
    int result = pthread_create(&threadId, NULL, pthreadTest, cString);
    if (result == 0) {
        NSLog(@"成功");
    } else {
        NSLog(@"失败");
    }
    
    
    NSInteger count = 1000 * 100;
    for (NSInteger i = 0; i < count; i++) {
        // 栈区
        NSInteger num = i;
        // 常量区
        NSString *name = @"zhang";
        // 堆区
        NSString *myName = [NSString stringWithFormat:@"%@ - %zd", name, num];
        NSLog(@"%@", myName);
    }
}

void *pthreadTest(void *para){
    // 接 C 语言的字符串
    //    NSLog(@"===> %@ %s", [NSThread currentThread], para);
    // __bridge 将 C 语言的类型桥接到 OC 的类型
    NSString *name = (__bridge NSString *)(para);
    
    NSLog(@"===>%@ %@", [NSThread currentThread], name);
    
    return NULL;
}

- (IBAction)clearAllData:(id)sender {
    for (NSUInteger i = 0; i < LockTypeCount; i++) {
        TimeCosts[i] = 0;
    }
    TimeCount = 0;
    printf("---- clear ----\n\n");
}

- (void)test:(int)count {
    NSTimeInterval begin, end;
    TimeCount += count;
    
    {
        // 不再安全的 OSSpinLock  除此dispatch_semaphore 和 pthread_mutex 性能是最高的
        OSSpinLock lock = OS_SPINLOCK_INIT;
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            OSSpinLockLock(&lock);
            OSSpinLockUnlock(&lock);
        }
        end = CACurrentMediaTime();
        TimeCosts[LockTypeOSSpinLock] += end - begin;
        printf("OSSpinLock:               %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        // 同步 ---
        // > 0
        // GCD 控制并发数
        
        
        dispatch_semaphore_t lock =  dispatch_semaphore_create(2);
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            
            dispatch_semaphore_signal(lock);
        }
        end = CACurrentMediaTime();
        TimeCosts[LockTypedispatch_semaphore] += end - begin;
        printf("dispatch_semaphore:       %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        pthread_mutex_t lock;
        pthread_mutex_init(&lock, NULL);
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            pthread_mutex_lock(&lock);
            pthread_mutex_unlock(&lock);
        }
        end = CACurrentMediaTime();
        TimeCosts[LockTypepthread_mutex] += end - begin;
        pthread_mutex_destroy(&lock);
        printf("pthread_mutex:            %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        NSCondition *lock = [NSCondition new];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        TimeCosts[LockTypeNSCondition] += end - begin;
        printf("NSCondition:              %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        NSLock *lock = [NSLock new];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        TimeCosts[LockTypeNSLock] += end - begin;
        printf("NSLock:                   %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        pthread_mutex_t lock;
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&lock, &attr);
        pthread_mutexattr_destroy(&attr);
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            pthread_mutex_lock(&lock);
            pthread_mutex_unlock(&lock);
        }
        end = CACurrentMediaTime();
        TimeCosts[LockTypepthread_mutex_recursive] += end - begin;
        pthread_mutex_destroy(&lock);
        printf("pthread_mutex(recursive): %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        NSRecursiveLock *lock = [NSRecursiveLock new];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        TimeCosts[LockTypeNSRecursiveLock] += end - begin;
        printf("NSRecursiveLock:          %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:1];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        TimeCosts[LockTypeNSConditionLock] += end - begin;
        printf("NSConditionLock:          %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        NSObject *lock = [NSObject new];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            @synchronized(lock) {}
        }
        end = CACurrentMediaTime();
        TimeCosts[LockTypesynchronized] += end - begin;
        printf("@synchronized:            %8.2f ms\n", (end - begin) * 1000);
    }
    
    printf("---- fin (%d) ----\n\n",count);
}

@end
