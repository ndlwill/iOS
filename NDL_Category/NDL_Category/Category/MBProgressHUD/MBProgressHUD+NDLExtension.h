//
//  MBProgressHUD+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/9/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (NDLExtension)

// 自带indicator
+ (void)ndl_showIndicatorToView:(UIView *)parentView;
// indicator + text
+ (void)ndl_showIndicatorToView:(UIView *)parentView text:(NSString *)text;

// text
+ (void)ndl_showText:(NSString *)text toView:(UIView *)parentView;

// success || error || info
+ (void)ndl_showCustomViewWithImageNamed:(NSString *)imageName text:(NSString *)text toView:(UIView *)parentView;

// hide
+ (void)ndl_hideHUDFromView:(UIView *)parentView animated:(BOOL)animated;

@end
