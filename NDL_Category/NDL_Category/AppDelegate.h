//
//  AppDelegate.h
//  NDL_Category
//
//  Created by ndl on 2017/9/14.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

// 灭霸
// https://juejin.im/post/5cc652adf265da03540316e3

// 面向对象设计的六大设计原则
// https://juejin.im/post/5b9526c1e51d450e69731dc2

// ##Network##
// https://github.com/kangzubin/XMNetworking

// ##Demo##
// https://github.com/boai/BADemoTest

// apple
// https://developer.apple.com/downloads/
// iOS Developer Library

/*
 支持本地的文件放在<本地代号>.lproj
 eg:en-US.lproj    en是语言代号 US是国家代号
 本地代号由“语言代号+国家（或地区）代号”
 */

// ##OpenGL##
// https://blog.csdn.net/wangdingqiaoit/article/category/2107037
// https://learnopengl-cn.github.io/

// js
// https://github.com/guanyuxin/baogame

// ##shader##
// https://www.shadertoy.com/view/Ms2SD1

// ##OC Vendor##
// DOUAudioStreamer
// iCarousel
// libwebp
// pop
// RegexKitLite
// ZipArchive
// TTTAttributedLabel
// https://github.com/samsoffes/sskeychain
// https://github.com/calimarkus/JDStatusBarNotification

// ##AV##
// https://www.raywenderlich.com/30200/avfoundation-tutorial-adding-overlays-and-animations-to-videos

// YXM
// http://www.cnblogs.com/YouXianMing/archive/2016/01.html

// ##美团##
// http://www.jianshu.com/p/0ccf4ea14e79

// 其他
// effecthub.com
// http://blog.it2048.cn/article_googlejx.html

// ##面试##
// https://www.jianshu.com/p/1798ba01e9ef
// https://zhuanlan.zhihu.com/c_154646059
// https://hit-alibaba.github.io/interview/
// https://www.jianshu.com/p/e709fde38de3
// 各个大厂
// https://www.jianshu.com/nb/34904451

// AsyncDisplaykit
// http://texturegroup.org/docs/getting-started.html

// YY
// https://blog.ibireme.com/

// 业务逻辑: 处理数据
// 反序列化 / 数据解析 : 把服务器返回给客户端的二进制数据转换成客户端可以直接使用的OC对象

// MARK:事件的传递和响应机制
// https://www.jianshu.com/p/2e074db792ba
/*
 ###事件的产生和传递###
 
 事件的产生:
 发生触摸事件后，系统会将该事件加入到一个由UIApplication管理的事件队列中,为什么是队列而不是栈？因为队列的特点是FIFO，即先进先出，先产生的事件先处理才符合常理，所以把事件添加到队列。
 UIApplication会从事件队列中取出最前面的事件，并将事件分发下去以便处理，通常，先发送事件给应用程序的主窗口（keyWindow）。
 主窗口会在视图层次结构中找到一个最合适的视图来处理触摸事件，这也是整个事件处理过程的第一步。
 找到合适的视图控件后，就会调用视图控件的touches方法来作具体的事件处理
 事件的传递:
 触摸事件的传递是从父控件传递到子控件
 也就是UIApplication->window->寻找处理事件最合适的view
 注 意: 如果父控件不能接受触摸事件，那么子控件就不可能接收到触摸事件
 
 1.首先判断主窗口（keyWindow）自己是否能接受触摸事件
 2.判断触摸点是否在自己身上
 3.子控件数组中从后往前遍历子控件，重复前面的两个步骤（所谓从后往前遍历子控件，就是首先查找子控件数组中最后一个元素，然后执行1、2步骤）
 4.view，比如叫做fitView，那么会把这个事件交给这个fitView，再遍历这个fitView的子控件，直至没有更合适的view为止。
 5.如果没有符合条件的子控件，那么就认为自己最合适处理这个事件，也就是自己是最合适的view
 
 UIView不能接收触摸事件的三种情况：
 不允许交互：userInteractionEnabled = NO
 隐藏：如果把父控件隐藏，那么子控件也会隐藏，隐藏的控件不能接受事件
 透明度：如果设置一个控件的透明度<0.01，会直接影响子控件的透明度。alpha：0.0~0.01为透明
 
 寻找最合适的view底层剖析:
 hitTest:withEvent:方法
 pointInside方法
 
 拦截事件的处理:
 正因为hitTest：withEvent：方法可以返回最合适的view，所以可以通过重写hitTest：withEvent：方法，返回指定的view作为最合适的view。
 不管点击哪里，最合适的view都是hitTest：withEvent：方法中返回的那个view。
 通过重写hitTest：withEvent：，就可以拦截事件的传递过程，想让谁处理事件谁就处理事件
 
 事件传递给谁，就会调用谁的hitTest:withEvent:方法。
 如果hitTest:withEvent:方法中返回nil，那么调用该方法的控件本身和其子控件都不是最合适的view，也就是在自己身上没有找到更合适的view。那么最合适的view就是该控件的父控件

 技巧：想让谁成为最合适的view就重写谁自己的父控件的hitTest:withEvent:方法返回指定的子控件，或者重写自己的hitTest:withEvent:方法 return self。但是，建议在父控件的hitTest:withEvent:中返回子控件作为最合适的view
 
 hitTest：withEvent：中return nil的意思是调用当前hitTest：withEvent：方法的view不是合适的view，子控件也不是合适的view
 
 hit:withEvent:方法底层会调用pointInside:withEvent:方法判断点在不在方法调用者的坐标系上
 
 pointInside:withEvent:方法：
 pointInside:withEvent:方法判断点在不在当前view上（方法调用者的坐标系上）如果返回YES，代表点在方法调用者的坐标系上;返回NO代表点不在方法调用者的坐标系上，那么方法调用者也就不能处理事件
 
 ###事件的响应###
 触摸事件处理的整体过程:
 1>用户点击屏幕后产生的一个触摸事件，经过一系列的传递过程后，会找到最合适的视图控件来处理这个事件2>找到最合适的视图控件后，就会调用控件的touches方法来作具体的事件处理touchesBegan…touchesMoved…touchedEnded…3>这些touches方法的默认做法是将事件顺着响应者链条向上传递（也就是touch方法默认不处理事件，只传递事件），将事件交给上一个响应者进行处理

 响应者链条：在iOS程序中无论是最后面的UIWindow还是最前面的某个按钮，它们的摆放是有前后关系的，一个控件可以放到另一个控件上面或下面，那么用户点击某个控件时是触发上面的控件还是下面的控件呢，这种先后关系构成一个链条就叫“响应者链”。也可以说，响应者链是由多个响应者对象连接起来的链条
 响应者对象：能处理事件的对象，也就是继承自UIResponder的对象

 1>如果当前view是控制器的view，那么控制器就是上一个响应者，事件就传递给控制器；如果当前view不是控制器的view，那么父视图就是当前view的上一个响应者，事件就传递给它的父视图
 2>在视图层次结构的最顶级视图，如果也不能处理收到的事件或消息，则其将事件或消息传递给window对象进行处理
 3>如果window对象也不处理，则其将事件或消息传递给UIApplication对象
 4>如果UIApplication也不能处理该事件或消息，则将其丢弃
 
 事件的传递和响应的区别：
 事件的传递是从上到下（父控件到子控件），事件的响应是从下到上（顺着响应者链条向上传递：子控件到父控件
 */

