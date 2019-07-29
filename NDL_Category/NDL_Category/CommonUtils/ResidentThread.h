//
//  ResidentThread.h
//  NDL_Category
//
//  Created by dzcx on 2019/5/27.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 CFRunLoopRef源码:
 
 // 用DefaultMode启动
 void CFRunLoopRun(void) {
 CFRunLoopRunSpecific(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 1.0e10, false);
 }
 
 /// 用指定的Mode启动，允许设置RunLoop超时时间
 int CFRunLoopRunInMode(CFStringRef modeName, CFTimeInterval seconds, Boolean stopAfterHandle) {
 return CFRunLoopRunSpecific(CFRunLoopGetCurrent(), modeName, seconds, returnAfterSourceHandled);
 }
 
 /// RunLoop的实现
 int CFRunLoopRunSpecific(runloop, modeName, seconds, stopAfterHandle) {
 
 /// 首先根据modeName找到对应mode
 CFRunLoopModeRef currentMode = __CFRunLoopFindMode(runloop, modeName, false);
 /// 如果mode里没有source/timer/observer, 直接返回。
 if (__CFRunLoopModeIsEmpty(currentMode)) return;
 
 /// 1. 通知 Observers: RunLoop 即将进入 loop。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopEntry);
 
 /// 内部函数，进入loop
 __CFRunLoopRun(runloop, currentMode, seconds, returnAfterSourceHandled) {
 
 Boolean sourceHandledThisLoop = NO;
 int retVal = 0;
 do {
 
 /// 2. 通知 Observers: RunLoop 即将触发 Timer 回调。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeTimers);
 /// 3. 通知 Observers: RunLoop 即将触发 Source0 (非port) 回调。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeSources);
 /// 执行被加入的block
 __CFRunLoopDoBlocks(runloop, currentMode);
 
 /// 4. RunLoop 触发 Source0 (非port) 回调。
 sourceHandledThisLoop = __CFRunLoopDoSources0(runloop, currentMode, stopAfterHandle);
 /// 执行被加入的block
 __CFRunLoopDoBlocks(runloop, currentMode);
 
 /// 5. 如果有 Source1 (基于port) 处于 ready 状态，直接处理这个 Source1 然后跳转去处理消息。
 if (__Source0DidDispatchPortLastTime) {
 Boolean hasMsg = __CFRunLoopServiceMachPort(dispatchPort, &msg)
 if (hasMsg) goto handle_msg;
 }
 
 /// 通知 Observers: RunLoop 的线程即将进入休眠(sleep)。
 if (!sourceHandledThisLoop) {
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeWaiting);
 }
 
 /// 7. 调用 mach_msg 等待接受 mach_port 的消息。线程将进入休眠, 直到被下面某一个事件唤醒。
 /// • 一个基于 port 的Source 的事件。
 /// • 一个 Timer 到时间了
 /// • RunLoop 自身的超时时间到了
 /// • 被其他什么调用者手动唤醒
 __CFRunLoopServiceMachPort(waitSet, &msg, sizeof(msg_buffer), &livePort) {
 mach_msg(msg, MACH_RCV_MSG, port); // thread wait for receive msg
 }
 
 /// 8. 通知 Observers: RunLoop 的线程刚刚被唤醒了。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopAfterWaiting);
 
 /// 收到消息，处理消息。
 handle_msg:
 
 /// 9.1 如果一个 Timer 到时间了，触发这个Timer的回调。
 if (msg_is_timer) {
 __CFRunLoopDoTimers(runloop, currentMode, mach_absolute_time())
 }
 
 /// 9.2 如果有dispatch到main_queue的block，执行block。
 else if (msg_is_dispatch) {
 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(msg);
 }
 
 /// 9.3 如果一个 Source1 (基于port) 发出事件了，处理这个事件
 else {
 CFRunLoopSourceRef source1 = __CFRunLoopModeFindSourceForMachPort(runloop, currentMode, livePort);
 sourceHandledThisLoop = __CFRunLoopDoSource1(runloop, currentMode, source1, msg);
 if (sourceHandledThisLoop) {
 mach_msg(reply, MACH_SEND_MSG, reply);
 }
 }
 
 /// 执行加入到Loop的block
 __CFRunLoopDoBlocks(runloop, currentMode);
 
 
 if (sourceHandledThisLoop && stopAfterHandle) {
 /// 进入loop时参数说处理完事件就返回。
 retVal = kCFRunLoopRunHandledSource;
 } else if (timeout) {
 /// 超出传入参数标记的超时时间了
 retVal = kCFRunLoopRunTimedOut;
 } else if (__CFRunLoopIsStopped(runloop)) {
 /// 被外部调用者强制停止了
 retVal = kCFRunLoopRunStopped;
 } else if (__CFRunLoopModeIsEmpty(runloop, currentMode)) {
 /// source/timer/observer一个都没有了
 retVal = kCFRunLoopRunFinished;
 }
 
 /// 如果没超时，mode里没空，loop也没被停止，那继续loop。
 } while (retVal == 0);
 }
 
 /// 10. 通知 Observers: RunLoop 即将退出。
 __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopExit);
 }
 */


