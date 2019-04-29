//
//  AppDelegate.m
//  NDL_Category
//
//  Created by ndl on 2017/9/14.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"

#import "Aspects.h"

#import <UserNotifications/UserNotifications.h>
#import "SecondViewController.h"
#import <PushKit/PushKit.h> // iOS8.0
#import <FBMemoryProfiler/FBMemoryProfiler.h>

#define LOG_LEVEL_DEF ddLogLevel
#import <CocoaLumberjack/CocoaLumberjack.h>

#import "MBProgressHUD+NDLExtension.h"

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;// DDLogLevelDebug下面的DDLogVerbose不会打印显示
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif


#define TEST test
static const NSUInteger test = 100;


static NSInteger badgeCount = 0;

int func1(int a) {
    static int b = 3;
    return a + b;;
}

int func2(int c) {
    static int b = 2;
    return func1(c + b);
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
    NSLog(@"=====didFinishLaunchingWithOptions=====");
    [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
//        NSLog(@"===123456===");
    } error:nil];
    
    NSLog(@"%ld", TEST);
    
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
    [DDLog addLogger:fileLogger];
    
    // fileLogger.currentLogFileInfo.filePath
    // /Users/dzcx/Library/Developer/CoreSimulator/Devices/43F257FE-9CD7-48C8-8834-AD0C8C38E949/data/Containers/Data/Application/F63A8943-977F-4E85-A784-895C0D05EF02/Library/Caches
    DDLogVerbose(@"Verbose");
    DDLogDebug(@"Debug");
    DDLogInfo(@"Info");
    DDLogWarn(@"Warn");
    DDLogError(@"Error");
    
    // FBMemoryProfiler
//    self.memoryProfiler = [[FBMemoryProfiler alloc] init];
//    [self.memoryProfiler enable];
    
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
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
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
            application.applicationIconBadgeNumber = 0;
            NSLog(@"app被通知启动 pushInfo = %@", pushInfo);
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
    
    
    [NotificationCenter addObserver:self selector:@selector(systemClockDidChanged:) name:NSSystemClockDidChangeNotification object:nil];
    
#if CGFLOAT_IS_DOUBLE
    
#else
    
#endif
    
    return YES;
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
// iOS4.0-iOS10.0
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceiveLocalNotification = %@ state = %ld", notification, Application.applicationState);
    
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

// ios7  用于静默推送   静默推送:iOS7以后出现, 不会出现提醒及声音
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


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"AppDelegate applicationWillTerminate");
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
    //可以设置当收到通知后, 有哪些效果呈现(声音/提醒/数字角标)
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

// =================didReceiveRemoteNotification=================
// iOS 10 及以上 - 收到推送消息后   用于后台及程序退出
//后台运行: 指的是程序已经打开, 用户看不见程序的界面, 如锁屏和按Home键.
//程序退出: 指的是程序没有运行, 或者通过双击Home键,关闭了程序
// 点击提送通知
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

@end
