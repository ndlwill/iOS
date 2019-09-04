//
//  TestTimerViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/24.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestTimerViewController.h"
#import "NSTimer+Block.h"
#import <UIImageView+WebCache.h>

@interface TestTimerViewController ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIView *frontView;
@property (nonatomic, strong) UIView *backView;

@end

@implementation TestTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    /*
    // strong (self.timer): NO, YES, self.timer(NO, YES)
    // weak (self.timer): NO 崩溃，YES (self.timer retainCount= 3, 2)
    NSLog(@"self retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));// 12, 12
    // 不调[self.timer invalidate]; self.timer = nil;的情况下
    // repeat: NO self可以被释放
    // repeat: YES self不可以被释放
    // repeat: If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires
    // target: The object to which to send the message specified by aSelector when the timer fires. The timer maintains a strong reference to target until it (the timer) is invalidated
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate:) userInfo:nil repeats:YES];
    NSLog(@"self retainCount = %ld timer = %ld", CFGetRetainCount((__bridge CFTypeRef)(self)), CFGetRetainCount((__bridge CFTypeRef)(self.timer)));// 13, 14 - 4, 4
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"self retainCount = %ld timer = %ld", CFGetRetainCount((__bridge CFTypeRef)(self)), CFGetRetainCount((__bridge CFTypeRef)(self.timer)));// 6, 7 - 2, 3
    });
     */
    
    // 检测内存泄漏: Tecent的 MLeakFinder
    // MARK:###使用weakSelf还是会vc不能释放，target还是会强引用weakSelf指向的vc，vc的引用计数+1(相当于__strong typeof(self) strongSelf = weakSelf)。而block中的weakSelf，被block截获后，block结构体内部会加入一个weakSelf的变量，self（vc）的引用计数不变(vc->block->weakSelf)###
    // target:self runloop->(强引用)timer->vc  造成vc不能释放，不是循环引用，而是timer强引用vc
    // 解决方案:
    // 1.消息转发(代理类NSProxy弱引用vc) 这样vc就可以释放了，然后在vc dealloc中写[self.timer invalidate]; self.timer = nil;释放timer
    // 2.引入第三者类，打破强引用, class_addMethod
    // 3.封装NSTimer的分类，提供block形式
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer ndl_blockScheduledTimerWithTimeInterval:1.0 block:^{
        [weakSelf doSomething];
    } repeats:YES];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    contentView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:contentView];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 15, 60, 70)];
    self.backView.backgroundColor = [UIColor greenColor];
    [contentView addSubview:self.backView];
    
    self.frontView = [[UIView alloc] initWithFrame:CGRectMake(20, 15, 60, 70)];
    self.frontView.backgroundColor = [UIColor redColor];
    [contentView addSubview:self.frontView];
    
    
    // MARK:performSelector
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiTest) name:@"Noti" object:nil];
    
    // performSelector:1-3-test
    // postNotificationName:在主线程 1-notiTest(main thread)-3
    // postNotificationName:在子线程 1-[notiTest(子thread),3 顺序不定]
    NSLog(@"1");
    [self performSelector:@selector(test) withObject:nil afterDelay:0.0];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"Noti" object:nil];
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"Noti" object:nil];
    //    });
    NSLog(@"3");
    
    // test1没被调用，子线程中runloop默认没有开启。
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 如果[[NSRunLoop currentRunLoop] run]放在前面，这句代码只是尝试开启线程的runloop，如果该线程中并没有任何事件（source，timer，observer），并不会成功的开启
        // This method sets up a timer to perform the aSelector message on the current thread’s run loop
        [self performSelector:@selector(test1) withObject:nil afterDelay:2.0];
        [[NSRunLoop currentRunLoop] run];// 这样test1才会执行 这句代码必须放在后面
        //        NSLog(@"runloop = %@", [NSRunLoop currentRunLoop]);
    });
    
    
    /*
     [self performSelector:@selector(test) withObject:nil afterDelay:0];这种调用方式，不能简单的认为是犯了低级错误，当我们不需要返回值的时候，按照官方文档的建议，我们可以用performSelectorOnMainThread,也可以用[self performSelector:@selector(test) withObject:nil afterDelay:0];
     */
    // 11-22没有test11，同上
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //        NSLog(@"11");
    //        [self performSelector:@selector(test11) withObject:nil afterDelay:0];
    //        NSLog(@"22");
    //    });
    
    /*
     performSelector:withObject: 是在 NSObject 中定义的；
     [self performSelector:@selector(test) withObject:nil] 会在底层转换为 objcMsgSend(self, @selector(test))
     */
}

- (void)notiTest
{
    NSLog(@"notiTest curThread = %@", [NSThread currentThread]);
}

- (void)test11
{
    NSLog(@"test11");
}

- (void)test
{
    // main
    NSLog(@"test currentThread = %@", [NSThread currentThread]);
}

- (void)test1
{
    // 子线程
    NSLog(@"test1 currentThread = %@", [NSThread currentThread]);
}



// ========================
- (void)doSomething
{
    NSLog(@"doSomething");
}

- (void)timerUpdate:(NSTimer *)timer
{
    NSLog(@"timerUpdate");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"TestTimerViewController before dismisss");
//    });
    
    
    // MARK:fromView和toView需要添加到同一个父view上，这样才会让父view翻转
//    [UIView transitionFromView:self.frontView toView:self.backView duration:3.0 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
//
//    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"===TestTimerViewController dealloc===");
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


@end
