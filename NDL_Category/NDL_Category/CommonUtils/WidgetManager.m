//
//  WidgetManager.m
//  NDL_Category
//
//  Created by dzcx on 2018/9/5.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "WidgetManager.h"

@implementation WidgetManager

#pragma mark - class methods
+ (UILabel *)labelWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    if (text && ![text isEqualToString:@""]) {
        label.text = text;
    }
    return label;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor title:(NSString *)title borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font = titleFont;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (title && ![title isEqualToString:@""]) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    if (borderWidth != 0) {
        button.layer.borderWidth = borderWidth;
        button.layer.borderColor = borderColor.CGColor;
    }
    
    if (cornerRadius != 0) {
        button.layer.cornerRadius = cornerRadius;
    }
    
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor title:(NSString *)title imageName:(NSString *)imageName borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius target:(id)target action:(SEL)action
{
    UIButton *button = [WidgetManager buttonWithFrame:frame titleFont:titleFont titleColor:titleColor title:title borderWidth:borderWidth borderColor:borderColor cornerRadius:cornerRadius target:target action:action];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    return button;
}

+ (UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    if (cornerRadius != 0) {
        view.layer.cornerRadius = cornerRadius;
    }
    return view;
}

+ (UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIView *view = [WidgetManager viewWithFrame:frame backgroundColor:backgroundColor cornerRadius:cornerRadius];
    if (borderWidth != 0) {
        view.layer.borderWidth = borderWidth;
        if (borderColor) {
            view.layer.borderColor = borderColor.CGColor;
        }
    }
    return view;
}

+ (UITableView *)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    tableView.estimatedRowHeight = 0.0;
    tableView.estimatedSectionHeaderHeight = 0.0;
    tableView.estimatedSectionFooterHeight = 0.0;
    
    tableView.separatorStyle = separatorStyle;
    
    return tableView;
}

@end
