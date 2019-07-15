//
//  ResidentThread.m
//  NDL_Category
//
//  Created by dzcx on 2019/5/27.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "ResidentThread.h"
#import "DebugThread.h"

@interface ResidentThread ()

@property (nonatomic, weak) DebugThread *thread;
@property (nonatomic, assign) BOOL shouldKeepRunning;

@end

@implementation ResidentThread

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
            [NSThread currentThread].name = @"NDL_ResidentThread_With_Stop";
            NSRunLoop *curRL = [NSRunLoop currentRunLoop];
            [curRL addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
            
        }
    };
    
    self.shouldKeepRunning = YES;
    if (@available(iOS 10.0, *)) {
        debugThread = [[DebugThread alloc] initWithBlock:threadBlock];
    } else {
        debugThread = [[DebugThread alloc] initWithTarget:self selector:@selector(threadTask:) object:threadBlock];
    }
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
