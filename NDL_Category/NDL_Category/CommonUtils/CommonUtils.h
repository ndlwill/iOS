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
// 快速排序
void quickSort_C(int array[], int minIndex, int maxIndex);

// 二分查找(在排好序的基础上实现)

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

/*
 // 二叉排序树
 
 若左子树不空，则左子树上所有结点的值均小于它的根节点的值；
 若右子树不空，则右子树上所有结点的值均大于它的根结点的值
 左、右子树也分别为二叉排序树
 */


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
