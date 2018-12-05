//
//  UIViewController+NavigationBarExtension.m
//  NDL_Category
//
//  Created by dzcx on 2018/11/8.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "UIViewController+NavigationBarExtension.h"
#import "UINavigationController+NDLExtension.h"
#import <objc/runtime.h>

@implementation UIViewController (NavigationBarExtension)
#pragma mark - getter
- (UIColor *)navBarTintColor
{
    return self.navigationController.navigationBar.barTintColor;
}

- (UIColor *)navItemTintColor
{
    return self.navigationController.navigationBar.tintColor;
}

- (CGFloat)navBarAlpha
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

#pragma mark - setter
- (void)setNavBarTintColor:(UIColor *)navBarTintColor
{
    self.navigationController.navigationBar.barTintColor = navBarTintColor;
}

- (void)setNavItemTintColor:(UIColor *)navItemTintColor
{
    self.navigationController.navigationBar.tintColor = navItemTintColor;
}

- (void)setNavBarAlpha:(CGFloat)navBarAlpha
{
    objc_setAssociatedObject(self, @selector(navBarAlpha), @(navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNavBarFirstSubViewAlpha:navBarAlpha];
}
@end
