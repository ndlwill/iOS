//
//  UIApplication+NDLExtension.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/6.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "UIApplication+NDLExtension.h"

@implementation UIApplication (NDLExtension)

- (void)ndl_openURL:(NSURL *)url
{
    if (@available(iOS 10.0, *)) {
        [Application openURL:url options:@{} completionHandler:nil];
    } else {
        [Application openURL:url];
    }
}

@end
