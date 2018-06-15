//
//  CircleTransitionAnimator.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/11.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "CircleTransitionAnimator.h"

@interface CircleTransitionAnimator () 

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation CircleTransitionAnimator 

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    UIView *containerView = transitionContext.containerView;
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSLog(@"fromVC = %@ toVC = %@", fromVC, toVC);
    // 先添加toView
    [containerView addSubview:toVC.view];
    
    // edgeSpace = 10 wh = 50
    UIBezierPath *originPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(NDLScreenW - 10 - 50, TopExtendedLayoutH + 10, 50, 50)];
    CGFloat finalCircleRadius = sqrt(NDLScreenW * NDLScreenW + NDLScreenH * NDLScreenH);
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(NDLScreenW - 10 - 25 - finalCircleRadius, TopExtendedLayoutH + 10 + 25 - finalCircleRadius, 2 * finalCircleRadius, 2 * finalCircleRadius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;// modelLayer status(end status)
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimation.fromValue = (__bridge id _Nullable)(originPath.CGPath);
    maskAnimation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
    maskAnimation.duration = [self transitionDuration:transitionContext];
    maskAnimation.delegate = self;
    [maskLayer addAnimation:maskAnimation forKey:nil];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    [self.transitionContext completeTransition:!self.transitionContext.transitionWasCancelled];
    [self.transitionContext completeTransition:YES];
}

@end
