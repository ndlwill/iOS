//
//  NextViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NextViewController.h"
#import "DrawerTransitionAnimator.h"

@interface NextViewController ()

// https://developer.apple.com/documentation/uikit/uipercentdriveninteractivetransition?language=objc
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;

@property (nonatomic, assign) BOOL dismissFlag;

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dismissFlag = YES;
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDidTriggered:)];
    [self.view addGestureRecognizer:panGesture];
}

// 有点瑕疵，界面闪烁(一开始向上平移)
//- (void)panGestureDidTriggered:(UIPanGestureRecognizer *)panGesture
//{
//    CGFloat offsetY = [panGesture translationInView:self.view].y;
//    CGFloat velocityY = [panGesture velocityInView:self.view].y;
//
//    // 100相对于self.view.height - 100: realOffsetY = (self.view.height - 100) * offsetY / 100; percent = realOffsetY / (self.view.height - 100)
//    CGFloat percent = 0.0;
//    if (offsetY > 0) {
//        percent = offsetY / 300.0;
//    }
//
//    switch (panGesture.state) {
//        case UIGestureRecognizerStateBegan:
//        {
//            self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
//            __strong DrawerTransitionAnimator *transitioningDelegate = (DrawerTransitionAnimator *)self.transitioningDelegate;
//            transitioningDelegate.interactiveTransition = self.interactiveTransition;
//
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//            break;
//        case UIGestureRecognizerStateChanged:
//        {
//            [self.interactiveTransition updateInteractiveTransition:percent];
//        }
//            break;
//        case UIGestureRecognizerStateEnded:// 手指离开屏幕
//        {
//            if (velocityY > 0) {// 向下不显示presentedView
//                NSLog(@"===UIGestureRecognizerStateEnded > 0===");
//                [self.interactiveTransition finishInteractiveTransition];
//            } else {// 向上显示presentedView
//                NSLog(@"===UIGestureRecognizerStateEnded <= 0===");
////                [self.interactiveTransition updateInteractiveTransition:0.0];
//                [self.interactiveTransition cancelInteractiveTransition];
//            }
//
//            self.interactiveTransition = nil;
//        }
//            break;
//
//        default:
//        {
//            NSLog(@"===default===");
//            [self.interactiveTransition cancelInteractiveTransition];
//            self.interactiveTransition = nil;
//        }
//            break;
//    }
//}


- (void)panGestureDidTriggered:(UIPanGestureRecognizer *)panGesture
{
    CGFloat offsetY = [panGesture translationInView:self.view].y;
    CGFloat velocityY = [panGesture velocityInView:self.view].y;
    
    
    
    // 100相对于self.view.height - 100: realOffsetY = (self.view.height - 100) * offsetY / 100; percent = realOffsetY / (self.view.height - 100)
    CGFloat percent = 0.0;
    if (offsetY > 0) {
        percent = offsetY / 300.0;
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"===UIGestureRecognizerStateBegan===");
            NSLog(@"offsetY = %lf velocityY = %lf", offsetY, velocityY);// offsetY第一次拿到可能为0
            
            self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            __strong DrawerTransitionAnimator *transitioningDelegate = (DrawerTransitionAnimator *)self.transitioningDelegate;
            transitioningDelegate.interactiveTransition = self.interactiveTransition;
            
            // 如果是向上的，第一次进panGestureDidTriggered这个方法 拿到的velocityY是<0的
            if (velocityY > 0 ) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            NSLog(@"percent = %lf", percent);
            [self.interactiveTransition updateInteractiveTransition:percent];
        }
            break;
        case UIGestureRecognizerStateEnded:// 手指离开屏幕
        {
            if (velocityY > 0) {// 向下不显示presentedView
                NSLog(@"===UIGestureRecognizerStateEnded > 0===");
                [self.interactiveTransition finishInteractiveTransition];
            } else {// 向上显示presentedView
                NSLog(@"===UIGestureRecognizerStateEnded <= 0===");
                //                [self.interactiveTransition updateInteractiveTransition:0.0];
                [self.interactiveTransition cancelInteractiveTransition];
            }
            
            self.interactiveTransition = nil;
        }
            break;
            
        default:
        {
            NSLog(@"===default===");
            [self.interactiveTransition cancelInteractiveTransition];
            self.interactiveTransition = nil;
        }
            break;
    }
}

- (void)dealloc{
    NSLog(@"===NextViewController Dealloc===");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"NextViewController touchesBegan");
//    [super touchesBegan:touches withEvent:event];// 不写 拦截事件，不向下传递

//    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