/*
 Runloop的机制保证程序的持续运行
 Runloop是事件接收和分发机制的一个实现
 
 Thread 包含一个CFRunloop, 一个CFRunloop 包含一种CFRunloopMode, mode 包含 CFRunloopSource, CFRunloopTimer, CFRunloopObserver
 
 Apple 不允许直接创建Runloop, 它只提供了两个自动获取的函数： CFRunLoopGetMain() 和 CFRunLoopGetCurrent()
 
 你只能在一个线程的内部获取其 RunLoop（主线程除外）
 [NSRunLoop currentRunLoop];方法调用时，会先看一下字典里有没有存子线程相对用的RunLoop，如果有则直接返回RunLoop，如果没有则会创建一个，并将与之对应的子线程存入字典中
 
 一个Runloop包含若干个Mode, 每个Mode又包含若干个Source / Timer / Observer. 每次调用Runloop 的主函数时，只能指定其中一个Mode, 这个Mode被称作 CurrentMode. 如果需要切换Mode, 只能退出Loop, 再重新指定一个Mode进入。这样做主要是为了分隔开不同组的 Source/Timer/Observer, 让其互不影响
 
 kCFRunLoopCommonModes: 这是一个占位用的Mode，作为标记kCFRunLoopDefaultMode和UITrackingRunLoopMode用，并不是一种真正的Mode
 
 Source/Timer/Observer 被统称为 model item， 一个item 可以被同时加入多个 Mode. 但一个item被重复加入同一个mode时是不会有效果的。如果一个mode中一个item都没有，则Runloop会直接退出，不进入循环
 
 int main(int argc, char * argv[]) {
 //程序一直运行状态
 while (AppIsRunning) {
 //睡眠状态，等待唤醒事件
 id whoWakesMe = SleepForWakingUp();
 //得到唤醒事件
 id event = GetEvent(whoWakesMe);
 //开始处理事件
 HandleEvent(event);
 }
 return 0;
 }
 
 GCD 中dispatch到main queue的block会被dispatch到main Runloop中执行
 
 Runloop 源码:
void CFRunLoopRun(void) {
int32_t result;
do {
result = CFRunLoopRunSpecific(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 1.0e10, false);
CHECK_FOR_FORK();
} while (kCFRunLoopRunStopped != result && kCFRunLoopRunFinished != result);
}
 
 
 执行顺序的伪代码:
 int32_t __CFRunLoopRun()
 {
 // 通知即将进入runloop
 __CFRunLoopDoObservers(KCFRunLoopEntry);
 
 do
 {
 // 通知将要处理timer和source
 __CFRunLoopDoObservers(kCFRunLoopBeforeTimers);
 __CFRunLoopDoObservers(kCFRunLoopBeforeSources);
 
 // 处理非延迟的主线程调用
 __CFRunLoopDoBlocks();
 // 处理Source0事件
 __CFRunLoopDoSource0();
 
 if (sourceHandledThisLoop) {
 __CFRunLoopDoBlocks();
 }
 /// 如果有 Source1 (基于port) 处于 ready 状态，直接处理这个 Source1 然后跳转去处理消息。
 if (__Source0DidDispatchPortLastTime) {
 Boolean hasMsg = __CFRunLoopServiceMachPort();
 if (hasMsg) goto handle_msg;
 }
 
 /// 通知 Observers: RunLoop 的线程即将进入休眠(sleep)。
 if (!sourceHandledThisLoop) {
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeWaiting);
 }
 
 // GCD dispatch main queue
 CheckIfExistMessagesInMainDispatchQueue();
 
 // 即将进入休眠
 __CFRunLoopDoObservers(kCFRunLoopBeforeWaiting);
 
 // 等待内核mach_msg事件
 mach_port_t wakeUpPort = SleepAndWaitForWakingUpPorts();
 
 // 等待。。。
 
 // 从等待中醒来
 __CFRunLoopDoObservers(kCFRunLoopAfterWaiting);
 
 // 处理因timer的唤醒
 if (wakeUpPort == timerPort)
 __CFRunLoopDoTimers();
 
 // 处理异步方法唤醒,如dispatch_async
 else if (wakeUpPort == mainDispatchQueuePort)
 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__()
 
 // 处理Source1
 else
 __CFRunLoopDoSource1();
 
 // 再次确保是否有同步的方法需要调用
 __CFRunLoopDoBlocks();
 
 } while (!stop && !timeout);
 
 // 通知即将退出runloop
 __CFRunLoopDoObservers(CFRunLoopExit);
 }
 
 ===============================
 CFRunLoopSourceRef
 Source分为两种:
 Source0：非基于Port的 用于用户主动触发的事件（点击button 或点击屏幕）
 Source1：基于Port的 通过内核和其他线程相互发送消息（与内核相关）
 注意：Source1在处理的时候会分发一些操作给Source0去处理
 
 ===============================
 CFRunLoopTimer:
 NSTimer是对RunLoopTimer的封装
 
 + (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;
 + (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;
 
 - (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay inModes:(NSArray *)modes;
 
 + (CADisplayLink *)displayLinkWithTarget:(id)target selector:(SEL)sel;
 - (void)addToRunLoop:(NSRunLoop *)runloop forMode:(NSString *)mode;

 ===============================
 CFRunLoopObserverRef:
 CFRunLoopObserverRef是观察者，能够监听RunLoop的状态改变
 
 ===============================
 启动Runloop的时候可以设置什么时候停止。
 [NSRunLoop currentRunLoop]runUntilDate:<#(nonnull NSDate *)#>
 [NSRunLoop currentRunLoop]runMode:<#(nonnull NSString *)#> beforeDate:<#(nonnull NSDate *)#>
 
 */

