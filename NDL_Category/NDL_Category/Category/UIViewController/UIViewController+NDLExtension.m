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
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

@end
