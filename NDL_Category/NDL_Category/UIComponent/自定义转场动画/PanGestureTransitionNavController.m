//
//  PanGestureTransitionNavController.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "PanGestureTransitionNavController.h"



@interface PanGestureTransitionNavController ()



@end

@implementation PanGestureTransitionNavController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDidTriggered:)];
    [self.view addGestureRecognizer:panGesture];
}

#pragma mark - Gesture Callback
- (void)panGestureDidTriggered:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translationOffset = [panGesture translationInView:self.view];
    CGFloat progress = fabs(translationOffset.x) / self.view.width;
    
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            if (self.viewControllers.count > 1) {
                [self popViewControllerAnimated:YES];
            } else {
                [self pushViewController:self.pushVC animated:YES];
            }
            
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"velocity = %lf progress = %lf", [panGesture velocityInView:panGesture.view].x, progress);
            [self.interactiveTransition updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateEnded:
            if ([panGesture velocityInView:panGesture.view].x > 0) {
                [self.interactiveTransition finishInteractiveTransition];
            } else {
                [self.interactiveTransition cancelInteractiveTransition];
            }
            self.interactiveTransition = nil;
            break;
            
        default:
            [self.interactiveTransition cancelInteractiveTransition];
            self.interactiveTransition = nil;
            break;
    }
    
}

@end
