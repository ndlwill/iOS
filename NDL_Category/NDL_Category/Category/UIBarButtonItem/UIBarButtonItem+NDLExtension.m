//
//  UIBarButtonItem+NDLExtension.m
//  NDL_Category
//
//  Created by dzcx on 2018/4/10.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "UIBarButtonItem+NDLExtension.h"

@implementation UIBarButtonItem (NDLExtension)

+ (instancetype)itemWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    if (highlightedImage) {
        [button setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    } else {
        button.adjustsImageWhenHighlighted = NO;
    }
    CGSize imageSize = button.currentBackgroundImage.size;
    button.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

@end