/*
 __bridge只做类型转换，但是不修改对象（内存）管理权:
 NSURL *url = [[NSURL alloc] initWithString:@"http://www.baidu.com"];
 CFURLRef ref = (__bridge CFURLRef)url;
 
 __bridge_retained（也可以使用CFBridgingRetain）将Objective-C的对象转换为Core Foundation的对象，同时将对象（内存）的管理权交给我们，后续需要使用CFRelease或者相关方法来释放对象
 OC->CF
 NSURL *url = [[NSURL alloc] initWithString:@"http://www.baidu.com"];
 CFURLRef ref = (__bridge_retained CFURLRef)url;
 CFRelease(ref);
 
 __bridge_transfer（也可以使用CFBridgingRelease）将Core Foundation的对象转换为Objective-C的对象，同时将对象（内存）的管理权交给ARC
 CF->OC
 CFStringRef cfString= CFURLCreateStringByAddingPercentEscapes(
 NULL,
 (__bridge CFStringRef)text,
 NULL,
 CFSTR("!*’();:@&=+$,/?%#[]"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
 NSString *ocString = (__bridge_transfer CFStringRef)cfString;
 */

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

/*
 策略设计模式:
 概念：定义一系列的算法，并且将每个算法封装起来，算法之间还可以互相替换。这种设计模式称为策略模式。
 为了解决if-else和switch-case的问题
 */

// GPS定位轨迹抽稀之道格拉斯-普克（Douglas-Peuker)算法
// https://www.jianshu.com/p/bf595477a124

// 使用keychain需要导入Security框架
// keychain保存更为安全，而且keychain里保存的信息不会因App被删除而丢失

/*
 MARK:###断点续传###
 https://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg
 
 断点的由来是在下载过程中，将一个下载文件分成了多个部分，同时进行多个部分一起的下载，当 某个时间点，任务被暂停了，此时下载暂停的位置就是断点了
 续传就是当一个未完成的下载任务再次开始时，会从上次的断点继续传送
 
 使用多线程断点续传下载的时候，将下载或上传任务（一个文件或一个压缩包）人为的划分为几个部分，每一个部分采用一个线程进行上传或下载
 
 断点续传实质就是能记录上一次已下载完成的位置
 
 断点续传的过程
 1.断点续传需要在下载过程中记录每条线程的下载进度；
 2.每次下载开始之前先读取数据库，查询是否有未完成的记录，有就继续下载，没有则创建新记录插入数据库；
 3.在每次向文件中写入数据之后，在数据库中更新下载进度；
 4.下载完成之后删除数据库中下载记录
 */
