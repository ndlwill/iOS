//
//  WidgetManager.h
//  NDL_Category
//
//  Created by dzcx on 2018/9/5.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WidgetManager : NSObject

// label
+ (UILabel *)labelWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment text:(NSString *)text;

// button
+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor title:(NSString *)title borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius target:(id)target action:(SEL)action;

+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor title:(NSString *)title imageName:(NSString *)imageName borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius target:(id)target action:(SEL)action;

// view
+ (UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius;

+ (UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

// UITableView
+ (UITableView *)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle;

@end
