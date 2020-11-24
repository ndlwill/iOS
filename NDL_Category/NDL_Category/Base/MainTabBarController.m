//
//  MainTabBarController.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/9.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "MainTabBar.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

+ (void)initialize
{
//    [UITabBar appearance].barTintColor
//    [UITabBar appearance].backgroundImage
    
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    //UIBarItem setTitleTextAttributes: .....   后面有UI_APPEARANCE_SELECTOR宏的方法都可以通过appearance统一设置所有的UITabBarItem
    UITabBarItem *item = [UITabBarItem appearance];
//    item.titlePositionAdjustment = UIOffsetMake(0, 1.5);
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self setupChildVC:<#(UIViewController *)#> title:<#(NSString *)#> image:<#(NSString *)#> selectedImage:<#(NSString *)#>];
    
    
    //自定义tabbar  self.tabBar是readonly的不能赋值，通过kvc访问成员变量_tabbar
    [self setValue:[[MainTabBar alloc] init] forKeyPath:@"tabBar"];
}

/**
 * 初始化子控制器
 */
- (void)setupChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    /*
     在ViewController中写（vc被nvc管理,nvc被tvc管理）
     self.title = @"cc";//相当于调用下面两行
     
     self.tabBarItem.title = @"cc";
     self.navigationItem.title = @"cc";
     */
    
    // 设置文字和图片
    //navItem
    vc.navigationItem.title = title;
    //tabbarItem
    vc.tabBarItem.title = title;
    
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];//###
}

// MARK: overrride UIInterfaceOrientation iOS6.0
// 页面旋转（视图旋转）- UIInterfaceOrientation
// UIInterfaceOrientation程序界面的当前旋转方向(可以设置)
// ##单页面旋转方向设置##// General里面选择3个方向
/**
 MainTabBar的两个选项
 Test1VC: ->BaseNav -> MainTabBar 包裹
 - (BOOL)shouldAutorotate
 {
     NSLog(@"Test1-shouldAutorotate");
     return NO;
 }

 - (UIInterfaceOrientationMask)supportedInterfaceOrientations
 {
     NSLog(@"Test1-supportedInterfaceOrientations");
     return UIInterfaceOrientationMaskAllButUpsideDown;
 }

 - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
 {
     NSLog(@"Test1-preferredInterfaceOrientationForPresentation");
     return UIInterfaceOrientationPortrait;
 }
 
 Test2VC: ->BaseNav -> MainTabBar 包裹
 - (BOOL)shouldAutorotate
 {
     NSLog(@"Test2-shouldAutorotate");
     return YES;
 }

 - (UIInterfaceOrientationMask)supportedInterfaceOrientations
 {
     NSLog(@"Test2-supportedInterfaceOrientations");
     return UIInterfaceOrientationMaskAllButUpsideDown;
 }

 - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
 {
     NSLog(@"Test2-preferredInterfaceOrientationForPresentation");
     return UIInterfaceOrientationPortrait;
 }
 */
// ###系统未关闭屏幕自动旋转功能###
//1.决定当前界面是否开启自动转屏，如果返回NO，后面两个方法也不会被调用，只是会支持默认的方向
- (BOOL)shouldAutorotate
{
    NSLog(@"TabBar-shouldAutorotate");
    return [self.selectedViewController shouldAutorotate];
}
//2.返回支持的旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    NSLog(@"TabBar-supportedInterfaceOrientations");
    return [self.selectedViewController supportedInterfaceOrientations];
}

//3.返回进入界面默认显示方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    NSLog(@"TabBar-preferredInterfaceOrientationForPresentation");
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

// ###系统关闭屏幕自动旋转功能。在程序界面通过点击等方式切换到横屏###
/**
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
 //    [self setInterfaceOrientation:UIDeviceOrientationLandscapeLeft];
     // or
     [self setInterfaceOrientation1:UIInterfaceOrientationLandscapeRight];
 }
 
 ###确保shouldAutorotate方法返回YES###
 // 方法1：
 - (void)setInterfaceOrientation:(UIDeviceOrientation)orientation {
       if ([[UIDevice currentDevice]   respondsToSelector:@selector(setOrientation:)]) {
           [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation]
                                        forKey:@"orientation"];
         }
     }

 //方法2：
 - (void)setInterfaceOrientation1:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
             SEL selector = NSSelectorFromString(@"setOrientation:");
             NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice
         instanceMethodSignatureForSelector:selector]];
             [invocation setSelector:selector];
             [invocation setTarget:[UIDevice currentDevice]];
             int val = orientation;
             [invocation setArgument:&val atIndex:2];
             [invocation invoke];
         }
     }
 */

/**
 屏幕旋转控制的优先级：
 1.屏幕旋转设置方式
 - Xcode的General设置
 - Xcode的nfo.plist设置
 - 代码设置Appdelegete中

 3.开启App旋转的全局权限
 Device Orientation属性配置
 【General】—>【Deployment Info】—>【Device Orientation】
 Info.Plist设置
 Supported interface orientation
 与第一种方式一样的效果，两种方式最终都是设置info.plist中的属性
 
 Appdelegate&&Window中设置: 优先级大于info.plist中设置的屏幕方向参数,已验证
 - (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
     return  UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
 }
 如果我们实现了Appdelegate的这一方法，那么我们的App的全局旋转设置将以这里的为准，即使前两种方法的设置与这里的不同。
 
 关于旋转的优先级从高到低就是UITabbarViewController>UINavigationBarController >UIViewController了
 如果具有高优先级的控制器关闭了旋转设置，那么低优先级的控制器是无法做到旋转的。
 
 实现需求：
 App主要主界面竖向展示，部分页面横向展示
 两种解决方案
 （1）、逐级控制
 1.开启全局权限设置项目支持的旋转方向
 2.自定义标签控制器和导航控制器来设置屏幕的自动旋转。
 3.自定义基类控制器设置不支持自动转屏，并默认只支持竖屏
 4.对项目中需要转屏幕的控制器开启自动转屏、设置支持的旋转方向并设置默认方向
 
 （2）、通过全局监听当前的方向变化
 1.在Applegate文件中增加一个用于记录当前屏幕是否横屏的属性
 2.需要横屏的界面，进入界面后强制横屏，离开界面时恢复竖屏
 
 1、添加监听

 [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(onDeviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification
                                                object:nil];
 [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

 2、实现监听

 - (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
     if (_allowAutoRotate) {
         //只支持横屏
         return UIInterfaceOrientationMaskLandscape;
     }else{
         //支持竖屏
         return UIInterfaceOrientationMaskPortrait;
     }
 }

 3、页面控制

 - (void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
     AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     delegate.allowAutoRotate = YES;
     //进入界面：设置横屏
     [self setDeviceInterfaceOrientation:UIDeviceOrientationLandscapeLeft];
 }

 - (void)viewWillDisappear:(BOOL)animated{
     [super viewWillDisappear:animated];
     AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     delegate.allowAutoRotate = NO;
     //离开界面:设置竖屏
     [self setDeviceInterfaceOrientation:UIDeviceOrientationPortrait];
 }
 */


@end
