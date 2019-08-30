//
//  NSTimer+Block.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/25.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "NSTimer+Block.h"

@implementation NSTimer (Block)

+ (NSTimer *)ndl_blockScheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats
{
    NSTimer *timer = [self timerWithTimeInterval:interval target:self selector:@selector(blockSelector:) userInfo:[block copy] repeats:repeats];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}

+ (void)blockSelector:(NSTimer *)timer
{
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
