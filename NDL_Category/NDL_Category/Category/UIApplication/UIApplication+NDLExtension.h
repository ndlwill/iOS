//
//  UIApplication+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/6.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (NDLExtension)

// 适配系统版本的openURL
- (void)ndl_openURL:(NSURL *)url;

@end
