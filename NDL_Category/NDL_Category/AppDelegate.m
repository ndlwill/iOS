//
//  AppDelegate.m
//  NDL_Category
//
//  Created by ndl on 2017/9/14.
//  Copyright © 2017年 ndl. All rights reserved.
//

// ===导航栏===
// https://www.jianshu.com/p/859a1efd2bbf

// ===bytedance大神=== 优化
// https://blog.csdn.net/Hello_Hwc
// https://github.com/LeoMobileDeveloper/Blogs
// 这种一对多的消息通知关系，用总线设计模式可以完美解决
// https://github.com/LeoMobileDeveloper/QTEventBus
/*
 NotificationCenter的通信方式在完全松耦合的场景下是很适用的：发送者不用关心接收者，发送者和接受者统一按照JSON等协议通信
 业务层代码的通信需要松耦合，因为两个业务通常是独立开发迭代，通信按照指定协议即可，不可能开发的时候强制要import另一个业务代码进来
 像登录这种基础服务代码，本质上不属于业务，开发的时候往往需要import对应的framework进来，这时候强类型的通信方式往往更好
 和基础服务代码通信的频率要远高于业务之间通信，甚至业务之间的通信很多时候也可以沉入到Service层
 事件总线:
 总线本质上是”发布-订阅”这种消息范式：订阅者不关心消息由谁发送；接收者也不关系消息由谁接收。
 总线是为了解决模块或者类之间消息通信而存在的
 1.定义事件
 用类名来区分事件，从而实现强类型：订阅者subscribe类名，发布者dispatch类。
 用字符串eventType来对类事件进行二级划分，从而实现弱类型
 
 事件是用类来定义的，所以接口不难定义:
 @interface QTEventBus : NSObject
 - (...)on:(Class)eventClass; //订阅事件
 - (void)dispatch:(id<QTEvent>)event; //发布事件
 @end
 
 
 iOS编译:
 https://blog.csdn.net/Hello_Hwc/article/details/85226147
 */

// ===转场动画===
// https://blog.csdn.net/qq_19678579/article/details/51519757
// https://github.com/Yalantis/StarWars.iOS

// FRDModuleManager: AppDelegate瘦身 for组件化

// Q·i Share
// https://www.jianshu.com/u/3db23baa08c7

// 数据结构
// https://blog.51cto.com/9291927/category25.html
/*
 逻辑结构:
 集合结构：数据元素之间没有特别的关系，仅同属相同集合。
 线性结构：数据元素间是一对一的关系
 树形结构：数据元素间存在一对多的层次关系
 图形结构：数据元素之间是多对多的关系
 
 物理结构:
 物理结构是逻辑结构在计算机中存储形式，分为顺序存储结构和链式存储结构。
 顺序存储结构将数据存储在地址连续的存储单元里。
 链式存储结构将数据存储在任意的存储单元里，通过保存地址的方式找到相关联的数据元素
 
 O（2）==>O（1）
 O（3n+3）==> O（3n）==>O（n）
 O（3n^2+n+4）==>O（n^2）
 
 S（n）表示算法的空间复杂度
 
 通常情况下，算法的时间复杂度更受关注。可以通过增加额外空间降低时间复杂度
 */

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "NSString+DirPath.h"
#import "Aspects.h"

// iOS10
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "SecondViewController.h"
#import <PushKit/PushKit.h> // iOS8.0
#import <FBMemoryProfiler/FBMemoryProfiler.h>

#define LOG_LEVEL_DEF ddLogLevel
//#import <CocoaLumberjack/CocoaLumberjack.h>
#import "NDLDDLogFormatter.h"

#import "MBProgressHUD+NDLExtension.h"

#import "XLogManager.h"

#import <CrashReporter/CrashReporter.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import "ResidentThread.h"

// ===cocoapods===
// https://www.jianshu.com/p/b2f391ba0287

// 远程推送: 在联网的情况下，由远程服务器推送给客户端的通知

// 自定义打印日志级别
//#ifdef DEBUG
//static const DDLogLevel ddLogLevel = DDLogLevelVerbose;// DDLogLevelDebug下面的DDLogVerbose不会打印显示
//#else
//static const DDLogLevel ddLogLevel = DDLogLevelWarning;
//#endif


#define TEST test
static const NSUInteger test = 100;

static NSInteger messageId = 0;

static NSInteger badgeCount = 0;

int func1(int a) {
    static int b = 3;
    return a + b;;
}

int func2(int c) {
    static int b = 2;
    return func1(c + b);
}

static bool debugger_should_exit (void) {
#if !TARGET_OS_IPHONE
    return false;
#endif
    
    struct kinfo_proc info;
    size_t info_size = sizeof(info);
    int name[4];
    
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    
    if (sysctl(name, 4, &info, &info_size, NULL, 0) == -1) {
        NSLog(@"sysctl() failed: %s", strerror(errno));
        return false;
    }
    
    if ((info.kp_proc.p_flag & P_TRACED) != 0)
        return true;
    
    return false;
}

