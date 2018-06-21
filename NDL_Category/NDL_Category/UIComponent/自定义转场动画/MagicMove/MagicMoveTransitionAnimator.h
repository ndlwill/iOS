//
//  MagicMoveTransitionAnimator.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

// UIViewControllerAnimatedTransitioning 控制器动画过渡协议

// 转场动画器对象
@interface MagicMoveTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) NSTimeInterval transitionDuration;
@property (nonatomic, assign) BOOL isPushFlag;

// fromView中执行动画的tempView
@property (nonatomic, weak) UIView *animationTempView;
// fromView中originView
@property (nonatomic, weak) UIView *animationOriginView;

@end
