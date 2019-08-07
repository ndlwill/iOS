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


@end
