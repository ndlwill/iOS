//
//  DrawerTransitionAnimator.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

// 抽屉转场动画 (UIViewControllerTransitioningDelegate for presentVC)
@interface DrawerTransitionAnimator : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) BOOL isPresentFlag;

@end
