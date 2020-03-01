//
//  MyOperation.m
//  NDL_Category
//
//  Created by ndl on 2019/11/16.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "MyOperation.h"

@implementation MyOperation

// 要执行的任务
- (void)main
{
    NSLog(@"MyOperation current_thread = %@", [NSThread currentThread]);
    
    //耗时操作1
    for (int i = 0; i<1000; i++) {
        // 一般不会将判断放在耗时操作里面，判断多次，耗费性能
        // if(self.isCancelled) return;
        NSLog(@"任务1-%d--%@",i,[NSThread currentThread]);
    }
    
    // ###苹果官方建议，每当执行完一次耗时操作之后，就查看一下当前队列是否为取消状态，如果是，那么就直接退出,以此提高程序的性能###
    if(self.isCancelled) return;
    
    NSLog(@"+++++++++++++++++++++++++++++++++");
    
    //耗时操作2
    for (int i = 0; i<1000; i++) {
        NSLog(@"任务2-%d--%@",i,[NSThread currentThread]);
    }

    if(self.isCancelled) return;
    
    NSLog(@"+++++++++++++++++++++++++++++++++");
    
    //耗时操作3
    for (int i = 0; i<1000; i++) {
        NSLog(@"任务3-%d--%@",i,[NSThread currentThread]);
    }
}

@end