// 前提是存在CrashReporter
static void save_crash_report (PLCrashReporter *reporter) {
#if TARGET_OS_IPHONE
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (![fm createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error: &error]) {
        NSLog(@"Could not create documents directory: %@", error);
        return;
    }
    
    NSData *data = [[PLCrashReporter sharedReporter] loadPendingCrashReportDataAndReturnError:&error];
    if (data == nil) {
        NSLog(@"Failed to load crash report data: %@", error);
        return;
    }
    
    NSString *outputPath = [documentsDirectory stringByAppendingPathComponent:@"demo.plcrash"];
    if (![data writeToFile:outputPath atomically:YES]) {
        NSLog(@"Failed to write crash report");
    }
    
    NSLog(@"Saved crash report to: %@", outputPath);
#endif
}


/*
 Downloading Content in the Background(在后台下载内容):
 利用NSURLSession 对象来启动下载 // iOS 7.0
 
 创建configuration对象支持后台下载的步骤如下：
 1. 创建configuration对象，利用NSURLSessionConfiguration 的backgroundSessionConfigurationWithIdentifier: 方法。
 2. 设置configurtion对象的sessionSendsLaunchEvents 属性为YES
 3. 如果你的应用在前台的时候就开始传输，那么建议设置configuration对象的 discretionary属性为YES
 4. 配置其他相关的configuration对象属性
 5. 利用configuration对象，创建NSURLSession对象
 
 你的NSURLSession对象就会把上传和下载任务在相应的时间交给系统处理。如果任务完成的时候，你的应用依然在前台运行，session对象会通知它的代理。如果任务没有完成的时候系统终止了你的应用，系统会在后台继续自动管理这些任务，如果用户终止了你的应用，系统会取消所有正在等待的任务
 
 当程序退到后台进行下载时，不会再走NSURLSession的代理方法，只有所有的下载任务都执行完成，系统会调用ApplicationDelegate的application:handleEventsForBackgroundURLSession:completionHandler:回调
 
 当所有和后台session相关联的任务完成的时候，系统重新启动终止的应用（assuming that the sessionSendsLaunchEvents property was set to YES and that the user did not force quit the app）并会调用app的代理方法* application:handleEventsForBackgroundURLSession:completionHandler:*（The system may also relaunch the app to handle authentication challenges or other task-related events that require your app’s attention.）在你实现这个代理中，利用提供的标识创建一个和以前配置一样的新的NSURLSessionConfiguration和NSURLSession对象，
 系统会重新连接新的session对象到以前的任务，并向session对象的代理报告其状态
 */

@interface AppDelegate () <PKPushRegistryDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTask;

// test bgTask
@property (nonatomic, strong) NSTimer *timer;

// will show up as a button on the screen. Once tapped, it will open memory profiler in full size mode
@property (nonatomic, strong) FBMemoryProfiler *memoryProfiler;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, assign) BOOL isLaunchedByNotification;

@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

/*
 "==" 是判断两个对象的引用（reference）是否一样，也就是内存地址是否一样。
 */

// ###没有进行过任何设置的app，默认退到后台极短的几秒后就变成挂起状态###
// 当设置了UIBackgroundTaskIdentifier后台任务标记时，程序后台保活会延迟到三分钟左右

// 程序启动时，超过了5-6秒APP会被系统杀掉，而系统在锁屏的状态下启动要比激活状态慢很多，很容易触发watchdog的crash
@implementation AppDelegate

// MVVM M:模型 V:视图+控制器 VM:视图模型
//模型(M):保存视图数据。
//视图+控制器(V):展示内容 + 如何展示
//视图模型(VM):处理展示的业务逻辑，包括按钮的点击，数据的请求和解析等等。

/*
需要在某个页面禁止自动键盘处理事件相应
 - (void) viewWillAppear: (BOOL)animated {
     [IQKeyboardManager sharedManager].enable = NO;
 }
 
 - (void) viewWillDisappear: (BOOL)animated {
    [IQKeyboardManager sharedManager].enable = YES;
 }

 */



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"=====didFinishLaunchingWithOptions===== documentDir = %@", [NSString documentDir]);
    
    self.serialQueue = dispatch_queue_create("messageQueue", DISPATCH_QUEUE_SERIAL);
    
    // KSCrash:
    // https://github.com/kstenerud/KSCrash
    
    // =====PLCrashReporter=====
//    [self _initCrashReporter];
    
    // =====aspect=====
    [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
//        NSLog(@"===123456===");
    } error:nil];
    
    NSLog(@"%ld", TEST);

    // =====Mars=====
    [XLogManager openWithLogDirName:@"mars_log" logNamePrefix:@"ndl"];
    
    
    // https://blog.csdn.net/mandagod/article/details/82854364
    // 添加记录器
    // OS
//    [DDLog addLogger:[DDOSLogger sharedInstance]];
    
    // TTY 发送日志语句到Xcode控制台，如果可用
