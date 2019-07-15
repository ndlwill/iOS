//
//  HomeTranViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/12/18.
//  Copyright © 2018 ndl. All rights reserved.
//

#import "HomeTranViewController.h"
#import "TranNextViewController.h"

@interface HomeTranViewController () <UITextFieldDelegate, UINavigationControllerDelegate>

@end

@implementation HomeTranViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.transitioningDelegate
    self.view.backgroundColor = [UIColor yellowColor];
    self.title = @"Home";
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(20, TopExtendedLayoutH, self.view.width - 40, 60)];
    topView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:topView];
    topView.layer.cornerRadius = 10.0;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, topView.width - 20, topView.height - 20)];
    textField.placeholder = @"select address";
    textField.delegate = self;
//    textField.backgroundColor = [UIColor whiteColor];
    [topView addSubview:textField];
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.navigationController pushViewController:[TranNextViewController new] animated:YES];
    return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
}

#pragma mark - UINavigationControllerDelegate
//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
//{
//    if (operation == UINavigationControllerOperationPush) {// push
//        NSLog(@"===Five Push ===");// 3.
//        BellhopTransitionAnimator *animator = [[BellhopTransitionAnimator alloc] init];
//        animator.transitionDuration = 0.2;
//        animator.isPushFlag = YES;
//
//        return animator;
//    }
//    
//    return nil;// 返回nil表示默认转场动画
//}

@end