// 给RunLoop添加监听者，监听其运行状态:
// -(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
// {
// //创建监听者
// /*
// 第一个参数 CFAllocatorRef allocator：分配存储空间 CFAllocatorGetDefault()默认分配
// 第二个参数 CFOptionFlags activities：要监听的状态 kCFRunLoopAllActivities 监听所有状态
// 第三个参数 Boolean repeats：YES:持续监听 NO:不持续
// 第四个参数 CFIndex order：优先级，一般填0即可
// 第五个参数 ：回调 两个参数observer:监听者 activity:监听的事件
// */
///*
// 所有事件
// typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
// kCFRunLoopEntry = (1UL << 0),   //   即将进入RunLoop
// kCFRunLoopBeforeTimers = (1UL << 1), // 即将处理Timer
// kCFRunLoopBeforeSources = (1UL << 2), // 即将处理Source
// kCFRunLoopBeforeWaiting = (1UL << 5), //即将进入休眠
// kCFRunLoopAfterWaiting = (1UL << 6),// 刚从休眠中唤醒
// kCFRunLoopExit = (1UL << 7),// 即将退出RunLoop
// kCFRunLoopAllActivities = 0x0FFFFFFFU
// };
// */
//CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//    switch (activity) {
//        case kCFRunLoopEntry:
//            NSLog(@"RunLoop进入");
//            break;
//        case kCFRunLoopBeforeTimers:
//            NSLog(@"RunLoop要处理Timers了");
//            break;
//        case kCFRunLoopBeforeSources:
//            NSLog(@"RunLoop要处理Sources了");
//            break;
//        case kCFRunLoopBeforeWaiting:
//            NSLog(@"RunLoop要休息了");
//            break;
//        case kCFRunLoopAfterWaiting:
//            NSLog(@"RunLoop醒来了");
//            break;
//        case kCFRunLoopExit:
//            NSLog(@"RunLoop退出了");
//            break;
//
//        default:
//            break;
//    }
//});
//
//// 给RunLoop添加监听者
///*
// 第一个参数 CFRunLoopRef rl：要监听哪个RunLoop,这里监听的是主线程的RunLoop
// 第二个参数 CFRunLoopObserverRef observer 监听者
// 第三个参数 CFStringRef mode 要监听RunLoop在哪种运行模式下的状态
// */
//CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
///*
// CF的内存管理（Core Foundation）
// 凡是带有Create、Copy、Retain等字眼的函数，创建出来的对象，都需要在最后做一次release
// GCD本来在iOS6.0之前也是需要我们释放的，6.0之后GCD已经纳入到了ARC中，所以我们不需要管了
// */