//    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // ASL 发送日志语句到苹果日志系统(Apple System Logs)，以便它们显示在Console.app上
//    [DDLog addLogger:[DDASLLogger sharedInstance]];
    // DDFileLogger，你的日志语句将写入到一个文件中，默认路径在沙盒的Library/Caches/Logs/目录下，文件名为bundleid+空格+日期.log
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];// File
    fileLogger.rollingFrequency = 60 * 60 * 24;// 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
//    fileLogger.maximumFileSize = 1024 * 1024 * 2;
    NDLDDLogFormatter *logFormatter = [[NDLDDLogFormatter alloc] init];
    [fileLogger setLogFormatter:logFormatter];
    [DDLog addLogger:fileLogger];
    
//    DDAbstractDatabaseLogger
    
    // fileLogger.currentLogFileInfo.filePath
    // /Users/dzcx/Library/Developer/CoreSimulator/Devices/43F257FE-9CD7-48C8-8834-AD0C8C38E949/data/Containers/Data/Application/F63A8943-977F-4E85-A784-895C0D05EF02/Library/Caches
//    DDLogVerbose(@"Verbose");
//    DDLogDebug(@"Debug");
//    DDLogInfo(@"Info");
//    DDLogWarn(@"Warn");
//    DDLogError(@"Error");
    
    
    // Profiler: 分析器
    // =====FBMemoryProfiler=====
//    self.memoryProfiler = [[FBMemoryProfiler alloc] init];
//    [self.memoryProfiler enable];
    
    
    // ======
//    self.bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
//        [application endBackgroundTask:self.bgTask];
//        self.bgTask = UIBackgroundTaskInvalid;
//    }];
    
    
    // https://oopsr.github.io/2016/06/20/voip/
    /*
     制作.pem格式证书:
     1、将之前生成的voip.cer SSL证书双击导入钥匙串
     2、打开钥匙串访问，在证书中找到对应voip.cer生成的证书，右键导出并选择.p12格式,这里我们命名为voippush.p12,这里导出需要输入密码(随意输入，别忘记了)。
     3、目前我们有两个文件，voip.cer SSL证书和voippush.p12私钥，新建文件夹命名为VoIP、并保存两个文件到VoIP文件夹。
     4、把.cer的SSL证书转换为.pem文件，打开终端命令行cd到VoIP文件夹、执行以下命令
     openssl x509 -in voip.cer  -inform der -out VoiPCert.pem
     5、把.p12私钥转换成.pem文件，执行以下命令（这里需要输入之前导出设置的密码）
     openssl pkcs12 -nocerts -out VoIPKey.pem -in voippush.p12
     6、再把生成的两个.pem整合到一个.pem文件中
     cat VoiPCert.pem VoIPKey.pem > ck.pem
     最终生成的ck.pem文件一般就是服务器用来推送的
     */
    
    /*
     Capabilities中打开3个backmode：Background fetch、Remote nofications、Voice over IP，以及Push Notifications（在工程里打开设置，和手机里设置的接收通知权限没有关系，即使用户将设置里的APNS关闭也能收到VoIP消息）
     
     voip好处:
     只有当VoIP发生推送时，设备才会唤醒，从而节省能源。
     VoIP推送被认为是高优先级通知，并且毫无延迟地传送。
     VoIP推送可以包括比标准推送通知提供的数据更多的数据。
     如果收到VoIP推送时，您的应用程序未运行，则会自动重新启动。
     即使您的应用在后台运行，您的应用也会在运行时处理推送。
     
     VOIP全称voice-over-ip，是iOS8新引入的一种推送方式类型
     VoIP推送证书只有发布证书
     另外有自己做过推送的应该都知道服务器一般集成的.pem格式的证书，所以还需将证书转成.pem格式
     */
    // 使用PushKit接收VoIP推送
    // 以前应用保活是通过与服务器发送周期性的心跳来维持，这样会导致设备被频繁唤醒，消耗电量，类似现在很多android系统的保活
    // voip: 解决微信在APP被杀死和黑屏的情况下都能收到呼叫并且能连续响铃和振动(APP死了，怎么去激活？)
    // 注册VoIP服务
//    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
//    pushRegistry.delegate = self;
//    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    // UIBackgroundTaskIdentifier
    
#if DEBUG
    
#endif
    
    // 禁止手机睡眠
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // 系统悬浮窗口调试工具
    // 运行程序后，两根手指点击状态栏即可调起这个调试的悬浮层 在iOS 11及更高版本上不起作用
