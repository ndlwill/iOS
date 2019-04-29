//
//  DrawerTransitionAnimator.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
// ################################################################
// ###NB_BLOG###
/*
https://www.cnblogs.com/zhangxiaoxu/p/7054904.html
https://www.jianshu.com/u/e2f2d779c022
 */
 
// present && dismiss   ###转场的关键就是UIViewControllerTransitioningDelegate###

// 官方
// @protocol UIViewControllerTransitionCoordinator <UIViewControllerTransitionCoordinatorContext>

// 抽屉转场动画 (UIViewControllerTransitioningDelegate for presentVC)
@interface DrawerTransitionAnimator : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) BOOL isPresentFlag;

@end
