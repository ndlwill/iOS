//
//  NDLConstants.m
//  NDL_Category
//
//  Created by dzcx on 2018/4/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

// swift demo
// https://github.com/zixun/CocoaChinaPlus
// https://github.com/Light413/dctt
// https://github.com/hrscy/TodayNews

// swift教程
// http://www.swift51.com/swift4.0/chapter2/chapter2.html

// swift第三方
// RxSwift
// https://www.jianshu.com/p/f61a5a988590
// https://beeth0ven.github.io/RxSwift-Chinese-Documentation/

// YTKNetwork是比较经典的利用OOP思想（面向对象）

// Moya
// 基于swift的Moya虽然也有使用到继承，但是它的整体上是以POP思想（Protocol Oriented Programming,面向协议编程）

/*
 swift:
 1.Safe
 在软件生产之前捕获开发人员的错误
 2.Fast
 3.Expressive
 
 Features:
 使代码更易于读写
 支持推断类型，使代码更清晰，更不容易出错，模块消除了头文件并提供了命名空间
 
 闭包与函数指针统一
 元组和多个返回值
 支持方法，扩展和协议的结构体
 功能编程模式，例如映射和过滤
 */

#import "NDLConstants.h"

NSString * const kRemoteGifUrlStr = @"https://raw.githubusercontent.com/mengxianliang/XLPlayButton/master/GIF/1.gif";

NSString * const kMessageTableName = @"t_message";
NSString * const kTestTableName = @"t_test";

// label: font = 15
CGFloat const kSystemBadgeViewWH = 18.0;

// 50
NSInteger const kTextViewMaxTextLength = 5;

CGFloat const kBigTitleWrapperViewHeight = 60.0;
CGFloat const kBigTitleFontSize = 28.0;
CGFloat const kBigTitleBundleMargin = (40 - kBigTitleFontSize) / 2.0;
// ((40 - 28) / 2)=6 + 28 = 34
CGFloat const kBigTitleLimitY = (kBigTitleBundleMargin + kBigTitleFontSize);

CGFloat const kBigTitleHeight = 60.0;
CGFloat const kBigTitleMaxY = 52.0;
CGFloat const kBigTitleMiddleY = 28.0;

// NavigationItemBarButton Tags
NSInteger const kNavigationItemLeftBarButtonTag = 2000;
// Transition Tags
NSInteger const kTransitionAnimationViewTag = 3000;

NSString * const kAES_Key = @"1234567812345678";// 最多16bytes
NSString * const kAES_IV = @"AES_IV";// 最多16bytes

#pragma mark - Navigation
CGFloat const kNavBackButtonWidth = 60.0;
CGFloat const kNavBigTitleContainerViewHeight = 48.0;
CGFloat const kNavBigTitleHeight = 40.0;
CGFloat const kNavBigTitleLeadingToLeftEdge = 20.0;
CGFloat const kNavTextFieldBigTitleContainerViewHeight = 50.0;
