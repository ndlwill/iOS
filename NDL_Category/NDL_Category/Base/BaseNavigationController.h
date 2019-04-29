//
//  BaseNavigationController.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/19.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 UINavigationController:
 层级关系
 UILayoutContainerView(UINavigationTransitionView(UIViewControllerWrapperView), UINavigationBar)
 */

/*
 私有变量:
 valueForKey:@"_isTransitioning"    // transition动画是否正在进行
 
 内部的selector:
 NSSelectorFromString(@"handleNavigationTransition:");
 
 // ###
 @"_updateInteractiveTransition:"
 */
@interface BaseNavigationController : UINavigationController

@end