//    Class overlayClass = NSClassFromString(@"UIDebuggingInformationOverlay");
//    IGNORE_PERFORM_SELECTOR_LEAK_WARNING([overlayClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")])
    
    
    // log: UIApplicationLaunchOptionsRemoteNotificationKey
    NSLog(@"remote key = %@", UIApplicationLaunchOptionsRemoteNotificationKey);
    // 推送点击 APP完全被关闭后，收到通知
    if (launchOptions) {
        NSLog(@"launchOptions = %@", launchOptions);
        
        // UIApplication: 493-line
        NSDictionary *pushInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushInfo) {
            self.isLaunchedByNotification = YES;
            application.applicationIconBadgeNumber = 0;
            NSLog(@"app被通知启动 pushInfo = %@", pushInfo);
        } else {
            self.isLaunchedByNotification = NO;
        }
    }
    
    // 涉及到UIScrollView的contentInsets等一些问题
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    
    
    // 是否启用自动键盘处理事件响应，默认为 YES
    [IQKeyboardManager sharedManager].enable = YES;
    // 键盘到 textfield 的距离，前提是 enable 属性为 YES，如果为 NO，该属性失效 不能小于0，默认为10.0
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0;
    
    // 点击输入框以外部分，是否退出键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    // 是否显示键盘上方的toolBar
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    // 如果当某一个输入框特定不需要键盘上的工具条时
    //textField.inputAccessoryView = [[UIView alloc] init];
    //toolBar 右方完成按钮的 text，默认为 Done
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    /*
     //toolBar管理textfield 的方式：
     IQAutoToolbarBySubviews,根据添加顺序
     IQAutoToolbarByTag,     根据 tag 值
     IQAutoToolbarByPosition,根据坐标位置
     */
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    
    
    // =====推送=====
    // 在iOS8之后想要设置applicationIconBadgeNumber,需要在didFinishLaunchingWithOptions进行用户授权
    //注册推送
    [self registerPush];
    
    // iOS3.0-8.0
    /*
    UIRemoteNotificationType remoteNotificationType = Application.enabledRemoteNotificationTypes;
    if (remoteNotificationType != UIRemoteNotificationTypeNone) {
        // 允许远程推送
    }
     */
    
    
//    [Application isRegisteredForRemoteNotifications];// 8.0
    
    // MARK: process message
//    [ResidentThread executeTask:^{
//        for (int i = 0; i < 30000; i++) {
//            NSLog(@"task1 = %d", i);
//        }
//    }];
//
//    [ResidentThread executeTask:^{
//        for (int i = 0; i < 10; i++) {
//            NSLog(@"task2 = %d", i);
//        }
//    }];
    
    
    [NotificationCenter addObserver:self selector:@selector(systemClockDidChanged:) name:NSSystemClockDidChangeNotification object:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 block:^(NSTimer * _Nonnull timer) {
        messageId++;
        
        dispatch_async(self.serialQueue, ^{
            [NotificationCenter postNotificationName:@"InnerMessage" object:nil userInfo:@{@"messageId": @(messageId)}];
        });
        
//        [ResidentThread executeTask:^{
//            [NotificationCenter postNotificationName:@"InnerMessage" object:nil userInfo:@{@"messageId": @(messageId)}];
//        }];
    } repeats:YES];
    
//    // block 主线程
//    for (int i = 0 ; i < 1000000; i++) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSLog(@"cur thread = %@ i = %ld", [NSThread currentThread], i);
//        });
//
//
////        dispatch_async(self.serialQueue, ^{
////            NSLog(@"cur thread = %@ i = %ld", [NSThread currentThread], i);
////        });
//    }
    
#if CGFLOAT_IS_DOUBLE
    
#else
    
#endif
    
    // MARK:=====crash=====
//    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    // 注册runloop观察者
//    [self registerRunLoopObserver];
    
    return YES;
}

// ========================PLCrashReporter Start========================
/**
 init PLCrashReporter
 */
- (void)_initCrashReporter
{
    // 模拟器
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"TARGET_IPHONE_SIMULATOR");
#endif
    
    // 模拟器 && 真机
#if TARGET_OS_IPHONE
    NSLog(@"TARGET_OS_IPHONE");
#endif

    // 调试模式下是无法获取到crash信息的
//    if (debugger_should_exit()) {
//        NSLog(@"The demo crash app should be run without a debugger present. Exiting ...");
//        return;
//    }
    
    PLCrashReporterConfig *crashReporterConfig = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeMach symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];// 希望抓到的日志是被dysm解析过的日志,而不是原始堆栈信息
    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:crashReporterConfig];
    
    NSError *error;
    // If a crash report exists
    if ([crashReporter hasPendingCrashReport]) {
        NSLog(@"handleCrashReport!!!");
        [self handleCrashReport:crashReporter];
    }
    // Enable the Crash Reporter ,开启crashrepoter
    if (![crashReporter enableCrashReporterAndReturnError:&error]) {
        NSLog(@"Warning: Could not enable crash reporter: %@", error);
    }
}

