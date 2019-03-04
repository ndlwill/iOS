//
//  UIViewController+NDLExtension.m
//  NDL_Category
//
//  Created by ndl on 2017/11/20.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import "UIViewController+NDLExtension.h"

@implementation UIViewController (NDLExtension)

- (void)ndl_popToViewController:(Class)viewControllerClass
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:viewControllerClass]) {
            //        if ([vc isMemberOfClass:viewControllerClass]) {// ###
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

// modal转场动画:presentingVC相当于fromVC，presentedVC相当于toVC
+ (instancetype)ndl_curTopViewController
{
    UIViewController *curTopVC = RootViewController;
//    [curTopVC presentingViewController]// present curTopVC的vc
    while ([curTopVC presentedViewController]) {// 被curTopVC present的vc
        curTopVC = [curTopVC presentedViewController];
    }
    
    if ([curTopVC isKindOfClass:[UITabBarController class]] && ((UITabBarController *)curTopVC).selectedViewController != nil) {
        curTopVC = ((UITabBarController *)curTopVC).selectedViewController;
    }
    
    while ([curTopVC isKindOfClass:[UINavigationController class]] && [(UINavigationController*)curTopVC topViewController]) {
        curTopVC = ((UINavigationController*)curTopVC).topViewController;
    }
    
    return curTopVC;
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle
              cancelAction:(void (^)())cancelAction
          destructiveTitle:(NSString *)destructiveTitle
         destructiveAction:(void (^)())destructiveAction
           otherTitleArray:(NSArray<NSString *> *)otherTitleArray
               otherAction:(void (^)(NSInteger index))otherAction
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelTitle) {
        [alertVC addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelAction) {
                cancelAction();
            }
        }]];
    }
    
    if (destructiveTitle) {
        [alertVC addAction:[UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (destructiveAction) {
                destructiveAction();
            }
        }]];
    }
    
    if (otherTitleArray.count > 0) {
        [otherTitleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [alertVC addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (otherAction) {
                    otherAction(idx);
                }
            }]];
        }];
    }
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
