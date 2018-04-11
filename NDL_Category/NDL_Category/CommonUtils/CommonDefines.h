//
//  CommonDefines.h
//  NDL_Category
//
//  Created by ndl on 2018/1/30.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>


#ifdef DEBUG
#define NDLLog(...) NSLog(__VA_ARGS__)
#else
#define NDLLog(...)
#endif

#define MainThreadAssert() NSAssert([NSThread isMainThread], @"needs to be accessed on the main thread.");

#define NDLScreenW [UIScreen mainScreen].bounds.size.width
#define NDLScreenH [UIScreen mainScreen].bounds.size.height

// UIColorFromHex(0xffffff)
#define UIColorFromHex(hex) [UIColor colorWithRed:((hex & 0xFF0000) >> 16) / 255.0 green:((hex & 0x00FF00) >> 8) / 255.0 blue:(hex & 0x0000FF) / 255.0 alpha:1.0]

// 4舍5入 两位小数
#define RoundTwoDecimalPlace(value) (floor(value * 100 + 0.5) / 100)

#define NDLRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define NDLRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//#define IsMainThread [NSThread isMainThread]

// [UIApplication sharedApplication].windows.firstObject
#define KeyWindow [UIApplication sharedApplication].keyWindow

#define kBaseURL @""

// 弱引用
#define WEAK_REF(obj) \
__weak typeof(obj) weak_##obj = obj; \

/// 判断当前编译使用的SDK版本是否为 iOS 11.0 及以上
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
#define IOS11_SDK_ALLOWED YES
#endif

#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)

#define UIFontMake(size) [UIFont systemFontOfSize:size]

// 自动提示宏
// 宏里面的#，会自动把后面的参数变成C语言的字符串  // 逗号表达式，只取最右边的值
#define keyPath(objc,keyPath) @(((void)objc.keyPath,#keyPath))
// 宏的操作原理，每输入一个字母就会直接把宏右边的拷贝，
// 并且会自动补齐前面的内容。

#pragma mark - App
// 获取App当前版本号
#define App_Bundle_Version [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
// 获取App当前build版本号
#define App_Build_Version [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
// 获取App当前名字
#define App_Name [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#pragma mark - Device
// 获取当前设备的UUID
#define Device_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
// 获取当前设备的系统版本
#define Device_System_Version [[[UIDevice currentDevice] systemVersion] floatValue]


CG_INLINE BOOL
ReplaceMethod(Class _class, SEL _originSelector, SEL _newSelector) {
    Method oriMethod = class_getInstanceMethod(_class, _originSelector);
    Method newMethod = class_getInstanceMethod(_class, _newSelector);
    if (!newMethod) {
        // class 里不存在该方法的实现
        return NO;
    }
    BOOL isAddedMethod = class_addMethod(_class, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (isAddedMethod) {
        class_replaceMethod(_class, _newSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
    return YES;
}

#pragma mark - UIEdgeInsets

// UIKIT_STATIC_INLINE
/// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

/// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}
