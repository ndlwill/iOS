//
//  MBProgressHUD+NDLExtension.m
//  NDL_Category
//
//  Created by dzcx on 2018/9/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "MBProgressHUD+NDLExtension.h"

@implementation MBProgressHUD (NDLExtension)

+ (void)ndl_showIndicatorToView:(UIView *)parentView
{
    if (parentView == nil) {
        parentView = KeyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)ndl_showIndicatorToView:(UIView *)parentView text:(NSString *)text
{
    if (parentView == nil) {
        parentView = KeyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    hud.label.text = text;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)ndl_showText:(NSString *)text toView:(UIView *)parentView
{
    if (parentView == nil) {
        parentView = KeyWindow;
    }
    // 这个方法默认 //    hud.removeFromSuperViewOnHide = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:18.0];
    
    [hud hideAnimated:YES afterDelay:1.0f];
}

+ (void)ndl_showCustomViewWithImageNamed:(NSString *)imageName text:(NSString *)text toView:(UIView *)parentView
{
    if (parentView == nil) {
        parentView = KeyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:1.f];
}

+ (void)ndl_hideHUDFromView:(UIView *)parentView animated:(BOOL)animated
{
    if (parentView == nil) {
        parentView = KeyWindow;
    }
    [self hideHUDForView:parentView animated:animated];
}

@end
