//
//  CommonUtils.h
//  NDL_Category
//
//  Created by ndl on 2017/10/18.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// 招商银行（China Merchants Bank） CMB

// 参考:
// 资源命名 模块名_类别_功能_状态@2x.png setting_button_search_selected@2x.png

/*
 Xcode
 代码块的存放地址：~/Library/Developer/Xcode/UserData/CodeSnippets Xcode
 文件模版的存放地址：/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/File Templates/
 */

/*
 iOS的keychain服务:
 提供了一种安全的保存私密信息（密码，序列号，证书等）的方式，每个ios程序都有一个独立的keychain存储。
 相对于NSUserDefaults、文件保存等一般方式，keychain保存更为安全，而且keychain里保存的信息不会因App被删除而丢失
 */

// pem转cer证书：$ openssl x509 -in in.pem -out out.cer -outform der

// NSString *regexStr = @"(#\\w+#)";// 含#XXX#的字符串

// NSInteger test = (-22 % 10);// -2
// NSInteger test = (-22 / 10);// -2

// NS_DESIGNATED_INITIALIZER关键字 意思是最终被指定的初始化方法，在interface只能用一次而且必须以init开头的方法
// NS_UNAVAILABLE关键字 这个宏的意思的不能用,有这个宏你在前面调用的时候Xcode是不会提示这个方法的
/*
 - (instancetype)init{
 
 @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Use -initWithGestureRecognizer:edgeForDragging:" userInfo:nil];
 }
 */

// 手势
/*
velocityInView： 手指在视图上移动的速度（x,y）, 正负也是代表方向
在绝对值上|x| > |y| 水平移动， |y| > |x| 竖直移动
 */

@interface CommonUtils : NSObject

// 强制旋转
+ (void)forceInterfaceOrientation:(UIInterfaceOrientation)orientation;

+ (NSInteger)integerCeil:(NSInteger)value;

// 过渡值
+ (CGFloat)transitionValueWithPercent:(CGFloat)percent fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue;
// 过渡颜色值
+ (UIColor *)transitionColorWithPercent:(CGFloat)percent fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;
// 缓存的大小
+ (CGFloat)cachedSize;
// 清除缓存
+ (void)clearCache;

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
// 打印某个类所有的实例方法（包括私有方法）
+ (void)logInstanceMethodListForClass:(Class)className;

// 打开app setting
+ (void)openAppSettingURL;

// scrollView总共数据量
+ (NSUInteger)totalDataCountsForScrollView:(UIScrollView *)scrollView;

// 播放自定义声音
+ (void)playCustomSoundWithPath:(NSString *)resourcePath;

+ (NSArray *)bubbleSort:(NSArray *)array;

// https://www.cnblogs.com/manji/p/4881907.html
/*
 排序算法分类：
 内部排序（在排序过程中不需要访问外存就可以完成排序）
 外部排序
 
 交换排序:
 冒泡排序
 快速排序
 
 选择排序:
 直接选择排序
 堆排序
 
 插入排序:
 直接插入排序 // 将n个元素的数列分为已有序和无序两个部分，每次处理就是将无序数列的第一个元素与有序数列的元素从后往前逐个进行比较，找出插入位置，将该元素插入到有序数列的合适位置中
 希尔排序 // 缩小增量排序，是对直接插入排序的一种改进
 
 合并排序
 
 外部排序:
 常见的是多路归并算法，即将原文件分为多个能够一次装入内存一部分，分别把每一部分调入内存完成排序，然后对已经排序的子文件进行归并排序
 */
// =====C Function=====
// 冒泡排序
void bubbleSort_C(int array[], int arrayLength);
// 选择排序
void selectionSort_C(int array[], int arrayLength);
// 插入排序
void insertionSort_C(int array[], int arrayLength);
// 快速排序
void quickSort_C(int array[], int minIndex, int maxIndex);

// 二分查找(在排好序的基础上实现)


// ===================================================================
// https://hit-alibaba.github.io/interview/basic/algo/Tree.html
// 二叉树：是每个节点都只能有两个子节点的树结构
// 树结构通常结合了另外两种数据结构的优点：一种是有序数组，另外一种是链表。 树结构的查询的速度和有序数组一样快，树结构的插入数据和删除数据的速度也和链表一样快
/*
 路径:    顺着连接点的边从一个节点走向另一个节点，所经过的节点的顺序排列就称为路径
 根:    树顶端的节点就称为根，一棵树只有一个根，如果要把一个节点和边的集合定义为树，那么从根到其他任何一个节点都必须有一条路径
 父节点:    每个节点（除了根）都恰好有一条边向上连接到另一个节点，上面的节点就称为下面节点的“父节点”
 子节点:    每个节点都可能有一条或多条边向下连接其他节点，下面的这些节点就称为它的“子节点”
 叶节点:    没有子节点的节点称为“叶子节点”或简称“叶节点”。树只能有一个根，但是可以有很多叶节点
 子树:    每个节点都可以作为子树的根，它和它所有的子节点，子节点的子节点等都含在子树中
 访问:    当程序控制流程到达某个节点的时候，就称为“访问”这个节点，通常是为了在这个节点处执行某种操作，例如查看节点某个数据字段的值或者显示节点
 遍历:    遍历树意味着要遵循某种特定的顺序访问树中的所有节点
 层:    一个节点的层数是指从根开始到这个节点有多少“代”
 关键字:    可以看到，对象中通常会有一个数据域被指定为关键字值。这个值通常用于查询或者其他操作
 二叉树:    如果树中的每个节点最多只能有两个子节点，这样的树就称为“二叉树”
 */

