//
//  UINavigationController+NDLExtension.m
//  NDL_Category
//
//  Created by ndl on 2017/11/20.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import "UINavigationController+NDLExtension.h"

@interface UINavigationController () <UINavigationBarDelegate>

@end

@implementation UINavigationController (NDLExtension)

+ (void)load
{
    NSArray *methodArray = @[@"_updateInteractiveTransition:"];// , @"popToViewController:animated:", @"popToRootViewControllerAnimated:", @"setDelegate:"
    for (NSString *methodStr in methodArray) {
        NSString *newMethodStr = [[@"ndl_" stringByAppendingString:methodStr] stringByReplacingOccurrencesOfString:@"__" withString:@"_"];
        ReplaceMethod([self class], NSSelectorFromString(methodStr), NSSelectorFromString(newMethodStr));
    }
}

#pragma mark - public methods
- (void)setNavBarFirstSubViewAlpha:(CGFloat)alpha
{
//    NSLog(@"subView = %@", self.navigationBar.subviews);
    UIView *navBarFirstSubView = self.navigationBar.subviews.firstObject;// _UIBarBackground
    /*
     [
     <UIImageView: 0x7f99bcc8e4c0; frame = (0 64; 375 0.5); userInteractionEnabled = NO; layer = <CALayer: 0x6000030621a0>>,
     <UIVisualEffectView: 0x7f99bcc8e6f0; frame = (0 0; 375 64); layer = <CALayer: 0x6000030624e0>>
     ]
     */
//    NSLog(@"subView = %@", navBarFirstSubView.subviews);
    
//    [CommonUtils logIvarListForClass:[navBarFirstSubView class]];
//    NSLog(@"==========我是分割线==========");
//    [CommonUtils logPropertyListForClass:[navBarFirstSubView class]];
    
    // 阴影视图
    UIView *shadowView = [navBarFirstSubView valueForKey:@"_shadowView"];
    if (shadowView) {
        shadowView.alpha = alpha;
    }
    
    // 如果导航栏默认没有设置半透明,背景视图透明度也进行改变
    if (!self.navigationBar.isTranslucent) {
        navBarFirstSubView.alpha = alpha;
        return;
    }
    
    NSLog(@"UINavigationController+NDLExtension: isTranslucent = YES");
    if (@available(iOS 10.0, *)) {
        UIView *bgEffectView = [navBarFirstSubView valueForKey:@"_backgroundEffectView"];// 拿到的是_UIBarBackground层级上面的UIVisualEffectView
        if (bgEffectView && ![self.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault]) {
            bgEffectView.alpha = alpha;
        }
    } else {
        UIView *backdropView = [navBarFirstSubView valueForKey:@"_adaptiveBackdrop"];
        UIView *backdropEffectView = [backdropView valueForKey:@"_backdropEffectView"];
        if (backdropView && backdropEffectView) {
            backdropEffectView.alpha = alpha;
        }
    }
}

#pragma mark - private methods
- (void)ndl_updateInteractiveTransition:(CGFloat)percentComplete
{
    UIViewController *topVC = self.topViewController;
    if (!topVC) {
        return;
    }
    // 1.获取转场上下文协调者
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = topVC.transitionCoordinator;
    // 2.根据转场上下文协调者获取转场始末控制器
    UIViewController *fromVC = [transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    // 3.获取始末控制器导航栏透明度
    CGFloat fromNavBarAlpha = fromVC.navBarAlpha;
    CGFloat toNavBarAlpha = toVC.navBarAlpha;
    // 4.计算转场过程中变化的透明度值(系统默认从一个颜色过渡到另一个颜色，不考虑alpha，eg:toVC的navBar color:blue alpha:0.0,刚开始边缘交互的时候 颜色会一下子变为blue)
    CGFloat curNavBarAlpha = fromNavBarAlpha + (toNavBarAlpha - fromNavBarAlpha) * percentComplete;
    // 5.重新设定透明度
    [self setNavBarFirstSubViewAlpha:curNavBarAlpha];
    
    // 6.设置转场中的tintColor ?
    
    // 调用系统原来的操作(调用系统原来的f操作前，做一些自定义操作)
    [self ndl_updateInteractiveTransition:percentComplete];
}

//- (NSArray<UIViewController *> *)ndl_popToViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [self setNavBarFirstSubViewAlpha:viewController.navBarAlpha];
//
//    return [self ndl_popToViewController:viewController animated:animated];
//}

//- (NSArray<UIViewController *> *)ndl_popToRootViewControllerAnimated:(BOOL)animated
//{
//    [self setNavBarFirstSubViewAlpha:self.viewControllers.firstObject.navBarAlpha];
//
//    return [self ndl_popToRootViewControllerAnimated:animated];
//}

#pragma mark - UINavigationBarDelegate
//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
//{
//
//    return YES;
//}

// 处理手势转场取消的情况 （侧滑返回也会走这个）
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    UIViewController *topVC = self.topViewController;
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = topVC.transitionCoordinator;
    
    
    return YES;
}

@end
