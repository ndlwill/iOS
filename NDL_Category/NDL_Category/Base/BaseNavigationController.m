//
//  BaseNavigationController.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/19.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "BaseNavigationController.h"

// for自定义转场
/* <UINavigationControllerDelegate> */
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController


#pragma mark - Overrides
/**
 * 当第一次使用这个类的时候会调用一次,只会被调用一次
 */
+ (void)initialize
{
    // 当导航栏用在BaseNavigationController中, appearance设置才会生效
    //    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    
    UINavigationBar *bar = [UINavigationBar appearance];
    // 使得self.navigationBar.translucent = NO
//    [bar setBackgroundImage:[UIImage ndl_imageWithColor:[UIColor ndl_randomColor] size:CGSizeMake(1.0, 1.0)] forBarMetrics:UIBarMetricsDefault];
    
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20]}];
    
    // 设置item
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // UIControlStateNormal
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    
    // UIControlStateDisabled
    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
    itemDisabledAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
    
    // 去除ShadowImage
//    [bar setShadowImage:[[UIImage alloc] init]];
}

/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
//自定义navc，重写pushViewController方法，使得所有被push的vc的backbarbutton都一致
//navc的rootvc也是被push进去的
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //如果push进来的第一个controller就不需要修改viewController.navigationItem.leftBarButtonItem
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        button.size = CGSizeMake(60, 44);// button.x 相对于navigationBar为16
        
        /*
         // 以前的
//        button.size = CGSizeMake(70, 30);
//        // 让按钮内部的所有内容左对齐
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        // 让按钮的内容往左边偏移10  内边距
//        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);//tlbr  设置这个，同时需要设置button.frame使content在frame的范围内，不然pop返回的时候，超出frame的backBarBtn做渐变动画会有bug
         */
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(backBarBtnItemClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        // 修改导航栏左边的item  一旦换了左边的item，就不能点左边拖拽到右边返回
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        //    self.navigationItem.leftBarButtonItem = nil;// 表示使用系统默认的返回
        //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];// 表示没有返回按钮
        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem(在viewController的viewDidLoad里面设置)
    [super pushViewController:viewController animated:animated];
}



#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // for自定义转场
//    self.delegate = self;
    
//    self.interactivePopGestureRecognizer.enabled = YES;
    
    // 如果边缘右滑移除控制器的功能失效，清空代理(让导航控制器重新设置这个功能)
//    self.interactivePopGestureRecognizer.delegate = nil;// 设置了viewController.navigationItem.leftBarButtonItem需要设置这个
}

#pragma mark - Private Methods

#pragma mark - UIButton Actions
- (void)backBarBtnItemClicked
{
    [self popViewControllerAnimated:YES];
}


// TODO:============================我是分割线============================
#pragma mark - UINavigationControllerDelegate
//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
//{
//
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
//{
//    if (operation == UINavigationControllerOperationPush) {// push
//        return nil;
//    } else if (operation == UINavigationControllerOperationPop) {// pop
//        return nil;
//    } else {
//        return nil;
//    }
//}

@end
