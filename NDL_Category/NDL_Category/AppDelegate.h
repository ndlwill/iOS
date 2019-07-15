//
//  AppDelegate.h
//  NDL_Category
//
//  Created by ndl on 2017/9/14.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

// 业务逻辑: 处理数据

// MQTT
// https://www.runoob.com/w3cnote/mqtt-intro.html
// https://mcxiaoke.gitbooks.io/mqtt-cn/content/
/*
 MQTT（Message Queuing Telemetry Transport，消息队列遥测传输）是IBM开发的一个即时通讯协议
 是轻量级基于代理的发布/订阅的消息传输协议。有可能成为物联网的重要组成部分
 该协议支持所有平台，几乎可以把所有联网物品和外部连接起来，被用来当做传感器的通信协议
 MQTT由于开放源代码，耗电量小等特点，将会在移动消息推送领域会有更多的贡献，在物联网(Internet of Thing)领域，传感器与服务器的通信，信息的收集
 
 非常适合"在物联网领域，传感器与服务器的通信，信息的收集"，要知道嵌入式设备的运算能力和带宽都相对薄弱，使用这种协议来传递消息再适合不过了
 
 该协议的特点有:
 使用发布/订阅消息模式，提供一对多的消息发布，解除应用程序耦合。
 对负载内容屏蔽的消息传输。
 使用 TCP/IP 提供网络连接。
 有三种消息发布服务质量(QoS):
 "至多一次"，消息发布完全依赖底层 TCP/IP 网络。会发生消息丢失或重复。这一级别可用于如下情况，环境传感器数据，丢失一次读记录无所谓，因为不久后还会有第二次发送。
 "至少一次"，确保消息到达，但消息重复可能会发生。
 "只有一次"，确保消息到达一次。这一级别可用于如下情况，在计费系统中，消息重复或丢失会导致不正确的结果。
 小型传输，开销很小（固定长度的头部是 2 字节），协议交换最小化，以降低网络流量。
 使用 Last Will 和 Testament 特性通知有关各方客户端异常中断的机制
 */

// Interceptor: 拦截器

//https://blog.csdn.net/u013282507/article/category/6429655
//https://github.com/mengxianliang?tab=repositories

// 断点处自动执行任务
// Add Action->Debugger Command-> po "MyVar = \(MyVar)"

/*
Bitbucket:
ndlwill1020@126.com
gmail:
ndlwill1020@gmail.com
 */

/*
 图片浏览器:
 PhotoBrowser
 ImageViewer
 */

/*
 导入调试包:command+shift+g
 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport
 把文件解压到这个文件夹下，重新启动Xcode，连上真机运行，Xcode会开始下载调试组件（2-3G），下载完成之后就能在真机上运行了
 
 保留常用的系统版本所对应的调试组件，删除调试组件
 ~/Library/Developer/Xcode/iOS DeviceSupport
 */

/*
 fishhook:
 struct rebinding {
 const char *name; //字符串名称
 void *replacement; //替换后的方法
 void **replaced; //原始的方法（通常要存储下来，在替换后的方法里调用）
 };
 
 //两个参数分别是rebinding结构体数组，以及数组的长度
 int rebind_symbols(struct rebinding rebindings[], size_t rebindings_nel);

 由于 CFNetwork 都是 C 函数实现，想要对 C 函数 进行 Hook 需要使用 Dynamic Loader Hook 库函数 - fishhook，
 
 Dynamic Loader（dyld）通过更新 Mach-O 文件中保存的指针的方法来绑定符号。借用它可以在 Runtime 修改 C 函数调用的函数指针。fishhook 的实现原理：遍历 __DATA segment 里面 __nl_symbol_ptr 、__la_symbol_ptr 两个 section 里面的符号，通过 Indirect Symbol Table、Symbol Table 和 String Table 的配合，找到自己要替换的函数，达到 hook 的目的

 fishhook是Facebook提供的一个动态修改链接mach-O文件的工具。
 利用MachO文件加载原理，通过修改懒加载和非懒加载两个表的指针达到C函数HOOK的目的
 在程序启动的时候 Mach-O 文件会被 DYLD （动态加载器）加载进内存。加载完 Mach-O 后，DYLD接着会去加载 Mach-O 所依赖的动态库
 程序的底层都是汇编
 
 ##使用PIC的Mach-O文件，在引用符号（比如printf）的时候，并不是直接去找到符号的地址（编译期并不知道运行时printf的函数地址），而是通过在__DATA Segment上创建一个指针，等到启动的时候，dyld动态的去做绑定（bind），这样__DATA Segment上的指针就指向了printf的实现
 finshhook就是通过rebind_symbols修改__DATASegment上的符号指针指向，来动态的hook C函数
 
 在__DATA段中，有两个Sections和动态符号绑定有关：
 __nl_symbol_ptr 存储了non-lazily绑定的符号，这些符号在mach-o加载的时候绑定。
 __la_symbol_ptr 存储了lazy绑定的符号（方法），这些方法在第一调用的时候，由dyld_stub_binder来绑定，所以你会看到，每个mach-o的non-lazily绑定符号都有dyld_stub_binder
 
 利用dyld相关接口，我们可以注册image装载的监听方法:
 调用_dyld_register_func_for_add_image注册监听方法后，当前已经装载的image(动态库等)会立刻触发回调，之后的image会在装载的时候触发回调。dyld在装载的时候，会对符号进行bind，而fishhook则会在回调函数中进行rebind。
 
 void LeoTestCFunction(){
 
 }
 int main(int argc, char * argv[]) {
 @autoreleasepool {
 LeoTestCFunction();
 return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
 }
 }
 内部函数，编译后，函数的实现会在mach-o的__TEXT（代码段）里
 编译后，当前调用处的指针，是直接指向代码段中的地址的
 这个地址是由mach-o的base+offset获得的，其中offset是一定的。dyld在装载的时候，只需要对这些符号进行rebase即可（修改地址为newbae+offset）
 
 
 更轻量的 View Controllers:
 1.将业务逻辑移到 Model 中(User)
 2.创建 Store 类   Store 对象会关心数据加载、缓存和设置数据栈。它也经常被称为服务层或者仓库
 3.把网络请求逻辑移到 Model 层
 4.把 View 代码移到 View 层
 */

