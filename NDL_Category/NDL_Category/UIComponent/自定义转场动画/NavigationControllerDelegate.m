//
//  NavigationControllerDelegate.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "CircleTransitionAnimator.h"

@interface NavigationControllerDelegate ()



@end

@implementation NavigationControllerDelegate

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [[CircleTransitionAnimator alloc] init];
}


// UIViewControllerInteractiveTransitioning是一个代理，UIPercentDrivenInteractiveTransition便是iOS为我们提供的一个实现了这一代理的类，该类可以按比例更新视图切换过程、直接完成切换、取消切换等
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransition;
}

@end
