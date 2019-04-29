//
//  UINavigationBar+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2019/4/8.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 官方文档
 translucent:
 默认是YES
 您可以通过将属性设置为NO来强制使用不透明背景
 如果导航栏具有自定义背景图像，则默认值是从图像的Alpha值推断出来的。如果它具有alpha <1.0的任何像素（则为YES）
 1.如果setTranslucent:YES 并 设置了不透明的自定义背景图像。它会将小于1.0的系统不透明度应用于图像
 2.如果setTranslucent:NO 并 设置了半透明的自定义背景图像。它将使用barTintColor（如果定义了）为图像提供不透明的背景
 或者黑色for UIBarStyleBlack，白色for UIBarStyleDefault，如果barTintColor为nil
 */

/*
 // translucent = NO _UIBarBackground上面的UIVisualEffectView没有被创建,barTintColor作用于_UIBarBackground,
 // translucent = YES barTintColor作用于_UIBarBackground的UIVisualEffectView的最上面的view(index = 2)
 
 self.navigationController.navigationBar.translucent = YES;
 */

/*
 UINavigationBarDelegate:
 shouldPushItem
 didPushItem
 shouldPopItem
 didPopItem
 
 A->B:
 B:viewWillAppear
 shouldPushItem navVC.topViewController = B
 didPushItem
 B:viewDidAppear
 
 B->A:
 返回
 shouldPopItem navVC.topViewController = B
 A:viewWillAppear navVC.topViewController = A
 didPopItem navVC.topViewController = A
 A:viewDidAppear
 
 手势返回
 A:viewWillAppear navVC.topViewController = A
 shouldPopItem navVC.topViewController = A
 didPopItem navVC.topViewController = A
 A:viewDidAppear
 */
@interface UINavigationBar (NDLExtension)

- (UIView *)ndl_backgroundView;

- (CGFloat)ndl_backgroundOpacity;

@end

NS_ASSUME_NONNULL_END
