//
//  UIViewController+NDLExtension.h
//  NDL_Category
//
//  Created by ndl on 2017/11/20.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

// 页面跳转的顺序viewDidLoad->===viewWillDisappear===->viewWillAppear->(viewWillLayoutSubviews->viewDidLayoutSubviews执行多次)->===viewDidDisappear===->viewDidAppear->(viewWillLayoutSubviews->viewDidLayoutSubviews可能出现，请求慢，请求完了更新UI)
// 跳转界面 eg:pushViewController pushViewController前面可以设置将要显示vc的属性,pushViewController后面 新的vc才会viewDidLoad
@interface UIViewController (NDLExtension)

- (void)ndl_popToViewController:(Class)viewControllerClass;

+ (instancetype)ndl_curTopViewController;

@end
