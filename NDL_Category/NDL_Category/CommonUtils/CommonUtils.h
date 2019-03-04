//
//  CommonUtils.h
//  NDL_Category
//
//  Created by ndl on 2017/10/18.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 iOS的keychain服务:
 提供了一种安全的保存私密信息（密码，序列号，证书等）的方式，每个ios程序都有一个独立的keychain存储。
 相对于NSUserDefaults、文件保存等一般方式，keychain保存更为安全，而且keychain里保存的信息不会因App被删除而丢失
 */

// pem转cer证书：$ openssl x509 -in in.pem -out out.cer -outform der

// NSString *regexStr = @"(#\\w+#)";// 含#XXX#的字符串

// NSInteger test = (-22 % 10);// -2
// NSInteger test = (-22 / 10);// -2
@interface CommonUtils : NSObject

+ (NSInteger)integerCeil:(NSInteger)value;

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

// 打开app setting
+ (void)openAppSettingURL;

// scrollView总共数据量
+ (NSUInteger)totalDataCountsForScrollView:(UIScrollView *)scrollView;

// 播放自定义声音
+ (void)playCustomSoundWithPath:(NSString *)resourcePath;

+ (NSArray *)bubbleSort:(NSArray *)array;

// =====C Function=====
// 冒泡排序
void bubbleSort_C(int array[], int arrayLength);
// 选择排序
void selectionSort_C(int array[], int arrayLength);
// 快速排序
void quickSort_C(int array[], int minIndex, int maxIndex);
// 二分查找(在排好序的基础上实现)


// SSID全称Service Set IDentifier - wifi名称

// ========test========
+ (void)logStackInfo;

+ (void)testForSubTitles:(NSString *)subTitle,...NS_REQUIRES_NIL_TERMINATION;

+ (void)logTimeZone:(NSTimeZone *)timeZone;

+ (void)logDate;

+ (void)logCalendar;

+ (void)logLocal:(NSLocale *)local;

+ (void)testDate;

@end
