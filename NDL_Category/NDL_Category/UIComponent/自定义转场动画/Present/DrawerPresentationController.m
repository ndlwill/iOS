//
//  DrawerPresentationController.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "DrawerPresentationController.h"

static CGFloat const kPresentedViewTopOffsetToEdge = 100.0;

@interface DrawerPresentationController ()

@property (nonatomic, strong) UIVisualEffectView *blurView;

@end

// log打印基于
//    [self.containerView addSubview:presentingVC.view];
//    [self.containerView addSubview:self.blurView];
@implementation DrawerPresentationController

#pragma mark - Overrides
// 在呈现过渡即将开始的时候被调用
- (void)presentationTransitionWillBegin
{
    // 创建视图
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.blurView.frame = self.containerView.bounds;
    self.blurView.alpha = 0.0;
    
    UIViewController *presentingVC = self.presentingViewController;
    NSLog(@"containerView superView = %@ keyWindow = %@", self.containerView.superview, KeyWindow);// window = keyWindow
    NSLog(@"containerView = %@ containerView subViews = %@ presentingView superView = %@ presentedView superView = %@", self.containerView, self.containerView.subviews, presentingVC.view.superview, self.presentedViewController.view.superview);// UITransitionView:##0x7ffd35d1eed0##, [], UITransitionView:0x7fb8724069d0, (null)
    NSLog(@"===presentationTransitionWillBegin presentingVC = %@", presentingVC);// first
    NSLog(@"===presentationTransitionWillBegin presentedVC = %@ presentedView = %@", self.presentedViewController, self.presentedViewController.view);// next, UIView
    
    // self.containerView被传递给动画控制器
//    [self.containerView addSubview:presentingVC.view];
//    [self.containerView addSubview:self.blurView];
//  /*[self.containerView addSubview:self.presentedView];*/
//    NSLog(@"presentingView superView = %@ containerView subViews = %@", presentingVC.view.superview, self.containerView.subviews);// UITransitionView: ##0x7ffd35d1eed0##(containerView)
    
    [presentingVC.view.superview addSubview:self.blurView];
    

    
    [presentingVC.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.blurView.alpha = 0.7;
        presentingVC.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:nil];
}

// 在呈现过渡结束时被调用
- (void)presentationTransitionDidEnd:(BOOL)completed
{
    NSLog(@"presentationTransitionDidEnd: containerView subViews = %@", self.containerView.subviews);// 3个 presentedView=0x7f972c5201b0
    if (!completed) {
        [self.blurView removeFromSuperview];
    }
}

//- (BOOL)shouldRemovePresentersView
//{
//    return NO;
//}

// =====上面设置presentationTransition=====



// =====设置dismissalTransition=====
- (void)dismissalTransitionWillBegin
{
    UIViewController *presentingVC = self.presentingViewController;
    NSLog(@"===dismissalTransitionWillBegin===");
//    NSLog(@"===dismissalTransitionWillBegin presentingVC = %@ presentingView = %@", presentingVC, presentingVC.view);// first, UIView: ##0x7f9e1f516a40##(scale = 0.9, 0.9)
    [presentingVC.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.blurView.alpha = 0.0;
        presentingVC.view.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    NSLog(@"===dismissalTransitionDidEnd container subView = %@ container superView = %@===", self.containerView.subviews, self.containerView.superview);// 3个 presentingView=UIView: ##0x7f9e1f516a40##, blurView, presentedView ||| window
    if (completed) {
        NSLog(@"===dismissalTransitionDidEnd completed===");
        [self.blurView removeFromSuperview];
    }
    
    //    [self.containerView addSubview:presentingVC.view];
    //    [self.containerView addSubview:self.blurView];
    // 这种情况下需要下面
//    [KeyWindow addSubview:self.presentingViewController.view];
}

// =====调整presentedView=====

// 被presented的view
- (UIView *)presentedView
{
    UIView *presentedView = self.presentedViewController.view;
    presentedView.layer.cornerRadius = 8.0;
    return presentedView;
}

// 被presented的view的frame
- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect containerRect = self.containerView.bounds;
    CGRect presentedViewRect = CGRectMake(containerRect.origin.x, containerRect.origin.y + kPresentedViewTopOffsetToEdge, containerRect.size.width, containerRect.size.height - kPresentedViewTopOffsetToEdge);
    return presentedViewRect;
}

// ios8以上的系统，可以通过UIPresentationController类并重写以下方法并返回true可以解决
// Indicate whether the view controller's view we are transitioning from will be removed from the window in the end of the presentation transition  (Default: NO)
//- (BOOL)shouldRemovePresentersView
//{
//    return YES;
//}

- (void)dealloc
{
    NSLog(@"===DrawerPresentationController Dealloc===");
}

@end
