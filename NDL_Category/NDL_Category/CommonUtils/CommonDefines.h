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

// #用来把参数转换成字符串
#define CString(value) #value
// __VA_ARGS__ 是一个可变参数的宏
// ##__VA_ARGS__ 宏前面加上##的作用在于，当可变参数的个数为0时，这里的##起到把前面多余的","去掉的作用,否则会编译出错
#define CLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);

// 父视图layoutSubViews然后子视图layoutSubViews

#ifdef DEBUG
#define NDLLog(...) NSLog(__VA_ARGS__)
#else
#define NDLLog(...)
#endif


#define IsMainThread [NSThread isMainThread]
#define MainThreadAssert() NSAssert([NSThread isMainThread], @"needs to be accessed on the main thread.");

#define NDLScreenW [UIScreen mainScreen].bounds.size.width
#define NDLScreenH [UIScreen mainScreen].bounds.size.height
#define ScreenScale ([[UIScreen mainScreen] scale])

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

// ui适配
// 资源按照iphone6设计
#define ReferToIphone6WidthRatio (NDLScreenW / 375.0)
#define RealWidthValueReferToIphone6(value) (value * ReferToIphone6WidthRatio)
#define ReferToIphone6HeightRatio (NDLScreenH / 667.0)
#define RealHeightValueReferToIphone6(value) (value * ReferToIphone6HeightRatio)

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
#define EndTime NDLLog(@"TimeDelta: %lf", CFAbsoluteTimeGetCurrent() - start);


#pragma mark - App

#define MainBundle [NSBundle mainBundle]
// 获取App当前版本号
#define App_Bundle_Version [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
// 获取App当前build版本号
#define App_Build_Version [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
// 获取App当前版本identifier
#define App_Bundle_Identifier [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]
// 获取App当前名字
#define App_Name [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
// 返回dic dic[@"CFBundleURLSchemes"] 返回URLScheme数组
#define App_URLTypes [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"]
// app icon
#define App_Icon_File [[[MainBundle infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];

// 检查APPStore版本
// http://itunes.apple.com/cn/lookup?id=1071516426

#pragma mark - Device
// 获取当前设备的UUID ?
#define Device_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
// 获取当前设备的系统版本
#define Device_System_Version [[[UIDevice currentDevice] systemVersion] floatValue]


// ====================ignore clang warning====================
#pragma mark - ignore clang warning
//warning 列表参考：https://clang.llvm.org/docs/DiagnosticsReference.html
/*
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wunused-variable"
 #pragma clang diagnostic ignored "-Wundeclared-selector"
 // 这里是会报警告的代码
 #pragma clang diagnostic pop
 */

#define BeginIgnoreDeprecatedWarning _Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")
#define EndIgnoreDeprecatedWarning _Pragma("clang diagnostic pop")

#define IGNORE_PERFORM_SELECTOR_LEAK_WARNING(code) _Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
code; \
_Pragma("clang diagnostic pop")

// 角度转弧度
#define DEGREE2RADIAN(angle) ((angle) / 180.0 * M_PI)
// 弧度转角度
#define RADIAN2DEGREE(radian) ((radian) * (180.0 / M_PI))
// 是否是有效字符串
#define ValidStringFlag(str) (str && ![str isEqualToString:@""])


// ====================deprecated====================
#pragma mark - deprecated
/*
 NS_DEPRECATED_IOS(2_0, 4_0)
 __attribute((deprecated("不建议使用")))
 */


// @property (nonatomic, strong, nonnull) dispatch_semaphore_t lock;
#define NDLLOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define NDLUNLOCK(lock) dispatch_semaphore_signal(lock);


#pragma mark - Navigation_BigTitle
#define BigTitleFont [UIFont fontWithName:@"PingFangSC-Medium" size:28]
#define BigTitleTextColor UIColorFromHex(0x343434)
#define TextFieldBigTitleFont [UIFont fontWithName:@"PingFangSC-Medium" size:22];
// TextField光标颜色
#define TextFieldCursorColor UIColorFromHex(0x02C6DC)

// 高德行政区域查询
// https://lbs.amap.com/api/webservice/guide/api/district