- (void)handleCrashReport:(PLCrashReporter *)crashReporter
{
    /* Save any existing crash report. */
//    save_crash_report(crashReporter);
    
    NSData *crashData;
    NSError *error;
    
    // Try loading the crash report
    crashData = [crashReporter loadPendingCrashReportDataAndReturnError:&error];
    if (crashData == nil) {
        NSLog(@"Could not load crash report: %@", error);
        // Purge the report
        [crashReporter purgePendingCrashReport];
        return;
    }
    
    // We could send the report from here, but we'll just print out
    // some debugging info instead
    PLCrashReport *report = [[PLCrashReport alloc] initWithData:crashData error:&error];
    if (report == nil) {
        NSLog(@"Could not parse crash report: %@", error);
        [crashReporter purgePendingCrashReport];
        return;
    }
    
    NSLog(@"=====Crashed on %@", report.systemInfo.timestamp);
    NSLog(@"=====Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name, report.signalInfo.code, report.signalInfo.address);
    
    // 转换为正常的 .crash 文件
    // ./plcrashutil convert --format=iphone example_report.plcrash > app.crash
    // 或者
//    NSString *humanReadable = [PLCrashReportTextFormatter stringValueForCrashReport:report withTextFormat:PLCrashReportTextFormatiOS];
//    NSLog(@"Report: %@", humanReadable);
    
    // 提示
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"===crash===" message:humanReadable preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//        [alertVC addAction:action];
//        [Application.keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
//    });
    
    // 上传crash
    [crashReporter purgePendingCrashReport];
}

// ========================PLCrashReporter End========================

void uncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols]; //得到当前调用栈信息
    NSString *reason = [exception reason];       //非常重要，就是崩溃的原因
    NSString *name = [exception name];           //异常类型

    NSLog(@"===============uncaughtExceptionHandler===============");
    DDLogVerbose(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
    NSLog(@"======================================================");
}



- (void)registerRunLoopObserver
{
    CFRunLoopObserverContext context = {0, (__bridge void *)self, &CFRetain, &CFRelease, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, true, 0, &runLoopObserverCallBack, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    AppDelegate *appDelegate = (__bridge AppDelegate *)info;
    
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"===kCFRunLoopEntry===");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"===kCFRunLoopBeforeTimers===");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"===kCFRunLoopBeforeSources===");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"===kCFRunLoopBeforeWaiting===");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"===kCFRunLoopAfterWaiting===");
            break;
        case kCFRunLoopExit:
            NSLog(@"===kCFRunLoopExit===");
            break;
            
        default:
            break;
    }
}

- (void)systemClockDidChanged:(NSNotification *)notification
{
    NSLog(@"###systemClockDidChanged###");
}

// 注册推送
- (void)registerPush
{
    // 申请通知权限
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *userNotificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        userNotificationCenter.delegate = self;// 必须写代理，不然无法监听通知的接收与点击事件
        // 进行用户授权
        [userNotificationCenter requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            NSLog(@"granted = %ld", [[NSNumber numberWithBool:granted] integerValue]);
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        // 获取权限设置
        [userNotificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            UNAuthorizationStatus authorizationStatus = settings.authorizationStatus;
            if (authorizationStatus == UNAuthorizationStatusAuthorized) {
                NSLog(@"被授权");
            } else {
                NSLog(@"未被授权");
            }
        }];
    } else {// iOS8.0-10.0
        UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        // 授权通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:userNotificationSettings];
        
        
        //
        UIUserNotificationSettings *curUserNotificationSettings = [UIApplication sharedApplication].currentUserNotificationSettings;
        UIUserNotificationType userNotificationType = curUserNotificationSettings.types;
        if (userNotificationType != UIUserNotificationTypeNone) {
            // 允许推送
        }
    }
    
    //iOS8以下
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    
    
    // 注册远程通知
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}



// //app进入后台后保持运行
- (void)startTask {
    self.bgTask = [Application beginBackgroundTaskWithExpirationHandler:^{
 //如果在系统规定时间3分钟内任务还没有完成，在时间到之前会调用这个 ExpirationHandlerBlock
 //结束后台运行，让app挂起
 //切记endBackgroundTask要和beginBackgroundTaskWithExpirationHandler成对出现
        [Application endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }];
    
    // do bg task
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // do something
        NSLog(@"backgroundTimeRemaining = %lf", Application.backgroundTimeRemaining);
        
        
        
        [Application endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    });
}

// iOS 9 3D-Touch 主屏操作
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    // iconType: UIApplicationShortcutIconType
    NSLog(@"shortcutItem = %@", shortcutItem.userInfo);
    NSArray<NSString *> *allKeyArr = shortcutItem.userInfo.allKeys;
    for (NSString *key in allKeyArr) {
        if ([key isEqualToString:@"secondKey"]) {
            NSLog(@"current vc = %@", [UIViewController ndl_curTopViewController]);
            [[UIViewController ndl_curTopViewController] presentViewController:[SecondViewController new] animated:YES completion:nil];
        }
    }
}

// iOS 9.0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
//    NSLog(@"url.scheme = %@", url.scheme);
//    NSLog(@"from source app key（Bundle ID）= %@", options[UIApplicationOpenURLOptionsSourceApplicationKey]);
    
    return YES;
}

