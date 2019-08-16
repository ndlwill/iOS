//
//  UIView+NDLTapGesture.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/10.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 操作设备的方式主要有三种：触摸屏幕、晃动设备、通过遥控设施控制设备。对应的事件类型有以下三种：
 1、触屏事件（Touch Event）
 2、运动事件（Motion Event）
 3、远端控制事件（Remote-Control Event）
 
 响应者对象（Responder Object），指的是有响应和处理上述事件能力的对象。响应者链就是由一系列的响应者对象构成的一个层次结构
 */

@interface UIView (NDLTapGesture)

- (void)ndl_addTapGestureWithHandler:(CommonNoParamNoReturnValueBlock)handler;

@end
