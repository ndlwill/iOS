//
//  UITabBarItem+NDLExtension.m
//  NDL_Category
//
//  Created by dzcx on 2018/5/14.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "UITabBarItem+NDLExtension.h"

@implementation UITabBarItem (NDLExtension)

- (UIView *)ndl_badgeSuperView
{
    UIView *tabBarButton = [self valueForKey:@"_view"];
    for (UIView *subView in tabBarButton.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            return subView;
        }
    }
    return tabBarButton;
}

@end