// ======================didReceiveLocalNotification======================
// 本地通知:
// 当App在前台状态下，如果有通知会调用该方法
// 当应用程序在后台状态下，点击推送通知，程序从后台进入前台后，会调用该方法（从锁屏界面点击推送通知从后台进入前台也会执行）
// 当应用程序完全退出时不调用该方法
// iOS4.0-iOS10.0
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceiveLocalNotification = %@ state = %ld", notification, Application.applicationState);
    
//    [application cancelLocalNotification:notification];
}

// =====监听附加操作按钮=====
// local: iOS8.0-iOS10.0
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    
}
// local: iOS9.0-iOS10.0
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler
{
    
}

// remote: iOS8.0-iOS10.0
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    
}

// remote: iOS9.0-iOS10.0
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler
{
    
}

// ======================RegisterUserNotificationSettings======================
// iOS8.0-iOS10.0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // 10.0 use: [UNUserNotificationCenter requestAuthorizationWithOptions:completionHandler:]
    NSLog(@"didRegisterUserNotificationSettings = %@", notificationSettings);
}
// ======================RegisterForRemoteNotifications(DeviceToken)======================
// iOS3.0
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken = %@", deviceToken);
}
// iOS3.0
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotifications: error = %@", error);
}

// =================didReceiveRemoteNotification=================
// 推送点击  app在后台/前台，app未关闭时：
// iOS3.0-10.0 (ios12测试下来 3种情况都不走这个)
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber = 0;
    NSLog(@"userInfo = %@", userInfo);
    
    //    //程序关闭状态点击推送消息打开
    //    if (self.isLaunchedByNotification) {
    //        //TODO
    //    }
    //    else{
    //        //前台运行
    //        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
    //            //TODO
    //        }
    //        //后台挂起时
    //        else{
    //            //TODO
    //        }
    //        //收到推送消息手机震动，播放音效
    //        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //        AudioServicesPlaySystemSound(1007);
    //    }
    //    //设置应用程序角标数为0
    //    [UIApplication sharedApplication].applicationIconBadgeNumber = 9999;
    //    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

// ios7  用于静默推送   静默推送:iOS7以后出现, 不会出现提醒及声音 前台/后台/退出/静默推送都可以处理
/*
 推送的payload中不能包含alert及sound字段
 需要添加content-available字段, 并设置值为1
 例如: {"aps":{"content-available":"1"},"PageKey”":"2"}
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"=====ios7-静默推送=====");
    completionHandler(UIBackgroundFetchResultNewData);
}

//- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier
//{
//    
//}


// =================app life cirlce=================
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"AppDelegate applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [self startTask];
    NSLog(@"AppDelegate applicationDidEnterBackground");
    Application.applicationIconBadgeNumber = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.f repeats:YES block:^(NSTimer * _Nonnull timer) {
        badgeCount++;
        Application.applicationIconBadgeNumber = badgeCount;
        NSLog(@"count = %ld", badgeCount);
        if (badgeCount == 10) {
            [self.timer invalidate];
        }
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"AppDelegate applicationWillEnterForeground");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"AppDelegate applicationDidBecomeActive");
}

/*
 1.查看所用的Framework或.a是否支持bitcode:
 otool -l framwork路径下的实体文件 | grep __LLVM
 没有输出结果，那么说明所用的framework或.a不支持设置Enable bitcode为YES
 
 2.查看Framework支持的架构:
 lipo -info framework或者.a实体文件路径
 lipo -info /Users/dzcx/Desktop/mars-master/mars/cmake_build/iOS/Darwin.out/mars.framework/mars
 
 =====
 CPU
 iPhone
 
 armv6
 iPhone, iPhone 3G
 
 armv7
 iPhone 3GS, iPhone4(GSM),iPhone 4(CDMA),iPhone 4S
 
 armv7s
 iPhone 5, iPhone 5C
 
 arm64
 iPhone 5S, iPhone SE, iPhone 6, iPhone 6 Plus, iPhone 6s, iPhone 6s Plus, iPhone 7, iPhone 7 Plus, iPhone 8, iPhone 8 Plus, iPhone X
 
 arm64e
 iPhone XS, iPhone XS Max, iPhone XR
 
 iPhone 5S之前使用的是32位微处理器，iPhone 5S及之后都是64位的微处理器
 =====

 CPU    iPhone
 i386    32 位微处理器
 x86_64    64 位微处理器
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"AppDelegate applicationWillTerminate");

    [XLogManager close];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
}


#pragma mark - UNUserNotificationCenterDelegate
// 用于前台运行
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    
    //收到推送的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    
    //收到推送消息body
    NSString *body = content.body;
    
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    // 推送消息的标题
    NSString *title = content.title;
    
    if([request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        // 判断为远程通知
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        
    }else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    
    //可以设置当收到通知后, 有哪些效果呈现(声音/提醒/数字角标)
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

// =================didReceiveRemoteNotification=================
// iOS 10 及以上 - 收到推送消息后   用于后台及程序退出
//后台运行: 指的是程序已经打开, 用户看不见程序的界面, 如锁屏和按Home键.
//程序退出: 指的是程序没有运行, 或者通过双击Home键,关闭了程序
// 点击推送通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [MBProgressHUD ndl_showText:response.actionIdentifier toView:KeyWindow];
    // actionIdentifier:
    // UNNotificationDefaultActionIdentifier 用户点击
    // UNNotificationDismissActionIdentifier
    NSLog(@"actionIdentifier = %@ identifier = %@", response.actionIdentifier, response.notification.request.identifier);// request.identifier用来区分
    NSLog(@"didReceiveNotificationResponse userInfo = %@", userInfo);
    
    
    /*
     亲测:
     本地推送:
     前台，后台，app被kill都走这个
     */
    
    
