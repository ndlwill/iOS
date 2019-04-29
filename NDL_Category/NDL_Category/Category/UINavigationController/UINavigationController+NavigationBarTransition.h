//
//  UINavigationController+NavigationBarTransition.h
//  NDL_Category
//
//  Created by dzcx on 2019/4/9.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NavigationBarTransitionStyle) {
    NavigationBarTransitionStyle_System = 0,// crossFade
    NavigationBarTransitionStyle_FullScreen
};

NS_ASSUME_NONNULL_BEGIN

/*
 系统##手势##返回:调用顺序
 popViewControllerAnimated
 B:viewWillDisappear
 A:viewWillAppear
 updateInteractiveTransition
 */
@interface UINavigationController (NavigationBarTransition)

@end

NS_ASSUME_NONNULL_END
