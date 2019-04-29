//
//  DrawerTransitionAnimator.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "DrawerTransitionAnimator.h"
#import "DrawerPresentationController.h"

@implementation DrawerTransitionAnimator

#pragma mark - UIViewControllerTransitioningDelegate
/*
 该方法用于告诉系统谁来负责自定义转场
 第一个参数: 被展现的控制
 第二个参数: 发起的控制器
 */
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return [[DrawerPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

// 告诉系统谁来负责展现的样式
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresentFlag = YES;
    
    return self;
}

// 告诉系统谁来负责消失的样式
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    NSLog(@"===animationControllerForDismissedController===");// dismiss 先执行这个
    self.isPresentFlag = NO;
    
    return self;
}


/*
 interactionControllerForPresentation
 &&
 interactionControllerForDismissal
 1.返回值是nil
执行非交互式动画，走animationControllerForPresentedController&&animationControllerForDismissedController
 2.不是nil
 不会调用animator(动画控制器)的animateTransition方法,调用交互式控制器(UIPercentDrivenInteractiveTransition)的startInteractiveTransition
 不走animationControllerForPresentedController&&animationControllerForDismissedController
 
 
 */
//- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
//{
//    
//}

// 手势dismiss
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if (animator) {
        return self.interactiveTransition;
    }
    
    return nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning
// 该方法用于告诉系统展现或者消失动画的时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

/*
 Custom 模式下，fromView 并不受 containerView 管理，这时通过viewForKey:方法来获取 fromView 得到的是 nil.但是你可以用下面的方法来搞
 获取视图 ** public func viewControllerForKey(key: String) -> UIViewController? **
 key:UITransitionContextToViewControllerKey, and  UITransitionContextFromViewControllerKey. 再通过.view 来拿到对应的 to/from View
 */

/*
 1.FullScreen 模式：presentation 结束后，presentingView 被主动移出视图结构，不过，在 dismissal transition中希望其出现在屏幕上并且在对其添加动画怎么办呢？实际上，你按照容器类 VC 转场里动画控制器里那样做也没有问题，就是将其加入 containerView 并添加动画。不用担心，结束后，UIKit 会自动将其恢复到原来的位置。
 2.Custom 模式：presentation 结束后，presentingView(fromView) 未被主动移出视图结构，在 dismissal 中，注意不要像其他转场中那样将 presentingView(toView) 加入 containerView 中，否则 dismissal 结束后本来可见的 presentingView 将会随着 containerView 一起被移除。如果你在 Custom 模式下没有注意到这点，很容易出现黑屏之类的现象
 */

/// 无论是展现还是消失都会调用这个方法
/// 注意点: 只要实现了这个方法, 那么系统就不会再管控制器如何弹出和消失了, 所有的操作都需要我们自己做
// transitionContext: 里面就包含了我们所有需要的参数
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    /*
    将要执行动画的视图 toView 加到containerView中，其中fromView 系统已经自动加入.
    ** 注意，如果当前是present的style是Custom,那么在dismiss的时候就不要加toView了，一般在转场结束completeTransition后，会自动将fromView从容器中移除。但是Custom类型的时候却没有移除，你可以明显的看到。因此在dismiss的时候，之前的fromView 也就变成了toView。
     **
     */
    
    /*
     当从A present 到B的时候   上面的fromViewController就是A ， toViewController就是B
     这个时候 A就是B的 presentingViewController  B就是A的presentedViewController
     这个是不会受到present还是dismiss影响的
     
     再当从B dismiss到A的时候    上面的fromViewController就是B ， toViewController就是A
     这个时候 toViewController.presentingViewController 也就是A的presentingViewController 就不是B（fromViewController）了，
     是更前面的，要理解的了的话你就知道因该是ViewController
     
     所以这个时候 isPresenting 就是NO
     这就是这个isPresenting判断的逻辑，其实说白了这样可以判断是A到B的present 还是B到A的dismiss
     */
//    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    
    if (self.isPresentFlag) {// present
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        NSLog(@"containerView subView = %@", transitionContext.containerView.subviews);
        [transitionContext.containerView addSubview:toView];
        
        NSLog(@"toVC:initialFrame = %@ finalFrame = %@ containerView = %@", NSStringFromCGRect([transitionContext initialFrameForViewController:toVC]), NSStringFromCGRect([transitionContext finalFrameForViewController:toVC]), transitionContext.containerView);// UITransitionView与UIPresentationController.containerView同一个
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        CGRect animationStartFrame = CGRectOffset(finalFrame, 0, finalFrame.size.height);
        toView.frame = animationStartFrame;
        
        // UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            toView.frame = finalFrame;// next向上
            
        } completion:^(BOOL finished) {
            if (finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }
        }];
    } else {// dismiss
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//        [transitionContext.containerView addSubview:toView];
        
        CGRect animationStartFrame = fromView.frame;
        CGRect animationEndFrame = CGRectOffset(fromView.frame, 0, fromView.height + 10);// 10为额外的安全区域,保证看不到view,如果不写,一直向下移动的时候，会露出一点view
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            // next向下
            fromView.frame = animationEndFrame;
            
        } completion:^(BOOL finished) {
            if (finished) {
                NSLog(@"===dismiss completeTransition before wasCancelled = %ld isInteractive = %ld===", [[NSNumber numberWithBool:transitionContext.transitionWasCancelled] integerValue], [[NSNumber numberWithBool:transitionContext.isInteractive] integerValue]);
                
                if ([transitionContext transitionWasCancelled]) {// 被取消
                    [transitionContext completeTransition:NO];
                    fromView.frame = animationStartFrame;
                } else {
                    [transitionContext completeTransition:YES];
                }
//                [transitionContext completeTransition:![transitionContext transitionWasCancelled] || ![transitionContext isInteractive]];// 我觉得会调用dismissalTransitionDidEnd
                
                
                NSLog(@"===dismiss completeTransition after===");
            }
        }];
    }
}

@end