/*
 系统就是通过@autoreleasepool {}这种方式来为我们创建自动释放池的，一个线程对应一个runloop，系统会为每一个runloop隐式的创建一个自动释放池，所有的autoreleasePool构成一个栈式结构，在每个runloop结束时，当前栈顶的autoreleasePool会被销毁，而且会对其中的每一个对象做一次release（严格来说，是你对这个对象做了几次autorelease就会做几次release，不一定是一次)，特别指出，使用容器的block版本的枚举器的时候，系统会自动添加一个autoreleasePool
 
 [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
 // 这里被一个局部@autoreleasepool包围着
 }];
 */

/*
 Event_loop:
 
 function do_loop() {
 initialize();
 do {
 var message = get_next_message();
 process_message(message);
 } while (message != quit);
 }
 开启一个循环，保证线程不退出，这就是Event_loop模型
 */

// 常驻线程
NS_ASSUME_NONNULL_BEGIN

typedef void(^TaskBlock)(void);

@interface ResidentThread : NSObject

// 不会销毁
+ (void)executeTask:(TaskBlock)taskBlock;

// 不会销毁
+ (void)executeTask:(TaskBlock)taskBlock identity:(NSString *)identity;

// 线程随当前对象销毁
- (void)executeTask:(TaskBlock)taskBlock;

@end

NS_ASSUME_NONNULL_END

/*
 当调用 NSObject 的 performSelecter:afterDelay: 后，实际上其内部会创建一个 Timer 并添加到当前线程的 RunLoop 中。所以如果当前线程没有 RunLoop，则这个方法会失效。
 当调用 performSelector:onThread: 时，实际上其会创建一个 Timer 加到对应的线程去，同样的，如果对应线程没有 RunLoop 该方法也会失效
 */

/*
 事件响应和手势识别底层处理:
 事件响应：
 苹果注册了一个 Source1 (基于 mach port 的) 用来接收系统事件，其回调函数为 __IOHIDEventSystemClientQueueCallback()。
 当一个硬件事件(触摸/锁屏/摇晃等)发生后，首先由 IOKit.framework 生成一个 IOHIDEvent 事件并由 SpringBoard 接收。SpringBoard 只接收按键(锁屏/静音等)，触摸，加速，接近传感器等几种 Event，随后用 mach port 转发给需要的App进程。随后苹果注册的那个 Source1 就会触发回调，并调用 _UIApplicationHandleEventQueue() 进行应用内部的分发。
 _UIApplicationHandleEventQueue() 会把 IOHIDEvent 处理并包装成 UIEvent 进行处理或分发，其中包括识别 UIGesture/处理屏幕旋转/发送给 UIWindow 等。通常事件比如 UIButton 点击、touchesBegin/Move/End/Cancel 事件都是在这个回调中完成的
 
 手势识别：
 当上面的 _UIApplicationHandleEventQueue() 识别了一个手势时，其首先会调用 Cancel 将当前的 touchesBegin/Move/End 系列回调打断。随后系统将对应的 UIGestureRecognizer 标记为待处理。
 苹果注册了一个 Observer 监测 BeforeWaiting (Loop即将进入休眠) 事件，这个Observer的回调函数是 _UIGestureRecognizerUpdateObserver()，其内部会获取所有刚被标记为待处理的 GestureRecognizer，并执行GestureRecognizer的回调。
 当有 UIGestureRecognizer 的变化(创建/销毁/状态改变)时，这个回调都会进行相应处理
 */

/*
 AFNetworking:
 
 + (void)networkRequestThreadEntryPoint:(id)__unused object {
 @autoreleasepool {
 [[NSThread currentThread] setName:@"AFNetworking"];
 NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
 [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
 [runLoop run];
 }
 }
 
 + (NSThread *)networkRequestThread {
 static NSThread *_networkRequestThread = nil;
 static dispatch_once_t oncePredicate;
 dispatch_once(&oncePredicate, ^{
 _networkRequestThread =
 [[NSThread alloc] initWithTarget:self
 selector:@selector(networkRequestThreadEntryPoint:)
 object:nil];
 [_networkRequestThread start];
 });
 
 return _networkRequestThread;
 }
 */


/*
 TableView中实现平滑滚动延迟加载图片:
 利用CFRunLoopMode的特性，可以将图片的加载放到NSDefaultRunLoopMode的mode里，这样在滚动UITrackingRunLoopMode这个mode时不会被加载而影响到。
 
 UIImage *downloadedImage = ...;
 [self.imageView performSelector:@selector(setImage:)
 withObject:downloadedImage
 afterDelay:0
 inModes:@[NSDefaultRunLoopMode]];
 */
