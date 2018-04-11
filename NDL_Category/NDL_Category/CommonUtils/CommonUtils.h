//
//  CommonUtils.h
//  NDL_Category
//
//  Created by ndl on 2017/10/18.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonUtils : NSObject

// 键盘所在的window
+ (UIWindow *)keyboardWindow;
// 是否有第三方输入法
+ (BOOL)haveExtensionInputMode;

// 获取一个像素
+ (CGFloat)onePixel;

// 打印某个类所有的成员变量
+ (void)logIvarListForClass:(Class)className;
// 打印某个类所有的属性
+ (void)logPropertyListForClass:(Class)className;

@end
