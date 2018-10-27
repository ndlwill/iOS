//
//  UITabBarItem+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/5/14.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (NDLExtension)

// 获取badgeView的父视图
- (UIView *)ndl_badgeSuperView;

@end