//    //程序关闭状态点击推送消息打开
//    if (self.isLaunchedByNotification) {
//        //TODO
    // 此时state为: UIApplicationStateInactive
//    }
//    else{
//        //前台运行 
//        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//            //TODO
//        }
//        //后台挂起时
//        else{
            // 此时state为: UIApplicationStateInactive
//            //TODO
//        }
//        //收到推送消息手机震动，播放音效
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        AudioServicesPlaySystemSound(1007);
//    }
//    //设置应用程序角标数为0
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 9999;
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    completionHandler();
}



#pragma mark - PKPushRegistryDelegate
/*
 推送:
 
 后台使用的接口
 开发接口：gateway.sandbox.push.apple.com:2195
 发布接口：gateway.push.apple.com:2195
 
 官网提供的是：
 开发接口: api.development.push.apple.com:443
 发布接口: api.push.apple.com:443
 
 这两个接口都能使用一个是Socket连接的方式，一个是采用Http的方式
 */

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)pushCredentials forType:(PKPushType)type
{
    // 获取token方法
    // 1.获取deviceToken，并去除非法字符
    NSString *deviceToken = [[pushCredentials.token description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"voip deviceToken = %@", deviceToken);
    
    // 上传token处理
}


// ===接收VoIP消息方法===
// [iOS8.0, iOS11.0)
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type
{
    BOOL showLocalNotificationFlag = NO;
    // 一般做本地推送处理或者结合callKit弹出电话页面
    switch (Application.applicationState) {
        case UIApplicationStateActive:
            
            break;
        case UIApplicationStateInactive:
            
            break;
        case UIApplicationStateBackground:
            showLocalNotificationFlag = YES;
            break;
        default:
            break;
    }
    
    if (showLocalNotificationFlag) {
        
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(PKPushType)type
{
    
}

// iOS11.0
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void (^)(void))completion
{
    
}

//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}

@end


/*
 ##QIShare##
 https://www.jianshu.com/u/3db23baa08c7
 */

/*
 ==组件化==
 
 // start
 MARK: ==配置podspec文件并发布自己的源代码==
 
 创建 podsepc文件:
 pod sepc create PodspecFileName
 创建tag号并push到远端:
 配置好podsepc文件后，接着创建一个tag号，这个tag好要与podspec中的version相对应。创建完tag号后，不要忘记push到远端
 git tag 0.0.1
 git push origin --tag
 pod spec lint xxxx.podspec 来测试一下我们配置的podspec是否正确
 测试和创建CocoaPods账号:
 往CocoaPods上集成开源库，需要相关的CocoaPods账号。我们可以通过 pod trunk me来查看账号是否存在
 pod trunk register XX@126.com 'ndl'
 注册完后，需要进入邮箱进行账号的激活
 再次进行trunk me测试
 发布:
 pod trunk push xxxxx.podspce 将podspec文件发布到CocoaPods的Spec仓库中
 将我们创建和配置的xxxx.podspec文件发布到 CocoaPods的Specs仓库（https://github.com/CocoaPods/Specs.git）
 我们在发布我们的工程到CocoaPods的时，本质上是根据我们的工程名称创建相关的文件夹，然后根据我们的tag号创建子文件夹，然后在子文件夹中上传当前版本所对应的podspec文件
 仓库引用:
 // end
 
 ##路由是组件化的中间件技术，他解决了我们组件化的耦合问题##
 当我们想跳转一个A页面的时候，通常来讲我们需要import A页面的头文件，在写相应的跳转方法，但是这样，我们就耦合了A文件，也就无法与之独立，如果A页面是其他业务的文件，那么我们将与其他业务耦合，这样千丝万缕的联系，使我们整个工程根本无法独立拆分
 
 [UIImage imageNamed:@“图片名"]方式加载本地图片，这种方式默认是从mainBundle中去加载图片
 
 基础组件拆分 工具，分类，网络等
 比如，有3个tabbar专题、作者、商城三个模块，就可以理解成3个业务组件 (###组件间通信###)
 功能组件也很好理解，比如我们项目中用到的轮播器、播放器、图片浏览器等都可以单独抽出功能组件
 业务组件间的通信。比如专题组件A、作者组件B、点击专题A组件中cell的作者头像图标跳转到B组件中“作者详情”的界面。这就是简单的组件间通信
 
 
 查看当前仓库对应的远程仓库地址:
 git remote -v
 
 将本地的仓库地址指向github上创建的远程仓库地址:
 git remote add origin https://XXX
 
 pod repo remove master // 移除master
 
 spec: [spek]
 MARK: ===创建私有的Specs仓库===
 -----远程索引库NDLSpecs:
 每创建一个组件都会带有一个 xxx.podspec 的索引文件。专门用来存放这些索引文件的库就叫做索引库
 
 -----本地索引库 （本地索引库就是用来存放本地索引文件的库）:
 pod repo 查看一下当前有哪些本地索引库（如果你之前没有创建过，应该只有一个master）
 
 通过pod repo add <本地索引库的名字（NDLSpecs）>  <远程索引库的地址（https://github.com/ndlwill/NDLSpecs.git）> ，创建本地索引库并和远程索引库做关联（注：本地索引库的名字建议和远程索引库起的名字一样）
 #message: Cloning spec repo `NDLSpecs` from `https://github.com/ndlwill/NDLSpecs.git`
 cd .cocoapods 进入本地索引库的物理地址
 
 官方spec镜像
 https://github.com/CocoaPods/Specs.git
 
 -----远程代码库 CategoryKit:
 不用勾选readme .gitignore选none
 
 -----本地代码库 CategoryKit:
 pod lib create <组件名(CategoryKit)>
 把代码文件放到CategoryKit->Classes目录
 cd Example文件夹 pod install
 Example: import "XXX.h"
 编译组件看是否报错，编译通过后需要修改podspecs索引文件
 a. 修改版本号
 b. 修改项目的简单概述和详细描述
 c. 修改homepage和source地址
 d. 添加依赖库
 编译运行通过后，提交组件到远程代码库并打tag
 cd CategoryKit
 git add .
 git commit -m “xxx"
 git remote add origin 远程代码仓库地址(https://github.com/ndlwill/CategoryKit.git)
 git push origin master
 git tag 版本号 （注：这里的版本号必须和podspec里写的版本号一致）
 
 git tag -a 1.0.0 -m "1.0.0版本”
 显示标签
 $ git tag
 显示标签具体信息
 $ git show 1.0.0
 
 git push --tags
 
 -----验证podspec索引文件是否正确:
 (pod repo lint xxxxSpecsName 该Specs仓库是否可用)
 
 pod lib lint CategoryKit.podspec --verbose --allow-warnings （--sources='https://github.com/CocoaPods/Specs.git' 默认值）验证本地索引文件是否正确
 ###pod spec lint --verbose --allow-warnings 命令验证podspec索引文件（既验证本地同时验证远程的podspec）
 验证提交到代码仓库里的podspec是否正确
 --verbose 是为了打印更加详细的信息方便查看
 
 pod lib lint的时候报Could not find a `ios` simulator:
 gem sources -l
 gem sources --remove  https://gems.ruby-china.org
 gem sources --add  https://gems.ruby-china.com
 更新CocoaPods
 sudo gem install cocoapods
 
 -----验证通过后，pod repo push <本地索引库(NDLSpecs)> <索引文件名(CategoryKit.podspec)> - -verbose - -allow-warnings 提交索引文件到远程索引库
 本地也可以查看是否成功
 
 -----项目pod CategoryKit
 source 'https://github.com/ndlwill/NDLSpecs.git'
 source 'https://github.com/CocoaPods/Specs.git'
 pod 'CategoryKit'
 需要在Podfile中指定组件远程索引库地址，如果不指定默认会从master的索引库查找就会报找不到组件
 pod repo查看索引库地址
 Podfile文件修改
 新项目： #import <XX.h>
 
 BaseKit
 -----设置subspec子库
 需要注释掉之前的 s.source_files 和原来的依赖库,设置子库的subspec 和子库依赖库

 */

//s.subspec 'Category' do |category|
//category.source_files = 'FFBaseKit/Classes/Category/**/*'
//end
//
//s.subspec 'Tools' do |tools|
//tools.source_files = 'FFBaseKit/Classes/Tools/**/*'
//tools.dependency 'MBProgressHUD'
//end
//
//s.subspec 'APIs' do |apis|
//apis.source_files = 'FFBaseKit/Classes/APIs/**/*'
//apis.dependency 'AFNetworking'
//apis.dependency 'FMDB'
//end

//s.subspec后面是我们文件目录对应名称
//do后面是起的一个别名
//别名.source_files是文件路径
//别名. dependency后面是子库的依赖库

//pod 'FFBaseKit' 引入pod库中所有模块
//pod 'FFBaseKit/Category' 只引入Category模块
//pod 'FFBaseKit', :subspecs => ['Category', 'Tools']

// podspec编写
// https://blog.csdn.net/zramals/article/details/81388703

// MARK: Carthage
/**
 https://www.cnblogs.com/ludashi/p/9000571.html
 */
