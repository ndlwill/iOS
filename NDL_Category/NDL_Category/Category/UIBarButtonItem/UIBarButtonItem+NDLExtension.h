//
//  UIBarButtonItem+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/4/10.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (NDLExtension)

// 只针对只有图片的
+ (instancetype)itemWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action;

@end