// math
// https://blog.csdn.net/u013282174/article/details/80311284 矩阵变换
/*
 向量:
 平面向量是在二维平面内既有方向(direction)又有大小(magnitude)的量，物理学中也称作矢量
 与之相对的是只有大小、没有方向的数量（标量）
 我们可以声明一个向量a⃗  = (2,3)，那么实际上向量a⃗ 就表示起点位于原点，终点位于坐标系中(2,3)的向量
 一旦两个向量的方向和大小相等，那么这两个向量就是相等的向量。
 比如起点位于(1,1)终点位于(3,4)的向量和我们上面的向量a就是方向相同，大小相等的向量，它们两个是相等的向量
 
 向量的标准表达式，也就是我们在上一部分讲到的使用一个坐标点来表示一个向量，该表达式是以起点为原点，取终点的值来表示一个向量
 一个向量a⃗ ，起始点为(x1,y1)，终止点为(x2,y2)，那么它的坐标表达式就是：
 a⃗ =(x2−x1,y2−y1)
 若两个向量的坐标表达式一样，那么它们就是相等的向量
 向量的长度又叫做向量的模 使用勾股定理计算出斜边长度也就是向量的模
 |a⃗ |=开根号((x2−x1)平方+(y2−y1)平方)
 
 向量的夹角表示的是两个向量的起始点相同时所形成的弧度小于π的角的大小
 若有两个向量a⃗ =(x1,y1)和b⃗ =(x2,y2)，则它们的夹角α满足：
 
 cosα=a⃗ ⋅b⃗ / |a⃗ ||b⃗ |
 
 向量的到角指的是两个向量起点相同的情况下，其中一个向量按照一个方向（顺时针或逆时针）旋转后与另一个向量共线所需旋转的角度。
 所以到角有两种情况：顺时针到角和逆时针到角，很容易得到的是，顺时针到角 = 2π - 逆时针到角，其中小于π的那个到角就是夹角
 
 向量的坐标表达式：a⃗ =(x,y)，它实际上类似一条一次曲线（线性曲线，或者说，一次函数图像）：y=kx。
 那么曲线的方向实际上是由斜率决定的，也就是斜率 k=y/x
 那么我们的向量在改变向量的坐标表达式的时候，只要保证斜率不变就可以使向量的长度改变的同时，方向不变
 或者根据相似三角形定理
 我们设向量a⃗ =(x,y)的终点为A，那么A点的坐标就是(x,y)，x和y的几何意义就是点A在x轴和y轴的投影大小，我们画出其中一个投影，也就是从A点向x轴作垂线，垂足为D1，若原点为O。
 那么很明显△AD1O是一个直角三角形，两条直角边的长度分别是OD1=x和AD1=y，斜边长就是向量的模
 接下来，我们要将向量a⃗ =(x,y)的长度设置为l，也就是移动点A，使得向量a⃗ =(x,y)的长度为l而向量的方向不变。
 我们设移动后的终止点为A′(x′,y′)，按照同样的方式作垂线，垂足为D2，那么得到新的直角三角形△AD2O，两条直角边的长度分别是OD2=x′和AD2=y′，
 显然，我们最终是要解出x′和y′的值，也就可以转换成几何问题，解OD2和AD2的长度。
 
 由于OAA′三点共线，那么△AD2O和△AD1O就是相似三角形，那么由相似三角形的边长比值关系，我们可以得到：
 |a⃗ |/l=x/x′=y/y′
 
 向量加法:
 a⃗ =(x1,y1)、b⃗ =(x2,y2)、c⃗ =a⃗ +b⃗
 那么
 c⃗ =(x1+x2,y1+y2)
 向量的加法其实可以简单理解为：参与加法的向量全部收尾相连后，最初的起点和最后的终点即为和向量的起点和终点
 
 向量减法:
 a⃗ =(x1,y1)、b⃗ =(x2,y2)、c⃗ =a⃗ −b⃗
 那么
 c⃗ =(x1−x2,y1−y2)
 
 向量数量积:
 虽然向量不能加减一个自然数，但是可以乘以一个自然数
 若有a⃗ =(x,y)，那么a⃗ ⋅2就表示a⃗ +a⃗ =(2x,2y)，所以向量的数量积就是把向量的坐标表达式的x和y分别乘以这个自然数，
 即对于任意向量a⃗ =(x,y)和任意自然数d：
 a⃗ ⋅d=(d⋅x,d⋅y)
 
 向量内积:
 a⃗ =(x1,y1)、b⃗ =(x2,y2)
 那么
 a⃗ ⋅b⃗ =x1⋅x2+y1⋅y2
 这是线性代数中的矩阵乘法公式（一维矩阵即向量）
 
 向量的平移指的是向量方向和大小不变，仅改变向量起始点的一种操作
 对于一个向量a⃗ =(x,y)，若将其起始点平移至(x1,y1)，，那么此时向量a⃗ 的终止点就是(x+x1,y+y1)
 
 向量的旋转指的是向量以自己的起始点为圆心，按某个方向（顺时针或者逆时针）旋转某个角度。若要沿任意点进行旋转，就涉及到矩阵计算了
 若有向量a⃗ =(x,y)，沿原点顺时针旋转θ后的坐标表达式为(x′,y′)，则有
 x′=x⋅cosθ+y⋅sinθ
 y′=−x⋅sinθ+y⋅cosθ
 
 坐标系转换:
 我们在上面讨论的平面向量的各种公式坐标系都是笛卡尔坐标系，也就是y轴正方向向上，而我们绘图的坐标系是UIKit坐标系，y轴正方向向下
 所以我们如果要在UIKit坐标系下使用笛卡尔向量，只需要在使用公式的时候把旋转方向取反就行了
 */

