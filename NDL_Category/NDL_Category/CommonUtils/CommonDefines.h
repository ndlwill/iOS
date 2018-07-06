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

//CGRectOffset(CGRectMake(0, 0, 100, 100), 0, 10) // {0, 10, 100, 100}
//CGRectInset(CGRectMake(0, 0, 100, 100), 0, 10) // {0, 10, 100, 80}

//#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);

#ifdef DEBUG
#define NDLLog(...) NSLog(__VA_ARGS__)
#else
#define NDLLog(...)
#endif


#define IsMainThread [NSThread isMainThread]
#define MainThreadAssert() NSAssert([NSThread isMainThread], @"needs to be accessed on the main thread.");

#define NDLScreenW [UIScreen mainScreen].bounds.size.width
#define NDLScreenH [UIScreen mainScreen].bounds.size.height

// UIColorFromHex(0xffffff)
#define UIColorFromHex(hex) [UIColor colorWithRed:((hex & 0xFF0000) >> 16) / 255.0 green:((hex & 0x00FF00) >> 8) / 255.0 blue:(hex & 0x0000FF) / 255.0 alpha:1.0]

// 4舍5入 两位小数
#define RoundTwoDecimalPlace(value) (floor(value * 100 + 0.5) / 100)

#define NDLRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define NDLRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define WhiteColor [UIColor whiteColor]


#define Application [UIApplication sharedApplication]
// [UIApplication sharedApplication].windows.firstObject
#define KeyWindow Application.delegate.window
//#define KeyWindow [UIApplication sharedApplication].keyWindow
#define RootViewController KeyWindow.rootViewController

//#define kBaseURL @""

// 弱引用
#define WEAK_REF(obj) \
__weak typeof(obj) weak_##obj = obj; \
// 强引用
#define STRONG_REF(obj) __strong typeof(obj) strong_##obj = weak_##obj;

#define WeakSelf(instance) __weak typeof(self) instance = self;
#define StrongSelf(instance, weakSelf) __strong typeof(self) instance = weakSelf;

// 系统单例宏
// 用户偏好设置
#define UserPreferences [NSUserDefaults standardUserDefaults]
#define NotificationCenter [NSNotificationCenter defaultCenter]
#define CurrentDevice [UIDevice currentDevice]
// 发通知
#define PostNotification(name, obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

/// 判断当前编译使用的SDK版本是否为 iOS 11.0 及以上
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
#define IOS11_SDK_ALLOWED YES
#endif

// iOS系统版本
#define SystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
#define iOS9Later (SystemVersion >= 9.0f)

// ## 把两个语言符号组合成单个语言符号  ...省略号只能代替最后面的宏参数
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

// 资源按照iphone6设计
#define ReferToIphone6WidthRatio (NDLScreenW / 375.0)
#define RealValueReferToIphone6(value) (value * ReferToIphone6WidthRatio)

// 机型小于等于4英寸
#define IS_LESS_THAN_OR_EQUAL_TO_4INCH (NDLScreenW < 375.0)

// 适配iphoneX
#define iPhoneX (NDLScreenW == 375.f && NDLScreenH == 812.f ? YES : NO)

// 视频通话statusBarH会有变化,所以写死20或者44
//#define NDLStatusBarH [UIApplication sharedApplication].statusBarFrame.size.height
//#define NDLNavigationBarH self.navigationController.navigationBar.frame.size.height
#define NavigationBarH 44.0
#define AdditionaliPhoneXTopSafeH 44.0
#define AdditionaliPhoneXBottomSafeH 34.0

#define StatusBarH (iPhoneX ? AdditionaliPhoneXTopSafeH : 20.0)

#define TopSafeH (iPhoneX ? AdditionaliPhoneXTopSafeH : 0.0)
#define BottomSafeH (iPhoneX ? AdditionaliPhoneXBottomSafeH : 0.0)

#define TopExtendedLayoutH (StatusBarH + NavigationBarH)
#define BottomExtendedLayoutH self.tabBarController.tabBar.frame.size.height

// Font
#define UISystemFontMake(size) [UIFont systemFontOfSize:size]
#define UIBoldSystemFontMake(size) [UIFont boldSystemFontOfSize:size]
#define UIFontWithName(nameStr, sizeFloat) [UIFont fontWithName:nameStr size:sizeFloat]

// Image
#define UIImageNamed(nameStr) [UIImage imageNamed:nameStr]

// 自动提示宏
// 宏里面的#，会自动把后面的参数变成C语言的字符串  // 逗号表达式，只取最右边的值
#define keyPath(objc,keyPath) @(((void)objc.keyPath,#keyPath))
// 宏的操作原理，每输入一个字母就会直接把宏右边的拷贝，
// 并且会自动补齐前面的内容。

// #符号用作一个预处理运算符   该过程称为字符串化
/*
 如果x是一个宏参量，那么#x可以把参数名转化成相应的字符串
 PSQR(x) printf("the square of" #x "is %d./n",(x)*(x))
 int y =4;
 PSQR(y);
 PSQR(2+4);
 the square of y is 16
 the square of 2+4 is 36
 */

// 单例
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_IMPLEMENT(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

// 获取一段时间间隔
#define StartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define EndTime NDLLog(@"TimeDelta: %lf", CFAbsoluteTimeGetCurrent() - start)


#pragma mark - App
// 获取App当前版本号
#define App_Bundle_Version [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
// 获取App当前build版本号
#define App_Build_Version [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
// 获取App当前版本identifier
#define App_Bundle_Identifier [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]
// 获取App当前名字
#define App_Name [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#pragma mark - Device
// 获取当前设备的UUID ?
#define Device_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
// 获取当前设备的系统版本
#define Device_System_Version [[[UIDevice currentDevice] systemVersion] floatValue]

#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
#define NDLBadgeViewIgnoreDeprecatedMethodStart()   _Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")
#define NDLBadgeViewIgnoreDeprecatedMethodEnd()     _Pragma("clang diagnostic pop")
#else
#define NDLBadgeViewIgnoreDeprecatedMethodStart()
#define NDLBadgeViewIgnoreDeprecatedMethodEnd()
#endif


#pragma mark - Navigation_BigTitle
#define BigTitleFont [UIFont fontWithName:@"PingFangSC-Medium" size:28]
#define BigTitleTextColor UIColorFromHex(0x343434)
#define TextFieldBigTitleFont [UIFont fontWithName:@"PingFangSC-Medium" size:22];
// TextField光标颜色
#define TextFieldCursorColor UIColorFromHex(0x02C6DC)


