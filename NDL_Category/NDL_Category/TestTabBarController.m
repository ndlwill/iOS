//
//  TestTabBarController.m
//  NDL_Category
//
//  Created by ndl on 2019/11/21.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestTabBarController.h"
#import "BaseNavigationController.h"

@interface TestTabBarController () <UITabBarControllerDelegate>

@end

@implementation TestTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)setupChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // MARK: vc title
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

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"UITabBarDelegate: tabBar-didSelectItem");
    
    NSArray<UITabBarItem *> *items = tabBar.items;
    NSUInteger selectedIndex = [items indexOfObject:item];
    
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"UITabBarControllerDelegate: tabBarController-didSelectViewController");
}


@end
