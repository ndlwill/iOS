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

static NSInteger badgeCount = 0;
@interface AppDelegate () <PKPushRegistryDelegate>

@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTask;

// test bgTask
@property (nonatomic, strong) NSTimer *timer;

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
    
//    self.bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
//        [application endBackgroundTask:self.bgTask];
//        self.bgTask = UIBackgroundTaskInvalid;
//    }];
    
    // APNs: 能够有效收到apns推送，首先必须要确保设备处于online的状态
    
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
            NSLog(@"pushInfo = %@", pushInfo);
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
    
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    [NotificationCenter addObserver:self selector:@selector(systemClockDidChanged:) name:NSSystemClockDidChangeNotification object:nil];
    
    return YES;
}

- (void)systemClockDidChanged:(NSNotification *)notification
{
    NSLog(@"###systemClockDidChanged###");
}

// 注册推送
- (void)registerPush
{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *userNotificationCenter = [UNUserNotificationCenter currentNotificationCenter];
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

        UIUserNotificationSettings *curUserNotificationSettings = [UIApplication sharedApplication].currentUserNotificationSettings;
        UIUserNotificationType userNotificationType = curUserNotificationSettings.types;
        if (userNotificationType != UIUserNotificationTypeNone) {
            // 允许推送
        }
    }
}

// //app进入后台后保持运行
- (void)startTask {
    self.bgTask = [Application beginBackgroundTaskWithExpirationHandler:^{
 //如果在系统规定时间3分钟内任务还没有完成，在时间到之前会调用这个block
 //结束后台运行，让app挂起
 //切记endBackgroundTask要和beginBackgroundTaskWithExpirationHandler成对出现
        [Application endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }];
}

// iOS 9 3D-Touch 主屏操作
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}

// 推送点击  app在后台/前台，app未关闭时：
// iOS3.0-10.0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber = 0;
    NSLog(@"userInfo = %@", userInfo);
}

//- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier
//{
//    
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [self startTask];
    
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
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
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
