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

@interface AppDelegate ()

@end

@implementation AppDelegate


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
    
#if DEBUG
    
#endif
    
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
    UIUserNotificationSettings *userNotificationSettings = [UIApplication sharedApplication].currentUserNotificationSettings;
    UIUserNotificationType userNotificationType = userNotificationSettings.types;
    if (userNotificationType != UIUserNotificationTypeNone) {
        // 允许推送
    }
    
    // 8.0 DEPRECATED
    UIRemoteNotificationType remoteNotificationType = Application.enabledRemoteNotificationTypes;
    if (remoteNotificationType != UIRemoteNotificationTypeNone) {
        // 允许远程推送
    }
    
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        UNAuthorizationStatus authorizationStatus = settings.authorizationStatus;
        if (authorizationStatus == UNAuthorizationStatusAuthorized) {
            // 被授权
        }
    }];
    
//    [Application isRegisteredForRemoteNotifications];// 8.0
    
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    return YES;
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
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}

// 推送点击  app在后台/前台，app未关闭时：
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
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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


@end