// xcode
// commad + shift + K  clean项目

// the icon size of iOS 11 must be 120*120 pixels

// 推送(阿里云)
// 将App上传App Store前，可以在注册的测试上，运行Ad Hoc环境的App，用以测试App生产环境的的功能，包括生产环境的远程推送通知
// 开发环境和生产环境App获取的deviceToken是不同的
// 通过xcode安装的是dev环境
// iphoneX device-token
// (卸载安装 每次都不一样)dev-db33aa54 d21dd18b fc554e13 e6d3705e c118f36a cf76edc8 74a8e287 2d510a2a
//                        89d9968b 6127f805 5dc0ecb7 1dabd512 4bf9ead6 b05751ef f98a2be4 2d41ef7d
// dis-93caf972 50ec26e0 430dbb18 43a2fca7 2fc4cb97 a882c0fe 8120ff60 a113fd0a

/*
 Mediator 不能直接去调用组件的方法，因为这样会产生依赖，那我就要通过其他方法去调用，也就是通过 字符串->方法 的映射去调用。runtime 接口的 className + selectorName -> IMP 是一种，注册表的 key -> block 是一种，而前一种是 OC 自带的特性，后一种需要内存维持一份注册表
 */

/*
 @encode是编译器指令之一
 @encode返回一个给定的Objective-C 类型编码(Objective-C Type Encodings)
 这是一种内部表示的字符串，类似于 ANSI C 的 typeof 操作
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end
/*
 __attribute__:
 基于__attribute__的clang语法，把注册信息写到mach-o文件里
 __attribute__ ((used, section ("__DATA,__QTEventBus")))的作用是告诉编译器这个结构体会用到，麻烦写到__DATA段中的__QTEventBus section里
*/

// ##AppDelegate优化##
// 1.延迟加载：分享SDK之类的，可以等到第一次调用再出初始化
// 2.加载内嵌的动态库速度较慢。关键是：减少动态库的数量。合并动态库，比如公司内部由私有Pod建立了如下动态库：XXTableView, XXHUD, XXLabel，强烈建议合并成一个XXUIKit来提高加载速度

/*
 开源源码解析:
 https://github.com/Draveness/analyze
 */

// ==国外大神NSHipster==
// https://nshipster.com/

/*
 结构体大小的计算:
 结构体计算要遵循字节对齐原则
 结构体默认的字节对齐一般满足三个准则:
 1) 结构体变量的首地址能够被其最宽基本类型成员的大小所整除；
 2) 结构体每个成员相对于结构体首地址的偏移量（offset）都是成员大小的整数倍，如有需要编译器会在成员之间加上填充字节（internal adding）；
 3) 结构体的总大小为结构体最宽基本类型成员大小的整数倍，如有需要编译器会在最末一个成员之后加上填充字节（trailing padding）
 
 总结:结构体大小结果要为成员中最大字节的整数倍
 struct {   char a;   short b;   char c; }S1;
 struct {  char  a;  char  b;  short c; }S2;
 分别用程序测试得出 sizeof(S1)=6 , sizeof(S2)=4。
 
  (1）首先找出成员变量中最大的字节，可见对于 S1 和 S2 最大是 short ，占 2 个字节；
 （2）所以以后都已2个字节为准，也就是说最多只要2个字节，其他填充占位，注意下图一个格子表示一个字节；
 （3）所以先画2个格子，以后看成员顺序，逐次增加，每次一2为增加基准
 
 就是当结构体成员变量是另外一个结构体时，只要把结构体中成员为另一结构体作为整体相加就行
 
 typedef struct A
 {
 char a1;
 short int a2;
 int a3;
 double d;
 };
 
 A=16
 
 typedef struct B
 {
 long int b2;
 short int b1;
 A a;
 };
 
 而对于 B，先不要管 A a，也就是先去掉 A a 成员结构体 B 算出其为 16，所以最后结果为 16+16=32
 */
