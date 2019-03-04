//
//  MagicMoveTransitionAnimator.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "MagicMoveTransitionAnimator.h"

@implementation MagicMoveTransitionAnimator

#pragma mark - init
- (instancetype)init
{
    if (self = [super init]) {
        _transitionDuration = 0.5;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return _transitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = transitionContext.containerView;// UIViewControllerWrapperView
    
    if (self.isPushFlag) {// push
        NSLog(@"push before containerView.subViews = %@", containerView.subviews);// FiveView(fromView) 系统自动添加fromView
//        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//        NSLog(@"toView = %@ toVC = %@", toView, toVC);
        
        UIImageView *toImageView = nil;
        for (UIView *subView in toView.subviews) {
            if ([subView isKindOfClass:[UIImageView class]]) {
                toImageView = (UIImageView *)subView;
                break;
            }
        }
//        UIView *toTransitionView = [toView viewWithTag:kTransitionAnimationViewTag];
        self.animationOriginView.hidden = YES;
        toView.alpha = 0.0;
        toImageView.hidden = YES;
        
        [containerView addSubview:toView];
        [containerView addSubview:self.animationTempView];
        // toImageView在toView的坐标 转换成 在containerView的坐标
        CGRect toImageViewFinalFrameInContainerView = [containerView convertRect:toImageView.frame fromView:toView];
        
        [UIView animateWithDuration:_transitionDuration delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            toView.alpha = 1.0;
            self.animationTempView.frame = toImageViewFinalFrameInContainerView;
        } completion:^(BOOL finished) {
            toImageView.hidden = NO;
            
            self.animationTempView.hidden = YES;
            /* 转场的结果有两种：完成或取消。非交互转场的结果只有完成一种情况，不过交互式转场需要考虑取消的情况。如何结束取决于转场的进度，通过[transitionContext transitionWasCancelled]方法来获取转场的结果，然后使用completeTransition:来通知系统转场过程结束，这个方法会检查动画控制器是否实现了animationEnded:方法，如果有，则调用该方法*/
            // before completeTransition: 有fromView+toView
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            // after completeTransition: fromView被移除
            NSLog(@"push after containerView.subViews = %@", containerView.subviews);// SixView(toView) + animationTempView 完成后系统自动移除fromView
        }];
    } else {// pop
        NSLog(@"pop before containerView.subViews = %@", containerView.subviews);// SixView(fromView) + animationTempView
        
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        
        UIImageView *fromImageView = nil;
        for (UIView *subView in fromView.subviews) {
            if ([subView isKindOfClass:[UIImageView class]]) {
                fromImageView = (UIImageView *)subView;
                break;
            }
        }
        fromImageView.hidden = YES;
        self.animationTempView.hidden = NO;// 显示截图view
        
        CGRect fromImageViewFinalFrameInContainerView = [containerView convertRect:self.animationOriginView.frame fromView:self.animationOriginView.superview];
        
        // 添加toView
        [containerView insertSubview:toView atIndex:0];
        [containerView bringSubviewToFront:self.animationTempView];// 防止five push six push other pop six时视图层级问题
        
        [UIView animateWithDuration:_transitionDuration delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            fromView.alpha = 0.0;
            self.animationTempView.frame = fromImageViewFinalFrameInContainerView;
        } completion:^(BOOL finished) {
            NSLog(@"===self.interactiveTransition finish || cancel后走这边===");
            fromImageView.hidden = NO;
            
            /*
             cancel:
             
             动画里设置的，系统会帮我们恢复
             fromView.alpha = 0.0;
             self.animationTempView.frame = fromImageViewFinalFrameInContainerView;
             */
            if (transitionContext.transitionWasCancelled) {// cancel
                // 恢复到初始状态
                self.animationTempView.hidden = YES;// 不写也行～
                [transitionContext completeTransition:NO];
            } else {// finish
                self.animationOriginView.hidden = NO;
                [self.animationTempView removeFromSuperview];// 必须移除
                [transitionContext completeTransition:YES];
            }
            
//            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            NSLog(@"pop after containerView.subViews = %@", containerView.subviews);
        }];
    }
}

@end
