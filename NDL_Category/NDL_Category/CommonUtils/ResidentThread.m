//
//  ResidentThread.m
//  NDL_Category
//
//  Created by dzcx on 2019/5/27.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "ResidentThread.h"
#import "DebugThread.h"

static DebugThread *commonThread_;
static NSMutableDictionary *threadDic_;

@interface ResidentThread ()

@property (nonatomic, weak) DebugThread *thread;
@property (nonatomic, assign) BOOL shouldKeepRunning;

@end

@implementation ResidentThread

+ (void)executeTask:(TaskBlock)taskBlock
{
    if (!taskBlock) {
        return;
    }
    
    if (!commonThread_) {
        void (^commonThreadBlock)(void) = ^ {
            NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
            [currentRunLoop addPort:[NSPort new] forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
            while (1) {
                [currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        };
        if (@available(iOS 10.0, *)) {
            commonThread_ = [[DebugThread alloc] initWithBlock:commonThreadBlock];
        } else {
            commonThread_ = [[DebugThread alloc] initWithTarget:self selector:@selector(classThreadTask:) object:commonThreadBlock];
        }
        [commonThread_ start];
    }
    [self performSelector:@selector(actualClassThreadTask:) onThread:commonThread_ withObject:taskBlock waitUntilDone:NO];
}

+ (void)executeTask:(TaskBlock)taskBlock identity:(NSString *)identity
{
    if (!taskBlock || !identity || identity.length == 0) {
        return;
    }
    
    if (!threadDic_) {
        threadDic_ = [NSMutableDictionary dictionary];
    }
    
    DebugThread *valueThread = [threadDic_ objectForKey:identity];
    if (!valueThread) {
        void (^classThreadBlock)(void) = ^ {
            CFRunLoopSourceContext content = {0};
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &content);
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            CFRelease(source);
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
        };
        
        if (@available(iOS 10.0, *)) {
            valueThread = [[DebugThread alloc] initWithBlock:classThreadBlock];
        } else {
            valueThread = [[DebugThread alloc] initWithTarget:self selector:@selector(classThreadTask:) object:classThreadBlock];
        }
        [valueThread start];
    }
    [self performSelector:@selector(actualClassThreadTask:) onThread:valueThread withObject:taskBlock waitUntilDone:NO];
}

+ (void)classThreadTask:(void (^)(void))block
{
    block();
}

+ (void)actualClassThreadTask:(TaskBlock)taskBlock
{
    taskBlock ? taskBlock() : nil;
}

#pragma mark - init
- (instancetype)init
{
    if (self = [super init]) {
        [self _createThread];
    }
    return self;
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"=====ResidentThread dealloc=====");
    if (self.thread) {
        // 必须执行，不然线程DebugThread没被销毁
        [self performSelector:@selector(stopRunLoop) onThread:self.thread withObject:nil waitUntilDone:YES];
    }
}

#pragma mark - private instance methods
- (void)_createThread
{
    DebugThread *debugThread = nil;
    
    __weak typeof(self) weakSelf = self;
    void (^threadBlock)(void) = ^ {
        @autoreleasepool {
            NSLog(@"=====threadBlock=====");
//            [NSThread currentThread].name = @"NDL_ResidentThread_With_Stop";
            NSRunLoop *curRL = [NSRunLoop currentRunLoop];
            [curRL addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
            // 不写下面代码（保活线程），线程=====DebugThread dealloc=====
            while (weakSelf.shouldKeepRunning) {
                NSLog(@"===shouldKeepRunning = YES===");// shouldKeepRunning = YES,执行一次task这边走一次
                [curRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }
    };
    
    self.shouldKeepRunning = YES;
    if (@available(iOS 10.0, *)) {
        debugThread = [[DebugThread alloc] initWithBlock:threadBlock];
    } else {
        debugThread = [[DebugThread alloc] initWithTarget:self selector:@selector(threadTask:) object:threadBlock];
    }
    debugThread.name = @"NDL_ResidentThread_With_Stop";
    self.thread = debugThread;
    [self.thread start];
}

- (void)actualThreadTask:(void (^)(void))task
{
    task ? task() : nil;
}

- (void)stopRunLoop
{
    self.shouldKeepRunning = NO;
    CFRunLoopStop(CFRunLoopGetCurrent());
}

#pragma mark - target_selector
- (void)threadTask:(void (^)(void))task
{
    task();
}

#pragma mark - public instance methods
- (void)executeTask:(TaskBlock)taskBlock
{
    if (!taskBlock || !self.thread) {
        return;
    }
    
    [self performSelector:@selector(actualThreadTask:) onThread:self.thread withObject:taskBlock waitUntilDone:NO];
}

@end