// 满二叉树：深度为k且有2^k －1个结点的二叉树称为满二叉树

/*
二叉树的性质：

性质1：在二叉树中第 i 层的结点数最多为2^(i-1)（i ≥ 1）
性质2：高度为k的二叉树其结点总数最多为2^k－1（ k ≥ 1）
性质3：对任意的非空二叉树 T ，如果叶结点的个数为 n0，而其度为 2 的结点数为 n2，则：n0 = n2 + 1
*/
 
/*
 二叉排序树（Binary Sort Tree）又称二叉查找树（Binary Search Tree），亦称二叉搜索树
 // 二叉排序树
 若左子树不空，则左子树上所有结点的值均小于它的根节点的值；
 若右子树不空，则右子树上所有结点的值均大于它的根结点的值
 左、右子树也分别为二叉排序树
 没有键值相等的节点
 */
+ (void)logBinaryTree;


// SSID全称Service Set IDentifier - wifi名称

// ========test========
+ (void)logStackInfo;

+ (void)testForSubTitles:(NSString *)subTitle,...NS_REQUIRES_NIL_TERMINATION;

+ (void)logTimeZone:(NSTimeZone *)timeZone;

+ (void)logDate;

+ (void)logCalendar;

+ (void)logLocal:(NSLocale *)local;

+ (void)testDate;

+ (void)testFont:(UIFont *)font;

@end


// MARK: GCD
// GCD也可以创建计时器，而且更为精确:
//
// -(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
// {
// //创建队列
// dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
// //1.创建一个GCD定时器
// /*
// 第一个参数:表明创建的是一个定时器
// 第四个参数:队列
// */
//dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//// 需要对timer进行强引用，保证其不会被释放掉，才会按时调用block块
//// 局部变量，让指针强引用
//self.timer = timer;
////2.设置定时器的开始时间,间隔时间,精准度
///*
// 第1个参数:要给哪个定时器设置
// 第2个参数:开始时间
// 第3个参数:间隔时间
// 第4个参数:精准度 一般为0 在允许范围内增加误差可提高程序的性能
// GCD的单位是纳秒 所以要*NSEC_PER_SEC
// */
//dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//
////3.设置定时器要执行的事情
//dispatch_source_set_event_handler(timer, ^{
//    NSLog(@"---%@--",[NSThread currentThread]);
//});
//// 启动
//dispatch_resume(timer);
//}

/*
 MARK:===线程与进程===
 一个程序至少要有进城,一个进程至少要有一个线程
 进程有独立的地址空间，一个进程崩溃后，在保护模式的影响下不会对其他进程产生影响
 进程:资源分配的最小独立单元,进程是具有一定独立功能的程序
 进程是系统进行资源分配和调度的一个独立单位.
 
 线程:是CPU调度和分派的基本单元,它是比进程更小的能独立运行的基本单位.它可与同属一个进程的其他线程共享进程所拥有的全部资源
 线程有自己的堆栈和局部变量，但线程之间没有单独的地址空间，一个线程死掉就等同于整个进程死掉
 线程是CPU独立运行和独立调度的基本单位(可以理解为一个进程中执行的代码片段)。
 进程是线程的容器，真正完成代码执行的线程，而进程则作为线程的执行环境。一个程序至少包含一个进程，一个进程至少包含一个线程，一个进程中的所有线程共享当前进程所拥有的资源
 
 同步就是顺序执行，执行完一个再执行下一个，需要等待、协调运行
 异步就是彼此独立,在等待某事件的过程中继续做自己的事，不需要等待这一事件完成后再工作
 线程就是实现异步的一个方式。异步是让调用方法的主线程不需要同步等待另一线程的完成，从而可以让主线程干其它的事情
 多线程只是我们实现异步的一种手段
 异步是当一个调用请求发送给被调用者,而调用者不用等待其结果的返回而可以做其它的事情
 
 并发性（Concurrence）：指两个或两个以上的事件或活动在同一时间间隔内发生
 并发性是对有限物理资源强制行使多用户共享以提高效率
 并行性（parallelism）指两个或两个以上事件或活动在同一时刻发生
 并行性使多个程序同一时刻可在不同CPU上同时执行
 区别：一个处理器同时处理多个任务和多个处理器或者是多核的处理器同时处理多个不同的任务
 前者是逻辑上的同时发生（simultaneous），而后者是物理上的同时发生
 */
