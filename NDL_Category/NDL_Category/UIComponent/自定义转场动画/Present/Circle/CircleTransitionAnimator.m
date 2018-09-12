//
//  CircleTransitionAnimator.m
//  DaZhongChuXing
//
//  Created by dzcx on 2018/9/5.
//  Copyright © 2018年 tony. All rights reserved.
//

#import "CircleTransitionAnimator.h"

@interface CircleTransitionAnimator ()

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation CircleTransitionAnimator

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
   self.isPresentFlag = YES;
   return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
   self.isPresentFlag = NO;
   return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
   return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
   self.transitionContext = transitionContext;
   
   if (self.isPresentFlag) {
      UIView *containerView = transitionContext.containerView;
      UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
      // 先添加toView
      [containerView addSubview:toVC.view];
      
      UIBezierPath *originPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.originCenterPoint.x, self.originCenterPoint.y, 0, 0)];
      CGFloat finalCircleRadius = sqrt(kScreenWidth * kScreenWidth + kScreenHeight * kScreenHeight);
      
      UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.originCenterPoint.x - finalCircleRadius, self.originCenterPoint.y - finalCircleRadius, 2 * finalCircleRadius, 2 * finalCircleRadius)];
      
      CAShapeLayer *maskLayer = [CAShapeLayer layer];
      maskLayer.path = finalPath.CGPath;// modelLayer status(end status)
      toVC.view.layer.mask = maskLayer;
      
      CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
      maskAnimation.fromValue = (__bridge id _Nullable)(originPath.CGPath);
      maskAnimation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
      maskAnimation.duration = [self transitionDuration:transitionContext];
      maskAnimation.delegate = self;
      [maskLayer addAnimation:maskAnimation forKey:nil];
   } else {
      UIView *containerView = transitionContext.containerView;
      UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
      UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
      
      [containerView addSubview:toVC.view];
      [containerView addSubview:fromVC.view];
      
      UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.originCenterPoint.x, self.originCenterPoint.y, 0, 0)];
      CGFloat finalCircleRadius = sqrt(kScreenWidth * kScreenWidth + kScreenHeight * kScreenHeight);
      
      UIBezierPath *originPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.originCenterPoint.x - finalCircleRadius, self.originCenterPoint.y - finalCircleRadius, 2 * finalCircleRadius, 2 * finalCircleRadius)];
      
      CAShapeLayer *maskLayer = [CAShapeLayer layer];
      maskLayer.path = finalPath.CGPath;
      fromVC.view.layer.mask = maskLayer;
      
      CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
      maskAnimation.fromValue = (__bridge id _Nullable)(originPath.CGPath);
      maskAnimation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
      maskAnimation.duration = [self transitionDuration:transitionContext];
      maskAnimation.delegate = self;
      [maskLayer addAnimation:maskAnimation forKey:nil];
   }
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
   [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
   
   [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
   [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

@end
