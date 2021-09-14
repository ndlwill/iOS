//
//  InterviewViewController.m
//  NDL_Category
//
//  Created by ndl on 2019/11/1.
//  Copyright © 2019 ndl. All rights reserved.
//

/**
 快速搜索在目录下面的含有关键字的文件
 grep -r 关键字
 */

// MARK: 多页面嵌套 JXPagerView、JXCategoryView

// 判断设备是否越狱，依据是否存在apt和Cydia.app

// MARK: lipo
/**
 lipo 是管理Fat File 的工具，可以查看cpu 架构，提取特定架构，整合和拆分库文件
 
 查看静态库指出cpu的架构:
 lipo -info 静态库路径.framework/xxxx 或 静态库路径.a
 
 lipo -info /Users/tgkj/Desktop/TeeagerGreenModel.framework/TeeagerGreenModel
 Architectures in the fat file: /Users/tgkj/Desktop/TeeagerGreenModel.framework/TeeagerGreenModel are: armv7 i386 x86_64 arm64
 
 合并静态库:
 lipo -create 静态库路径1  静态库路径2 -output 存放路径
 lipo -create /Users/tgkj/Library/Developer/Xcode/DerivedData/ TeeagerGreenModel-bjryvkwvkylloqeqscwurstbubsa/Build/Products/Release-iphoneos/TeeagerGreenModel.framework/TeeagerGreenModel /Users/tgkj/Library/Developer/Xcode/DerivedData/TeeagerGreenModel-bjryvkwvkylloqeqscwurstbubsa/Build/Products/Release-iphonesimulator/TeeagerGreenModel.framework/TeeagerGreenModel -output /Users/tgkj/Library/Developer/Xcode/DerivedData/TeeagerGreenModel-bjryvkwvkylloqeqscwurstbubsa/Build/Products/Release-iphoneos/TeeagerGreenModel.framework/TeeagerGreenModel
 
 移除指定架构:
 lipo  静态库路径 -remove CPU架构名称 -output 移除后存放路径
 lipo  /Users/tgkj/Library/Developer/Xcode/DerivedData/ TeeagerGreenModel-bjryvkwvkylloqeqscwurstbubsa/Build/Products/Release-iphoneos/TeeagerGreenModel.framework/TeeagerGreenModel -remove armv7 -output /Users/tgkj/Library/Developer/Xcode/DerivedData/ TeeagerGreenModel-bjryvkwvkylloqeqscwurstbubsa/Build/Products/Release-iphoneos/TeeagerGreenModel.framework/TeeagerGreenModel

 */

// MARK: 字节
// https://juejin.im/user/2999123452637853
// https://juejin.im/user/78820566645534
// https://juejin.im/user/2788017221155176/posts

// MARK: LG_BLOG
// https://www.jianshu.com/p/e2a7c218926b
// https://www.jianshu.com/u/1e877b3dcc34
// https://juejin.im/user/2436173498429287

// MARK: AV相关
// https://github.com/wsl2ls/iOS_Tips
// https://juejin.im/user/2788017221155176/posts

// MARK: LG_Stu
// https://blog.csdn.net/lin1109221208
// https://www.jianshu.com/p/74e278cabf47
// https://www.jianshu.com/u/4db89678773b

// https://www.jianshu.com/u/e15d1f644bea // https://github.com/wsl2ls

// MARK: 富文本
// https://www.jianshu.com/p/89ed22f50a9c

// MARK: 监控
// https://github.com/Tencent/OOMDetector

// MARK: UICollectionView
// https://github.com/liangdahong/BMLongPressDragCellCollectionView

// MARK: 工具
/**
 Alfred
 goshell
 */

// MARK: Jenkins
/**
 需要java环境
 brew install jenkins
 java -jar jenkins.war --httpPort=8099
 浏览器 localhost:8099
 */

// MARK: 音视频
/**
 采集：
 通过一些系统API获取就要可以获取物理摄像头将采集到的视频数据与麦克风采集到的音频数据.
 */

// MARK: Ruby
// https://www.runoob.com/ruby/ruby-syntax.html

// MARK: AsyncDisplayKit is now Texture
// https://texturegroup.org/docs/corner-rounding.html
// https://blog.csdn.net/kmyhy/article/details/54632659
// https://blog.csdn.net/kmyhy/article/details/54846322
// https://www.jianshu.com/p/afc69cd9e824
// http://www.cocoachina.com/articles/20182

// MARK: ===面试===
/**
 https://blog.csdn.net/wxs0124/article/details/107106654 // 推荐
 https://www.jianshu.com/p/e2a7c218926b
 https://www.jianshu.com/p/1e752f5678f1
 https://www.jianshu.com/p/c10b25003153
 https://juejin.im/post/6844904087046225933
 */

// MARK: NSTimer
/**
 内存泄露原理分析+解决方案
 NSTimer必须与RunLoop搭配使用，因为其定时任务的触发基于RunLoop，NSTimer使用常见的Target-Action模式。由于RunLoop会强引用timer，timer会强引用Target，容易造成循环引用、内存泄露等问题。
 
 NSTimer与RunLoop:
 NSTimer需要与RunLoop搭配使用。创建完定时器后，需要把定时器添加到指定RunLoopMode，添加完毕定时器就自动触发（fire）或者在设定时间fireDate后自动触发。
 NSTimer并非真正的机械定时器，可能会出现延迟情况。当timer注册的RunLoop正在执行耗时任务、或者当前RunLoopMode并非注册是指定的mode，定时任务可能会延迟执行。
 
 创建定时器,传入Target对象，Timer会在强引用Target直到Timer失效（调用invalidate）
 注册定时器，调用RunLoop的addTimer:
 RunLoop会强引用Timer。当调用Timer的invalidate使之失效时，RunLoop才会把Timer从RunLoop中移除并清除Timer对Target的强引用，invalidate是把Timer从RunLoop中移除的唯一方法。
 
 把Timer注册到RunLoop后，Timer会被其强引用，保证Timer存活，定时任务能触发。因此Target对象使用Timer实际上可以使用weak弱引用，只要你能保证创建完Timer将其加入RunLoop中。（注意：Timer通常用懒加载，且Timer一加入RunLoop就自动fire，如果想在特定时间点才fire定时任务，那必须到特定时间点才加入RunLoop，或者初始化后马上加入RunLoop并暂停定时器）
 
 RunLoop强引用Timer、Timer强引用Target。Target必须等待Timer执行invalidate后清除其对Target的强引用，dealloc才会执行。
 
 如果在target中传入weak的self，那么可以解决循环引用问题吗？
 答案是:否
 
 内存泄漏解决方案:
 内存泄漏主要原因是RunLoop强引用Timer、Timer强引用Target，导致Target不执行析构。下面提供两种解决方案，本质是是从Target入手，把Target替换为另一个对象，而不是使用Timer的客户对象。客户对象不在作为Target，即可像使用普通对象一样，在dealloc中invalidate Timer。
 方案一：使用Block代替Target-Action
 方案二：直接替换Target
 
 当创建定时任务仅需执行一次（repeats=NO，也就是延迟定时任务），则执行完定时任务，会自动执行invalidate操作。
 但需注意：Timer会强引用Target直到延迟任务执行完毕。
 
 对于NSTimer，面试官还会问，它是否是时间准确呢？大家可能都知道是时间不准确的，因为受RunLoop的影响，那么GCD中也有延时，如果用GCD来做延时，那时间准确吗？
 答案是GCD的time是准确的，GCD 的线程管理是通过系统来直接管理的。GCD Timer 是通过 dispatch port 给 RunLoop 发送消息，来使 RunLoop 执行相应的 block，如果所在线程没有 RunLoop，那么 GCD 会临时创建一个线程去执行 block，执行完之后再销毁掉，因此 GCD 的 Timer 是不依赖 RunLoop 的。
 */

// MARK: Singleton单例
/**
 单例模式：确保某一个类只有一个实例，而且自行实例化并向整个系统提供这个实例单例模式
 安全保障：防止两个线程同时调用shareInstance，使用@synchronized锁定
 GCD创建：dispatch_once中dispatch_once_t类型为typedef long
 onceToken= 0，线程执行dispatch_once的block中代码
 onceToken= -1，线程跳过dispatch_once的block中代码不执行
 onceToken= 其他值，线程被线程被阻塞，等待onceToken值改变
 用途：限制创建，提供全局调用，节约资源和提高性能
 
 @synchronized单例
 dispatch_once单例
 使用@synchronized虽然解决了多线程的问题，但是并不完美。因为只有在single未创建时，我们加锁才是有必要的。如果single已经创建.这时候锁不仅没有好处，而且还会影响到程序执行的性能（多个线程执行@synchronized中的代码时，只有一个线程执行，其他线程需要等待）。

 + (SingletonManager*)shareManager {
     static dispatch_once_t token;
     dispatch_once(&token, ^{
         if(defaultManager == nil) {
             NSLog(@"dispatch_once Token: %ld",token);// 768
             defaultManager = [[self alloc] init];
         }
     });
     NSLog(@"Token: %ld",token);
     NSLog(@"DefaultManager: %@",defaultManager);
     return defaultManager;
 }
 
 当线程首先调用shareInstance，某一线程要执行block中的代码时，首先需要改变onceToken的值，再去执行block中的代码。这里onceToken的值变为了768。
这样当其他线程再获取onceToken的值时，值已经变为768。其他线程被阻塞。
 当block线程执行完block之后。onceToken变为-1。其他线程不再阻塞，跳过block。
 下次再调用shareInstance时，block已经为-1。直接跳过block。
 这样dispatch_once在首次调用时同步阻塞线程，生成单例之后，不再阻塞线程。
 
 静态变量在程序运行期间只被初始化一次，然后其在下一次被访问时，其值都是上次的值，其在除了这个初始化方法以外的任何地方都不能直接修改这两个变量的值。这是单例只被初始化一次的前提。
 点击查看 dispatch_once 发现内部通过宏把 _dispatch_once 转化成 dispatch_once
 查找到 _dispatch_once 函数，我们发现 DISPATCH_EXPECT 方法
 ~0l 是长整型0按位取反，就是长整型的-1
 
 剩下就是 DISPATCH_EXPECT(x, v) 了，DISPATCH_EXPECT(*predicate, ~0l)  就是说，*predicate 很可能是 ~0l ，而当  DISPATCH_EXPECT(*predicate, ~0l)  不是 ~0l 时 才调用真正的 dispatch_once 函数。
 */

// MARK: SGPlayer
// https://github.com/libobjc/SGPlayer

// MARK: GPUImage
// https://www.jianshu.com/nb/4268718

// MARK: libevent
/**
 https://libevent.org/
 https://www.cnblogs.com/szitcast/p/10963742.html
 
 void *memcpy(void *str1, const void *str2, size_t n) 从存储区 str2 复制 n 个字节到存储区 str1
 
 event_base:
 使用libevent函数之前需要分配一个或者多个event_base结构体。每个event_base结构体持有一个事件集合，可以检测以确定哪个事件是激活的
 */

// MARK: 性能优化
// https://juejin.im/post/5e4cfa4f6fb9a07cce74dba7

// MARK: .m->c++
// xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc main.m -o main-arm64.cpp
// 把cpp文件直接拽入Xcode，为了不显示报错信息，我们不让它参与编译

// MARK: 预处理
/**
 程序中的源代码计算机是无法识别的，需要将写好的代码转成0、1二进制代码，计算机才能识别。将源代码转成二进制代码需要两步：编译和链接
 
 编译是通过编译器将每个文件的代码都转为二进制代码，在这个过程中，如果有语法错误，会有编译失败的提示，如果成功，那么会生成对应多个目标文件。在一个文件中可能会用到其他文件，因此，还需要将编译生成的目标文件和系统提供的文件组合到一起，这个过程就是链接，最后生成了可执行文件。

 通常人们所理解的程序运行就是编译和链接两个阶段，但实际上在编译之前，预处理器要进行预处理操作，处理完之后才能进入到编译阶段。因为预处理指令是在编译之前就进行了，所以它比程序运行时进行操作的效率高。
 
 预处理程序实际上是在分析程序前先处理的语句，它可以识别散布在程序中的特定语句。所有的预处理语句都适用"#"开头，这个符号必须是一行中的第一个非空字符。
 预处理可以大概分为三类：文件包含、宏定义和条件编译。
 
 文件包含：在当前文件中用到其它文件中的函数或方法或其它信息时，可以将其它文件的头文件包含进来，然后再当前文件中使用，文件包含一般放到文件的开头。
 #import在导入文件的时候进行了去重复检查，此外，""和<>两者也是有区别的，""一般是用来引用自定义的文件，<>一般是用来引用系统的文件。
 
 宏定义:
 在程序中，有一些常量或者简短的函数会被多次重复调用的，对于这些常用的数据，我们可以使用宏定义
 使用宏定义可以快速的完成程序中的多处配置，最大的好处就是只要修改宏定义的值，所有使用宏定义的值都会发生改变。此外，宏定义是在程序编译之前进行替换和设置，比定义成全局变量或者函数的效率要高。
 
 条件编译：
 在编译之前由预处理器来根据处理语句进行判断，如果满足条件，就编译满足条件下的代码。反之就不进入编译环节。
 条件编译主要分为两种：一种是判断是否定义过某个宏，根据是否定义过这个宏，来决定是否编译某段代码。另外，还有一组语句和条件结构中的阶梯if结构非常类似，但是写法上有区别，是 #if、#elif、#else、#endif组成。需要注意的是，无论哪种，都要有 #endif结束标志。此外，最重要的一点是： 条件编译中的条件不能使用普通变量，一般会选择使用宏定义。

#if defined(ZB_COUNT)
    NSLog(@"定义了 COUNT 这个宏");
#endif
 
#if ZB_COUNT== 1
     NSLog(@"ZB_COUNT=1");
 #elif ZB_COUNT==2
     NSLog(@"ZB_COUNT=2");
 #elif ZB_COUNT==3
     NSLog(@"ZB_COUNT=3");
 #else
     NSLog(@"ZB_COUNT=%i", ZB_COUNT);
 #endif

 #           空指令，没有任何效果
 #include    包含一个源代码文件
 #define     定义宏
 #undef      取消定义宏
 #if         如果条件为真，则编译下面的代码
 #elif       如果前面的#if不为真，则编译下面的代码
 #endif      结束一个#if。。。#elif条件编译块
 #ifdef      如果已经定义了某个宏，则编译下面的代码
 #ifndef     如果没有定义某个宏，则编译下面的代码
 #error      停止编译并显示错误信息
// MARK: Hash 在 iOS 中的应用
/**
 iOS系统API给我们提供一个自动过滤重复元素的容器 NSMutableSet/NSSet
 当我们向该实例对象中添加字符串时，如果重复添加两个相同的字符串，集合中只会保留一个。
 但是对于自定义一个类如Person，如果想利用NSMutableSet/NSSet来过滤重复元素（如多个Person实例的uid相同），我们必须要同时实现- (BOOL)isEqual:和- (NSUInteger)hash这两个方法。
 两个相等的实例，他们的hash值一定相等。但是hash值相等的两个实例，不一定相等
 
 OC 中 == 运算符判断的是指针是否相等, 而 isEqual 方法内部除了判断指针是否相等，还要判断对象的属性是否相等
 
 但对于自定义类型来说, 做判等时通常需要重写isEqual方法。
 @interface Person : NSObject
 @property (nonatomic, copy) NSString *name;
 @property (nonatomic, strong) NSDate *birthday;
 @end
 - (BOOL)isEqual:(id)object {
     if (self == object) {
         return YES;
     }

     if (![object isKindOfClass:[Person class]]) {
         return NO;
     }

     return [self isEqualToPerson:object];
 }

 - (BOOL)isEqualToPerson:(Person *)person {
     if (!person) {
         return NO;
     }

     BOOL haveEqualNames = (!self.name && !person.name) || [self.name isEqualToString:person.name];
     BOOL haveEqualBirthdays = (!self.birthday && !person.birthday) || [self.birthday isEqualToDate:person.birthday];

     return haveEqualNames && haveEqualBirthdays;
 }

 - (NSUInteger)hash
 如果在 Person 类中重写- (NSUInteger)hash方法，该方法只在 Person 实例对象被添加至NSSet或将Person实例对象设置为NSDictionary的key 时会调用
 
 hash方法和判等的关系？
 为了优化判等的效率, 基于 hash 的 NSSet 和 NSDictionary 在判断成员是否相等时, 通常会这样做:

 首先判断 hash 值是否和目标 hash 值相等。如果相同再进行对象之后的判等逻辑, 作为判等的结果； 如果不等, 直接判断为不相等。
 
 Person 类正确的 Hash 实现方法应该是借助位运算:
 - (NSUInteger)hash {
     return [self.name hash] ^ [self.birthday hash];
 }
 
 
 实现- (BOOL)isEqual: 和 - (NSUInteger)hash方法，实现过滤自定义实例的功能:
 @interface Person : NSObject

 @property (nonatomic, assign) NSInteger uid;
 @property (nonatomic, strong) NSString *name;

 - (instancetype)initWithID:(NSInteger)uid name:(NSString *)name;

 @end
 
 #import "Person.h"

 @implementation Person

 - (instancetype)initWithID:(NSInteger)uid name:(NSString *)name{
     if (self = [super init]) {
         self.uid = uid;
         self.name = name;
     }
     return self;
 }

 - (BOOL)isEqual:(Person *)object{
     BOOL result;
     if (self == object) {
         result = YES;
     }else{
         if (object.uid == self.uid) {
             result = YES;
         }else{
             result = NO;
         }
     }
     NSLog(@"%@ compare with %@ result = %@",self,object,result ? @"Equal":@"NO Equal");
     return result;
 }

 - (NSUInteger)hash{
     NSUInteger hashValue = self.uid;
     //在这里只需要比较uid就行。这样的话就满足如果两个实例相等，那么他们的 hash 一定相等，但反过来hash值相等，那么两个实例不一定相等。但是在 Person 这个实例中，hash值相等那么实例一定相等。（不考虑继承之类的）
     NSLog(@"hash = %lu,addressValue = %lu,address = %p",(NSUInteger)hashValue,(NSUInteger)self,self);
     // 如果返回的 值 与  之前返回的值不一样  则不会继续判断 isEqual 方法
     return hashValue;
 }


 - (NSString *)description{
     return [NSString stringWithFormat:@"%p(%ld,%@)",self,self.uid,self.name];
 }


 @end
 
 */

// MARK: ===图形图像渲染原理===
/**
 可视化应用程序都是由 CPU 和 GPU 协作执行的
 
 CPU（Central Processing Unit）：现代计算机的三大核心部分之一，作为整个系统的运算和控制单元。CPU 内部的流水线结构使其拥有一定程度的并行计算能力。
 GPU（Graphics Processing Unit）：一种可进行绘图运算工作的专用微处理器。GPU 能够生成 2D/3D 的图形图像和视频，从而能够支持基于窗口的操作系统、图形用户界面、视频游戏、可视化图像应用和视频播放。GPU 具有非常强的并行计算能力
 
 使用 GPU 渲染图形的根本原因就是：速度。GPU 的并行计算能力使其能够快速将图形结果计算出来并在屏幕的所有像素中进行显示
 
 那么像素是如何绘制在屏幕上的？计算机将存储在内存中的形状转换成实际绘制在屏幕上的对应的过程称为 渲染。渲染过程中最常用的技术就是 光栅化
 
 光栅化就是将数据转化成可见像素的过程
 GPU 则是执行转换过程的硬件部件。由于这个过程涉及到屏幕上的每一个像素，所以 GPU 被设计成了一个高度并行化的硬件部件
 
 GPU 图形渲染流水线的主要工作可以被划分为两个部分：
 把 3D 坐标转换为 2D 坐标
 把 2D 坐标转变为实际的有颜色的像素
 
 GPU 图形渲染流水线的具体实现可分为六个阶段:
 顶点着色器（Vertex Shader）
 形状装配（Shape Assembly），又称 图元装配
 几何着色器（Geometry Shader）
 光栅化（Rasterization）
 片段着色器（Fragment Shader）
 测试与混合（Tests and Blending）
 
 第一阶段，顶点着色器。该阶段的输入是 顶点数据（Vertex Data） 数据，比如以数组的形式传递 3 个 3D 坐标用来表示一个三角形。顶点数据是一系列顶点的集合。顶点着色器主要的目的是把 3D 坐标转为另一种 3D 坐标，同时顶点着色器可以对顶点属性进行一些基本处理
 
 第二阶段，形状（图元）装配。该阶段将顶点着色器输出的所有顶点作为输入，并将所有的点装配成指定图元的形状。图中则是一个三角形。图元（Primitive） 用于表示如何渲染顶点数据，如：点、线、三角形
 
 第三阶段，几何着色器。该阶段把图元形式的一系列顶点的集合作为输入，它可以通过产生新顶点构造出新的（或是其它的）图元来生成其他形状。例子中，它生成了另一个三角形
 
 第四阶段，光栅化。该阶段会把图元映射为最终屏幕上相应的像素，生成片段。片段（Fragment） 是渲染一个像素所需要的所有数据
 
 第五阶段，片段着色器。该阶段首先会对输入的片段进行 裁切（Clipping）。裁切会丢弃超出视图以外的所有像素，用来提升执行效率。
 
 第六阶段，测试与混合。该阶段会检测片段的对应的深度值（z 坐标），判断这个像素位于其它物体的前面还是后面，决定是否应该丢弃。此外，该阶段还会检查 alpha 值（ alpha 值定义了一个物体的透明度），从而对物体进行混合。因此，即使在片段着色器中计算出来了一个像素输出的颜色，在渲染多个三角形的时候最后的像素颜色也可能完全不同
 
 混合，GPU 采用如下公式进行计算，并得出最后的颜色
 R = S + D * (1 - Sa)
 
 假设有两个像素 S(source) 和 D(destination)，S 在 z 轴方向相对靠前（在上面），D 在 z 轴方向相对靠后（在下面），那么最终的颜色值就是 S（上面像素） 的颜色 + D（下面像素） 的颜色 * （1 - S（上面像素） 颜色的透明度）
 
 如果让图形看上去更加真实，需要足够多的顶点和颜色，相应也会产生更大的开销。为了提高生产效率和执行效率，开发者经常会使用 纹理（Texture） 来表现细节
 纹理是一个 2D 图片（甚至也有 1D 和 3D 的纹理）。纹理一般可以直接作为图形渲染流水线的第五阶段的输入
 
 着色器事实上是一些程序，它们运行在 GPU 中成千上万的小处理器核中
 这些着色器允许开发者进行配置，从而可以高效地控制图形渲染流水线中的特定部分。由于它们运行在 GPU 中，因此可以降低 CPU 的负荷。着色器可以使用多种语言编写，OpenGL 提供了 GLSL（OpenGL Shading Language） 着色器语言
 
 */

// MARK: ===iOS App 的图形渲染技术===
/**
 http://www.cocoachina.com/cms/wap.php?action=article&id=25510
 App 使用 Core Graphics、Core Animation、Core Image 等框架来绘制可视化内容，这些软件框架相互之间也有着依赖关系。这些框架都需要通过 OpenGL 来调用 GPU 进行绘制，最终将内容显示到屏幕之上
 
 iOS 渲染框架:
 UIKit
 可以通过设置 UIKit 组件的布局以及相关属性来绘制界面。
 UIKit 自身并不具备在屏幕成像的能力，其主要负责对用户操作事件的响应（UIView 继承自 UIResponder），事件响应的传递大体是经过逐层的 视图树 遍历实现的。

 Core Animation
 Core Animation 源自于 Layer Kit，动画只是 Core Animation 特性的冰山一角。
 Core Animation 是一个复合引擎，其职责是 尽可能快地组合屏幕上不同的可视内容，这些可视内容可被分解成独立的图层（即 CALayer），这些图层会被存储在一个叫做图层树的体系之中。从本质上而言，CALayer 是用户所能在屏幕上看见的一切的基础。

 Core Graphics
 Core Graphics 基于 Quartz 高级绘图引擎，主要用于运行时绘制图像。开发者可以使用此框架来处理基于路径的绘图，转换，颜色管理，离屏渲染，图案，渐变和阴影，图像数据管理，图像创建和图像遮罩以及 PDF 文档创建，显示和分析。
 当开发者需要在 运行时创建图像 时，可以使用 Core Graphics 去绘制。与之相对的是 运行前创建图像，例如用 Photoshop 提前做好图片素材直接导入应用。相比之下，我们更需要 Core Graphics 去在运行时实时计算、绘制一系列图像帧来实现动画。

 Core Image
 Core Image 与 Core Graphics 恰恰相反，Core Graphics 用于在 运行时创建图像，而 Core Image 是用来处理 运行前创建的图像 的。Core Image 框架拥有一系列现成的图像过滤器，能对已存在的图像进行高效的处理。
 大部分情况下，Core Image 会在 GPU 中完成工作，但如果 GPU 忙，会使用 CPU 进行处理。

 OpenGL ES
 OpenGL ES（OpenGL for Embedded Systems，简称 GLES），是 OpenGL 的子集。在前面的 图形渲染原理综述 一文中提到过 OpenGL 是一套第三方标准，函数的内部实现由对应的 GPU 厂商开发实现。

 Metal
 Metal 类似于 OpenGL ES，也是一套第三方标准，具体实现由苹果实现。大多数开发者都没有直接使用过 Metal，但其实所有开发者都在间接地使用 Metal。Core Animation、Core Image、SceneKit、SpriteKit 等等渲染框架都是构建于 Metal 之上的。
 当在真机上调试 OpenGL 程序时，控制台会打印出启用 Metal 的日志。根据这一点可以猜测，Apple 已经实现了一套机制将 OpenGL 命令无缝桥接到 Metal 上，由 Metal 担任真正于硬件交互的工作
 
 UIView 与 CALayer 的关系:
 CALayer，即 backing layer
 视图的职责是 创建并管理 图层
 
 为什么iOS要基于UIView和CALayer提供两个平行的层级关系呢：
 ###
 其原因在于要做职责分离，这样也能避免很多重复代码。
 在iOS和MacOSX两个平台上，事件和用户交互有很多地方的不同，基于多点触控的用户界面和基于鼠标键盘的交互有着本质的区别，这就是为什么iOS有UIKit和UIView，对应Mac OSX有AppKit和NSView的原因。
 ###
 
 除了 视图树 和 图层树，还有 呈现树 和 渲染树
 
 CALayer 基本等同于一个 纹理。纹理是 GPU 进行图像渲染的重要依据
 在 图形渲染原理 中提到纹理本质上就是一张图片，因此 CALayer 也包含一个 contents 属性指向一块缓存区，称为 backing store，可以存放位图（Bitmap）。iOS 中将该缓存区保存的图片称为 寄宿图
 
 图形渲染流水线支持从顶点开始进行绘制（在流水线中，顶点会被处理生成纹理），也支持直接使用纹理（图片）进行渲染
 相应地，在实际开发中，绘制界面也有两种方式：一种是 手动绘制；另一种是 使用图片
 对此，iOS 中也有两种相应的实现方式：
 ##使用图片：contents image
 ##手动绘制：custom drawing
 
 Contents Image:
 Contents Image 是指通过 CALayer 的 contents 属性来配置图片。然而，contents 属性的类型为 id。在这种情况下，可以给 contents 属性赋予任何值，app 仍可以编译通过。但是在实践中，如果 content 的值不是 CGImage ，得到的图层将是空白的
 为什么要将 contents 的属性类型定义为 id 而非 CGImage。这是因为在 Mac OS 系统中，该属性对 CGImage 和 NSImage 类型的值都起作用，而在 iOS 系统中，该属性只对 CGImage 起作用。
 本质上，contents 属性指向的一块缓存区域，称为 backing store，可以存放 bitmap 数据
 iOS中将该缓存区保存的图片称为寄宿图。
 
 Custom Drawing:
 ###Custom Drawing 是指使用 Core Graphics 直接绘制寄宿图。
 实际开发中，一般通过继承 UIView 并实现 -drawRect: 方法来自定义绘制
 虽然 -drawRect: 是一个 UIView 方法，但事实上都是底层的 CALayer 完成了重绘工作并保存了产生的图片
 
 UIView 有一个关联图层，即 CALayer。
 CALayer 有一个可选的 delegate 属性，实现了 CALayerDelegate 协议。UIView 作为 CALayer 的代理实现了 CALayerDelegae 协议
 当需要重绘时，即调用 -drawRect:，CALayer 请求其代理给予一个寄宿图来显示
 CALayer 首先会尝试调用 -displayLayer: 方法，此时代理可以直接设置 contents 属性。
 - (void)displayLayer:(CALayer *)layer;
 如果代理没有实现 -displayLayer: 方法，CALayer 则会尝试调用 -drawLayer:inContext: 方法。在调用该方法前，CALayer 会创建一个空的寄宿图（尺寸由 bounds 和 contentScale 决定）和一个 Core Graphics 的绘制上下文，为绘制寄宿图做准备，作为 ctx 参数传入。
 - (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
 最后，由 Core Graphics 绘制生成的寄宿图会存入 backing store
 
 Core Animation 流水线:
 app 本身并不负责渲染，渲染则是由一个独立的进程负责，即 Render Server 进程
 IPC（Inter-Process Communication，进程间通信）
 App 通过 IPC 将渲染任务及相关数据提交给 Render Server。Render Server 处理完数据后，再传递至 GPU。最后由 GPU 调用 iOS 的图像设备进行显示
 
 Core Animation 流水线的详细过程如下：
 首先，由 app 处理事件（Handle Events），如：用户的点击操作，在此过程中 app 可能需要更新 视图树，相应地，图层树 也会被更新
 其次，app 通过 CPU 完成对显示内容的计算，如：视图的创建、布局计算、图片解码、文本绘制等。在完成对显示内容的计算之后，app 对图层进行打包，并在下一次 RunLoop 时将其发送至 Render Server，即完成了一次 Commit Transaction 操作
 Render Server 主要执行 Open GL、Core Graphics 相关程序，并调用 GPU
 GPU 则在物理层上完成了对图像的渲染
 最终，GPU 通过 Frame Buffer、视频控制器等相关部件，将图像显示在屏幕
 
 对上述步骤进行串联，它们执行所消耗的时间远远超过 16.67 ms，因此为了满足对屏幕的 60 FPS 刷新率的支持，需要将这些步骤进行分解，通过流水线的方式进行并行执行
 
 在 Core Animation 流水线中，app 调用 Render Server 前的最后一步 Commit Transaction 其实可以细分为 4 个步骤：
 Layout
 Display
 Prepare
 Commit
 
 Layout:
 Layout 阶段主要进行视图构建，包括：LayoutSubviews 方法的重载，addSubview: 方法填充子视图等。

 Display:
 Display 阶段主要进行视图绘制，这里仅仅是设置最要成像的图元数据。重载视图的 drawRect: 方法可以自定义 UIView 的显示，其原理是在 drawRect: 方法内部绘制寄宿图，该过程使用 CPU 和内存。

 Prepare:
 Prepare 阶段属于附加步骤，一般处理图像的解码和转换等操作。

 Commit:
 Commit 阶段主要将图层进行打包，并将它们发送至 Render Server。该过程会递归执行，因为图层和视图都是以树形结构存在
 
 动画渲染原理:
 iOS 动画的渲染也是基于上述 Core Animation 流水线完成的。这里我们重点关注 app 与 Render Server 的执行流程。

 日常开发中，如果不是特别复杂的动画，一般使用 UIView Animation 实现，iOS 将其处理过程分为如下三部阶段：

 Step 1：调用 animationWithDuration:animations: 方法
 Step 2：在 Animation Block 中进行 Layout，Display，Prepare，Commit 等步骤。
 Step 3：Render Server 根据 Animation 逐帧进行渲染
 */

// MARK: 内存管理
/**
 引用计数
 retain、release、etainCount
 
 - (NSUInteger)retainCount  {
     return (NSUInteger)__CFDoExternRefOperation(OPERATION_retainCount,self);
 }

 - (id)retain  {
     return (id)__CFDoExternRefOperation(OPERATION_retain,self);
 }

 - (void)release  {
     return __CFDoExternRefOperation(OPERATION_release,self);
 }

 int __CFDoExternRefOperation(uintptr_r op,id obj) {
         CFBasicHashRef table = 取得对象对应的散列表(obj);
         int count;

         switch(op) {
             case OPERATION_retainCount:
                 count = CFBasicHashGetCountOfKey(table,obj);
                 return count;
             case OPERATION_retain:
                 CFBasicHashAddValue(table,obj);
                 return obj;
             case OPERATION_release:
                 count = CFBasicHashRemoveValue(table,obj):
                 return 0 == count;
         }
     }
 
 采用散列表（引用计数表）来管理引用计数，当我们在调用retain、retainCount、release时，先调用_CFDoExternRefOperation()从而获取到引用计数表的内存地址以及本对象的内存地址，然后根据对象的内存地址在表中查询获取到引用计数值

 autorelease作用是将对象放入自动释放池中，当自动释放池销毁时对自动释放池中的对象都进行一次release操作
 
 ARC：
 使用@autoreleasepool{}来使用一个AutoreleasePool，随后编译器会改成下面的样子：
 void *context = objc_autoreleasePoolPush();
 // 执行的代码
 objc_autoreleasePoolPop(context);
 而这两个函数都是对AutoreleasePoolPage的简单的封装
 
 AutoreleasePool并没有单独的结构，而是由若干个AutoreleasePoolPage以双链表的形式组合而成（分别对应结构中的parent指针和child指针）
 AutoreleasePool是按线程一一对应的（结构中的thread指针指向当前线程）
 AutoreleasePoolPage每个对象开辟一个虚拟内存一页的大小，除了上面实例变量所占空间，剩下的空间全部用来存储autorelease对象的地址
 上面的id *next指针作为游标指向栈顶最新add进来的autorelease对象的下一个位置
 一个AutoreleasePoolPage的空间被占满时，会新建一个AutoreleasePoolPage对象，连接链表，后来的autorelease对象在新的page加入
 
 这一页再加入一个autorelease对象就要满了（也就是next指针马上指向栈顶），这时就要执行上面说的操作，建立下一页page对象，与这一页链表链接完成后，新page的next指针被初始化在栈底（begin的位置），然后继续向栈顶添加新对象。
 
 向一个对象发送- autorelease消息，就是将这个对象加入到当前AutoreleasePoolPage的栈顶next指针指向的位置
 
 每当执行一个objc_autoreleasePoolPush调用时，runtime向当前的AutoreleasePoolPage中add进一个哨兵对象，值为0（也就是nil）
 objc_autoreleasePoolPush的返回值正是这个哨兵对象的地址，被objc_autoreleasePoolPop(哨兵对象)作为入参
 
 根据传入的哨兵对象地址找到哨兵对象所处的page
 在当前page中，将晚于哨兵对象插入的所有autorelease对象都发送一次- release消息，并向回移动next指针到正确位置
 从最新加入的对象一直向前清理，可以向前跨越若干个page，直到哨兵所在的page

 id __strong obj = [[NSObject alloc] init];
 编译器会转换成下面代码：
 id obj = objc_msgSend(NSObject, @selector(alloc));
 objc_msgSend(obj, @selector(init));

 // ...
 objc_release(obj)

 id __strong obj = [NSMutableArray array];
 编译器会转换成下面代码：
 id obj = objc_msgSend(NSMutableArray, @selector(array));

 //替代我们调用retain方法，是obj持有该对象
 objc_retainAutoreleaseReturnValue(obj);
 objc_release(obj);
 
 + (id)array {
     return [[NSMutableArray alloc] init];
 }
 编译器转换如下：
 + (id)array {
     id obj = objc_msgSend(NSMutableArray,@selector(alloc));
     objc_msgSend(obj,@selector(init));
     
     // 代替我们调用autorelease方法
     return objc_autoreleaseReturnValue(obj);
 }
 objc_retainAutoreleaseReturnValue有一个成对的函数objc_autoreleaseReturnValue,这两个函数可以用于最优化程序的运行
 
 其实autorelease这个开销不小，runtime机制解决了这个问题
 优化:
 Thread Local Storage（TLS）线程局部存储
 将一块内存作为某个线程专有的存储，以key-value的形式进行读写
 在返回值身上调用objc_autoreleaseReturnValue方法时，runtime将这个返回值object储存在TLS中，然后直接返回这个object（不调用autorelease），同时，在外部接收这个返回值的objc_retainAutoreleaseReturnValue里，发现TLS中正好存在这个对象，那么直接返回这个object（不调用retain）。
 于是乎，调用方和被调用利用TLS做中转，很有默契的免去了对返回值的内存管理。

 __weak表示弱引用，弱引用不会影响对象的释放，而当对象被释放时，所有指向它的弱引用都会自动被置为nil，这样可以防止野指针
 obj对象在生成之后立马就会被释放，主要原因是因为__weak修饰的指针没有引起对象内部的引用计数发生变化
 Runtime维护了一个weak表，用于存储指向某个对象的所有weak指针。weak表其实是一个Hash（哈希）表
 Key是所指对象的地址，Value是weak指针的地址（这个地址的值是所指对象的地址）数组。
 
 1.初始化时，runtime会调用objc_initWeak函数，初始化一个新的weak指针指向对象的地址。
 2.添加引用时，objc_initWeak函数会调用objc_storeWeak()函数，objc_storeWeak()的作用是更新指针指向，创建对应的弱引用表。
 3.释放时，调用clearDeallocating函数。clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录。
 
 struct weak_table_t {
     weak_entry_t *weak_entries;     // 保存来所有指向指定对象的weak指针     weak_entries的对象
     size_t num_entries;             // weak对象的存储空间
     uintptr_t mask;
     uintptr_t max_hash_displacement;
 };
 
 id __weak obj = [[NSObject alloc] init];
 编译器转换后代码如下：
 id obj;
 id tmp = objc_msgSend(NSObject, @selector(alloc));
 objc_msgSend(tmp,@selector(init));
 objc_initWeak(&obj,tmp);
 objc_release(tmp);
 objc_destroyWeak(&obj);
 
 id objc_initWeak(id *location, id newObj) {
     if (!newObj) {
         *location = nil;
         return nil;
     }

     return storeWeak(location, newObj);
 }
 
 ###weak_entry_t是存储在弱引用表中的一个内部结构体，它负责维护和存储指向一个对象的所有弱引用Hash表###
 
 释放对象基本流程如下：
 调用objc_release
 因为对象的引用计数为0，所以执行dealloc
 在dealloc中，调用来_objc_rootDealloc函数
 在_objc_rootDealloc中，调用来object_dispose函数
 调用objc_destructInstance
 最后调用objc_clear_deallocating

 clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录。
 
 void objc_clear_deallocating(id obj) {
     assert(obj);
     assert(!UseGC);
     if (obj->isTaggedPointer()) return;
     obj->clearDeallocating();
 }

 //执行 clearDeallocating方法
 inline void objc_object::clearDeallocating() {
     sidetable_clearDeallocating();
 }
 void  objc_object::sidetable_clearDeallocating() {
     SideTable *table = SideTable::tableForPointer(this);
     // clear any weak table items
     // clear extra retain count and deallocating bit
     // (fixme warn or abort if extra retain count == 0 ?)
     spinlock_lock(&table->slock);
     RefcountMap::iterator it = table->refcnts.find(this);
     if (it != table->refcnts.end()) {
         if (it->second & SIDE_TABLE_WEAKLY_REFERENCED) {
             weak_clear_no_lock(&table->weak_table, (id)this);
         }
         table->refcnts.erase(it);
     }
     spinlock_unlock(&table->slock);
 }

最终通过调用weak_clear_no_lock方法，将weak指针置空
 
 objc_clear_deallocating函数的操作如下：
 从weak表中获取废弃对象的地址为键值的记录
 将包含在记录中的所有附有weak修饰符变量的地址，置为nil
 将weak表中该记录删除
 从引用计数表中删除废弃对象的地址为键值的记录
 
 __unsafe_unretained：
 __unsafe_unretained作用需要和weak对比，它不会引起对象的内部引用计数的变化，但是，当其指向的对象被销毁是__unsafe_unretained修饰的指针不会置为nil。是不安全的所有权修饰符，它不纳入ARC的内存管理。

 */

#import "InterviewViewController.h"
#import "DrawRectView.h"
#import "MyOperation.h"
#import "NDLDevice.h"
#import <AFNetworking.h>

@interface Sark : NSObject
@end
@implementation Sark
@end

@interface InterviewViewController ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSThread *testThread;

@property (nonatomic, strong) NSObject *tempObj;

@property (nonatomic, strong) NSObject *obj1;
@property (nonatomic, strong) NSObject *obj2;
@property (nonatomic, strong) NSObject *obj3;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSOperationQueue *myQueue;

@property (nonatomic, strong) NDLDevice *device;

@end

@implementation InterviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    // 111->222->333
//    dispatch_queue_t ser222 = dispatch_queue_create("222", NULL);
//    NSLog(@"=============111");
//    dispatch_sync(ser222, ^{
//        NSLog(@"=============222");
//        // 会阻塞主线程
////        for (NSInteger i = 0; i < 100000; i++) {
////            NSLog(@"for ========== 222");
////        }
//    });
//    NSLog(@"=============333");
    
    // MARK: isKindOfClass 与 isMemberOfClass
    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL res3 = [(id)[Sark class] isKindOfClass:[Sark class]];
    BOOL res4 = [(id)[Sark class] isMemberOfClass:[Sark class]];
    NSLog(@"%d %d %d %d", res1, res2, res3, res4);// 1 0 0 0
    /**
     ###在isKindOfClass中有一个循环，先判断class是否等于meta class，不等就继续循环判断是否等于meta class的super class，不等再继续取super class，如此循环下去###
     
     [NSObject class]执行完之后调用isKindOfClass，第一次判断先判断NSObject和 NSObject的meta class是否相等,NSObject的meta class与本身不等。接着第二次循环判断NSObject与meta class的superclass是否相等。我们可以看到：Root class(meta) 的superclass就是 Root
     class(class)，也就是NSObject本身。所以第二次循环相等，于是第一行res1输出应该为YES。

     同理，[Sark class]执行完之后调用isKindOfClass，第一次for循环，Sark的Meta Class与[Sark class]不等，第二次for循环，Sark Meta Class的super class 指向的是 NSObject Meta Class， 和Sark Class不相等。第三次for循环，NSObject Meta Class的super class指向的是NSObject Class，和 Sark Class 不相等。第四次循环，NSObject Class 的super class 指向 nil， 和 Sark Class不相等。第四次循环之后，退出循环，所以第三行的res3输出为NO
     
     isMemberOfClass的源码实现是拿到自己的isa指针和自己比较，是否相等。
     第二行isa 指向 NSObject 的 Meta Class，所以和 NSObject Class不相等。第四行，isa指向Sark的Meta Class，和Sark Class也不等，所以第二行res2和第四行res4都输出NO
     */
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"我们是ndl";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    label.layer.masksToBounds = YES;
    [self.view addSubview:label];
    [label sizeToFit];
    label.y = 100;
    // frame = {{0, 100}, {75.5, 20.5}}
    NSLog(@"frame = %@", NSStringFromCGRect(label.frame));
    
    // MARK: 后面全打印完，再打印111===，即这个viewDidLoad方法走完，再打印111===
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"111===");
    });
    NSLog(@"222===");
    
//     self.view.layer.delegate
    // MARK: CALayerDelegate
//     /* If defined, called by the default implementation of the -display
//      * method, in which case it should implement the entire display
//      * process (typically by setting the `contents' property). */
//     - (void)displayLayer:(CALayer *)layer;

//     /* If defined, called by the default implementation of -drawInContext: */
//     - (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
    
//    /* If defined, called by the default implementation of the
//     * -actionForKey: method. Should return an object implementing the
//     * CAAction protocol. May return 'nil' if the delegate doesn't specify
//     * a behavior for the current event. Returning the null object (i.e.
//     * '[NSNull null]') explicitly forces no further search. (I.e. the
//     * +defaultActionForKey: method will not be called.) */
//
//    - (nullable id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event;
    // eg:
//    [self.view.layer display]
//    [self.view.layer drawInContext:]
    
    DrawRectView *drawRectView = [[DrawRectView alloc] initWithFrame:CGRectMake(0, 100, 100, 40)];
    [self.view addSubview:drawRectView];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:@(1) forKey:@"one"];
    NSLog(@"dic = %@", dic);
    [dic setObject:@(2) forKey:@"two"];
//    [dic setObject:nil forKey:@"three"];// crash
    [dic setObject:[NSNull null] forKey:@"three"];
    [dic setObject:@(4) forKey:@"four"];
    NSLog(@"dic = %@", dic);

    [self testMath];
    [self testMemory];
    [self testBlock];
    [self testThread];
    [self testVender];
    
    // MARK: test kvo
//    self.device = [[NDLDevice alloc] init];
//    [self.device addObserver:self forKeyPath:@"deviceName" options:NSKeyValueObservingOptionNew context:nil];
//    self.device.deviceName = @"ndl";
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"===change name===");
//        self.device.deviceName = @"cc";
//    });
    
}

// MARK: kvo for NDLDevice
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    NSLog(@"==============keyPath = %@ vlaue = %@", keyPath, change[NSKeyValueChangeNewKey]);
//}

// MARK: 事件的响应
// touch方法默认不处理事件，只传递事件，将事件交给上一个响应者进行处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear:retain count = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.tempObj)));// 2
    NSLog(@"viewDidAppear:button retain count = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.button)));// 2
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"dispatch_after:retain count = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.tempObj)));// 2
        
        NSLog(@"dispatch_after:obj111 count = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.obj1)));// 4
        
        NSLog(@"dispatch_after:button retain count = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.button)));// 2
        
    });
}

- (void)testMath {
    NSArray *array = @[@(1), @(3), @(1), @(2), @(3)];
    // MARK: 全部元素异或消掉出现两次的数字
    // 异或的运算法则为：0⊕0=0，1⊕0=1，0⊕1=1，1⊕1=0（同为0，异为1）
    NSInteger result = 0;
    for (NSNumber *number in array) {
        result ^= number.integerValue;
    }
    NSLog(@"result = %ld", result);
    
}

- (void)testMemory {
    NSLog(@"=============start testMemory=============");
    NSObject *obj = [[NSObject alloc] init];// 1
    self.tempObj = obj;// 2
    NSLog(@"retain count = %ld", CFGetRetainCount((__bridge CFTypeRef)(obj)));// 2
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button = button;
    NSLog(@"button retain count = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.button)));// 3
    
    NSObject *obj111 = [[NSObject alloc] init];
    self.obj1 = obj111;
    self.obj2 = obj111;
    self.obj3 = obj111;
    NSLog(@"obj111 count = %ld", CFGetRetainCount((__bridge CFTypeRef)(obj111)));// 4
//    self.obj1 = nil;// referenceCount - 1 = 3  ，dispatch_after那边为3 不能用self.obj1 因为他为nil
    
    NSLog(@"=============end testMemory=============");
}

- (void)testBlock {
    // MARK: 局部对象变量也是一样，截获的是值(相当于*指针)，而不是指针，在外部将其置为nil，对block没有影响，而该对象调用方法会影响
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    void(^block)(void) = ^{
        NSLog(@"%@",arr);// 1,2,3
        [arr addObject:@"4"];// 表示改变arr指向的值
//        arr = [NSMutableArray arrayWithObject:@"111"];// 外面的需要__block,实质是改变arr的指向
        NSLog(@"after %@",arr);// 1,2,3,4
    };

    [arr addObject:@"3"];
    arr = nil;
    block();
    
//    __block NSArray *arr1 = [NSArray arrayWithObject:@"1"];
//    void(^block1)(void) = ^{
//        NSLog(@"%@",arr1);// 2
//        arr1 = [NSArray arrayWithObject:@"3"];
//        NSLog(@"after %@",arr1);// 3
//    };
//    arr1 = [NSArray arrayWithObject:@"2"];
//    block1();
}

- (void)testThread {
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"=========");
//        // MARK: [opaeration start]会在当前线程执行，这边的话即子线程
//        NSBlockOperation *blkOp = [NSBlockOperation blockOperationWithBlock:^{
//            NSLog(@"blkOp: curThread = %@", [NSThread currentThread]);
//
//        }];
//        [blkOp start];
//    });
    
//    NSLog(@"runloop = %@", [NSRunLoop currentRunLoop]);
    
     // dispatch_get_global_queue sync 1,2,3 耗时操作才会阻塞线程 这边是主线程
//        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//            sleep(2);
//            // main
//            NSLog(@"dispatch_get_global_queue sync 1 curThread = %@", [NSThread currentThread]);
//        });
//
//        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//            sleep(2);
//            NSLog(@"dispatch_get_global_queue sync 2");
//        });
//
//        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//            sleep(2);
//            NSLog(@"dispatch_get_global_queue sync 3");
//        });
        
        
        // ###没有死锁，阻塞了主线程,这边任务做完才能继续下去###
    //    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
    //        sleep(5.0);
    //        NSLog(@"!!!!!!!!");
    //    });
        
        // 死锁
    //    dispatch_sync(dispatch_get_main_queue(), ^{
    //        NSLog(@"deallock");
    //    });
        // 解决:
        // 1.
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        NSLog(@"dispatch_get_main_queue async");
    //    });
        // 2.
    //    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
    //        NSLog(@"===dispatch_get_global_queue sync");
    //    });
        
    //    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
    //        NSLog(@"globol block %@", [NSThread currentThread]);// globol block <NSThread: 0x6000026dccc0>{number = 1, name = main}
    //    });
    //
    //    dispatch_queue_t serialQueue1 = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    //    dispatch_sync(serialQueue1, ^{
    //        NSLog(@"serialQueue1 %@", [NSThread currentThread]);// serialQueue1 <NSThread: 0x6000026dccc0>{number = 1, name = main}
    //    });
    //
        
        
        // 死锁
    //    dispatch_queue_t serialQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    //    dispatch_queue_t serialQueue_1 = dispatch_queue_create("test_1", DISPATCH_QUEUE_SERIAL);
    //    dispatch_async(serialQueue, ^{
    //        NSLog(@"InterviewViewController: %@", [NSThread currentThread]);// <NSThread: 0x6000039ec3c0>{number = 6, name = (null)}
    //
    //        // test1 死锁
    ////        dispatch_sync(serialQueue, ^{
    ////            NSLog(@"deadlock %@", [NSThread currentThread]);
    ////        });
    //
    //        // test2 解决
    ////        dispatch_sync(serialQueue_1, ^{
    ////            NSLog(@"serialQueue_1 %@", [NSThread currentThread]);// <NSThread: 0x6000039ec3c0>{number = 6, name = (null)}
    ////        });
    //
    //        NSLog(@"##########");
    //    });
        
        
        
    //    dispatch_queue_t serialQueue11 = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    //    NSLog(@"1");
    //    dispatch_async(serialQueue11, ^{
    //        // 13=245
    ////        for (int i = 0 ; i < 1000; i++) {
    ////            NSLog(@"===");
    ////        }
    //
    //        // 阻塞线程
    ////        sleep(3.0);
    //
    //        // 13245
    //         NSLog(@"2");
    //    });
    //    NSLog(@"3");
    //    dispatch_sync(serialQueue11, ^{
    //        NSLog(@"4");
    //    });
    //    NSLog(@"5");
        
        
    //    dispatch_queue_t serialQueue11 = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    //    NSLog(@"1");
    //    dispatch_sync(serialQueue11, ^{
    //        // 154
    ////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    ////            NSLog(@"4");
    ////        });
    //
    //        // 154
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), serialQueue11, ^{
    //            NSLog(@"4");
    //        });
    //    });
    //    NSLog(@"5");
        
      
        // 13245
    //    dispatch_queue_t serialQueue11 = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    //    dispatch_queue_t serialQueue22 = dispatch_queue_create("test22", DISPATCH_QUEUE_SERIAL);
    //    NSLog(@"1");
    //    dispatch_async(serialQueue11, ^{
    //         NSLog(@"2");
    //    });
    //    NSLog(@"3");
    //    dispatch_sync(serialQueue22, ^{
    //        sleep(2.0);
    //        NSLog(@"4");
    //    });
    //    NSLog(@"5");
        
        
        // 0-9 barrier dispatch_barrier_sync 10-19
    //    dispatch_queue_t concurrentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    //    for (NSInteger i = 0; i < 10; i++) {
    //        dispatch_sync(concurrentQueue, ^{
    //            NSLog(@"%zd",i);
    //        });
    //    }
    //
    //    dispatch_barrier_sync(concurrentQueue, ^{
    //        NSLog(@"barrier");
    //    });
    //
    //    NSLog(@"dispatch_barrier_sync");
    //
    //    for (NSInteger i = 10; i < 20; i++) {
    //        dispatch_sync(concurrentQueue, ^{
    //            NSLog(@"%zd",i);
    //        });
    //    }
        
        // 0-9 dispatch_barrier_sync barrier 10-19
    //    dispatch_queue_t concurrentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    //    for (NSInteger i = 0; i < 10; i++) {
    //        dispatch_sync(concurrentQueue, ^{
    //            NSLog(@"%zd",i);
    //        });
    //    }
    //
    //    dispatch_barrier_async(concurrentQueue, ^{
    //        NSLog(@"barrier");
    //    });
    //
    //    NSLog(@"dispatch_barrier_async");
    //
    //    for (NSInteger i = 10; i < 20; i++) {
    //        dispatch_sync(concurrentQueue, ^{
    //            NSLog(@"%zd",i);
    //        });
    //    }
        
    
//        dispatch_queue_t concurrentQueue = dispatch_queue_create("test1", DISPATCH_QUEUE_CONCURRENT);
//        dispatch_group_t group = dispatch_group_create();
//        for (NSInteger i = 0; i < 10; i++) {
//            dispatch_group_async(group, concurrentQueue, ^{
//                sleep(1);
//                NSLog(@"%zd:网络请求 %@",i, [NSThread currentThread]);// child thread
//            });
//        }
//
//        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//            NSLog(@"刷新页面 %@", [NSThread currentThread]);// main
//        });
    
    
    // before dispatch_semaphore_signal semaphore---end,number = 100
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    __block NSInteger number = 0;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(3.0);
//        number = 100;
//        NSLog(@"dispatch_semaphore_signal");
//        dispatch_semaphore_signal(semaphore);
//    });
//
//    NSLog(@"before dispatch_semaphore_wait");
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    NSLog(@"semaphore---end,number = %zd",number);
  
    
//    _semaphore = dispatch_semaphore_create(1);
//    for (NSInteger i = 0; i < 100; i++) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [self asyncTaskWithID:i];
//        });
//    }
    
    // gcd cancel
//    [self gcdBlockCancel];
//    [self gcdCancel];

//    dispatch_queue_get_specific(<#dispatch_queue_t  _Nonnull queue#>, <#const void * _Nonnull key#>)
//    dispatch_queue_set_specific(<#dispatch_queue_t  _Nonnull queue#>, <#const void * _Nonnull key#>, <#void * _Nullable context#>, <#dispatch_function_t  _Nullable destructor#>)
    
    // 这个执行tests
//    [self performSelector:@selector(tests) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
    // 这个不执行tests
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"===performSelector:onThread: %@",[NSThread currentThread]);// 字线程
//        [self performSelector:@selector(tests) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
//    });
    // 这个执行tests
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"===performSelector:onThread: %@",[NSThread currentThread]);// 字线程
//        [self performSelector:@selector(tests) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
//        [[NSRunLoop currentRunLoop] run];// ###
//    });
    
    
    // job1->after 3 job2->after 2 job3
//    dispatch_queue_t targetQueue = dispatch_queue_create("target_queue", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_set_target_queue(queue1, targetQueue);
//    dispatch_set_target_queue(queue2, targetQueue);
//    dispatch_async(queue1, ^{
//    NSLog(@"do job1 %@", [NSThread currentThread]);// <NSThread: 0x600000f4fb80>{number = 6, name = (null)}
//    [NSThread sleepForTimeInterval:3.f];
//    });
//    dispatch_async(queue2, ^{
//    NSLog(@"do job2 %@", [NSThread currentThread]);// <NSThread: 0x600000f4fb80>{number = 6, name = (null)}
//    [NSThread sleepForTimeInterval:2.f];
//    });
//    dispatch_async(queue2, ^{
//    NSLog(@"do job3 %@", [NSThread currentThread]);// <NSThread: 0x600000f4fb80>{number = 6, name = (null)}
//    [NSThread sleepForTimeInterval:1.f];
//    });
    
    // MARK: https://www.jianshu.com/u/c5bd27531bfa
    // http://www.cocoachina.com/cms/wap.php?action=article&id=24524
    // MARK: NSOperation
    /**
     注意：这里 maxConcurrentOperationCount 控制的不是并发线程的数量，而是一个队列中同时能并发执行的最大操作数。而且一个操作也并非只能在一个线程中运行。
     
     NSOperationQueue 是操作队列, 即存放operation的队列
     NSInvocationOperation只有配合NSOperationQueue使用才能实现多线程编程，单独使用NSInvocationOperation不会开启线程，默认在当前线程（指执行该方法的线程）中同步执行
     
     ##
     NSOperation 可以调用 start 方法来执行任务，但默认是同步执行的
     如果将 NSOperation 添加到 NSOperationQueue（操作队列）中，系统会自动异步执行NSOperation中的操作
     ##

     NSOperation中的两种队列:
     主队列 通过mainQueue获得，凡是放到主队列中的任务都将在主线程执行
     非主队列 直接alloc init出来的队列。非主队列同时具备了并发和串行的功能，通过设置最大并发数属性来控制任务是并发执行还是串行执行
     
     NSOperationQueue *queue = [[NSOperationQueue alloc] init];
     队列的addOperation方法内部已经调用了[operation start]，不需要再手动启动
     
     队列的暂停和恢复以及取消：
     暂停操作不能使当前正在处于执行状态的任务暂停，而是该任务执行结束，后面的任务不会执行，处于排队等待状态 。例如执行2个任务，在执行第1个任务时，执行了暂停操作，第1个任务不会立即暂停，而是第1个任务执行结束后，所有任务暂停，即第2个任务不会再执行
     
     取消队列的所有操作:
     // 跟暂停相似，当前正在执行的任务不会立即取消，而是后面的所有任务永远不再执行，且该操作是不可以恢复的
     - (void)cancelAllOperations;
     也可以调用NSOperation的 cancel 方法取消单个操作
     
     操作依赖:
     NSOperation之间可以设置依赖来保证执行顺序，比如：操作A执行完后，才能执行操作B,就可以使用操作依赖
     [opB addDependency: opA]; // 操作B依赖于操作A
     而且可以在不同queue的NSOperation之间创建依赖关系，比如：操作A在队列1中，操作B在队列2中，也可以使用addDependency还保证执行顺序

     操作的监听:
     - (void (^)(void))completionBlock;
     - (void)setCompletionBlock:(void (^)(void))block;
     // NSOperation的completionBlock总是在子线程中执行
     
     operation的优先级只能应用与相同的 operation queue中的 operation之间. 不同的queue中的operation不受影响
     优先级一般运用于并行队列
     如果queue是串行队列, operation执行顺序还是按照加入到queue的先后顺序执行
     
     当一个 operation 被取消时，它的 completion block 仍然会执行，所以我们需要在真正执行代码前检查一下 isCancelled 方法的返回值
     
     cancel 的本质是将NSOperation的isCancelled属性设置为YES.
     我们会实时检测isCancelled属性, 在该属性被设置成YES以后, 会将isFinished设置成YES(如果是自定义的NSOperation, 这部分代码需要我们完成), 这样, KVO就会发出通知, 依赖该NSOperation的其他Operation就会将isReady属性设置成YES, 自己的 completionBlock 也会执行
     
     自定义NSOperation:
     在实际开发中, 我们的Operation可能需要在任何时间点取消这个操作, 可能在Operation被执行之前, 可能在Operation正在运行main函数之中的某个时间点. 因此如果我们需要自定义的Operation能够完美的支持取消操作,减少不必要的CPU消耗, 我们需要在Operation执行期间, 定期的检查isCancelled属性, 一旦Operation被cancelled, 我们就需要立即停止Operation
     
     有以下几个常规点去获取isCancelled的值:
     在Operation开始执行时
     至少在每次循环中检查一次
     在执行一个耗时任务之前
     在任何相对来说比较容易终止operation的地方
     
     手动调用start并且并发执行的NSOperation:
     默认情况下, NSOperation直接调用start是同步执行的, 也就是说, 实际上是调用的start方法的线程中执行的任务
     如果我们需要异步执行operation, 并且又是手动执行(直接调用start), 因此我们需要完成以下步骤:
     start: 必须重写, 所有并发执行的operation都需要重写该方法.(并且不要调用[super start]).start方法是NSOperation任务的起点, 我们可以在这里配置operatioin的执行线程以及其他的context.
     main: 可选.通常这个方法是专门用来实现与operation关联的任务的. 尽管大多数情况,我们可以在start中实现任务, 但在main实现具体任务做到控制逻辑和业务逻辑分离也很好.(SDWebImage 直接在start中完成的控制逻辑和业务逻辑调用)
     isExecuting和isFinished: 必须. 并发NSOPeration需要配置它的执行环境, 并且对外需要支持KVO监听这两个状态.
     isConcurrent or asynchronous: 必须. 这个属性用来标志一个operation是否是并发
     
     
     */
    // test1
//    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invoTask) object:nil];
//    [invocationOperation start];
    
    // test2
//    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"===blockOperation=== current thread:%@", [NSThread currentThread]);// 没有追加task main
//    }];
//    // 如果这个操作中的任务数量大于1,那么会开子线程并发执行任务，并且追加的任务不一定就是子线程,也有可能是主线程 乱序执行
//    [blockOperation addExecutionBlock:^{
//        NSLog(@"===blockOperation1=== current thread:%@", [NSThread currentThread]);//
//    }];
//    [blockOperation addExecutionBlock:^{
//        NSLog(@"===blockOperation2=== current thread:%@", [NSThread currentThread]);//
//    }];
//    [blockOperation start];
    
    // test3
//    MyOperation *myOperation = [[MyOperation alloc] init];
//    [myOperation start];
    
    // test4
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 最大并发数是队列在同一时间中最多有多少个任务可以执行
    // static const NSInteger NSOperationQueueDefaultMaxConcurrentOperationCount = -1;默认是-1
    /**
     maxConcurrentOperationCount >1 那么就是并发队列
     maxConcurrentOperationCount == 1 那就是串行队列
     maxConcurrentOperationCount == 0  不会执行任务
     maxConcurrentOperationCount == -1 特殊意义 最大值 表示不受限制
     */
    // MARK: ######
    // 不设置使用默认: 创建的队列中的任务默认是异步执行的 任务都是并发乱序执行的
    // 设置1: 124536 创建了多个线程，顺序执行
    queue.maxConcurrentOperationCount = 1;
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1#----%@",[NSThread currentThread]);
    }];
    op1.name = @"op1";
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2#----%@",[NSThread currentThread]);
    }];
    op2.name = @"op2";
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3#----%@",[NSThread currentThread]);
    }];
    //追加任务
    [op2 addExecutionBlock:^{
        NSLog(@"4#----%@",[NSThread currentThread]);
    }];
    [op2 addExecutionBlock:^{
        NSLog(@"5#----%@",[NSThread currentThread]);
    }];
    [op1 addObserver:self forKeyPath:@"cancelled" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [op1 addObserver:self forKeyPath:@"finished" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [op1 addObserver:self forKeyPath:@"executing" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [op1 addObserver:self forKeyPath:@"ready" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [op2 addObserver:self forKeyPath:@"ready" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    // YES代表暂停队列，NO代表恢复队列
    [queue setSuspended:YES];// 我认为适用于串行队列
    
    [queue addOperationWithBlock:^{
        NSLog(@"6#----%@",[NSThread currentThread]);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"###dispatch_after###");
        [queue setSuspended:NO];
    });
    /**
     queue.maxConcurrentOperationCount = 1;
     串行执行任务 ！= 只开一条线程(###我的理解是，可能创建多个线程，但线程是按顺序同步执行的###) 可以开启多条线程，只不过是以线程同步的方式执行的，就像加了互斥锁，区别队列里的任务是串行执行的还是并发执行的，不是看它开了多少条线程，而是看任务的执行方式，是有序的还是无序的
     */

    
    NSLog(@"===main queue===");
}

// MARK: 自定义NSOperation
/**
 即使几个operation被cancel调用, 仍然需要手动触发isFinished的KVO. 因为当一个operation依赖其他operation的时候, 它的finished 属性会被KVO建通, 只有当它所依赖的所有的operation的isFinished被设置成YES时, 这个operation才会执行
 
 start 方法主要影响的是 isExecuting 和 isFinished
 
 SDWebImageDownloaderOperation就是自定义NSOperatoin
 */
//@interface PPOperation2()
//// 声明属性(父类虽然有, 但是最后重新声明)
//@property (assign, nonatomic, getter = isExecuting) BOOL executing;
//@property (assign, nonatomic, getter = isFinished) BOOL finished;
//@end
//
//@implementation PPOperation2
//
//// 手动合成两个实例变量 _executing, _finished, 因为父类设置成ReadOnly
//@synthesize executing = _executing;
//@synthesize finished = _finished;
//
//- (id)init {
//    self = [super init];
//    if (self) {
//        _executing = NO;
//        _finished  = NO;
//    }
//    return self;
//}
//
//- (BOOL)isConcurrent {
//    return YES;
//}
//
//// finished 和 excuting 的 setter 需要通过KVO对外通知.
//- (void)setFinished:(BOOL)finished {
//    [self willChangeValueForKey:@"isFinished"];
//    _finished = finished;
//    [self didChangeValueForKey:@"isFinished"];
//}
//
//- (void)setExecuting:(BOOL)executing {
//    [self willChangeValueForKey:@"isExecuting"];
//    _executing = executing;
//    [self didChangeValueForKey:@"isExecuting"];
//}
//
///**
// 我们这里实现控制逻辑与业务逻辑的分离.
// 在start方法执行时, 也就是具体的业务代码`main`执行之前, 我们判断isCancelled方法,如果成功执行, 我们将executing设置成YES(内部包含KVO相关内容)
// */
//-(void)start{
//    if (self.isCancelled) {
//        self.finished = YES;
//        return;
//    }
//
//    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
//    self.executing = YES;
//}
//
///**
// 具体的业务执行内容, 如果业务逻辑执行
// */
//- (void)main {
//    NSLog(@"Start executing %@, mainThread: %@, currentThread: %@", NSStringFromSelector(_cmd), [NSThread mainThread], [NSThread currentThread]);
//
//    for (int i = 0; i < 2; i++) {
//        // 在一次循环之前检查, 检查是否被取消
//        if (self.isCancelled) {
//            self.executing = NO;
//            self.finished = YES;
//            return;
//        }
//
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"业务逻辑执行---%@",[NSThread currentThread]); // 打印当前线程
//    }
//
//    // 在所有任务完成以后. 设置NSOperation状态
//    self.executing = NO;
//    self.finished = YES;
//    NSLog(@"Finish executing %@", NSStringFromSelector(_cmd));
//}
//@end

- (void)testVender
{
    // MARK: ===AFNetworking
    /**
     1.调用父类初始化方法 (1.设置默认的configuration,配置我们的session  2.设置为delegate的操作队列并发的线程数量1，也就是串行队列 [因为NSURLSession初始化的时候，他要求他的delegateQueue为serialQueue]
     3.默认response为json解析 4.设置securityPolicy为无条件信任证书https认证 5.网络状态监听 6.使用NSLock确保线程安全 7.异步的获取当前session的所有未完成的task)
     2.给baseurl添加“/”
     3.给requestSerializer、responseSerializer设置默认值
     
     2.0 用常驻线程
     3.0 用NSOperationQueue
     */
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];// 对应一个session
    /**
     1.返回一个task，然后开始网络请求(1.生成request[1.先调用AFHTTPRequestSerializer的requestWithMethod函数构建request,即通过请求序列化构建request
     2.处理request构建产生的错误 – serializationError]，2.通过request生成task[给task添加代理])
     
     调用一个串行队列来创建dataTask
     //使用session来创建一个NSURLSessionDataTask对象
     dataTask = [self.session dataTaskWithRequest:request];
     
     AFHTTPRequestSerializer使用了KVO（kvo是响应式的）
     
     request封装: 1.请求头封装 2.请求参数封装
     请求行 请求头 请求体
     request（NSMutableURLRequest)： 设置请求行 请求头 以及处理请求参数 （1.get 将参数拼接到request的url上面 2.post 将参数设置到request的httpBody）
     
     get方法默认超时时间为60秒
     
     给task添加代理
     task和delegate
     AFURLSessionManagerTaskDelegate
     AFURLSessionManagerTaskDelegate : NSObject <NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>
     
     manager->session
     manager->task.id: delegate
     delegate->(weak)manager
     
     为task设置关联的delegate
     //将delegate存入字典，以taskid作为key，说明每个task都有各自的代理
     self.mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)] = delegate;
     
     //设置这两个NSProgress对应的cancel、pause和resume这三个状态，正好对应session task的cancel、suspend和resume三个状态
     
     typedef NS_ENUM(NSInteger, NSURLSessionTaskState) {
         NSURLSessionTaskStateRunning = 0,                     The task is currently being serviced by the session
         NSURLSessionTaskStateSuspended = 1,
         NSURLSessionTaskStateCanceling = 2,                   The task has been told to cancel.  The session will receive a URLSession:task:didCompleteWithError: message.
         NSURLSessionTaskStateCompleted = 3,                  The task has completed and the session will receive no more delegate notifications
     }
     
     通过内部类_AFURLSessionTaskSwizzling，方法交换task的resume 发送DidResume的通知 （发送task的状态）
     */
    [manager GET:@"" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    /**
     序列化:
     @protocol AFURLRequestSerialization <NSObject, NSSecureCoding(安全归档，即存储，对象持久化), NSCopying>
     
     Post: 多表单
     content-type: multipart/form-data: 多表单 eg:图片上传
     [manager POST:@"http://114.215.186.169:9002/api/demo/test/file" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {}
     
     ##用POST构建request，request为AFStreamingMultipartFormData的request，再用request构建NSURLSessionDataTask##
     @property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;
     requestSerializer构建request，用request构建AFStreamingMultipartFormData
     AFStreamingMultipartFormData有NSMutableURLRequest *request属性
     
     multipart/form-data数据封装:
     传的参数封装为body
     AFStreamingMultipartFormData:的属性
     boundary//分隔符
     +
     @interface AFMultipartBodyStream : NSInputStream <NSStreamDelegate>
     的属性HTTPBodyParts
     
     params->AFQueryStringPair->NSData->mutableHeaders->(1.key-value  Content-Disposition: form-data; name="" 2.AFHTTPBodyPart 被添加到AFMultipartBodyStream中的HTTPBodyParts数组)
     
     [self.request setHTTPBodyStream:self.bodyStream];
     [self.request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary] forHTTPHeaderField:@"Content-Type"];
     [self.request setValue:[NSString stringWithFormat:@"%llu", [self.bodyStream contentLength]] forHTTPHeaderField:@"Content-Length"];
     
     拼接\r\n
     '\r' 回车，回到当前行的行首，而不会换到下一行，如果接着输出的话，本行以前的内容会被逐一覆盖；
     '\n' 换行，换到当前位置的下一行，而不会回到行首
     
     task resume会调用stream的read   然后建立连接到服务器
     
     
     @protocol AFURLResponseSerialization <NSObject, NSSecureCoding, NSCopying>:
     @interface AFHTTPResponseSerializer : NSObject <AFURLResponseSerialization>
     请求成功 需要把response序列化 （因为耗时，所以开启异步线程）
     1.先验证内容有效性，看能不能解析数据
     2.验证状态码
     3.解析
     
     常见错误码
     -1011 ，-1016
     */
    
    /**
     HTTP:
     
     v1.1: keep-alive 被多个请求复用   缺点：客户端可以同时发送多个，服务器只能依次响应（即要等前一个返回给客户端才能响应下一个）
     v2.0: 特性: 多工（同时响应多个请求，防止阻塞），头信息压缩，服务器自推送（只要建立连接，服务器能直接给客户端发送消息）
     现在用的还是v1.1
     
     不验证身份： 会导致DOS攻击  直接通过野蛮手段残忍地耗尽被攻击对象的资源，目的是让目标计算机或网络无法提供正常的服务或资源访问，使目标系统服务系统停止响应甚至崩溃
     
     http缺点:
     通讯使用明文（不加密），内容可能会被窃听
     不验证通讯方的身份，有可能遭遇伪装
     无法验证报文的完整性，可能遭篡改
     
     
     AFSecurityPolicy:
     自签证书存在项目本地：
     AFSSLPinningModeNone: 不做本地证书验证，直接从客户端系统中的受信任颁发机构 CA 列表中去验证
     AFSSLPinningModeCertificate: 会对服务器返回的证书同本地证书全部进行校验，通过则通过，否则不通过
     
     // 从cerSet证书集合取出公钥（Public Key）集合，打断点po publicKey<SecKeyRef>
     AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];// 根据SSL验证模式和指定的证书集合创建实例
     security.allowInvalidCertificates = YES;
     security.validatesDomainName = NO;
     如果想要实现自签名的HTTPS访问成功，必须设置pinnedCertificates，且不能使用defaultPolicy
     如果不需要验证domain，就使用默认的BasicX509验证策略
     
     设置证书集合 如果是默认的 通过[self defaultPinnedCertificates]得到了
     
     单向认证：客户端认证服务端返回的信息（证书），认证服务器的合法性
     只需要验证服务端证书是否安全（即https的单向认证，这是AF默认处理的认证方式）
     
     - (void)URLSession:(NSURLSession *)session
     didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
      completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
     */
    
    /**
     AFNetworkReachabilityManager: 通过block回调和通知返回状态
     底层用的系统的SC（SystemConfiguration）框架
     SCNetworkReachabilityRef
     
     添加到runloop就会一直被持有，不会被释放
     flag->status
     
     
     if (__IPHONE_10_0) {
         [self cellularData];
     }else{
         [self startMonitoringNetwork];
     }
     如果选择了不允许网络，每次进app都无法请求网络，需要网络权限监控，让用户开启权限
     网络权限监控
     - (void)cellularData{
         
         CTCellularData *cellularData = [[CTCellularData alloc] init];
         
         cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
             
             switch (state) {
                 case kCTCellularDataRestrictedStateUnknown:
                     NSLog(@"不明错误.....");
                     break;
                 case kCTCellularDataRestricted:
                     NSLog(@"没有授权....");
                     // 默认没有授权 ... 发起设置弹框
                     break;
                 case kCTCellularDataNotRestricted:
                     NSLog(@"授权了////");
                     [self startMonitoringNetwork];
                     break;
                 default:
                     break;
             }
         };
     }
     
     图片缓存:
     @interface AFAutoPurgingImageCache : NSObject <AFImageRequestCache>
     缓存容量100M 零界点60M
     
     创建了同步队列，实际创建的是并发队列，它使用了栅栏函数来同步并发队列
     cachedImages 用了可变字典（内存缓存)
     @property (nonatomic, strong) NSMutableDictionary <NSString* , AFCachedImage*> *cachedImages;
     key: url
     
     addImage: withIdentity: 功能包含增加图片+自动清理
     使用了dispatch_barrier_async
     
     self.currentMemoryUsage > self.memoryCapacity 需要清理内存
     根据lastAccessDate排序图片
     如果currentMemoryUsage=102 102-60=42 需要清理42（42是个大约数，不一定=42）
     当清理的大小>=42则跳出循环，停止清理
     */
    
    /**
     图片下载:
     @interface AFImageDownloader : NSObject
     所有UIImageView对应一个单例的AFImageDownloader，其实UIBUtton也对应单例的AFImageDownloader，所有分类里的UI都是
     
     通过下载获得凭证receipt，可用他来取消下载
     
     downloader有imageCache这个属性和@property (nonatomic, strong) NSMutableDictionary *mergedTasks;
     mergedTasks存储AFImageDownloaderMergedTask
     AFImageDownloaderMergedTask有属性@property (nonatomic, strong) NSMutableArray <AFImageDownloaderResponseHandler*> *responseHandlers;
     同一个图片，不同地方下载，只需要下载一次，复合操作类AFImageDownloaderMergedTask（去重类，避免重复下载）来处理
     
     dict缓存和NSCache不是一个概念
     
     配置NSURLCache进行磁盘缓存
     NSURLCache缓存了从服务器返回的NSURLResponse对象
     configuration.URLCache
     
     downloader的session的configure的 NSURLCache设置为
     memory:20M disk:150M
     
     自定义NSOperation
     @property (nonatomic, readwrite, getter=isExecuting) BOOL executing;
     @property (nonatomic, readwrite, getter=isFinished) BOOL finished;
     @property (nonatomic, readwrite, getter=isCancelled) BOOL cancelled;
     // 因为父类的属性是Readonly的，重载时如果需要setter的话则需要手动合成。
     @synthesize executing = _executing;
     @synthesize finished = _finished;
     @synthesize cancelled = _cancelled;
     */
    
    /**
     系统缓存NSURLCache：
     该类通过将NSURLRequest对象映射到NSCachedURLResponse来实现对URL加载请求的响应缓存
     该类同时提供了复合内存和磁盘缓存，而且允许自定义内存和磁盘缓存的大小
     该类还允许自定义缓存的存储路径
     在iOS 操作系统中，如果系统的磁盘运行空间不足时，系统可能会清理磁盘缓存，当时这一清理过程只会发生在应用没有运行的时候,所以可以理解为应用运行过程中，系统不会进行磁盘清理.
     
     系统也会自动生成一个全局的NSURLCache对象进行网络请求的缓存.默认内存缓存为512KB，磁盘缓存为10MB.
     NSURLCache *cache = [NSURLCache sharedURLCache];
     
     手动设置全局请求缓存
     当diskPath为nil时会使用系统默认的路径.
         NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:20 * 1000 * 1000 diskCapacity:50 * 1000 * 1000 diskPath:@"com.supportHongKong.police"];
         [NSURLCache setSharedURLCache:cache];
     
     为某一类定义独立的请求缓存
     [[NSURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                              diskCapacity:150 * 1024 * 1024
                                                  diskPath:@"com.alamofire.imagedownloader"];
     这样AFImageDownloader中所有的请求缓存都会保存在自定义的diskPath中，可以进行响应的操作而不会对全局的缓存产生影响
     
     
     NSURLCache缓存获取
     - (nullable NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request;
     在NSURLCache中是通过request来获取缓存的(实质还是资源链接url字符串)，这样我们就可以用获取到NSCachedURLResponse对象，进而获取到缓存的二进制数据
     
     
     NSURLCache的磁盘存储路径: 使用默认路径：如果没有显式定义NSURLCache或者自定义时没有自定义有效diskPath，系统会默认将缓存保存保存在NSHomeDirectory()目录library/Caches/{bundleid}中；
     使用自定义路径：如果显式定义了有效的diskPath，系统就会把请求缓存保存在NSHomeDirectory()目录library/Caches/{bundleid}/{diskPath}中
     
     会发现有一个Cache.db文件和fsCachedData的文件夹，证明缓存是以数据库的方式进行了保存
     用DB Browser查看: http://www.sqlitebrowser.org/dl/
     
     request_object和response_object对应的类型都是BLOB类型
     将二进制转为plist
     plutil -convert binary1 -o request.plist request_object.bin
     
     在cfurl_cache_response中根据request_key(请求接口，即url)查到entry_ID；
     在cfurl_cache_blob_data根据entry_ID找到response_object；
     在cfurl_cache_receiver_data中根据entry_ID找到receiver_data
     
     拼接NSCacheURLResponse对象,至此我们就获取到了NSURLCache中的缓存
     NSURLResponse *urlResponse = [[NSURLResponse alloc] initWithURL:request.URL MIMEType:[[request allHTTPHeaderFields] objectForKey:@"Accept"] expectedContentLength:[(NSData *)response_object length] textEncodingName:nil];
      
     NSCachedURLResponse *cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:urlResponse data:receiver_data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
     
     
     使用NSURLCache好处:
     最大的好处莫过于你完全不用管理内存和磁盘上的缓存，只需要设置磁盘缓存的最大值即可，至于何时清理如何清理，完全不用去考虑；
     系统实现的请求缓存策略会充分考虑系统的开销，存取的效率等因素，相对来讲，安全性和效率都会比较有保证.
     
     使用NSURLCache缺点:

     最明显的优势也往往会成为缺点，因为可以干预的操作就会变少，不能按照自己的需要去实现个性化的清理等操作；
     内存缓存使用的是缓存的二进制数据，使用时每次都需要进行重新转化成指定的对象，带来不必要的系统开销.
     
     沙盒tmp:
     里边放置的是不需要一直持有的数据.你应该在不需要的时候删除它.当然,系统也可能会在你的app不运行时删除掉它.
     这个文件中的东西不会备份在iTunes和iCloud
     */
}

// MARK: kvo for NSOperation
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"===keyPath = %@ name = %@ NewKey = %ld OldKey = %ld===", keyPath, ((NSOperation *)object).name, [change[NSKeyValueChangeNewKey] boolValue], [change[NSKeyValueChangeOldKey] boolValue]);
}

- (void)dependencyTest{
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSOperationQueue *queue2 = [[NSOperationQueue alloc]init];
    
    //2.封装操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1---%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2---%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3---%@",[NSThread currentThread]);
    }];
    
    //操作监听
    op3.completionBlock = ^{
        NSLog(@"3已经执行完了------%@",[NSThread currentThread]);
    };
    
    //添加操作依赖
    [op1 addDependency:op3]; //跨队列依赖,op1属于queue，op3属于queue2
    [op2 addDependency:op1];
    
    //添加操作到队列
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue2 addOperation:op3];
    
    /**
     3---<NSThread: 0x60000276c400>{number = 3, name = (null)}
     1---<NSThread: 0x60000276c400>{number = 3, name = (null)}
     3已经执行完了------<NSThread: 0x60000276c900>{number = 4, name = (null)}
     2---<NSThread: 0x60000276c400>{number = 3, name = (null)}
     
     由依赖可知优先级：op3 > op1 > op2，
     监听的操作不一定和被监听的操作同一个线程，都是异步的，只是op3执行结束，肯定会执行监听的操作
     */
}

/**
 NSOperation实现线程间通信
 设置操作依赖来实现线程间通信
 使用场景：在子线程下载两张图片，下载完毕后绘制在UIImageView中
 
 开启两个异步的子线程来下载图片，添加操作依赖，使2张图片下载结束后，绘制图片。回到主线程显示图片
 */
- (void)downloadImage{
    
    __block UIImage *image1;
    __block UIImage *image2;
    
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    //2.封装操作下载图片1
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSURL *url = [NSURL URLWithString:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1907928680,2774802011&fm=26&gp=0.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        //拿到图片数据
        image1 = [UIImage imageWithData:data];
    }];
    
    
    //3.封装操作下载图片2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1412439743,1735171648&fm=26&gp=0.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        //拿到图片数据
        image2 = [UIImage imageWithData:data];
    }];
    
    //4.合成图片
    NSBlockOperation *drawOp = [NSBlockOperation blockOperationWithBlock:^{
        
        //4.1 开启图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        
        //4.2 画image1
        [image1 drawInRect:CGRectMake(0, 0, 200, 100)];
        
        //4.3 画image2
        [image2 drawInRect:CGRectMake(0, 100, 200, 100)];
        
        //4.4 根据图形上下文拿到图片数据
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //        NSLog(@"%@",image);
        
        //4.5 关闭图形上下文
        UIGraphicsEndImageContext();
        
        //7.回到主线程刷新UI
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//            self.imageView.image = image;
            NSLog(@"刷新UI---%@",[NSThread currentThread]);
        }];
        
    }];
    
    //5.设置操作依赖
    [drawOp addDependency:op1];
    [drawOp addDependency:op2];
    
    //6.添加操作到队列中执行
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:drawOp];
}

// 开始
- (IBAction)startBtnClick:(id)sender{
    //1.创建队列
    //默认是并发队列
    self.myQueue = [[NSOperationQueue alloc]init];
    
    //2.设置最大并发数量 maxConcurrentOperationCount
    self.myQueue.maxConcurrentOperationCount = 1;
    
    MyOperation *op = [[MyOperation alloc]init];
    
    //4.添加到队列
    [self.myQueue addOperation:op];
}
// 暂停
- (IBAction)suspendBtnClick:(id)sender{
    //设置暂停和恢复
    //suspended设置为YES表示暂停，suspended设置为NO表示恢复
    //暂停表示不继续执行队列中的下一个任务，暂停操作是可以恢复的
    /*
     队列中的任务也是有状态的:已经执行完毕的 | 正在执行 | 排队等待状态
     */
    //不能暂停当前正在处于执行状态的任务
    [self.myQueue setSuspended:YES];
}
// 继续
- (IBAction)goOnBtnClick:(id)sender{
    //继续执行
    [self.myQueue setSuspended:NO];
}
// 取消
- (IBAction)cancelBtnClick:(id)sender{
    //取消队列里面的所有操作
    //取消之后，当前正在执行的操作的下一个操作将不再执行，而且永远不再执行，就像后面的所有任务都从队列里面移除了一样
    //取消操作是不可以恢复的
    //该方法内部调用了所有操作的cancel方法
    [self.myQueue cancelAllOperations];
}

- (void)invoTask {
    NSLog(@"===invoTask=== current thread:%@", [NSThread currentThread]);// main
}

- (void)tests {
    NSLog(@"=========performSelector: onThread");
}

- (void)asyncTaskWithID:(NSInteger)ID
{
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    _count++;
    sleep(1);
    NSLog(@"执行任务:%zd ID = %ld %@",_count, ID, [NSThread currentThread]);
    dispatch_semaphore_signal(_semaphore);
}

- (void)gcdBlockCancel{
    
    dispatch_queue_t queue = dispatch_queue_create("com.gcdtest.www", DISPATCH_QUEUE_SERIAL);
    
    dispatch_block_t block1 = dispatch_block_create(0, ^{
        sleep(5);
        NSLog(@"block1 %@",[NSThread currentThread]);
    });
    
    dispatch_block_t block2 = dispatch_block_create(0, ^{
        sleep(3);
        NSLog(@"block2 %@",[NSThread currentThread]);
    });
    
    dispatch_block_t block3 = dispatch_block_create(0, ^{
        NSLog(@"block3 %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, block1);
    dispatch_async(queue, block2);
    dispatch_async(queue, block3);
    dispatch_block_cancel(block3);
}

- (void)gcdCancel{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block BOOL isCancel = NO;
    
    dispatch_async(queue, ^{
        NSLog(@"任务001 %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务002 %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务003 %@",[NSThread currentThread]);
        isCancel = YES;
    });
    
    dispatch_async(queue, ^{
        // 模拟：线程等待3秒，确保任务003完成 isCancel＝YES
        sleep(3);
        if(isCancel){
            NSLog(@"任务004已被取消 %@",[NSThread currentThread]);
        }else{
            NSLog(@"任务004 %@",[NSThread currentThread]);
        }
    });
}



@end

// MARK: 多线程
/**
 线程就是实现异步的一个方式
 异步是让调用方法的主线程不需要同步等待另一线程的完成，从而可以让主线程干其它的事情
 异步是当一个调用请求发送给被调用者,而调用者不用等待其结果的返回而可以做其它的事情
 
 MARK: ---1.进程、线程
 进程:进行中的程序
 进程是程序在计算机上的一次执行活动。当你运行一个程序，你就启动了一个进程.程序是死的(静态的)，进程是活的(动态的)
 进程可以分为系统进程和用户进程
 它是操作系统分配资源的基本单元
 是指在系统中正在运行的一个应用程序
 每个进程之间是独立的，每个进程均运行在其专用且受保护的内存空间内，拥有独立运行所需的全部资源
 
 多进程:
 凡是用于完成操作系统的各种功能的进程就是系统进程，它们就是处于运行状态下的操作系统本身;所有由用户启动的进程都是用户进程。进程是操作系统进行资源分配的单位
 在同一个时间里，同一个计算机系统中如果允许两个或两个以上的进程处于运行状态，这便是多进程
 
 线程:
 一个进程要想执行任务,必须至少有一条线程.应用程序启动的时候，系统会默认开启一条线程,也就是主线程
 
 多线程:
 同一时间，CPU只能处理1条线程，只有1条线程在执行。多线程并发执行，其实是CPU快速地在多条线程之间调度（切换）。如果CPU调度线程的时间足够快，就造成了多线程并发执行的假象
 如果线程非常非常多，CPU会在N多线程之间调度，消耗大量的CPU资源，每条线程被调度执行的频次会降低（线程的执行效率降低）
 
 多线程的优点:
 能适当提高程序的执行效率
 能适当提高资源利用率（CPU、内存利用率）
 多线程的缺点:
 开启线程需要占用一定的内存空间（默认情况下，主线程占用1M，子线程占用512KB），如果开启大量的线程，会占用大量的内存空间，降低程序的性能
 线程越多，CPU在调度线程上的开销就越大
 程序设计更加复杂：比如线程之间的通信、多线程的数据共享
 
 线程是进程的执行单元，进程的所有任务都在线程中执行
 线程是 CPU 分配资源和调度的最小单位
 一个进程中可有多个线程,但至少要有一条线程
 同一个进程内的线程共享进程资源
 
 MARK: ---2.GCD---队列
 队列是用来组织任务的，将任务加到队列中，任务会按照加入到队列中先后顺序依次执行，如果是同步队列，会在当前线程中执行，如果是异步队列，则操作系统会根据系统资源去创建新的线程去处理队列中的任务
 
 串行队列:
 按照FIFO原则，顺序执行,先加入队列中的任务先执行
 一个任务一任务的顺序执行，只有等到队列中上一个任务完成，才能执行下一个任务
 并行队列:
 任务是按照加入到队列中的顺序开始执行，但任务完成时的顺序是不确定的
 
 队列和线程的关系：
 在一个线程内可能有多个队列，这些队列可能是串行的或者是并行的，按照同步或者异步的方式工作
 异步的，则会开启新的线程工作
 同步的，会在当前线程内工作，不会创建新的线程
 
 并行同步队列，不会创建新的线程而且会是顺序执行相当于串行同步队列
 
 主线程和主队列的关系：
 主队列是主线中的一个串行队列
 所有的和UI的操作(刷新或者点击按钮)都必须在主线程中的主队列中去执行
 
 ###如果在主线程中创建自定义队列(串行或者并行均可),在这个队列中执行同步任务，同样可以更新UI操作，主队列中可以更新UI，自定义队列也可以更新UI，但自定义队列的更新UI的前提是在主线程中执行同步任务###
 ##主线程并行队列同步执行,任务会在主线中执行，不会创建新的线程，并且是顺序执行的
 ##主线程并行队列异步执行,任务会异步无顺序的执行，并且创建新的多个线程
 ##主线程串行队列同步执行,主线程中 顺序执行 不会创建新的线程
 ##主线程串行队列异步执行,只创建一个线程 顺序执行
 ##主线程 主队列 同步执行,会导致死锁，程序卡死
 ##主线程主队列异步执行,不会创建新的线程，但是却是异步的，先执行完队列中已经添加的任务，然后再执行队列中添加的 自定义任务
 
 主队列的任务一定在主线程执行，非主队列的任务也可以在主线程里执行
 
 而GCD共有三种队列类型：
 main queue：
 通过dispatch_get_main_queue()获得，这是一个与主线程相关的串行队列。

 global queue：
 全局队列是并发队列，由整个进程共享。存在着高、中、低三种优先级的全局队列。调用dispath_get_global_queue并传入优先级来访问队列。

 自定义队列：通过函数dispatch_queue_create创建的队列
 
 MARK: ---3.任务、队列
 任务就是要执行操作，也就是在线程中执行的那段代码。在 GCD 中是放在 block 中的
 执行任务有两种方式：同步执行（sync）和异步执行（async）
 
 同步(Sync)：
 同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，直到队列里面的任务完成之后再继续执行，即会阻塞线程。
 只能在当前线程中执行任务(是当前线程，不一定是主线程)，不具备开启新线程的能力

 异步(Async)：
 线程会立即返回，无需等待就会继续执行下面的任务，不阻塞当前线程。可以在新的线程中执行任务，具备开启新线程的能力(并不一定开启新线程)。如果不是添加到主队列上，异步会在子线程中执行任务
 
 队列：
 队列（Dispatch Queue）：这里的队列指执行任务的等待队列，即用来存放任务的队列。队列是一种特殊的线性表，采用 FIFO（先进先出）的原则，即新任务总是被插入到队列的末尾，而读取任务的时候总是从队列的头部开始读取。每读取一个任务，则从队列中释放一个任务
 在 GCD 中有两种队列：串行队列和并发队列。两者都符合 FIFO（先进先出）的原则。两者的主要区别是：执行顺序不同，以及开启线程数不同。
 
 串行队列（Serial Dispatch Queue）：
 同一时间内，队列中只能执行一个任务，只有当前的任务执行完成之后，才能执行下一个任务。（只开启一个线程，一个任务执行完毕后，再执行下一个任务）。主队列是主线程上的一个串行队列,是系统自动为我们创建的

 并发队列（Concurrent Dispatch Queue）：
 同时允许多个任务并发执行。（可以开启多个线程，并且同时执行任务）。###并发队列的并发功能只有在异步（dispatch_async）函数下才有效###
 
 MARK: ---4.NSOperationQueue的优点
 NSOperation、NSOperationQueue 是基于 GCD 更高一层的封装，完全面向对象.更简单易用、代码可读性也更高
 1.可以添加任务依赖，方便控制执行顺序
 2.可以设定操作执行的优先级
 3.任务执行状态控制:isReady,isExecuting,isFinished,isCancelled
 系统通过KVO的方式移除isFinished==YES的NSOperation
 4.可以设置最大并发量
 
 MARK: ---5.NSOperation和NSOperationQueue
 操作（Operation）:
 要执行的操作，就是你在线程中执行的那段代码。在 GCD 中是放在 block 中的
 在 NSOperation 中，使用 NSOperation 子类 NSInvocationOperation、NSBlockOperation，或者自定义子类来封装操作
 
 操作队列（Operation Queues）：
 用来存放操作的队列
 NSOperationQueue 对于添加到队列中的操作，首先进入准备就绪的状态（就绪状态取决于操作之间的依赖关系）
 然后进入就绪状态的操作的开始执行顺序（非结束执行顺序）由操作之间相对的优先级决定（优先级是操作对象自身的属性）

 操作队列通过设置最大并发操作数（maxConcurrentOperationCount）来控制并发、串行
 
 NSOperationQueue 为我们提供了两种不同类型的队列：主队列和自定义队列。主队列运行在主线程之上，而自定义队列在后台执行
 
 MARK: ---6.延时函数(dispatch_after)
 dispatch_after能让我们添加进队列的任务延时执行，该函数并不是在指定时间后执行处理，而只是在指定时间追加处理到dispatch_queue
 
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 
 });
 由于其内部使用的是dispatch_time_t管理时间，而不是NSTimer。
 所以如果在子线程中调用，相比performSelector:afterDelay,不用关心runloop是否开启
 
 MARK: ---7.死锁
 ###死锁就是队列引起的循环等待###
 
 比较常见的死锁例子:主队列同步
 dispatch_sync(dispatch_get_main_queue(), ^{
     NSLog(@"deallock");
 });
 ###在主线程中运用主队列同步，也就是把任务放到了主线程的队列中###
 同步对于任务是立刻执行的，那么当把任务放进主队列时，它就会立马执行,只有执行完这个任务，viewDidLoad才会继续向下执行。
 而viewDidLoad和任务都是在主队列上的，由于队列的先进先出原则，任务又需等待viewDidLoad执行完毕后才能继续执行，viewDidLoad和这个任务就形成了相互循环等待，就造成了死锁。
 想避免这种死锁，可以将同步改成异步dispatch_async,或者将dispatch_get_main_queue换成其他串行或并行队列，都可以解决
 
 也会造成死锁：
 dispatch_queue_t serialQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
dispatch_async(serialQueue, ^{
     dispatch_sync(serialQueue, ^{
         NSLog(@"deadlock");
     });
 });
 外面的函数无论是同步还是异步都会造成死锁
 这是因为里面的任务和外面的任务都在同一个serialQueue队列内，又是同步，这就和上边主队列同步的例子一样造成了死锁
 解决方法将里面的同步改成异步dispatch_async,或者将serialQueue换成其他串行或并行队列
 
 MARK: ---8.GCD任务执行顺序
 (1)串行队列先异步后同步
 dispatch_queue_t serialQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
 NSLog(@"1");
 dispatch_async(serialQueue, ^{
      NSLog(@"2");
 });
 NSLog(@"3");
 dispatch_sync(serialQueue, ^{
     NSLog(@"4");
 });
 NSLog(@"5");
 
 肯定是13245
 首先先打印1
 接下来将任务2其添加至串行队列上，由于任务2是异步，不会阻塞线程，继续向下执行，打印3
 然后是任务4,将任务4添加至串行队列上，因为任务4和任务2在同一串行队列，根据队列先进先出原则，任务4必须等任务2执行后才能执行，又因为任务4是同步任务，会阻塞线程，只有执行完任务4才能继续向下执行打印5

 这里的任务4在主线程中执行，而任务2在子线程中执行
 如果任务4是添加到另一个串行队列或者并行队列，则任务2和任务4无序执行(可以添加多个任务看效果)
 
 MARK: ---9.iOS中的多线程
 NSThread、NSoperationQueue、GCD
 
 NSThread：轻量级别的多线程技术
 是我们自己手动开辟的子线程，如果使用的是初始化方式就需要我们自己启动，如果使用的是构造器方式它就会自动启动。只要是我们手动开辟的线程，都需要我们自己管理该线程，不只是启动，还有该线程使用完毕后的资源回收
 NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(testThread:) object:@"我是参数"];
 // 当使用初始化方法出来的主线程需要start启动
 [thread start];
 // 可以为开辟的子线程起名字
 thread.name = @"NSThread线程";
 // 调整Thread的权限 线程权限的范围值为0 ~ 1 。越大权限越高，先执行的概率就会越高，由于是概率，所以并不能很准确的的实现我们想要的执行顺序，默认值是0.5
 thread.threadPriority = 1;
 // 取消当前已经启动的线程
 [thread cancel];
 
 // 通过遍历构造器开辟子线程
 [NSThread detachNewThreadSelector:@selector(testThread:) toTarget:self withObject:@"构造器方式"];
 
 GCD && NSOprationQueue:
 GCD是面向底层的C语言的API，NSOpertaionQueue用GCD构建封装的，是GCD的高级抽象
 GCD只支持FIFO的队列，而NSOperationQueue可以通过设置最大并发数，设置优先级，添加依赖关系等调整执行顺序
 NSOperationQueue甚至可以跨队列设置依赖关系，但是GCD只能通过设置串行队列，或者在队列内添加barrier(dispatch_barrier_async)任务，才能控制执行顺序
 NSOperationQueue因为面向对象，所以支持KVO，可以监测operation是否正在执行（isExecuted）、是否结束（isFinished）、是否取消（isCanceld）
 
 如果考虑异步操作之间的事务性，顺序行，依赖关系，比如多线程并发下载，GCD需要自己写更多的代码来实现，而NSOperationQueue已经内建了这些支持
 
 不论是GCD还是NSOperationQueue，我们接触的都是任务和队列，都没有直接接触到线程.线程管理也的确不需要我们操心
 
 MARK: ---10.dispatch_barrier_async
 (1)用GCD实现多读单写
 可以多个读者同时读取数据，而在读的时候，不能取写入数据
 并且，在写的过程中，不能有其他写者去写。即读者之间是并发的，写者与读者或其他写者是互斥的
 
 - (id)readDataForKey:(NSString *)key
 {
     __block id result;
     dispatch_sync(_concurrentQueue, ^{
         result = [self valueForKey:key];
     });
     return result;
 }

 - (void)writeData:(id)data forKey:(NSString *)key
 {
     dispatch_barrier_async(_concurrentQueue, ^{
         [self setValue:data forKey:key];
     });
 }
 
 MARK: ---11.dispatch_group_async
 在n个耗时并发任务都完成后，再去执行接下来的任务。比如，在n个网络请求完成后去刷新UI页面
 
 dispatch_queue_t concurrentQueue = dispatch_queue_create("test1", DISPATCH_QUEUE_CONCURRENT);
 dispatch_group_t group = dispatch_group_create();
 for (NSInteger i = 0; i < 10; i++) {
     dispatch_group_async(group, concurrentQueue, ^{
         sleep(1);
         NSLog(@"%zd:网络请求 %@",i, [NSThread currentThread]);// child thread
     });
 }
 
 dispatch_group_notify(group, dispatch_get_main_queue(), ^{
     NSLog(@"刷新页面 %@", [NSThread currentThread]);// main
 });
 
 MARK: ---12.Dispatch Semaphore
 GCD 中的信号量是指 Dispatch Semaphore，是持有计数的信号
 
 Dispatch Semaphore 提供了三个函数:
 1.dispatch_semaphore_create：创建一个Semaphore并初始化信号的总量
 2.dispatch_semaphore_signal：发送一个信号，让信号总量加1
 3.dispatch_semaphore_wait：可以使总信号量减1，当信号总量为0时就会一直等待（阻塞所在线程），否则就可以正常执行。

 在实际开发中主要用于：
 保持线程同步，将异步执行任务转换为同步执行任务
 保证线程安全，为线程加锁
 
 保持线程同步：
 dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
 __block NSInteger number = 0;
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     sleep(3.0);
     number = 100;
     NSLog(@"dispatch_semaphore_signal");
     dispatch_semaphore_signal(semaphore);
 });
 
 NSLog(@"before dispatch_semaphore_wait");
 dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
 NSLog(@"semaphore---end,number = %zd",number);
 
 dispatch_semaphore_wait加锁阻塞了当前线程，dispatch_semaphore_signal解锁后当前线程继续执行
 
 保证线程安全，为线程加锁：
 在线程安全中可以将dispatch_semaphore_wait看作加锁
 而dispatch_semaphore_signal看作解锁
 
 首先创建全局变量_semaphore = dispatch_semaphore_create(1);

 - (void)asyncTask
 {
     dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
     count++;
     sleep(1);
     NSLog(@"执行任务:%zd",count);
     dispatch_semaphore_signal(_semaphore);
 }
 
for (NSInteger i = 0; i < 100; i++) {
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
         [self asyncTask];
     });
 }
 
 MARK: ---13.dispatch_once实现单例
 + (instancetype)shareInstance {
     static dispatch_once_t onceToken;
     static id instance = nil;
     dispatch_once(&onceToken, ^{
         instance = [[self alloc] init];
     });
     return instance;
 }
 
 MARK: ---14.取消GCD任务
 NSOperation那样可以调用 -(void)cancel 取消一个操作的执行（注意这里的取消只是针对未执行的任务设置finished ＝ YES，如果这个操作已经在执行了，那么我们只能等其操作完成。当我们调用cancel方法的时候，他只是将isCancelled设置为YES）

 (1)dispatch_block_cancel
 iOS8之后可以调用dispatch_block_cancel来取消（需要注意必须用dispatch_block_create创建dispatch_block_t）
 dispatch_block_cancel也只能取消尚未执行的任务，对正在执行的任务不起作用
 (2)定义外部变量，用于标记block是否需要取消
 
 MARK: ---15.多线程的 并行 和 并发 有什么区别
 并行：充分利用计算机的多核，在多个线程上同步进行
 并发：在一条线程上通过快速切换，让人感觉在同步进行
 
 MARK: ---16.NSThread+runloop实现常驻线程
 由于每次开辟子线程都会消耗cpu，在需要频繁使用子线程的情况下，频繁开辟子线程会消耗大量的cpu,
 而且创建线程都是任务执行完成之后也就释放了，不能再次利用，那么如何创建一个线程可以让它可以再次工作呢？也就是创建一个常驻线程

 MARK: ---17.自旋锁与互斥锁
 自旋锁：
 是一种用于保护多线程共享资源的锁，与一般互斥锁（mutex）不同之处在于当自旋锁尝试获取锁时以忙等待（busy waiting）的形式不断地循环检查锁是否可用。当上一个线程的任务没有执行完毕的时候（被锁住），那么下一个线程会一直等待（不会睡眠），当上一个线程的任务执行完毕，下一个线程会立即执行。
 在多CPU的环境中，对持有锁较短的程序来说，使用自旋锁代替一般的互斥锁往往能够提高程序的性能

 互斥锁：
 当上一个线程的任务没有执行完毕的时候（被锁住），那么下一个线程会进入睡眠状态等待任务执行完毕，当上一个线程的任务执行完毕，下一个线程会自动唤醒然后执行任务
 
 自旋锁会忙等: 所谓忙等，即在访问被锁资源时，调用者线程不会休眠，而是不停循环在那里，直到被锁资源释放锁。
 　　互斥锁会休眠: 所谓休眠，即在访问被锁资源时，调用者线程会休眠，此时cpu可以调度其他线程工作。直到被锁资源释放锁。此时会唤醒休眠线程

 自旋锁的优点在于，因为自旋锁不会引起调用者睡眠，所以不会进行线程调度，CPU时间片轮转等耗时操作。所有如果能在很短的时间内获得锁，自旋锁的效率远高于互斥锁。
 缺点在于，自旋锁一直占用CPU，他在未获得锁的情况下，一直运行－－自旋，所以占用着CPU，如果不能在很短的时 间内获得锁，这无疑会使CPU效率降低。自旋锁不能实现递归调用
 
 自旋锁：atomic、OSSpinLock、dispatch_semaphore_t
 互斥锁：pthread_mutex、@ synchronized、NSLock、NSConditionLock 、NSCondition、NSRecursiveLock
 
 */

// MARK: 数据安全及加密
/**
 1.RSA非对称加密
 对称加密[算法]在加密和解密时使用的是同一个秘钥；而[非对称加密算法]需要两个[密钥]来进行加密和解密，这两个秘钥是[公开密钥]（public key，简称公钥）和私有密钥（private key，简称私钥）
 公开密钥与私有密钥是一对，如果用公开密钥对数据进行加密，只有用对应的私有密钥才能解密；如果用私有密钥对数据进行加密，那么只有用对应的公开密钥才能解密

 2.`SSL` 加密的过程用了哪些加密方法
 使用了 对称加密 和 非对称加密 的结合
 先使用 非对称加密 进行连接，这样做是为了避免中间人攻击秘钥被劫持，但是 非对称加密 的效率比较低。
 所以一旦建立了安全的连接之后，就可以使用轻量的 对称加密
 
 */

// MARK: UIKit
/**
 MARK: ---1.UIView与CALayer
 UIView为CALayer提供内容，负责处理触摸等事件，参与响应链
 CALayer负责显示内容
 
 MARK: ---2.为什么所有UI操作必须放在主线程
 UIKit框架不是线程安全的
 
 为什么不把UIKit框架设置为线程安全呢？
 因为线程安全需要加锁，我们都知道加锁就会消耗性能，影响处理速度，影响渲染速度，我们通常自己在写@property时都会写nonatomic来追求高性能高效率
 而UI又是最追求速度流畅，体验无顿挫感的，给UI加锁是不可能的
 
 苹果官方就强制规定所有UI操作必须在主线程中进行，避免多线程对UI进行操作，相当于人为给UIKit框架加锁，即高效高性能，又不会出现线程安全问题
 
 主线程又叫UI线程，其他所有耗时的非UI操作都要被放到子线程去进行
 
 MARK: ---3.图像显示原理
 1.CPU:输出位图
 2.GPU :图层渲染，纹理合成
 3.把结果放到帧缓冲区(frame buffer)中
 4.再由视频控制器根据vsync信号在指定时间之前去提取帧缓冲区的屏幕显示内容
 5.显示到屏幕上

 CPU工作
 1.Layout: UI布局，文本计算
 2.Display: 绘制
 3.Prepare: 图片解码
 4.Commit：提交位图

 GPU渲染管线(OpenGL)
 顶点着色，图元装配，光栅化，片段着色，片段处理
 
 MARK: ---4.UI卡顿掉帧原因
 iOS设备的硬件时钟会发出Vsync（垂直同步信号），然后App的CPU会去计算屏幕要显示的内容，之后将计算好的内容提交到GPU去渲染。随后，GPU将渲染结果提交到帧缓冲区，等到下一个VSync到来时将缓冲区的帧显示到屏幕上。也就是说，一帧的显示是由CPU和GPU共同决定的。
 一般来说，页面滑动流畅是60fps，也就是1s有60帧更新，即每隔16.7ms就要产生一帧画面，而如果CPU和GPU加起来的处理时间超过了16.7ms，就会造成掉帧甚至卡顿
 
 MARK: ---5.UIApplication-UIApplicationMain
 @interface UIApplication : UIResponder
 + (UIApplication *)sharedApplication;
 @property(nullable, nonatomic, assign) id<UIApplicationDelegate> delegate;
 @end
 
 UIApplicationDelegate协议中的方法正是用来处理这些事件的，app进入前台，进入后台，app被杀死等
 
 UIApplication对象代表的就是一个app
 
 AppDelegate文件中实现了UIApplicationDelegate协议中的方法
 
 main函数:
 main()函数中调用了UIApplicationMain()方法
 int UIApplicationMain(int argc, char * _Nonnull * _Null_unspecified argv, NSString * _Nullable principalClassName, NSString * _Nullable delegateClassName);
 argc、argv是系统参数
 第一个参数表示程序在进入mian函数是的参数的个数，默认为1
 第二个参数表示装载函数的数组（包含的各个参数），默认为程序的名字
 第三个参数是UIApplication类名或其子类名，若是nil，则默认使用UIApplication类名
 principalClassName传nil代表的是使用UIApplication类，delegateClassName是代理类名，该类必须要遵守UIApplicationDelegate协议
 
 UIApplicationMain()做的事情：
 1. 根据传入的principalClassName,创建一个UIApplication对象
 2. 根据传入的delegateClassName,创建一个遵守UIApplicationDelegate协议的对象，默认情况下是AppDelegate对象
 3. UIApplication对象中有一个属性是 delegate,第2步生成的类赋值给UIApplication对象的delegate属性。
 4. 之后开启一个runloop，也就是主runloop，处理事件
 
 app启动之后，创建的第一个视图控件就是UIWindow
 UIWindow本身并不做显示，UIWindow更像是一个容器，添加到UIWindow上的view会被显示到屏幕上
 
 app启动后，会加载info.plist文件，如果在info.plist文件中指定了main.storyboard，那么就去加载main.storyboard,根据main.storyboard初始化控制器，并将该控制器赋值给UIWindow的rootViewController属性。如果没有指定main.storyboard,需要手动创建UIViewController，并赋值给UIWindow的rootViewController。手动创建的操作通常是在
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
  {
     return YES;
 }
 UIWindow会自动将其rootViewController的view添加，这样其rootViewController就可以显示到屏幕上
 
 首先创建窗口，得到一个正确的UIWindow实例对象用来显示界面（self.window是系统自带的属性）。接着设置窗口的根控制器。自己创建控制器，设置这个控制器为self.window的根控制器。注意这个时候根控制器的view还没有加到self.window上，当窗口要显示的时候，才会把窗口的根控制器的view添加到窗口。
 
 显示窗口：
 [self.window makeKeyAndVisible]
 首先将self.window设置为UIApplication的keyWindow，这么做是方便我们以后查看UIApplication的主窗口是哪一个。
 接着，让self.window可见
 实际上将[self.window makeKeyAndVisible]替换为self.window.hidden = NO，那么界面也会正常显示出来，因为makeKeyAndVisible内部就是这么做的。但是此时并没有设置UIApplication的keyWindow，为了以后方便访问，还是用makeKeyAndVisible更好一点。

 
 MARK: ---UIView block动画实现原理
 如果一个属性被标记为Animatable，那么它具有以下两个特点：
 1、直接对它赋值可能产生隐式动画；
 2、我们的CAAnimation的keyPath可以设置为这个属性的名字
 
 当我们直接对可动画属性赋值的时候，由于有隐式动画存在的可能，CALayer首先会判断此时有没有隐式动画被触发。它会让它的delegate（没错CALayer拥有一个属性叫做delegate）调用actionForLayer:forKey:来获取一个返回值，这个返回值在声明的时候是一个id对象，当然在运行时它可能是任何对象。这时CALayer拿到返回值，将进行判断：
 如果返回的对象是一个nil，则进行默认的隐式动画；
 如果返回的对象是一个[NSNull null] ，则CALayer不会做任何动画；
 如果是一个正确的实现了CAAction协议的对象，则CALayer用这个对象来生成一个CAAnimation，并加到自己身上进行动画

 如果这个CALayer被一个UIView所持有，那么这个CALayer的delegate就是持有它的那个UIView
 既然UIView就是CALayer的delegate，那么actionForLayer:forKey:方法就是由UIView来实现的。所以UIView可以相当灵活的控制动画的产生
 当我们对UIView的一个属性赋值的时候，它只是简单的调用了它持有的那个CALayer的对应的属性的setter方法而已
 
 实际上结果大家都应该能想得到：在UIView的动画block外面，UIView的这个方法将返回NSNull，而在block里面，UIView将返回一个正确的CAAction对象
 - (void)uiviewAnimation {
 // 是尖括号的null，nil打印出来是圆括号的null
     NSLog(@"%@",[self.view.layer.delegate actionForLayer:self.view.layer forKey:@"position"]);// <null>
     
     [UIView animateWithDuration:1.25 animations:^{
 //  <_UIViewAdditiveAnimationAction: 0x600001ff0d40>
         NSLog(@"%@",[self.view.layer.delegate actionForLayer:self.view.layer forKey:@"position"]);
     }];
 }

 */

// MARK: CoreAnimation
// https://legacy.gitbook.com/book/zsisme/ios-/details
/**
 1.CALayer
 layer 层是涂层绘制、渲染、以及动画的完成者
 常见的属性有 Frame、Bounds、Position、AnchorPoint、Contents
 */

// MARK: Runloop
/**
 MARK: ---1.什么是异步绘制
 异步绘制，就是可以在子线程把需要绘制的图形，提前在子线程处理好。将准备好的图像数据直接返给主线程使用，这样可以降低主线程的压力
 
 MARK: ---2.AFNetworking 中如何运用 Runloop
 AFURLConnectionOperation 这个类是基于 NSURLConnection 构建的，其希望能在后台线程接收 Delegate 回调。为此 AFNetworking 单独创建了一个线程，并在这个线程中启动了一个 RunLoop

 + (void)networkRequestThreadEntryPoint:(id)__unused object {
     @autoreleasepool {
         [[NSThread currentThread] setName:@"AFNetworking"];
         NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
         [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
         [runLoop run];
     }
 }

 + (NSThread *)networkRequestThread {
     static NSThread *_networkRequestThread = nil;
     static dispatch_once_t oncePredicate;
     dispatch_once(&oncePredicate, ^{
         _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
         [_networkRequestThread start];
     });
     return _networkRequestThread;
 }
 通常情况下，调用者需要持有这个 NSMachPort (mach_port) 并在外部线程通过这个 port 发送消息到 loop 内；但此处添加 port 只是为了让 RunLoop 不至于退出，并没有用于实际的发送消息

 当需要这个后台线程执行任务时，AFNetworking 通过调用 [NSObject performSelector:onThread:..] 将这个任务扔到了后台线程的 RunLoop 中
 
 MARK: ---3.为什么 NSTimer 有时候不好使
 因为创建的 NSTimer 默认是被加入到了 defaultMode，所以当 Runloop 的 Mode 变化时，当前的 NSTimer 就不会工作了
 
 MARK: ---4.PerformSelector &&  PerformSelector:afterDelay
 performSelecor响应了OC语言的动态性:延迟到运行时才绑定方法
 [obj performSelector:@selector(play)];
 编译阶段并不会去检查方法是否有效存在
 performSelector:withObject:只是一个单纯的消息发送
 
 当调用 NSObject 的 performSelecter:afterDelay: 后，实际上其内部会创建一个 Timer 并添加到当前线程的 RunLoop 中。所以如果当前线程没有 RunLoop，则这个方法会失效
 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     dispatch_async(queue, ^{
          [self performSelector:@selector(test) withObject:nil afterDelay:2];
         [[NSRunLoop currentRunLoop] run];
 });
 run方法只是尝试想要开启当前线程中的runloop，但是如果该线程中并没有任何事件(source、timer、observer)的话，并不会成功的开启。
 对于该performSelector延迟方法而言，如果在主线程中调用，那么test方法也是在主线程中执行；如果是在子线程中调用，那么test也会在该子线程中执行
 
 
 当调用 performSelector:onThread: 时(关键点:waitUntilDone 我猜这个会创建一个 Timer)，实际上其会创建一个 Timer 加到对应的线程去，同样的，如果对应线程没有 RunLoop 该方法也会失效

 MARK: ---5.在不使用GCD和NSOperation的情况下，实现异步线程
 1.[self performSelectorInBackground:@selector(test) withObject:nil];
 2.performSelector:onThread:在指定线程执行
 
 MARK: ---6.autoreleasePool 在何时被释放
 App启动后，苹果在主线程 RunLoop 里注册了两个 Observer，其回调都是 _wrapRunLoopWithAutoreleasePoolHandler()
 
 第一个 Observer 监视的事件是 Entry(即将进入Loop)，其回调内会调用 _objc_autoreleasePoolPush() 创建自动释放池。优先级最高，保证创建释放池发生在其他所有回调之前
 
 第二个 Observer 监视了两个事件： BeforeWaiting(准备进入休眠) 时调用_objc_autoreleasePoolPop() 和 _objc_autoreleasePoolPush() 释放旧的池并创建新池；Exit(即将退出Loop) 时调用 _objc_autoreleasePoolPop() 来释放自动释放池。这个 Observer 的 优先级最低，保证其释放池子发生在其他所有回调之后
 
 MARK: ---7.手势识别 的过程
 当上面的 _UIApplicationHandleEventQueue()识别了一个手势时，其首先会调用 Cancel 将当前的 touchesBegin/Move/End 系列回调打断。随后系统将对应的 UIGestureRecognizer 标记为待处理。

 苹果注册了一个 Observer 监测 BeforeWaiting (Loop即将进入休眠) 事件，这个 Observer 的回调函数是 _UIGestureRecognizerUpdateObserver()，其内部会获取所有刚被标记为待处理的 GestureRecognizer，并执行GestureRecognizer 的回调
 
 MARK: ---8.`事件响应` 的过程
 苹果注册了一个 Source1 (基于 mach port 的) 用来接收系统事件，其回调函数为 __IOHIDEventSystemClientQueueCallback()。

 当一个硬件事件(触摸/锁屏/摇晃等)发生后，首先由 IOKit.framework 生成一个 IOHIDEvent 事件并由 SpringBoard 接收。SpringBoard 只接收按键(锁屏/静音等)，触摸，加速，接近传感器等几种 Event，随后用 mach port 转发给需要的 App 进程。随后苹果注册的那个 Source1 就会触发回调，并调用 _UIApplicationHandleEventQueue() 进行应用内部的分发。
 
 _UIApplicationHandleEventQueue() 会把 IOHIDEvent 处理并包装成 UIEvent 进行处理或分发，其中包括识别 UIGesture/处理屏幕旋转/发送给 UIWindow 等。通常事件比如 UIButton 点击、touchesBegin/Move/End/Cancel 事件都是在这个回调中完成的
 
 MARK: ---9.NSTimer
 NSTimer 其实就是 CFRunLoopTimerRef，他们之间是 toll-free bridged 的。一个 NSTimer 注册到 RunLoop 后，RunLoop 会为其重复的时间点注册好事件。例如 10:00, 10:10, 10:20 这几个时间点。RunLoop 为了节省资源，并不会在非常准确的时间点回调这个Timer。Timer 有个属性叫做 Tolerance (宽容度)，标示了当时间点到后，容许有多少最大误差
 
 如果某个时间点被错过了，例如执行了一个很长的任务，则那个时间点的回调也会跳过去，不会延后执行。就比如等公交，如果 10:10 时我忙着玩手机错过了那个点的公交，那我只能等 10:20 这一趟了。

 CADisplayLink 是一个和屏幕刷新率一致的定时器（但实际实现原理更复杂，和 NSTimer 并不一样，其内部实际是操作了一个 Source）。如果在两次屏幕刷新之间执行了一个长任务，那其中就会有一帧被跳过去（和 NSTimer 相似），造成界面卡顿的感觉。在快速滑动 TableView 时，即使一帧的卡顿也会让用户有所察觉。Facebook 开源的 AsyncDisplayLink 就是为了解决界面卡顿的问题，其内部也用到了 RunLoop
 
 MARK: ---10.Observer
 typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
     kCFRunLoopEntry         = (1UL << 0), // 即将进入Loop
     kCFRunLoopBeforeTimers  = (1UL << 1), // 即将处理 Timer
     kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
     kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠
     kCFRunLoopAfterWaiting  = (1UL << 6), // 刚从休眠中唤醒
     kCFRunLoopExit          = (1UL << 7), // 即将退出Loop
 };
 
 MARK: ---11.RunLoop与NSTimer
 默认情况下RunLoop运行在kCFRunLoopDefaultMode下，而当滑动tableView时，RunLoop切换到UITrackingRunLoopMode，而Timer是在kCFRunLoopDefaultMode下的，就无法接受处理Timer的事件
 
 [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
 Timer就被添加到多个mode上，这样即使RunLoop由kCFRunLoopDefaultMode切换到UITrackingRunLoopMode下，也不会影响接收Timer事件
 
 */

// 腾讯阅读团队MLeaksFinder
// http://wereadteam.github.io/
// MARK: 内存管理
/**
 MARK: ---1.如何检测内存泄漏
 Memory Leaks
 Alloctions
 Analyse
 Debug Memory Graph
 MLeaksFinder
 
 泄露的内存主要有以下两种:
 Leak Memory 这种是忘记 Release 操作所泄露的内存
 Abandon Memory 这种是循环引用，无法释放掉的内存
 
 MARK: ---2.__weak 和 _Unsafe_Unretain 的区别
 weak 修饰的指针变量，在指向的内存地址销毁后，会在 Runtime 的机制下，自动置为 nil。
 _Unsafe_Unretain不会置为 nil，容易出现 悬垂指针，发生崩溃。但是 _Unsafe_Unretain 比 __weak 效率高

 MARK: ---3.内存管理默认的关键字
 ARC:
 @property (atomic,readWrite,strong) UIView *view;
 如果改为基本数据类型，那就是 assign
 
 MARK: ---4.Dealloc 的实现机制
 1.首先调用 _objc_rootDealloc()
 2.接下来调用 rootDealloc()
 3.这时候会判断是否可以被释放，判断的依据主要有5个，判断是否有以上五种情况
 NONPointer_ISA
 weakly_reference
 has_assoc
 has_cxx_dtor
 has_sidetable_rc
 4-1.如果有以上五中任意一种，将会调用 object_dispose()方法，做下一步的处理。
 4-2.如果没有之前五种情况的任意一种，则可以执行释放操作，C函数的 free()。
 5.执行完毕
 
 object_dispose() 调用流程。
 1.直接调用 objc_destructInstance()。
 2.之后调用 C函数的 free()
 
 objc_destructInstance() 调用流程:
 1.先判断 hasCxxDtor，如果有 C++ 的相关内容，要调用 object_cxxDestruct() ，销毁 C++ 相关的内容。
 2.再判断 hasAssocitatedObjects，如果有的话，要调用 object_remove_associations()，销毁关联对象的一系列操作。
 3.然后调用 clearDeallocating()。
 4.执行完毕

 clearDeallocating() 调用流程:
 1.先执行 sideTable_clearDellocating()。
 2.再执行 weak_clear_no_lock,在这一步骤中，会将指向该对象的弱引用指针置为 nil。
 3.接下来执行 table.refcnts.eraser()，从引用计数表中擦除该对象的引用计数。
 4.至此为止，Dealloc 的执行流程结束。
 
 MARK: ---5.`@autoreleasePool` 的数据结构
 双向链表，每张链表头尾相接，有 parent、child指针
 每创建一个池子，会在首部创建一个 哨兵 对象,作为标记
 最外层池子的顶端会有一个next指针。当链表容量满了，就会在链表的顶端，并指向下一张表
 
 MARK: ---6.`retainCount` 怎么存储的
 存在64张哈希表中，根据哈希算法去查找所在的位置，无需遍历，十分快捷
 
 每一张 SideTable 主要是由三部分组成。自旋锁、引用计数表、弱引用表。
 引用计数表 中引入了 分离锁的概念，将一张表分拆成多个部分，对他们分别加锁，可以实现并发操作，提升执行效率
 
 引用计数表（哈希表）:
 通过指针的地址，查找到引用计数的地址
 通过 DisguisedPtr(objc_object) 函数存储，同时也通过这个函数查找
 
 SideTables是一个64个元素长度的hash数组，里面存储了SideTable。
 
 一个SideTable中，又有两个成员:
 RefcountMap refcnts;        // 对象引用计数相关 map
 weak_table_t weak_table;    // 对象弱引用相关 table
 refcents是一个hash map，其key是obj的地址，而value，则是obj对象的引用计数
 而weak_table则存储了弱引用obj的指针的地址，其本质是一个以obj地址为key，弱引用obj的指针的地址作为value的hash表。hash表的节点类型是weak_entry_t
 
 SideTables可以理解为一个全局的hash数组，里面存储了SideTable类型的数据，其长度为64
 SideTabls可以通过全局的静态函数获取
 
 struct SideTable {
     spinlock_t slock;           // 自旋锁，防止多线程访问冲突
     RefcountMap refcnts;        // 对象引用计数map
     weak_table_t weak_table;    // 对象弱引用map
 }
 
 typedef objc::DenseMap<DisguisedPtr<objc_object>,size_t,true> RefcountMap;
 
 struct weak_table_t {
     weak_entry_t *weak_entries;        // hash数组，用来存储弱引用对象的相关信息weak_entry_t
     size_t    num_entries;             // hash数组中的元素个数
     uintptr_t mask;                    // hash数组长度-1，会参与hash计算。（注意，这里是hash数组的长度，而不是元素个数。比如，数组长度可能是64，而元素个数仅存了2个）
     uintptr_t max_hash_displacement;   // 可能会发生的hash冲突的最大次数，用于判断是否出现了逻辑错误（hash表中的冲突次数绝不会超过改值）
 };
 
 MARK: ---内存管理
 在iOS中数据是存在在堆和栈中的，然而我们的内存管理管理的是堆上的内存，栈上的内存并不需要我们管理
 
 非OC对象（基础数据类型）存储在栈上
 OC对象存储在堆上
 
 arc在编译时期自动在已有代码中插入合适的内存管理代码
 
 MARK: ---8.什么时候使用自动释放池
 1、当我们需要创建大量的临时变量的时候，可以通过@autoreleasepool 来减少内存峰值。
 2、创建了新的线程执行Cocoa调用。
 3、如果您的应用程序或线程是长期存在的，并且可能会生成大量自动释放的对象，那么您应该定期清空并创建自动释放池（就像UIKit在主线程上所做的那样）；否则，自动释放的对象会累积，内存占用也会增加。但是，如果创建的线程不进行Cocoa调用，则不需要创建自动释放池

 MARK: ---9.管理对象内存的数据结构
 arc自动引用计数
 内存中每一个对象都有一个属于自己的引用计数器.当引用计数到零时，该对象就将释放占有的资源
 
 SideTables是一个hash数组(hash表),里面的内容装的都是SideTable结构体.它使用对象的内存地址当它的key
 又因为内存中对象的数量是非常非常庞大的需要非常频繁的操作SideTables，所以不能对整个Hash表加锁。苹果采用了分离锁技术
 通过SideTables[key]来得到SideTable
 
 降低锁竞争的另一种方法是降低线程请求锁的频率.分拆锁 (lock splitting) 和分离锁 (lock striping) 是达到此目的两种方式
 
 SideTable:
 自旋锁:spinlock_t  slock; 自旋锁比较适用于锁使用者保持锁时间比较短的情况
 正是由于自旋锁使用者一般保持锁时间非常短，因此选择自旋而不是睡眠是非常必要的，自旋锁的效率远高于互斥锁
 它的作用是在操作引用技术的时候对SideTable加锁，避免数据错误
 苹果知道对于引用计数的操作其实是非常快的。所以选择了虽然不是那么高级但是确实效率高的自旋锁
 
 引用计数器:RefcountMap  refcnts; RefcountMap其实是个C++的Map
 为什么Hash以后还需要个Map？
 假设现在内存中有16个对象。
 0x0000、0x0001、...... 0x000e、0x000f
     咱们创建一个SideTables[8]来存放这16个对象
 假设SideTables[0x0000]和SideTables[0x0x000f]冲突,映射到相同的结果。
 SideTables[0x0000] == SideTables[0x0x000f]  ==> 都指向同一个SideTable
 苹果把两个对象的内存管理都放到里同一个SideTable中。你在这个SideTable中需要再次调用table.refcnts.find(0x0000)或者table.refcnts.find(0x000f)来找到他们真正的引用计数器
这里是一个分流。内存中对象的数量实在是太庞大了我们通过第一个Hash表只是过滤了第一次，然后我们还需要再通过这个Map才能精确的定位到我们要找的对象的引用计数器
 
 引用计数器的数据类型是:
 typedef __darwin_size_t        size_t;
 其实是unsigned long，在32位和64位操作系统中，它分别占用32和64个bit。
 苹果经常使用bit mask技术。
 拿32位系统为例的话，可以理解成有32个盒子排成一排横着放在你面前。盒子里可以装0或者1两个数字。我们规定最后边的盒子是低位，左边的盒子是高位
 
 (1UL<<0)的意思是将一个"1"放到最右侧的盒子里，然后将这个"1"向左移动0位(就是原地不动):0b0000 0000 0000 0000 0000 0000 0000 0001
 引用计数器的结构,从低位（最右边）到高位：
 (1UL<<0)    WEAKLY_REFERENCED
 表示是否有弱引用指向这个对象，如果有的话(值为1)在对象释放的时候需要把所有指向它的弱引用都变成nil(相当于其他语言的NULL)，避免野指针错误
 (1UL<<1)    DEALLOCATING
 表示对象是否正在被释放。1正在释放，0没有
 REAL COUNT
 REAL COUNT的部分才是对象真正的引用计数存储区。
 (1UL<<(WORD_BITS-1))    SIDE_TABLE_RC_PINNED
 其中WORD_BITS在32位和64位系统的时候分别等于32和64。随着对象的引用计数不断变大。如果这一位都变成1了，就表示引用计数已经最大了不能再增加了
 
 维护weak指针的结构体: weak_table_t   weak_table;
 RefcountMap  refcnts;是一个一层结构，可以通过key直接找到对应的value。而这里是一个两层结构。
     第一层结构体中包含两个元素
 第一个元素weak_entry_t *weak_entries;是一个数组,上面的RefcountMap是要通过find(key)来找到精确的元素的。weak_entries则是通过循环遍历来找到对应的entry
 第二个元素num_entries是用来维护保证数组始终有一个合适的size。比如数组中元素的数量超过3/4的时候将数组的大小乘以2
 第二层weak_entry_t的结构包含3个部分
 1,referent:
 被指对象的地址。前面循环遍历查找的时候就是判断目标地址是否和他相等。
 2,referrers
 可变数组,里面保存着所有指向这个对象的弱引用的地址。当这个对象被释放的时候，referrers里的所有指针都会被设置成nil。
 3,inline_referrers
 只有4个元素的数组，默认情况下用它来存储弱引用的指针。当大于4个的时候使用referrers来存储指针。
 
 dealloc：
 sidetable_clearDeallocating()
 weak_clear_no_lock()
 
 分离锁:
 分离锁并不是一种锁，而是一种对锁的用法
 eg:hash数组0,1,2,3 (4个元素)
 对一整个表加一把锁，是我们平时比较常见的。如果我一次写操作需要操作表中多个单元格的数据，比如第一次操作0、1、2位置的数据，第二次操作0、2、3位置的数据。像这种情况锁的粒度就是以整张表为单位的，才能保证数据的安全
 对表中的各个元素分别加一把锁就是我们说的分离锁。适用于表中元素相互独立，你对第一个元素做写操作的时候不需要影响到其他元素。
 上文中所说的结构就是SideTables这个大的Hash表中每一个小单元格(SideTable)都带有一把锁。做写操作的时候(操作对象引用计数)单元格之间相互独立，互相没影响。所以降低了锁的粒度
 
 因为任何操作都需要锁整张表，所以写操作的时候相当于串行操作。没有并发。
 因为每一个单元格都有一把锁，所以写操作的时候有多少个单元格并发数就可以是多少
 
 当有多个线程在操作时,如果系统只有一个CPU,则它根本不可能真正同时进行一个以上的线程,它只能把CPU运行时间划分成若干个时间段,再将时间段分配给各个线程执行,在一个时间段的线程代码运行时,其它线程处于挂起状态.这种方式我们称之为并发(Concurrent).
 当系统有一个以上CPU时,则线程的操作有可能非并发.当一个CPU执行一个线程时,另一个CPU可以执行另一个线程,两个线程互不抢占CPU资源,可以同时进行,这种方式我们称之为并行(Parallel)

 
 eg:假设有80个学生需要咱们安排住宿，同时还要保证学生们的财产安全
 然不会给80个学生分别安排80间宿舍，然后给每个宿舍的大门上加一把锁
 把80个学生分配到10间宿舍里，每个宿舍住8个人。假设宿舍号分别是101、102 、... 110。然后再给他们分配床位，01号床、02号床等。然后给每个宿舍配一把锁来保护宿舍内同学的财产安全。为什么不只给整个宿舍楼上一把锁，每次有人进出的时候都把整个宿舍楼锁上？显然这样会造成宿舍楼大门口阻塞

 1、找到宿舍楼(SideTables)的宿管，跟他说自己要找10202(内存地址当做key)。
 2、宿管带着他SideTables[10202]找到了102宿舍SideTable，然后把102的门一锁lock，在他访问102期间不再允许其他访客访问102了。(这样只是阻塞了102的8个兄弟的访问，而不会影响整栋宿舍楼的访问)
 3、然后在宿舍里大喊一声:"2号床的兄弟在哪里？"table.refcnts.find(02)你就可以找到2号床的兄弟了。
 4、等这个访客离开的时候会把房门的锁打开unlock，这样其他需要访问102的人就可以继续进来访问了
 SideTables == 宿舍楼
 SideTable  == 宿舍
 RefcountMap里存放着具体的床位
 苹果之所以需要创造SideTables的Hash冲突是为了把对象放到宿舍里管理，把锁的粒度缩小到一个宿舍SideTable。RefcountMap的工作是在找到宿舍以后帮助大家找到正确的床位的兄弟
 
 MARK: ---ARC（引用计数）
 iOS5 引入的
 ARC 是编译器特性
 ARC 其实是在编译阶段自动帮开发者插入了管理内存的代码
 
 MARK: ---autorelease
 在MRC中，对某一个对象调用autorelease方法，表示延迟发送release消息，意思指的是，当我们把一个对象标记为autorelease时:[obj autorelease];,表示现在暂时不进行release操作，等这段语句所处的 autoreleasepool 进行 drain 操作时，所有标记了 autorelease 的对象的 retainCount 会被 -1。即 release 消息的发送被延迟到 pool 释放的时候了
 
 MARK: ---引用计数的理解
 mrc:
 NSObject *ob = [[NSObject alloc]init]
 右边：意思是在堆上开辟一块内存，用于存放 NSObjec的一个实例
 左边：在栈上创建了一个指针，该指针存储的是堆上实例的内存地址，此时该块内存的referencecount = 1
 NSObject *ob1 = ob;
 同样在栈上创建了一个指针存了堆上实例的内存地址，但是referencecount没有增加
 NSObject *ob2 = [ob retain];
 同样在栈上创建了一个指针，存的是堆上的内存地址，不同的是有一个[ob retain]方法执行了，关键就在这个 retain方法，因为这个 方法的作用是 ob指针指向的内存块发消息说:你的引用计数要加1
 引用计数是内存块的属性
 
 retain ： 保留。保留计数+1；
 release ： 释放。保留计数 -1；
 autorelease ：稍后(清理“自动释放池”时)，再递减保留计数，所以作用是延迟对象的release
 
 autorelease看上去很像ARC，但是实际上更类似C语言中的自动变量（局部变量），当某自动变量超出其作用域(例如大括号)，该自动变量将被自动废弃，而autorelease中对象实例的release方法会被调用
 
 一般调用完对象之后都会清空指针："object = nil"，这样就能保证不会出现指向无效对象的指针，也就是悬挂指针（dangling pointer）;
 悬挂指针：指向无效对象的指针
 
 Person *person = [[Person alloc] init]; //此时，计数 = 1
 [person retain];  //计数 = 2
 [person release];  //计数 = 1
 [person release]; //很可能计数 = 1;
 虽然第四行代码把计数1release了一次，原理上person对象的计数会变成0，但是实际上为了优化对象的释放行为，提高系统的工作效率，在retainCount为1时release系统会直接把对象回收，而不再为它的计数递减为0，所以一个对象的retainCount值有可能永远不为0
 
 arc:
 ARC下的iOS项目几乎把所有内存管理事宜都交给编译器来决定
 
 ARC并不是GC（Garbage Collection 垃圾回收器），它只是一种代码静态分析（Static Analyzer）工具，背后的原理是依赖编译器的静态分析能力，通过在编译时找出合理的插入引用计数管理代码，从而提高iOS开发人员的开发效率

 自动引用计数(ARC)是一个编译器级的功能
 
 在编译阶段，编译器将在项目代码中自动为分配对象插入retain、release和autorelease，且插入的代码不可见
 
 // mrc下
 -(void)setup{
    _person = [person new];
 }
 在ARC下编译，其代码会变成：（_person是个属性）
 -(void)setup{
   person *tmp = [person new];
   _person = [tmp retain];
   [tmp release];
 }
 
 运行期的优化：
 在personWithName方法中，返回对象给_one之前，为其调用了一次autorelease方法。
 由于实例变量是个强引用，所以编译器会在设置其值的时候还需要执行一次保留操作。

 //在personWithName方法返回前已有调用一次autorelease方法进行保留操作；
 person *tmp = [person personWithName:@"name"];
 _one = [tmp retain];
很明显，autorelease与紧跟其后的retain是重复的。为提升性能，可以将二者删去，舍弃autorelease这个概念，
 
 objc_autoreleaseReturnValue
 objc_retainAutoreleaseReturnValue
 
 // ======
 id objc = [[NSObject alloc] init];
 实际上已被附上所有权修饰符：
 id __strong objc = [[NSObject alloc] init];
 
 MARK: ---`ARC` 在运行时做了哪些工作
 运行期的优化:
 为了保证向后兼容性
 ARC 在运行时检测到类函数中的 autorelease 后紧跟其后 retain，此时不直接调用对象的 autorelease 方法，而是改为调用 objc_autoreleaseReturnValue.objc_autoreleaseReturnValue 会检视当前方法返回之后即将要执行的那段代码，若那段代码要在返回对象上执行 retain 操作，则设置全局数据结构中的一个标志位，而不执行 autorelease 操作
 与之相似
 如果方法返回了一个自动释放的对象，而调用方法的代码要保留此对象，那么此时不直接执行 retain ，而是改为执行 objc_retainAoutoreleasedReturnValue函数。此函数要检测刚才提到的标志位，若已经置位，则不执行 retain 操作，设置并检测标志位，要比调用 autorelease 和retain更快
 
 MARK: ---循环引用
 循环引用的实质：多个对象相互之间有强引用，不能释放让系统回收
 1、避免产生循环引用，通常是将 strong 引用改为 weak 引用
 2、在合适时机去手动断开循环引用
 
 MARK: ---底层解析weak
 Runtime维护了一个weak表，用于存储指向某个对象的所有weak指针。weak表其实是一个hash（哈希）表，Key是所指对象的地址，Value是weak指针的地址（这个地址的值是所指对象的地址）数组
 
 1、初始化时：runtime会调用objc_initWeak函数，初始化一个新的weak指针指向对象的地址
 2、添加引用时：objc_initWeak函数会调用 objc_storeWeak() 函数， objc_storeWeak() 的作用是更新指针指向，创建对应的弱引用表
 3、释放时，调用clearDeallocating函数。clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录
 {
     NSObject *obj = [[NSObject alloc] init];
     id __weak obj1 = obj;
 }
 id objc_initWeak(id *object, id value);
 objc_initWeak函数有一个前提条件：就是object必须是一个没有被注册为__weak对象的有效指针。而value则可以是null，或者指向一个有效的对象
 
 id objc_storeWeak(id *location, id value);
 
 SideTable
 它主要用于管理对象的引用计数和 weak 表
 weak表是一个弱引用表，实现为一个weak_table_t结构体，存储了某个对象相关的的所有的弱引用信息
 struct weak_table_t {
     // 保存了所有指向指定对象的 weak 指针
     weak_entry_t *weak_entries;
     // 存储空间
     size_t    num_entries;
     // 参与判断引用计数辅助量
     uintptr_t mask;
     // hash key 最大偏移值
     uintptr_t max_hash_displacement;
 };
 用 weak_entry_t 类型结构体对象作为 value

 当weak引用指向的对象被释放时:
 1、调用objc_release
 2、因为对象的引用计数为0，所以执行dealloc
 3、在dealloc中，调用了_objc_rootDealloc函数
 4、在_objc_rootDealloc中，调用了object_dispose函数
 5、调用objc_destructInstance
 6、最后调用objc_clear_deallocating调用了clearDeallocating
 
 MARK: ---ARC 在编译时做了哪些工作
 根据代码执行的上下文语境，在适当的位置插入 retain，release
 
 */

// MARK: Block
/**
 block本质是对象，底层源码他有isa指针，它是个struct Block_layout {
 void *isa;
 int32_t flags;
 void (*invoke)(void *, ...); 执行block
 ...
 ...
 struct Block_descriptor_1 *descriptor;
 }
 
 void(*testBlock)(void) = ^ {
 
 }
 struct Block_layout *customBlock = (__bridge struct Block_layout *)testBlock;
 customBlock->invoke(customBlock);
 block的方法签名信息：
 if (customBlock->flags & BLOCK_MAS_SIGNATURE) {
 // 通过地址偏移
 void *desc = customBlock->descriptor;// 拿到descriptor结构体的首地址
 
 }
 
 Aspects：
 hook一个selector->aspect_add
 AspectsIdentifier 代表一个hook
 AspectsContainer 容器
 
 方法签名信息:没有参数，没有返回值v@:
 block 签名信息: v@? (@?表示block)
 
 
 MARK: ---1.Block变量截获
 static NSInteger num3 = 300;

 NSInteger num4 = 3000;

 - (void)blockTest
 {
     NSInteger num = 30;
     
     static NSInteger num2 = 3;
     
     __block NSInteger num5 = 30000;
     
     void(^block)(void) = ^{
         
         NSLog(@"%zd",num);//局部变量
         
         NSLog(@"%zd",num2);//静态变量
         
         NSLog(@"%zd",num3);//全局变量
         
         NSLog(@"%zd",num4);//全局静态变量
         
         NSLog(@"%zd",num5);//__block修饰变量
     };
     
     block();
 }
 
 struct __WYTest__blockTest_block_impl_0 {
   struct __block_impl impl;
   struct __WYTest__blockTest_block_desc_0* Desc;
   NSInteger num;//局部变量
   NSInteger *num2;//静态变量
   __Block_byref_num5_0 *num5; // by ref//__block修饰变量
   __WYTest__blockTest_block_impl_0(void *fp, struct __WYTest__blockTest_block_desc_0 *desc, NSInteger _num, NSInteger *_num2, __Block_byref_num5_0 *_num5, int flags=0) : num(_num), num2(_num2), num5(_num5->__forwarding) {
     impl.isa = &_NSConcreteStackBlock;
     impl.Flags = flags;
     impl.FuncPtr = fp;
     Desc = desc;
   }
 };
 
 struct __Block_byref_num5_0 {
   void *__isa;
 __Block_byref_num5_0 *__forwarding;
  int __flags;
  int __size;
  NSInteger num5;
 };
 
 MARK: ---2.block详解
 block的本质是OC对象，其封装了函数调用以及其上下文
 捕获了外部变量的 block 的类会是 __NSMallocBlock__ 或者 __NSStackBlock__
 如果 block 被赋值给了某个变量，在这个过程中会执行 __Block__copy 将原有的 __NSStakeBlock__ 变成 __NSMallocBlock__
 如果 block没有赋值给某个变量，那他的类型就是 __NSStakeBlock__
 没有捕获外部变量的 block 的类会是 __NSGlobalBlock__ 即不再堆上，也不在栈上，它类似 C 语言函数一样会在代码段中
 
 void(^block)(int a) = ^(int a) {
         NSLog(@"this is a block");
     };
     NSLog(@"%@",[block class]);
     NSLog(@"%@",[[block class] superclass]);
     NSLog(@"%@",[[[block class] superclass] superclass]);
     NSLog(@"%@",[[[[block class] superclass] superclass] superclass]);
 //结果
 2019-05-27 20:01:01.579527+0800 Demo[54543:5941072] __NSGlobalBlock__
 2019-05-27 20:01:01.579709+0800 Demo[54543:5941072] __NSGlobalBlock
 2019-05-27 20:01:01.579812+0800 Demo[54543:5941072] NSBlock
 2019-05-27 20:01:01.579946+0800 Demo[54543:5941072] NSObject
 
 block 中的 isa 指向的是该 block 的 Class
 
 当函数返回时，函数的栈被销毁，这个 block 的内存也会被清除。所以在函数结束后，如果仍需要这个 block ，就需要用到 Block_copy() 方法将它拷贝到堆上。这个方法的核心动作是：申请内存，将栈数据复制过去。增加 block 的引用计数
 
 1.全局 block
 定义在函数外部的 block 是 global 类型的
 定义在函数内部的 block ，但是没有捕获任何自动变量，那也是全局的。
 
 2.栈 block
 保存在栈中的 block，当函数返回时会被销毁，和第一种的区别就是调用了外部变量
 
 3.堆内存
 保存在堆中的 block，当引用计数为 0 时会被销毁
 
 ARC下哪些情况下会从栈区自动copy到堆:
 block赋值给__strong变量
 block作为函数返回值
 带usingBlock:的系统api
 gcd实现的block
 
 因为局部变量作用域，如果超出作用域，局部变量会被释放，而要在作用域之外使用block,所以需要捕获，且为值传递
 而static变量一直保存在内存，直接使用指针访问即可
 
 如果是static修饰的变量，在block内部传递的是指针，在block内可以直接修改变量的值，当然全局变量也可以，但是普通自动变量是值传递，内部修改的是复制品的值，并不能修改外部变量的值，如果要修改怎么办呢？答案是__block修饰符
 
 被拷贝到对上后，栈上的forwarding指向堆，堆上的指向自己
 
 __block修饰符用于在block内部修改捕获的自动变量，且不能用于修饰static和全局变量
 
 当block内部访问了对象类型的auto变量时，是否会强引用?
 StackBlock:不管外部变量是弱引用还是强引用，都会弱引用该对象
 MallocBlock:根据外部变量的修饰符决定，外部强引用，block强引用对象，外部弱引用，block内部也弱引用
 {
     Person *p = [Person new];
     p.name = @"X";
     // 如果用weak，弱引用p,p会在本作用域结束后立马释放,强引用则会在block执行后block释放后释放。
     //__weak typeof (Person) *wp = p;
     void(^block)(void) = ^() {
     p.name = @"Y"
         //wp.name = @"Y";
     };
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         block();
     });
 }
 
 gcd的block访问了外部对象，会不会强引用，何时销毁？
 会，gcd的block也会被自动拷贝到堆成为堆block,如果引用了未修饰的外部变量也会强引用，直到block释放后，对象才会释放，例如以上例子中的dispatch_after,延迟到期执行之后才会释放
 
 解决block循环引用:
 __weak
 __unsafe__unretained
 __block
 前两个都是为了不形成循环引用，__weak会在对象释放后自动置为nil,而__unsafe__unretained则不会，所以是不安全的，不推荐。
 __block则是在形成循环引用后，主动打破循环，所以block内部逻辑必须执行，且必须将对象置为nil.
 __block Person *person = [[Person alloc] init];
 person.block = ^{
     NSLog(@"age is %d", person.age);
     person = nil;
 };
 person.block();
 
 int main(int argc, char * argv[]) {
     @autoreleasepool {
         void(^block)(int a) = ^(int a) {
             NSLog(@"this is a block");
         };
 block
         return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
     }
 }
 
 struct __block_impl {
   void *isa;
   int Flags;
   int Reserved;
   void *FuncPtr;
 };
 struct __main_block_impl_0 {
   struct __block_impl impl;
   struct __main_block_desc_0* Desc;
   __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
     impl.isa = &_NSConcreteStackBlock;//栈block
     impl.Flags = flags;
     impl.FuncPtr = fp;
     Desc = desc;
   }
 };
 static void __main_block_func_0(struct __main_block_impl_0 *__cself, int a) {

             NSLog((NSString *)&__NSConstantStringImpl__var_folders_lw_wmb5_p0n64n270_hcnwrkdxc0000gn_T_main_f39207_mi_0);
         }

 static struct __main_block_desc_0 {
   size_t reserved;
   size_t Block_size;
 } __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
 int main(int argc, char * argv[]) {
      // @autoreleasepool  { __AtAutoreleasePool __autoreleasepool;
         void(*block)(int a) = ((void (*)(int))&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));
         ((void (*)(__block_impl *, int))((__block_impl *)block)->FuncPtr)((__block_impl *)block, 1);
         return UIApplicationMain(argc, argv, __null, NSStringFromClass(((Class (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("AppDelegate"), sel_registerName("class"))));
     }
 }
 
 MARK: ---3.对栈block进行赋值操作：
 NSInteger num = 10;
 void (^mallocBlock)(void) = ^{
         NSLog(@"stackBlock:%zd",num);
     };
 NSLog(@"%@",[mallocBlock class]);// __NSMallocBlock__

 对栈blockcopy之后，并不代表着栈block就消失了，左边的mallock是堆block，右边被copy的仍是栈block
 
 
 
 [self testWithBlock:^{
     NSLog(@"%@",self);
 }];

 - (void)testWithBlock:(dispatch_block_t)block
 {
     block();
     dispatch_block_t tempBlock = block;
     NSLog(@"%@,%@",[block class],[tempBlock class]);
 }
 输出：
 __NSStackBlock__,__NSMallocBlock__
即如果对栈Block进行copy，将会copy到堆区，对堆Block进行copy，将会增加引用计数，对全局Block进行copy，因为是已经初始化的，所以什么也不做
 
 __block变量在copy时，由于__forwarding的存在，栈上的__forwarding指针会指向堆上的__forwarding变量，而堆上的__forwarding指针指向其自身，所以，如果对__block的修改，实际上是在修改堆上的__block变量
即__forwarding指针存在的意义就是，无论在任何内存位置，都可以顺利地访问同一个__block变量
 
 */

// MARK: Runtime
/**
 c,c++,汇编实现的api， 给oc提供了运行时功能
 
 xcrun-sdk iphoneos clang -arch arm64 -rewrite-objc main.m -o main.cpp
 clang -rewrite-objc main.m -o main.cpp
 
 任何的方法调用都会编译成objc_msgSend（消息接收者，方法编号-字符串【方法名字】）
 oc对象本质是结构体
 方法的本质是发送消息
 
 runtime的3种调用方式：
 1.runtime api eg: sel_registerName
 2.NSObject api
 3.oc上层写法  eg: @selector()
 
 @selector() 等价与 sel_registerName
 
 对象方法
 objc_msgSend(person, sel_registerName("walk"))
 
 类方法
 objc_msgSend(objc_getClass("Person"), sel_registerName("walk1"))
 
 向父类发消息（对象方法）
 struct objc_super mySuper;
 mySuper.receiver = person;// person对象 是Person类的对象
 mySuper.super_class = class_getSuperClass([person class]);// 因为对象方法存在对象所属的类
 objc_msgSendSuper(&mySuper,  @selector(run))
 
 向父类发消息（类方法）
 struct objc_super myClassSuper;
 mySuper.receiver = [person class]
 mySuper.super_class = class_getSuperclass(object_getClass([person class]));// 因为类方法存在对象所属类的元类
 objc_msgSendSuper(&myClassSuper,  @selector(run1))
 
 两种方式找方法实现（通过sel找imp）：
 1.快速 缓存里查找 （哈希表查找,汇编中查找CacheLoopup NORMAL// calls imp or objc_msgSend_uncached）
 汇编:
 CacheHit
 CheckMiss->objc_msgSend_uncached->MethodTableLookup->__class_lookupMethodAndLoadCache3
 从汇编__class_lookupMethodAndLoadCache3跳转到c/c++的_class_lookupMethodAndLoadCache3，前面是__开头，后面是_开头
 _class_lookupMethodAndLoadCache3这个就返回IMP，即return lookUpImpOrForward()
 2.慢速
 从自己类 Try this class's cache->Try this class's method lists
 //
 ->父类->NSObject 这个流程 （如果找到，缓存中存一份）
 lookUpImpOrForward->cache_getImp 因为多线程问题，所以还得查一下，可能其他线程也调用了这个方法，这样的话缓存里面就已经有了->找自己:getMethodNoSuper_nolock,如果找到，log_and_fill_cache
 //
 ->找父亲.....NSObject
 Try superclass caches and method lists
 for (Class curCLass = cls->superclass; curClass != nil; curClass = curClass->superclass) {
 imp = cache_getImp(curClass, sel);
 if (imp) {
 if(imp != (IMP)_objc_msgForward_impcache) {
 log_and_fill_cache()
 goto done;
 }
 }
 getMethodNoSuper_nolock()
 }
 
 动态方法解析
 No implementation found.try method resolver ##once##
 _class_resolveMethod() 判断cls是否是元类
 if (不是metaClass) {
    _class_resolveInstanceMethod()->lookupImpOrNil()这个找的是cls的元类是否实现了+ (BOOL)resolverInstanceMethod:(SEL)sel，因为类方法存在元类
 ->loopUpImpOrForward() 主要是查找resolverInstanceMethod
 因为NSObject默认实现了resolverInstanceMethod返回NO，所以不会照成这个loopUpImpOrForward死递归查找
 }else {
    _class_resolveClassMethod()// 元类的类方法，类方法是元类的实例方法
再调
 _class_resolveInstanceMethod()// 类的实例方法
 }
 + (BOOL)resolverInstanceMethod:(SEL)sel{
 
 }
 + (BOOL)resolverClassMethod:(SEL)sel{
 
 }
 

 
 消息转发
 No implementation found, and method resolver didnt help.Use forwarding
 imp = (IMP)_objc_msgForward_impcache;
 cache_fill(cls, sel, imp, inst);
 
 extern void instrumentObjcMessageSends(BOOL);// 用于打印信息
 main() {
 instrumentObjcMessageSends(YES);
 [Person walk];
 instrumentObjcMessageSends(NO);
 }
 
 // objc源码
 IMP lookUpImpOrNil() {
 IMP imp = lookUpImpOrForward()
 if (imp == _objc_msgForward_impcache) return nil;
 else return imp;
 }
 
 
 lldb:bt
 libobjc.A.dylib XXX方法 这个要去objc源码中查看
 
 汇编比c/c++快
 
 汇编: _objc_msgSend
 汇编有寄存器，可以用来存储
 
 MARK: ---alloc
 Person *p = [Person alloc];
 Person *p1 = [p init];
 Person *p2 = [p init];
 
 p,p1,p2的地址一致
 
 lldb: register read
 
 Symbolic bp(符号断点)
 
 alloc->[NSObject alloc]: _objc_rootAlloc(self)->callAlloc->class_createInstance->_class_createInstanceForZone(1.cls->instanceSize 内存大小 2.calloc 3.obj->initInstanceIsa) 就创建了实例对象
 _class_createInstanceFromZone:
 通过instanceSize()方法分配内存，calloc()开辟空间，initInstanceIsa()创建对象。
 initInstanceIsa():
 初始化了isainitIsa()
 
 init直接返回实例对象，啥也没做 为了让子类重写init方法，做相应的初始化
 工厂设计，父类没有实现，交给子类去实现
 init:
 _objc_rootInit(self)
 
 id _objc_rootInit(id obj) {
 return obj;
 }
 
 llvm编译器优化: optimize
 
 8的倍数算法
 int func(int num) {
    return (num + (8-1) >> 3 << 3);// 2的3次方等于8
  }
 
 
 lldb objc源码
 
 libobjc
 libmalloc:
 LGPerson *objc = [LGPerson alloc];// name,age isa=8 + age= 4内存对齐转为=>8+name=8 = 24  //内存对齐：高效，以空间换时间
 NSLog(@"%zu",class_getInstanceSize([objc class])); // 24 对象内存占用24
 void *p = calloc(1, 24);
 NSLog(@"%lu",malloc_size(p));// 32    内存对齐，系统开辟32，按照16倍数对齐
 
 //查看对象内存分布
 lldb: x 对象地址（0x2818b2020）
 0x2818b2020: 16位 8+8
 0x2818b2030: 16位 8+8 eg: 80 40 29 04 01 00 00 00 代表NString *name
 p 0x0104294080
 p (NSString *)0x0104294080
 
 po和p打印的不一样
 p/x按16进制输出
 
 MARK: ---类对象
 只有一个类对象
 
 union联合体:
 数据共享一片内存
 一个属性 代表不同意思 eg:上下左右 通过0000 1111加算法调整
 
 objc_class : objc_object{
    // Class ISA;
    Class superclass;// 8字节
    cache_t cache;// 16
    class_data_bits_t bits;
 // 指针偏移 因为能拿到类对象的指针，通过指针偏移拿到数据
    class_rw_t *data() {
    return bits.data();
    }
 }
 
 lldb: image list 和类对象的地址做差，然后在Mach-O中查看 .app文件
 
 eg:类对象地址0x000012e0
 则bits地址等于类对象地址0x000012e0偏移+ 8 + 8 + 16 = 32个字节：p (class_data_bits_t *)0x00001300
 得到$0= 0x......
 p $0->data()得到 class_rw_t *data
 
 实例方法的types = "v16@0:8"    imp(id self, SEL _cmd) 表示参数总共占16个字节，@(id)从0开始 :(SEL)从8开始
 
 Method method1 = class_getInstanceMethod([Person class], @selector(instanceMethod));// 类对象拿实例方法
 // 这个类方法是元类的实例方法
 Method method2 = class_getInstanceMethod(objc_getMetaClass("Person"), @selector(classMethod));// 元类对象拿类方法
 
 // class_getMethodImplementation底层实现是找IMP没找到返回_objc_msgForward
 IMP imp1 = class_getMethodImplementation([Person class], @selector(instanceMethod));// 能真正拿到
 IMP imp2 = class_getMethodImplementation([Person class], @selector(classMethod));// 拿到的_objc_msgForward的IMP
 IMP imp3 = class_getMethodImplementation(objc_getMetaClass("Person"), @selector(instanceMethod));// 拿到的_objc_msgForward的IMP
 IMP imp4 = class_getMethodImplementation(objc_getMetaClass("Person"), @selector(classMethod));// 能真正拿到
 
 // 这两个能拿到 并且返回的指针是一样的 class_getClassMethod的底层实现是return class_getInstanceMethod(cls->getMeta(), sel)
 // getMeta() {
    if(isMetaClass()) return (Class)this;
    else return this->ISA();
  }
 Method method1 = class_getClassMethod([Person class], @selector(classMethod));
 Method method2 = class_getClassMethod(objc_getMetaClass("Person"), @selector(classMethod));
 
 //加载类，加载分类  添加属性，添加方法，添加协议都会调用attachLists
 attachLists():
 attachCategories()->attachLists
 
 MARK: ---objc_init
 库是一种可执行代码，二进制
 静态库: .a  .lib  在链接阶段，将目标文件.o与引用的库一起打包成可执行文件，静态链接
 
 动态库: .so  .framework  在运行程序的时候被加载进去
 优点：
 减少打包app的体积
 共享内存
 热更新，更新动态库
 不稳定，不安全
 UIKit就是动态库，libsystem里面有libdispatch
 runtime在libobjc.dylib里面
 
 编译过程:
 源文件 .h,.m 比如写了UIView->预编译 比如宏->编译->汇编->链接 UIKit库，.a,.lib,.so->可执行文件
 
 dyld动态链接器，dyld开源的
 _dyld_start->libdispatch_init->_objc_init->main
 app加载过程:
 app启动后交给dyld去做剩余的工作->加载libsystem->runtime向dyld注册回调函数 (_dyld_objc_notify_register(&map_images, load_images, unmap_image)) 仅供objc运行时使用
 比如加载镜像文件的回调（加载可能成功或失败）
 { // ImageLoader循环加载image
 ->加载image(image相当于是库)
 ->执行map_images Load_images
 }
 ->调用main函数
 
 map_images函数:##主要功能，初始化类:realizeClass 设置rw，ro，处理分类:把分类中的方法，协议，属性添加到类中去##
 初始化哈希表，把类，方法编号，协议，分类加到哈希表，并设置rw，ro,通过attachLists（类加载,加载到内存）
 _read_images
 类 gdb_objc_realizes_classes(哈希表) key: 类名 value:class
 方法 nameSelectors(哈希表)  key: 方法名 value:SEL
 协议 protocol_map(哈希表)  key: 协议名 value:protocol_t
 
 addClassTableEntry(cls) 然后 realizeClass(cls)->methodizeClass(cls)->attachLists 方法列表，属性列表，协议列表
 
 load_images:
 load_images->prepare_load_methods()加载load,里面用到了递归，先父后子  call_load_methods()调用load方法->call_class_loads()  call_category_loads()
 
 load方法调用顺序:
 先父类，再子类，再分类
 add_classs_to_loadable_list            Loadable_classes                call_class_loads
                        =>                                      =>
 add_category_to_loadable_list          loadable_categories         call_category_loads
 
 initialize方法: 消息发送
 调用顺序: 先父后子
 如果父类的分类实现了，则先分类后子类（分类能覆盖原类，分类与分类之间也是有相应的覆盖）
 
 _objc_msgSend_uncached->_class_lookupMethodAndLoadCache->lookupImpOrForward->_class_initialize递归调用 然后call_initialize->[Person initialize]
 
 
 // 先执行testClassMethod(因为调用load之前，类的方法已经被加载了，所以可以调这个testClassMethod)，再进入main函数
 @interface Person : NSObject
 - (void)testInstanceMethod;
 + (void)testClassMethod;
 @end
 @implementation Person (Extension)
 + (void)load
 {
     [self testClassMethod];
 }
 @end
 
 // 因为父类load比子类先调，所以调的时候还没有方法交换
 @implementation Person
 + (void)load
 {
     [TestPerson testClassMethod];// 打印的是testClassMethod
 }
 + (void)testClassMethod
 {
     NSLog(@"testClassMethod");
 }
 @end
 @interface TestPerson : Person

 @end
 @implementation TestPerson
 + (void)load
 {
     ReplaceMethod(self, @selector(testClassMethod), @selector(ndl_testClassMethod));
 }
 + (void)ndl_testClassMethod
 {
     NSLog(@"ndl_testClassMethod");
 }
 @end
 
 方法交换的坑:
 方法交换实质是交换imp,oriSel的imp是newSel的newSelImp
 Student: Person
 // 当方法交换为这样时:
 + (void)lg_methodSwizzlingWithClass:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL{
     
     if (!cls) NSLog(@"传入的交换类不能为空");

     Method oriMethod = class_getInstanceMethod(cls, oriSEL);
     Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
     method_exchangeImplementations(oriMethod, swiMethod);
 }
 子类没有重写父类的实例方法instanceMethod，子类交换了父类的实例方法，用ndl_instanceMethod
 子类调用instanceMethod实际调用了ndl_instanceMethod
 父类调用instanceMethod，则导致崩溃，因为父类没有ndl_instanceMethod，找不到ndl_instanceMethod的IMP
 解决崩溃：
 1.+ (void)lg_betterMethodSwizzlingWithClass:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL{
     
     if (!cls) NSLog(@"传入的交换类不能为空");
     
     Method oriMethod = class_getInstanceMethod(cls, oriSEL);
     Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
     // 一般交换方法: 交换自己有的方法 -- 走下面 因为自己有意味添加方法失败
     // 交换自己没有实现的方法:
     //   首先第一步:会先尝试给自己添加要交换的方法 :personInstanceMethod (SEL) -> swiMethod(IMP)
     //   然后再将父类的IMP给swizzle  personInstanceMethod(imp) -> swizzledSEL
     //oriSEL:personInstanceMethod
     BOOL didAddMethod = class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
     if (didAddMethod) {
         class_replaceMethod(cls, swizzledSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));// 子类没有重写父类的方法走这边
     }else{
         method_exchangeImplementations(oriMethod, swiMethod);// 父类走这边
     }
 }
 也相当于给子类添加instanceMethod方法
 2.子类重写父类的instanceMethod，这样方法交换只影响子类
 推荐第一种，更完善的方法交换。但两者的最终结果是一致的
 
 // 父类子类都没实现helloword 导致的坑
 LGStudent *s = [[LGStudent alloc] init];
 [s helloword];
 @interface LGStudent : LGPerson
 - (void)helloword;
 @end
 @implementation LGStudent

 @end
 @implementation LGStudent (LG)

 + (void)load{
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
         
         [LGRuntimeTool lg_betterMethodSwizzlingWithClass:self oriSEL:@selector(helloword) swizzledSEL:@selector(lg_studentInstanceMethod)];

     });
 }

 helloworld(SEL)->lg_studentInstanceMethod(imp)
 lg_studentInstanceMethod(SEL)-//>hellopworld(imp) 交换不成功 找不到hellopworld的imp所以走自己的imp即lg_studentInstanceMethod(imp)，导致不断的打印LGStudent分类添加的lg对象方法
 - (void)lg_studentInstanceMethod{
     NSLog(@"LGStudent分类添加的lg对象方法:%s",__func__);
     [self lg_studentInstanceMethod];
 }
 @end
 // 从而得出最终的方法交换
 + (void)lg_bestMethodSwizzlingWithClass:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL{
     
     if (!cls) NSLog(@"传入的交换类不能为空");
     
     Method oriMethod = class_getInstanceMethod(cls, oriSEL);
     Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
     if (!oriMethod) {
         class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
         method_setImplementation(swiMethod, imp_implementationWithBlock(^(id self, SEL _cmd){ }));
     }

     BOOL didAddMethod = class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
     if (didAddMethod) {
         class_replaceMethod(cls, swizzledSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
     }else{
         method_exchangeImplementations(oriMethod, swiMethod);
     }
 }
 
 struct objc_method {
     SEL _Nonnull method_name                                 OBJC2_UNAVAILABLE;
     char * _Nullable method_types                            OBJC2_UNAVAILABLE;
     IMP _Nonnull method_imp                                  OBJC2_UNAVAILABLE;
 }
 

 
 MARK: ---runtime面试
 method_swizzling  要放在load方法执行，因为load方法他在main函数之前执行，并且是自动执行的，而且具有唯一性，不会被覆盖（分类覆盖原类方法）
 
 #import <objc/runtime.h>
 objc_getClass("__NSArrayI")
 
 如果主动调用load，相当于方法又换回去了，给load方法加上dispatch_once保证只交换一次
 
 MARK: ---消息发送流程
 objc_msgSend->lookupImpOrForward
 lookupImpOrForward没有找到imp会调_class_resolveMethod,给你动态添加方法的机会
 _class_resolveMethod根据判断cls是否是元类，分别调用_class_resolveInstanceMethod或者_class_resolveClassMethod
 _class_resolveInstanceMethod->loopupImpOrNil 查找的是添加方法的imp
 _objc_msgForward_impcache
 loopupImpOrNil 方法的
 
 每个oc方法都有两个隐式参数id self, SEL _cmd
 
 Man的test没有实现
 ((void(*)(id, SEL))_objc_msgForward)([Man new], @selector(test))调用不会走resolveInstanceMethod这是他与objc_msgSend的区别，他会走
 forwardingTargetForSelector 和 forwardInvocation（这两个才是真正的消息转发）
 如果Man的test实现了
 ((void(*)(id, SEL))_objc_msgForward)([Man new], @selector(test))调用的话，他不管你的方法有没有实现，都会走消息转发
 _objc_msgForward是个IMP调用它会触发消息转发流程
 
 JSPath就用到了_objc_msgForward
 Aspects用了_objc_msgForward达到方法交换的目的
 
 Person类有个类方法testClass（从元类里面找，沿着继承链一直找到根元类），没有实现，有个Person的分类实现了testClass的实例方法
 调用[Person testClass]会调用testClass实例方法
 因为根元类的父类指向根类NSObject，查看有没有同名的实例方法实现。最终都是经过NSObject，从而进入消息转发流程
 
 MARK: ---[self class]&&[super class]
 Man: Person
 在Man调用[self class]&&[super class]
 object_getClass(obj)=>obj->getIsa
 
 objc_msgSend(self, sel_registerName("class"))
 objc_msgSendSuper({self, class_getSuperclass(objc_getClass("Man"))}, sel_registerName("class"))
 我的理解是：都没重写class，最终调用NSObject的class即object_getClass(obj)，obj都是self，即都得到Man
 
 
 
 MARK: ---1.objc对象的isa的指针指向什么
 指向他的类对象,从而可以找到对象上的方法
 
 Root class (class)其实就是NSObject，NSObject是没有超类的，所以Root class(class)的superclass指向nil
 每个Class都有一个isa指针指向唯一的Meta class
 Root class(meta)的superclass指向Root class(class)，也就是NSObject
 每个Meta class的isa指针都指向Root class (meta)。
 
 MARK: ---2.一个 NSObject 对象占用多少内存空间(和内存对齐有关)
 http://opensource.apple.com/tarballs/ 搜索objc
 内存对齐：OC对象就是C++结构体，而结构体的内存大小必须是最大成员大小的倍数
 系统内存分配了16个字节空间给NSObject对象，但是在64位环境下，NSObject实际只使用了8个字节
 
 NSObject:
 struct NSObject_IMPL {
 Class isa; // 8个字节//isa是指向类对象的指针变量
 };
 结构体的地址就是第一个成员变量的地址
 
 class_getInstanceSize([NSObject Class])
 一个 NSObject 实例对象成员变量所占的大小，实际上是 8 字节
 本质是:
 size_t class_getInstanceSize(Class cls)
 {
     if (!cls) return 0;
     return cls->alignedInstanceSize();
 }
 
 malloc_size((__bridge const void *)obj);方法可以查看系统分配给obj的内存的大小: 16 字节
 
 对象在分配内存空间时，会进行内存对齐，所以在 iOS 中，分配内存空间都是 16字节 的倍数
 
 allocWithZone这个方法，查看创建一个对象是内存是怎么分配
 ->class_createInstance
 ->_class_createInstanceFromZone:   instanceSize(size_t extraBytes)内部实现为所有对象至少分配16 bytes 的大小
 
 
 @interface Person : NSObject{
 @public
 int _number;
 int _age;
 }
 @end

 @implementation Person

 @end

 @interface Student : Person{
 @public
 int _height;
 }
 @end

 @implementation Student

 @end
 
 struct Student_IMPL {
 struct Person_IMPL Person_IVARS;// 16
 int _height;
 };

 struct Person_IMPL {
 struct NSObject_IMPL NSObject_IVARS;// 8
 int _number;// 4
 int _age;// 4
 };

 struct NSObject_IMPL {
 Class isa;// 8
 };

 内存分配根据内存对齐:16 + 4 => 16 + 16 => 32  malloc_size
 实际占用:24 class_getInstanceSize
 
 MARK: ---class_rw_t && class_ro_t
 https://www.jianshu.com/u/24d715499bcf
 class_rw_t
 rw readwrite 内部信息可读可写的
 内部包含的信息来源时runtime时动态添加的，比如分类中的方法会在运行时添加到method_array_t中
 
 class_rw_t 提供了运行时对类拓展的能力，存有类的方法、属性（成员变量）、协议等信息。class_rw_t 的内容是可以在运行时被动态修改的，可以说运行时对类的拓展大都是存储在这里的

 class_ro_t
 ro readonly 内部信息只读
 内部为类编译器生成的信息，不可添加和删除
 
 class_ro_t 存储的大多是类在编译时就已经确定的信息
 
 MARK: ---3.class_rw_t
 rw代表可读可写
 ObjC 类中的属性、方法还有遵循的协议等信息都保存在 class_rw_t
 // 可读可写
 struct class_rw_t {
     // Be warned that Symbolication knows the layout of this structure.
     uint32_t flags;
     uint32_t version;

     const class_ro_t *ro; // 指向只读的结构体,存放类初始信息

     
      这三个都是二位数组，是可读可写的，包含了类的初始内容、分类的内容。
      methods中，存储 method_list_t ----> method_t
      二维数组，method_list_t --> method_t
      这三个二位数组中的数据有一部分是从class_ro_t中合并过来的。

     method_array_t methods; // 方法列表（类对象存放对象方法，元类对象存放类方法）
     property_array_t properties; // 属性列表
     protocol_array_t protocols; //协议列表

     Class firstSubclass;
     Class nextSiblingClass;
     
     //...
     }
 
 MARK: ---4.class_ro_t
 存储了当前类在编译期就已经确定的属性、方法以及遵循的协议
 
 struct class_ro_t {
     uint32_t flags;
     uint32_t instanceStart;
     uint32_t instanceSize;
     uint32_t reserved;

     const uint8_t * ivarLayout;

     const char * name;
     method_list_t * baseMethodList;
     protocol_list_t * baseProtocols;
     const ivar_list_t * ivars;

     const uint8_t * weakIvarLayout;
     property_list_t *baseProperties;
 };
 baseMethodList，baseProtocols，ivars，baseProperties都是一维数组
 
 MARK: ---5.isa 有两种类型:
 纯指针，指向内存地址
 NON_POINTER_ISA，除了内存地址，还存有一些其他信息
 
 MARK: ---6.Runtime 的方法缓存
 // 缓存曾经调用过的方法，提高查找速率
 struct cache_t {
     struct bucket_t *_buckets; // 散列表
     mask_t _mask; //散列表的长度 - 1
     mask_t _occupied; // 已经缓存的方法数量，散列表的长度使大于已经缓存的数量的。
     //...
 }
 
 struct bucket_t {
     cache_key_t _key; //SEL作为Key @selector()
     IMP _imp; // 函数的内存地址
     //...
 }
 
 bucket_t 中存储的是 SEL 和 IMP的键值对
 
 如果是有序方法列表，采用二分查找
 如果是无序方法列表，直接遍历查找
 
 查找的过程:
 // 查询散列表，k
 bucket_t * cache_t::find(cache_key_t k, id receiver)
 {
     assert(k != 0); // 断言

     bucket_t *b = buckets(); // 获取散列表
     mask_t m = mask(); // 散列表长度 - 1
     mask_t begin = cache_hash(k, m); // & 操作
     mask_t i = begin; // 索引值
     do {
         if (b[i].key() == 0  ||  b[i].key() == k) {
             return &b[i];
         }
     } while ((i = cache_next(i, m)) != begin);
     // i 的值最大等于mask,最小等于0。

     // hack
     Class cls = (Class)((uintptr_t)this - offsetof(objc_class, cache));
     cache_t::bad_cache(receiver, (SEL)k, cls);
 }
 上面是查询散列表函数，其中cache_hash(k, m)是静态内联方法，将传入的key和mask进行&操作返回uint32_t索引值。do-while循环查找过程，当发生冲突cache_next方法将索引值减1。
 
 MARK: ---7.关联对象释放
 它们会在被 NSObject -dealloc 调用的object_dispose()方法中释放
 被关联的对象在生命周期内要比对象本身释放的晚，它们会在被 NSObject -dealloc 调用的object_dispose()方法中释放
 
 1、调用 -release ：引用计数变为零
 对象正在被销毁，生命周期即将结束.
 不能再有新的 __weak 弱引用，否则将指向 nil.
 调用 [self dealloc]

 2、 父类调用 -dealloc
 继承关系中最直接继承的父类再调用 -dealloc
 如果是 MRC 代码 则会手动释放实例变量们（iVars）
 继承关系中每一层的父类 都再调用 -dealloc

 >3、NSObject 调 -dealloc
 只做一件事：调用 Objective-C runtime 中object_dispose() 方法

 >4. 调用 object_dispose()
 为 C++ 的实例变量们（iVars）调用 destructors
 为 ARC 状态下的 实例变量们（iVars） 调用 -release
 解除所有使用 runtime Associate方法关联的对象
 解除所有 __weak 引用
 调用 free()
 
 MARK: ---8.实例对象的数据结构
 struct objc_object {
     isa_t isa;
     //...
 }
 
 MARK: ---9.method swizzling
 进行方法交换
 每个类都有一个方法列表，存放着方法的名字和方法实现的映射关系，selector的本质其实就是方法名，IMP有点类似函数指针，指向具体的Method实现，通过selector就可以找到对应的IMP。
 
 换方法的几种实现方式：
 利用 method_exchangeImplementations 交换两个方法的实现
 利用 class_replaceMethod替换方法的实现
 利用 method_setImplementation 来直接设置某个方法的IMP
 
 SEL originalSelector = @selector(viewWillAppear:);
 SEL swizzledSelector = @selector(fd_viewWillAppear:);
 Method originalMethod = class_getInstanceMethod(class, originalSelector);
 Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
 BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
 if (success) {
     // 主类本身没有实现需要替换的方法，而是继承了父类的实现，即 class_addMethod 方法返回 YES 。
     // 这时使用 class_getInstanceMethod 函数获取到的 originalSelector 指向的就是父类的方法，我们再通过执行 class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
     // 将父类的实现替换到我们自定义的 mrc_viewWillAppear 方法中。这样就达到了在 mrc_viewWillAppear 方法的实现中调用父类实现的目的。
     class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
 } else {
     method_exchangeImplementations(originalMethod, swizzledMethod);
 }
 
 MARK: ---10.什么时候会报unrecognized selector的异常
 在向一个对象发送消息时，runtime库会根据对象的isa指针找到该对象实际所属的类，然后在该类中的方法列表以及其父类方法列表中寻找方法运行，如果，在最顶层的父类中依然找不到相应的方法时，会进入消息转发阶段，如果消息三次转发流程仍未实现，则程序在运行时会挂掉并抛出异常unrecognized selector sent to XXX
 
 MARK: ---11.如何给 Category 添加属性？关联对象以什么形式进行存储？
 关联对象
 关联对象 以哈希表的格式，存储在一个全局的单例中
 
 MARK: ---12.类对象的数据结构
 struct objc_class : objc_object {
 // Class ISA;
 Class superclass; //父类指针
 cache_t cache;             // formerly cache pointer and vtable 方法缓存
 class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags 用于获取地址

 class_rw_t *data() {
     return bits.data(); // &FAST_DATA_MASK 获取地址值
 }
 
 isa：指向元类
 superClass: 指向父类
 Cache: 方法的缓存列表
 data: 顾名思义，就是数据。是一个被封装好的 class_rw_t
 
 MARK: ---13.底层原理：category
 https://www.jianshu.com/p/5c16a3172afd
 我们每增加一个分类，编译后就会多一个_category_t的结构体
 然后在运行时阶段，把所有分类的结构体全部动态合并到我们类里面去
 结构体包含下面几种常见数据类型
 const struct _method_list_t *instance_methods;
 const struct _method_list_t *class_methods;
 const struct _protocol_list_t *protocols;
 const struct _prop_list_t *properties;

 “ _category_t”的结构两个参数对应着实例方法和类方法,最后两个参数为0，是因为我们的分类没有遵守协议也没有添加属性
 实例方法和类方法，而且这两个方法编译后也是以结构体的形式存在
 在运行时阶段，才会真正的把结构体里面的数据合并到我们的类里面去
 
 objc-os.mm 文件，这里是运行时方法的入口
 -> _objc_init 方法，点击 &map_images 参数
 ->再点击 map_images_nolock 方法
 hCount 是用来查找所有oc元数据模块的
 通过搜索 hCount ，我们可以看到一个叫 _read_images（加载模块） 的方法里面有个参数是传入 totalClasses（所有类）
 Discover categories，很明显接下来部分就是对找到的分类进行处理
 看到熟悉的 category_t 类型,还能看到方法名是叫做 _getObjc2CategoryList（获取分类列表）
 这里有两个是对类重新方法化的处理，分别把class和isa传了进去，这就符合了我们前面提到的，把类方法添加到元类对象的方法列表，把实例方法等添加到类对象的方法列表
 ->方法 attachCategories
 这里会有一个参数 isMeta 记录传进来的是否是元类对象。然后调用malloc函数开辟存储空间创建一个方法列表的二维数组（属性列表和协议列表同理），然后用 while 循环，根据是否为元类对象，取出对应的类方法或者实例方法，然后把方法数组添加到前面创建的二维数组中（属性和协议处理方法同理）
 把分类中所有的方法，属性，协议全部添加到类中去
 ->attachLists
 这里将是内存分配最重要一环
 在这个方法里重新计算了列表新的长度，并且调用 realloc 重新分配了新的内存空间。接下来调用 memmove 方法，把原来的方法列表向后移动，前面留出了新列表的长度，再调用 memcpy 方法，把新方法列表插入到整个列表最前面
 这一步内存移动的体现是，如果我们在分类中添加和原类中同名的方法时，我们调用该方法时会优先调用分类的方法，究其原因就是我们分类的方法在方法列表中重新插入在最前面，所以会优先调用，这也是我们常说的分类方法会覆盖原方法的原因
 
 总结:
 每创建一个分类，编译时就会生成一个 _category_t 的结构体，里面包含着分类的所有信息（方法，属性，协议）
 在运行时阶段，分类的所有信息（方法，属性，协议）会被分别读取，并且逐一添加到类里面去
 由于内存操作的原因，分类的方法会排在方法列表最前面，所以分类方法会优先于原类方法的调用（所谓的分类方法覆盖，本质是排序超前）
 
 
 MARK: Category 在编译过后，是在什么时机与原有的类合并到一起的：
 程序启动后，通过编译之后，Runtime 会进行初始化，调用 _objc_init。
 然后会 map_images。
 接下来调用 map_images_nolock。
 再然后就是 read_images，这个方法会读取所有的类的相关信息。
 最后是调用 reMethodizeClass:，这个方法是重新方法化的意思。
 在 reMethodizeClass: 方法内部会调用 attachCategories: ，这个方法会传入 Class 和 Category ，会将方法列表，协议列表等与原有的类合并。最后加入到 class_rw_t 结构体中
 
 Category 被添加在了 class_rw_t 的对应结构里
 Category 实际上是 Category_t 的结构体
 Category 在刚刚编译完的时候，和原来的类是分开的，只有在程序运行起来后，通过 Runtime ，Category 和原来的类才会合并到一起
 
 mememove，memcpy：这俩方法是位移、复制，简单理解就是原有的方法移动到最后，根根新开辟的空间，把前面的位置留给分类，然后分类中的方法，按照倒序依次插入，可以得出的结论就就是，越晚参与编译的分类，里面的方法才是生效的那个
 
 MARK: ---14.能否向编译后得到的类中增加实例变量？能否向运行时创建的类中添加实例变量？
 不能向编译后得到的类中增加实例变量；
 能向运行时创建的类中添加实例变量；

 1.因为编译后的类已经注册在 runtime 中,类结构体中的 objc_ivar_list 实例变量的链表和 instance_size 实例变量的内存大小已经确定，同时runtime会调用 class_setIvarlayout 或 class_setWeaklvarLayout 来处理strong weak 引用.所以不能向存在的类中添加实例变量。
 2.运行时创建的类是可以添加实例变量，调用class_addIvar函数. 但是的在调用 objc_allocateClassPair 之后，objc_registerClassPair 之前,
 
 MARK: ---15._objc_msgForward
 objc_msgForward在进行消息转发的过程中会涉及以下这几个方法：
 resolveInstanceMethod:方法 (或resolveClassMethod:)。
 forwardingTargetForSelector:方法
 methodSignatureForSelector:方法
 forwardInvocation:方法
 doesNotRecognizeSelector: 方法

 MARK: ---16.代码题
 @implementation Son : Father
 - (id)init {
     self = [super init];
     if (self) {
         NSLog(@"%@", NSStringFromClass([self class]));// son
         NSLog(@"%@", NSStringFromClass([super class]));// son
     }
     return self;
 }
 @end
 Son 及 Father 都没有实现 -(Class)calss 方法，所以这里所有的调用最终都会找到基类 NSObject 中，并且在其中找到 -(Class)calss 方法
 - (Class)class {
     return object_getClass(self);
 }
 
 Class object_getClass(id obj)
 {
     if (obj) return obj->getIsa();
     else return Nil;
 }
 最终这个方法返回的是，调用这个方法的 objc 的 isa 指针
 当利用 super 调用方法时，只要编译器看到super这个标志，就会让当前对象去调用父类方法，本质还是当前对象在调用，是去父类找实现，super 仅仅是一个编译指示器。但是消息的接收者 receiver 依然是self。最终在 NSObject 获取 isa 指针的时候，获取到的依旧是 self 的 isa，所以，我们得到的结果是：Son
 
 
 @interface Father : NSObject
 @end

 @implementation Father

 - (Class)class {
     return [Father class];
 }

 @end

 ---

 @interface Son : Father
 @end

 @implementation Son

 - (id)init {
     self = [super init];
     if (self) {
         NSLog(@"%@", NSStringFromClass([self class]));
         NSLog(@"%@", NSStringFromClass([super class]));
     }
     return self;
 }

 @end
 
 ---输出：---
 Father
 Father
 
 在调用[super class]的时候，runtime会去调用objc_msgSendSuper方法，而不是objc_msgSend
 
 MARK: ---17.runtime如何实现weak变量的自动置nil
 runtime 对注册的类会进行布局，对于 weak 修饰的对象会放入一个 hash 表中。 用 weak 指向的对象内存地址作为key，当此对象的引用计数为0的时候会 dealloc，假如 weak 指向的对象内存地址是a，那么就会以a为键， 在这个 weak表中搜索，找到所有以a为键的 weak 对象，从而设置为 nil

 1.初始化时：runtime会调用objc_initWeak函数，初始化一个新的weak指针指向对象的地址。
 2.添加引用时：objc_initWeak函数会调用objc_storeWeak() 函数， objc_storeWeak()的作用是更新指针指向，创建对应的弱引用表。
 3.释放时,调用clearDeallocating函数。clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录

 {
     NSObject *obj = [[NSObject alloc] init];
     id __weak obj1 = obj;
 }
 
  id obj1;
  objc_initWeak(&obj1, obj);
  obj引用计数变为0，变量作用域结束
  objc_destroyWeak(&obj1);
 
 objc_initWeak函数将“附有weak修饰符的变量（obj1）”初始化为0（nil）后，会将“赋值对象”（obj）作为参数，调用objc_storeWeak函数。
 obj1 = 0；
 obj_storeWeak(&obj1, obj);

 其实Weak表是一个hash（哈希）表，Key是weak所指对象的地址，Value是weak指针的地址（这个地址的值是所指对象指针的地址）数组
 
 */

// MARK: 图像
/**
 1.图像的压缩方式有哪些
 压缩图片质量
 一般情况下使用UIImageJPEGRepresentation或UIImagePNGRepresentation方法实现。
 压缩图片尺寸
 一般通过指定压缩的大小对图像进行重绘
 */

// MARK: OC底层
/**
 1.属性关键字
 1.读写权限：readonly,readwrite(默认)
 2.原子性: atomic(默认)，nonatomic。atomic读写线程安全，但效率低，而且不是绝对的安全，比如如果修饰的是数组，那么对数组的读写是安全的，但如果是操作数组进行添加移除其中对象的还，就不保证安全了。
 3.引用计数：
 retain/strong
 assign：修饰基本数据类型，修饰对象类型时，不改变其引用计数，会产生悬垂指针，修饰的对象在被释放后，assign指针仍然指向原对象内存地址，如果使用assign指针继续访问原对象的话，就可能会导致内存泄漏或程序异常
 weak：不改变被修饰对象的引用计数，所指对象在被释放后，weak指针会自动置为nil
 copy：分为深拷贝和浅拷贝
 浅拷贝：对内存地址的复制，让目标对象指针和原对象指向同一片内存空间会增加引用计数
 深拷贝：对对象内容的复制，开辟新的内存空间
 
 可变对象的copy和mutableCopy都是深拷贝
 不可变对象的copy是浅拷贝，mutableCopy是深拷贝
 copy方法返回的都是不可变对象

 */

// MARK: main
/**
 根据main()函数，来分析下UIApplicationMain()做的事情：
 1. 根据传入的principalClassName,创建一个UIApplication对象
 2. 根据传入的delegateClassName,创建一个遵守UIApplicationDelegate协议的对象，默认情况下是AppDelegate对象
 3. UIApplication对象中有一个属性是 delegate,第2步生成的类赋值给UIApplication对象的delegate属性。
 4. 之后开启一个runloop，也就是主runloop，处理事件。
 
 根控制器的创建：
 一个UIWindow必须要有rootViewController，app启动之后会创建一个UIWindow
 app启动后，会加载info.plist文件，如果在info.plist文件中指定了main.storyboard，那么就去加载main.storyboard,根据main.storyboard初始化控制器，并将该控制器赋值给UIWindow的rootViewController属性。如果没有指定main.storyboard,需要手动创建UIViewController，并赋值给UIWindow的rootViewController。手动创建的操作通常是在

 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
  {
     return YES;
 }
 */

// MARK: XNU
/**
 iOS系统来说，操作系统内核是XNU（X is not Unix）
 
 XNU内核启动后，启动的第一个进程是launchd
 
 load_machfile将Mach-O文件映射到内存
 ->parse_machfile()函数做的工作主要有3个
 （1）Mach-O文件的解析，以及对每个segment进行内存分配；（2）dyld的加载（3）dyld的解析以及虚拟内存分配
 dyld同样是Mach-O类型的文件
 
 thread_setentrypoint函数实际上设置入口地址，设置的是_dyld_start函数的入口地址
 _dyld_start是dyld起始函数，dyld是运行在用户态的，也就是从这里开始，内核态切换到了用户态
 
 app启动过程中，首先是操作系统内核进行一些处理，比如新建进程，分配内存等
 XNU将Mach-O文件加载到内存中，实际上后续用户态的dyld还要做一些工作
 dyld，即动态链接器，用于加载动态库。dyld是运行在用户态的，从XNU到dyld，完成了一次内核态到用户态的切换
 
 这里调用了dyldbootstrap::start()函数，此函数会完成动态库加载过程，并返回主程序main函数入口
 dyldbootstrap::start()函数调用dyld中的_main()函数，_main()函数返回主程序的main函数入口，也就是我们App的main函数地址
 
 _main()函数做的事情也比较多。主要完成了上下文的建立，主程序初始化成ImageLoader对象，加载共享的系统动态库，加载依赖的动态库，链接动态库，初始化主程序，返回主程序main()函数地址
 instantiateFromLoadedImage()函数主要是将主程序Mach-O文件转变成了一个ImageLoader对象，用于后续的链接过程
 在app启动过程中，主程序和其相关的动态库，最后都被转化成了一个ImageLoader对象
 
 mapSharedCache()负责将系统中的共享动态库加载进内存空间，比如UIKit就是动态共享库，这也是不同的App之间能够实现动态库共享的机制。不同App间访问的共享库最终都映射到了同一块物理内存，从而实现了共享动态库
 mapSharedCache()的主要逻辑就是：先判断共享动态库是否已经映射到内存中了，如果已经存在，则直接返回；否则打开缓存文件，并将共享动态库映射到内存中
 
 在将主程序以及其环境变量中的相关动态库都转成ImageLoader对象之后，dyld会将这些ImageLoader链接起来，链接使用的是ImageLoader自身的link()函数
 link()函数中主要做了以下的工作：
 1. recursiveLoadLibraries递归加载所有的依赖库
 2. recursiveRebase递归修正自己和依赖库的基址
 3. recursiveBind递归进行符号绑定
 在递归加载所有的依赖库的过程中，加载的方法是调用loadLibrary()函数，实际最终调用的还是load()方法。经过link()之后，主程序以及相关依赖库的地址得到了修正，达到了进程可用的目的
 
 link()函数执行完毕后，会调用initializeMainExecutable()函数，可以将该函数理解为一个初始化函数。实际上，一个app启动的过程中，除了dyld做一些工作外，还有一个重要的角色，就是runtime，而且runtime和dyld是紧密联系的。runtime里面注册了一些dyld的回调通知，这些通知是在runtime初始化的时候注册的。其中有一个通知是，当有新的镜像加载时，会执行runtime中的load-images()函数
 load_images()中首先调用了prapare_load_methods()函数，接着调用了call_load_methods()函数
 prepare_load_methods->调用_getObjc2NonlazyClassList获取到了所有类的列表.而remapClass是取得该类对应的指针，然后调用了schedule_class_load()函数
 在将子类添加到加载列表之前，其父类一定会优先加载到列表中。这也是为何父类的+load方法在子类的+load方法之前调用的根本原因
 call_load_methods->主要调用了call_class_loads()函数
 其主要逻辑就是从待加载的类列表loadable_classes中寻找对应的类，然后找到@selector(load)的实现并执行

 getThreadPC是ImageLoaderMachO中的方法，主要功能是获取app main函数的地址
 该函数的主要逻辑就是遍历loadCommand，找到’LC_MAIN’指令，得到该指令所指向的便宜地址，经过处理后，就得到了main函数的地址，将此地址返回给__dyld_start。__dyld_start中将main函数地址保存在寄存器后，跳转到对应的地址，开始执行main函数，至此，一个app的启动流程正式完成

 uintptr_t
 _main(const macho_header* mainExecutableMH, uintptr_t mainExecutableSlide,
         int argc, const char* argv[], const char* envp[], const char* apple[],
         uintptr_t* startGlue)
 {
     uintptr_t result = 0;
     sMainExecutableMachHeader = mainExecutableMH;
     // 处理环境变量，用于打印
     if ( sEnv.DYLD_PRINT_OPTS )
         printOptions(argv);
     if ( sEnv.DYLD_PRINT_ENV )
         printEnvironmentVariables(envp);
     try {
         // 将主程序转变为一个ImageLoader对象
         sMainExecutable = instantiateFromLoadedImage(mainExecutableMH, mainExecutableSlide, sExecPath);
         if ( gLinkContext.sharedRegionMode != ImageLoader::kDontUseSharedRegion ) {
             // 将共享库加载到内存中
             mapSharedCache();
         }
         // 加载环境变量DYLD_INSERT_LIBRARIES中的动态库，使用loadInsertedDylib进行加载
         if  ( sEnv.DYLD_INSERT_LIBRARIES != NULL ) {
             for (const char* const* lib = sEnv.DYLD_INSERT_LIBRARIES; *lib != NULL; ++lib)
                 loadInsertedDylib(*lib);
         }
         // 链接
         link(sMainExecutable, sEnv.DYLD_BIND_AT_LAUNCH, true, ImageLoader::RPathChain(NULL, NULL), -1);
         // 初始化
         initializeMainExecutable();
         // 寻找main函数入口
         result = (uintptr_t)sMainExecutable->getThreadPC();
     }
     return result;
 }
 */

// MARK: 组件化
/**
 MARK: ===Carthage 和 CoaoaPods 的区别
 CoaoaPods 是一套整体解决方案，我们在 Podfile 中指定好我们需要的第三方库。然后 CocoaPods 就会进行下载，集成，然后修改或者创建我们项目的 workspace 文件，这一系列整体操作。

 相比之下，Carthage 就要轻量很多，它也会一个叫做 Cartfile 描述文件，但 Carthage 不会对我们的项目结构进行任何修改，更不多创建 workspace。它只是根据我们描述文件中配置的第三方库，将他们下载到本地，然后使用 xcodebuild 构建成 framework 文件。然后由我们自己将这些库集成到项目中。Carthage 使用的是一种非侵入性的哲学。

 另外 Carthage 除了非侵入性，它还是去中心化的，它的包管理不像 CocoaPods 那样，有一个中心服务器(cocoapods.org)，来管理各个包的元信息，而是依赖于每个第三方库自己的源地址，比如 Github
 
 CocoaPods (默认)自动建立和更新一个 Xcode workspace，用来管理你的项目和所有依赖。Carthage 使用xcodebuild 来编译出二进制库，剩下的集成工作完全交给开发人员。
 CocoaPods 使用起来方便，Carthage 更加灵活并且对现有项目没有太多的侵略性。
 */

// MARK: 算法
/**
 1.数组中的全部元素异或消掉出现两次的数字
 
 MARK: 排序
 1.选择排序将已排序部分定义在左端，然后选择未排序部分的最小元素和未排序部分的第一个元素交换。
 void selectSort(int *arr, int length) {
     for (int i = 0; i < length - 1; i++) { //趟数
         for (int j = i + 1; j < length; j++) { //比较次数
             if (arr[i] > arr[j]) {
                 int temp = arr[i];
                 arr[i] = arr[j];
                 arr[j] = temp;
             }
         }
     }
 }

 2.冒泡排序将已排序部分定义在右端，在遍历未排序部分的过程执行交换，将最大元素交换到最右端。
 void bublleSort(int *arr, int length) {
     for(int i = 0; i < length - 1; i++) { //趟数
         for(int j = 0; j < length - i - 1; j++) { //比较次数
             if(arr[j] > arr[j+1]) {
                 int temp = arr[j];
                 arr[j] = arr[j+1];
                 arr[j+1] = temp;
             }
         }
     }
 }

 3.插入排序将已排序部分定义在左端，将未排序部分元的第一个元素插入到已排序部分合适的位置。

 */

// MARK: 性能优化
/**
 假设一个图层(CALayer)就是一个纹理(Texture)
 由于上面的是一个完全不透明的图层，所以上面的图层会部份遮盖掉下面的图层，而在遮盖掉的矩形区域内，GPU会直接使用上面图层的像素来显示
 如果我们最底的图层上放置的是一个有透明度的图层，那么在这个矩形区域里，GPU需要混合上下两个图层来计算出在屏幕上显示出来的像素的RGB值
 我们要做的就是避免像素混合，尽可能地为视图设置背景色，且设置opaque为YES，这会大大减少GPU的计算
 
 MARK: 检测图层混合
 1、模拟器debug- 选中 color blended layers红色区域表示图层发生了混合
 2、Instrument-选中Core Animation-勾选Color Blended Layers

 避免图层混合：
 1、确保控件的opaque属性设置为true，确保backgroundColor和父视图颜色一致且不透明
 2、如无特殊需要，不要设置低于1的alpha值
 3、确保UIImage没有alpha通道
 
 MARK: 检测离屏渲染
 1、模拟器debug-选中color Offscreen - Renderd离屏渲染的图层高亮成黄 可能存在性能问题
 2、真机Instrument-选中Core Animation-勾选Color Offscreen-Rendered Yellow
 
 离屏渲染就是在当前屏幕缓冲区以外，新开辟一个缓冲区进行操作
 
 如果 CPU GPU 累计耗时 16.67 毫秒还没有完成，就会造成卡顿掉帧

 将不在GPU的当前屏幕缓冲区中进行的渲染都称为离屏渲染，那么就还有另一种特殊的“离屏渲染”方式：CPU渲染。如果我们重写了drawRect方法，并且使用任何Core Graphics的技术进行了绘制操作，就涉及到了CPU渲染。整个渲染过程由CPU在App内同步地完成，渲染得到的bitmap最后再交由GPU用于显示

 三个选择：当前屏幕渲染、离屏渲染、CPU渲染
 
 由于GPU的浮点运算能力比CPU强，CPU渲染的效率可能不如离屏渲染；但如果仅仅是实现一个简单的效果，直接使用CPU渲染的效率又可能比离屏渲染好，毕竟离屏渲染要涉及到缓冲区创建和上下文切换等耗时操作
 
 在OpenGL中，GPU有2种渲染方式:
 On-Screen Rendering：当前屏幕渲染，在当前用于显示的屏幕缓冲区进行渲染操作
 Off-Screen Rendering：离屏渲染，在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作

 离屏渲染消耗性能的原因:
 需要创建新的缓冲区
 离屏渲染的整个过程，需要多次切换上下文环境，先是从当前屏幕（On-Screen）切换到离屏（Off-Screen）；等到离屏渲染结束以后，将离屏缓冲区的渲染结果显示到屏幕上，又需要将上下文环境从离屏切换到当前屏幕
 
 会触发离屏渲染:
 圆角 （maskToBounds并用才会触发）
 图层蒙版
 阴影
 光栅化
 
 MARK: 降低 APP 包的大小
 1.可执行文件
 利用 AppCode 检测未使用的代码：菜单栏 -> Code -> Inspect Code
 
 2.资源
 资源包括 图片、音频、视频等
 对资源进行无损的压缩
 去除没有用到的资源https://github.com/tinymind/LSUnusedResources
 
 MARK: 优化 `APP` 的电量
 CPU 处理
 定位
 网络
 图像
 
 1.尽可能降低 CPU、GPU 的功耗
 2.尽量少用 定时器。
 3.优化 I/O 操作。
 不要频繁写入小数据，而是积攒到一定数量再写入
 读写大量的数据可以使用 Dispatch_io ，GCD 内部已经做了优化。
 数据量比较大时，建议使用数据库
 4.网络方面的优化
 减少压缩网络数据 （XML -> JSON -> ProtoBuf），如果可能建议使用 ProtoBuf。
 如果请求的返回数据相同，可以使用 NSCache 进行缓存
 使用断点续传，避免因网络失败后要重新下载。
 网络不可用的时候，不尝试进行网络请求
 长时间的网络请求，要提供可以取消的操作
 采取批量传输。下载视频流的时候，尽量一大块一大块的进行下载，广告可以一次下载多个
 5.定位层面的优化
 如果只是需要快速确定用户位置，最好用 CLLocationManager 的 requestLocation 方法。定位完成后，会自动让定位硬件断电
 如果不是导航应用，尽量不要实时更新位置，定位完毕就关掉定位服务
 尽量降低定位精度，比如尽量不要使用精度最高的 kCLLocationAccuracyBest
 需要后台定位时，尽量设置 pausesLocationUpdatesAutomatically 为 YES，如果用户不太可能移动的时候系统会自动暂停位置更新
 尽量不要使用 startMonitoringSignificantLocationChanges，优先考虑 startMonitoringForRegion:
 6.硬件检测优化
 用户移动、摇晃、倾斜设备时，会产生动作(motion)事件，这些事件由加速度计、陀螺仪、磁力计等硬件检测。在不需要检测的场合，应该及时关闭这些硬件

 MARK: `tableview` 的流畅度
 https://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/
 使用reuseIdentifier来重用cells
 缓存行高
 
 CPU 层面
 1.Autolayout 会比直接设置 frame 消耗更多的 CPU 资源
 2.图片的 size 最好刚好跟 UIImageView 的 size 保持一致
 3.控制一下线程的最大并发数量
 4.尽量把耗时的操作放到子线程
 文本处理（尺寸计算、绘制）
 图片处理（解码、绘制）
 
 GPU层面
 尽量减少视图数量和层次
 减少透明的视图（alpha<1），不透明的就设置 opaque 为 YES
 尽量避免出现离屏渲染
 
 保持界面流畅的技巧
 1.预排版，提前计算
 2.预渲染，提前绘制
 3.图片异步加载
 
 MARK: 光栅化
 使用 UITableView 和 UICollectionView 时经常会遇到各个 Cell 的样式是一样的，这时候我们可以使用这个属性提高性能：
 cell.layer.shouldRasterize=YES;
 cell.layer.rasterizationScale=[[UIScreenmainScreen]scale]
 

 */

/**
 MARK: ===进阶
 MARK: ---runloop
 它是一个对象，他是运行循环，使程序进入do...while循环
 消息机制处理模式，消息交给runloop处理
 void CFRunLoopRun(void)
 
 作用：
 保持程序的持续运行
 处理app中的各种事件（触摸，定时器，performSelector）
 节约cpu资源，提高程序的性能，该做事就做事，该休息就休息
 
 port:端口
 
 timer:
 __CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__，它是个静态方法  表示runloop正在调用一个定时器的回调函数，然后走timer的回调
 
 performSelector:afterDelay: 也是__CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__
 
 dispatch_async(mainQueue, {}): 一定要mainQueue，__CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__
 
 __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__// onserver
 __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__//block
 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__// 相应source0
 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__// source1
 
 CF框架是开源的
 lldb: bt打印堆栈
 
 CFMutableDictionaryRef:
 线程: 对应runloop
 
 通过线程创建runloop
 CFRunLoopRef mainLoop = _CFRunLoopCreate(pthread_main_thread_np())
 
 struct __CFRunLoop {
 __CFPort _wakeUpPort;// used for CFRunLoopWakeUp
 }
 
 子线程的runloop默认不开启
 timer依赖于runloop
 // timer加入的mode和我们现在的runloop mode相等 || (timer加入的mode == kCFRunLoopCommonModes && rl->commonModes 包含当前的mode)
 [[NSRunLoop currentRunLoop] addTimer: forMode:]
 CFRunLoopAddItemsToCommonModes->根据判断匹配调用CFRunLoopAddTimer()（或者CFRunLoopAddSource,CFRunLoopAddObserver）->把timer#加#到commonModeItems
 RunLoopRun->RunLoopRunSpecific->__CFRunLoopDoBlocks() while循环item这边是#用#
 
 联合体节省内存
 typedef union {
 int a;
 float b;
 } UnionType;
 
 UnionType type;
 type.a = 10;
 &type.a 和&type.b地址一样
 sizeof(UnionType) = 4
 原理可利用位域得到值
 
 source0: 回调函数指针 标记signal为待处理，调用wakeup唤醒runloop处理事件。处理app内部事件
 source1: mach_port & 回调函数指针。port:线程间通讯
 
 
 可以通过临时变量控制线程退出，从而控制runloop（因为timer是基于runloop的），runloop没有意义了，timer也就没有意义了
 */
// MARK: ---weak底层
/**
 SideTable 散列表
 objc_initWeak->storeWeak->_class_initialize
 ->1.weak_unregister_no_lock 2.weak_register_no_lock
 
 weak_register_no_lock->1.(weak_entry_for_referent , append_referrer) 2.(weak_entry_t,  weak_grow_maybe, weak_entry_insert)
 
 oldObject: id referent_id
 location: id *referrer_id
 objc_object *referent = (objc_object *)referent_id
 
 weak_entry_for_referent: 从weakTable(weak_table_t)中根据referent(objc_object)得到entry（weak_entry_t）
 
 weak_unregister_no_lock:移除oldObj
 
 散列表->entry->weak引用对象
 entry哈希表
 weak_register_no_lock:注册newObj
 if (entry = weak_entry_for_referent(weak_table, referent)) {
 append_referrer(entry, referrer)
 } else {
 weak_entry_t new_entry(referent, referrer);
 weak_grow_maybe(weak_table)
 weak_entry_insert(weak_table, &new_entry)
 }
 
 通过SideTable找到weak_table
 weak_table根据referent找到或者创建weak_entry_t
 找到，然后append_referrer(entry, referrer)将新弱引用的对象加进去entry
 没找到，最后weak_entry_insert把entry加入到weak_table
 
 sidetable_clearDeallocating()->weak_clear_no_lock
 
 referrers = entry->referrers;
 
 objc_object **referrer = referrers[i];
 if (referrer) {
 if(*referrer == referent) {
 **referrer = nil;
 }
 }
 weak_entry_remove(weak_table, entry)
 */

// MARK: ---LG_runtime
/**
 https://www.jianshu.com/p/9d649ce6d0b8
 Runtime有两个版本：
 一个是Legacy版本(早期版本) 。
 一个是Modern版本(现行版本)。

 早期版本对应的编程接口：Objective-C 1.0
 现行版本对应的编程接口：Objective-C 2.0
 
 clang -rewrite-objc main.m -o test.cpp

oc对象本质是结构体
 objc_getClass("Person")
 
 class_getSuperclass([inst class])
 
 object_getClass([inst class])
 
 // 这个是c函数，用汇编实现的
 objc_msgSend:发消息要先去找方法
 1.快速：缓存查找cache_t(哈希表) 汇编
 2.慢速：c,c++  lookup
 _objc_msgSend源码分析：汇编部分
 LNilOrTagged
 LGetIsaDone->
 CacheLookup NORMAL (calls imp or objc_msgSend_uncached)->
 1.CacheHit->TailCallCachedImp
 2.CheckMiss->__objc_msgSend_uncached->MethodTableLookup(__class_lookupMethodAndLoadCache3跳转到c,c++ lookup)->TailCallFunctionPointer
 3.add
 
 // ##双下划线-单下划线##
 从汇编__class_lookupMethodAndLoadCache3跳转到c，c++的_class_lookupMethodAndLoadCache3
 ->lookupImpOrForward(Class cls, SEL sel, id inst) ### cls是类的话，inst是实例对象。cls是元类的话，inst是类对象并且object_getClass(inst) == cls,object_getClassName(inst) == "Student",class_getName(cls) == "Student"。
 ->cache_getImp (参数no 肯定不走这个)
 ->checkIsKnownClass 不是的话就fatal_error
 ->(cls->isRealized 判断类是否实现)
 ->没有就走realizeClass // Data赋值
 ->(cls->isInitialized)
 ->没有就走_class_initialize
 
 retry:
 // ###Try this class's cache###
 又会cache_getImp 因为remap(cls) 会重映射
 ->没有的话进行漫长过程的查找方法
 // ###Try this class's method lists:###
 method = getMethodNoSuper_nolock(cls, sel) { methodList: cls->data()->methods.beginLists() ---- cls->data()->methods.endLists() 这个返回查找 search_method_list()}
 if (method) {
 log_and_fill_cache()
 }
 
 // ###Try superclass caches and method lists:###
 // 一直找直到NSObject
 for (Class curClass = cls->superclass; curClass != nil; curClass = curClass->superclass){
 // Superclass cache
 imp = cache_getImp(curClass, sel)
 if(imp){
 if(imp!= (IMP)_objc_msgForward_impcache) {
 log_and_fill_cache()
 }
 }
 
 // Superclass method list
 method = getMethodNoSuper_nolock(curClass, sel)
 if (method) {
 log_and_fill_cache()
 imp = method->imp
 }
 }
 
 // ###动态方法解析### 通过一个变量控制，只会走一次动态方法解析
 No implementation found.Try method resolver once:
 _class_resolverMethod() {
 if (!cls->isMetaClass())// 不是元类
 // try [cls resolveInstanceMethod:sel]
 _class_resolveInstanceMethod() // 如果是对象方法走这个,它的实现里面的bool resolved = msg(cls, SEL_resolveInstanceMethod, sel)的cls是类对象
 } else {
 // 如果类方法没有实现: try [nonMetaClass resolverClassMethod:sel] and [cls resolveInstanceMethod:sel]
 // Person(类方法) - 元类(实例方法) - 根元类(实例方法) - NSObject(实例方法)
 _class_resolveClassMethod()
 
 if(!lookUpImpOrNil()){
 _class_resolveInstanceMethod()// 它的实现里面的bool resolved = msg(cls, SEL_resolveInstanceMethod, sel)的cls是元类
 }
 }
 
 // ###_class_resolveInstanceMethod它的实现###
 _class_resolveInstanceMethod(){
 // 后3个参数：initialize，cache，resolver
 if(!lookupImpOrNil(cls->ISA(), SEL_resolveInstanceMethod, cls, NO, YES, NO)) {// ###
 // resolver not implemented
 return;
 }
 BOOL (*msg)(Class, SEL, SEL) = (typeof(msg))objc_msgSend;
 // 系统帮忙发送了一次消息
 bool resolved = msg(cls, SEL_resolveInstanceMethod, sel)// 可以在这块动态添加方法，然后下一步就能找到imp了,###这个cls是类对象
 IMP imp = lookupImpOrNil(cls, sel, inst, NO, YES, NO)
 }
 
 // ###_class_resolveClassMethod它的实现###
 _class_resolveClassMethod() {
 if(!loopUpImpOrNil()){
 return
 }
 BOOL (*msg)(Class, SEL, SEL) = (typeof(msg))objc_msgSend;
 bool resolved = msg(_class_getNonMetaClass(cls, inst), SEL_resolveInstanceMethod, sel)
 IMP imp = lookupImpOrNil(cls, sel, inst, NO, YES, NO)
 }
 
 // ###_class_getNonMetaClass的实现###
 Class _class_getNonMetaClass(Class cls, id obj){
 cls = getNonMetaClass(cls, obj);
 return cls;
 }
 
 // ###getNonMetaClass的实现###
 Class getNonMetaClass(Class metacls, id inst){
 // metacls：元类
 // inst：类对象
 // return cls itself if it's already a ##non-meta class##(表示不是元类的类, 即NSObject)
 if(!metacls->isMetaClass()) return metacls;
 
 // 表示metacls是根元类
 if(metacls->ISA() == metacls){
 Class cls = metacls->superclass;
 if (cls->ISA() == metacls) return cls;
 }
 
 // 类对象
 if(inst) {
 Class cls = (Class)inst;
 realizeClass(cls);
 
 while(cls && cls->ISA() != metacls){
 cls = cls->superclass;
 realizeClass(cls);
 }
 
 if(cls) {
 assert(!cls->isMetaClass());
 assert(cls->ISA() == metacls);
 return cls;
 }
 }
 
 }
 
 NSString *str = nil;
 NSAssert(str != nil, @"str不能为空");
 
 //======================源码
 // ###isMetaClass的实现###
 bool isMetaClass() {
     assert(this);
     assert(isRealized());
     return data()->ro->flags & RO_META;
 }
 Class getMeta() {
     if (isMetaClass()) return (Class)this;
     else return this->ISA();
 }
 bool isRootClass() {
     return superclass == nil;
 }
 bool isRootMetaclass() {
     return ISA() == (Class)this;
 }
 bool isRealized() {
     return data()->flags & RW_REALIZED;
 }
 bool isInitialized() {
     return getMeta()->data()->flags & RW_INITIALIZED;
 }
 
 struct objc_class : objc_object{
 class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
 class_rw_t *data() {
     return bits.data();
 }
 }
 
 LGStudent *stu = [[LGStudent alloc] init];
 BOOL flag1 = class_isMetaClass([stu class]);// NO
 BOOL flag = class_isMetaClass([LGStudent class]);// NO
 //======================
 
 // ###lookUpImpOrNil的实现###
 IMP lookUpImpOrNil() {
 IMP imp = lookUpImpOrForward();
 if(imp == _objc_msgForward_impcache) return nil;
 else return imp
 }
 
 ##给NSObject的分类添加_class_resolveInstanceMethod的实现（即动态添加方法）可以让任何类没实现的方法不崩溃##
 或者
 @interface Person : NSObject
 + (void)lg_message;
 @end
 Person没有实现这个类方法
 但NSObject的分类实现了这个方法的实例方法的话，也就不会崩溃
 @implementation NSObject (LG)
 - (void)lg_message{
     NSLog(@"LG = %s",__func__);
 }
 @end
 
 // ###消息转发###
 No implementation found, and method resolver didn't help. Use forwarding:
 imp = (IMP)_objc_msgForward_impcache
 cache_fill()
 
 
 // 单下划线变双下划线
 imp = (IMP)_objc_msgForward_impcache又会走到汇编__objc_msgForward_impcache(即快速转发)
 ->__objc_msgForward
 ->__objc_msgForward_handler 系统有默认的处理: objc_defaultForwardHandler 这里面就会打印unrecognized selector sent to instance XX(no message forward handler is installed )  class_isMetaClass(object_getClass(self)) ? '+' : '-', object_getClassName(self), sel_getName(sel), self
 
 // ###class_getClassMethod的实现###
 Method class_getClassMethod(Class cls,SEL sel){
 return class_getInstanceMethod(cls->getMeta(), sel)
 }
 
 打印方法调用过程log可通过: 文件在/private/tmp/msgSends-XXX
 extern void instrumentObjcMessageSends(BOOL);
 
 instrumentObjcMessageSends(YES);
 [Person walk];// 通过消息转发
 instrumentObjcMessageSends(NO);
 
 // ###objc_object::ISA()###
 Class objc_object::ISA() {
 return (Class)(isa.bits & ISA_MASK)
 }
 
 类方法的查找流程和实例方法的查找流程不一样。
 实例方法查找->类->父类->NSObject
 类方法查找->元类->元类的父类->根元类->NSObject（它的类方法存在根元类，相当于是根元类的实例方法）
 类方法可以在NSObject以类方法实现（最好）也可以以对象方法实现
 
断点调试:
 bt
 
 eg:
 // 添加方法的实现
 + (BOOL)resolveInstanceMethod:(SEL)sel{
     if (sel == @selector(run)) {
         // 我们动态解析我们的 对象方法
         NSLog(@"对象方法解析走这里");
         SEL readSEL = @selector(readBook);
         Method readM= class_getInstanceMethod(self, readSEL);
         IMP readImp = method_getImplementation(readM);
         const char *type = method_getTypeEncoding(readM);
         return class_addMethod(self, sel, readImp, type);
     }
     return [super resolveInstanceMethod:sel];
 }
 
 + (BOOL)resolveClassMethod:(SEL)sel{
     if (sel == @selector(walk)) {
         // 我们动态解析我们的 对象方法
         NSLog(@"类方法解析走这里");
         SEL hellowordSEL = @selector(helloWord);
         // 类方法就存在我们的元类的方法列表
 
         // 类 的 类方法 && 元类 的 对象实例方法  两者是一样的
 //这两行是一样的
         // Method hellowordM= class_getClassMethod(self, hellowordSEL);// 或者下面这行
         Method hellowordM= class_getInstanceMethod(object_getClass(self), hellowordSEL);
 
         IMP hellowordImp = method_getImplementation(hellowordM);
         const char *type = method_getTypeEncoding(hellowordM);
         NSLog(@"%s",type);
         return class_addMethod(object_getClass(self), sel, hellowordImp, type);
     }
     return [super resolveClassMethod:sel];
 }
 
 // CoreFoundation库路径
 ###/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/CoreFoundation.framework###
 */

// MARK: ---LG_runloop
/**
 https://blog.ibireme.com/2015/05/18/runloop/
 Source有两个版本：
 Source0 和 Source1。
 • Source0 只包含了一个回调（函数指针），它并不能主动触发事件。使用时，你需要先调用 CFRunLoopSourceSignal(source)，将这个 Source 标记为待处理，然后手动调用 CFRunLoopWakeUp(runloop) 来唤醒 RunLoop，让其处理这个事件。
 • Source1 包含了一个 mach_port 和一个回调（函数指针），被用于通过内核和其他线程相互发送消息。这种 Source 能主动唤醒 RunLoop 的线程
 
 Runloop的作用:
 保持程序的持续运行
 处理APP中的各种事件（触摸、定时器、performSelector）
 节省cpu资源、提供程序的性能：该做事就做事，该休息就休息
 
 void CFRunLoopRun(void) {
 int32_t result;
 do {
 result = CFRunLoopSpecific()
 }while (result != kCFRunLoopRunStopped && result != kCFRunLoopRunFinished )
 }
 
 // 调用block
 block应用：__CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__
 // performSelector:withObject:afterDelay 底层也是走的这个__CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__
 调用timer：__CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__
 响应source0：__CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__
 响应source1： __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__
 // dispatch_async(dispatch_get_main_queue(), {})
 GCD主队列：__CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__
 observer源：__CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__

 CFRunLoopSpecific
 ->__CFRunLoopRun
 ->__CFRunLoopDoTimers
 ->__CFRunLoopDoTimer
 ->__CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__
 
 ###CFRunLoopSpecific的实现###
 CFRunLoopSpecific(){
 CFRunLoopModeRef currentMode = __CFRunLoopFindMode(rl, modeName, false);
 
 int32_t result = kCFRunLoopRunFinished;
 if (currentMode->_observerMask & kCFRunLoopEntry ) __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopEntry);
 result = __CFRunLoopRun(rl, currentMode, seconds, returnAfterSourceHandled, previousMode);
 if (currentMode->_observerMask & kCFRunLoopExit ) __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopExit);
 }
 
 ###__CFRunLoopRun的实现###
 __CFRunLoopRun() {
 int32_t retVal = 0;
 do {
 // ##2
 if (rlm->_observerMask & kCFRunLoopBeforeTimers) __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeTimers);
 // ##3
 if (rlm->_observerMask & kCFRunLoopBeforeSources) __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeSources);
 // ##4
 Boolean sourceHandledThisLoop = __CFRunLoopDoSources0(rl, rlm, stopAfterHandle);
 if (sourceHandledThisLoop) {
     __CFRunLoopDoBlocks(rl, rlm);
 }
 
 if (MACH_PORT_NULL != dispatchPort && !didDispatchPortLastTime) {
 #if DEPLOYMENT_TARGET_MACOSX || DEPLOYMENT_TARGET_EMBEDDED || DEPLOYMENT_TARGET_EMBEDDED_MINI
             msg = (mach_msg_header_t *)msg_buffer;
 // ##5
             if (__CFRunLoopServiceMachPort(dispatchPort, &msg, sizeof(msg_buffer), &livePort, 0)) {
                 goto handle_msg;// ##9
             }
 #elif DEPLOYMENT_TARGET_WINDOWS
             if (__CFRunLoopWaitForMultipleObjects(NULL, &dispatchPort, 0, 0, &livePort, NULL)) {
                 goto handle_msg;
             }
 #endif
         }
 
 // ##6
 if (!poll && (rlm->_observerMask & kCFRunLoopBeforeWaiting)) __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeWaiting);
 
 #if USE_DISPATCH_SOURCE_FOR_TIMERS
         do {
             if (kCFUseCollectableAllocator) {
                 objc_clear_stack(0);
                 memset(msg_buffer, 0, sizeof(msg_buffer));
             }
             msg = (mach_msg_header_t *)msg_buffer;
 // ##7
             __CFRunLoopServiceMachPort(waitSet, &msg, sizeof(msg_buffer), &livePort, poll ? 0 : TIMEOUT_INFINITY);// 会走mach_msg_trap
             
             if (modeQueuePort != MACH_PORT_NULL && livePort == modeQueuePort) {
                 // Drain the internal queue. If one of the callout blocks sets the timerFired flag, break out and service the timer.
                 while (_dispatch_runloop_root_queue_perform_4CF(rlm->_queue));
                 if (rlm->_timerFired) {
                     // Leave livePort as the queue port, and service timers below
                     rlm->_timerFired = false;
                     break;
                 } else {
                     if (msg && msg != (mach_msg_header_t *)msg_buffer) free(msg);
                 }
             } else {
                 // Go ahead and leave the inner loop.
                 break;
             }
         } while (1);
 #else
         if (kCFUseCollectableAllocator) {
             objc_clear_stack(0);
             memset(msg_buffer, 0, sizeof(msg_buffer));
         }
         msg = (mach_msg_header_t *)msg_buffer;
         __CFRunLoopServiceMachPort(waitSet, &msg, sizeof(msg_buffer), &livePort, poll ? 0 : TIMEOUT_INFINITY);
 #endif
 
 // ##8
 if (!poll && (rlm->_observerMask & kCFRunLoopAfterWaiting)) __CFRunLoopDoObservers(rl, rlm, kCFRunLoopAfterWaiting);
 
 handle_msg:;// ##9
 __CFRunLoopSetIgnoreWakeUps(rl);
 
 }while (0 == retVal);
 }
 
 CFMutableDictionaryRef:
 线程->runloop
 
 runloop根据线程创建
 __CFRunloop底层是结构体
 
 CFRunloop-CFRunlopMode // 1-n 但runloop只能在一个mode下运行
mode里面有很多items
 
 rl: runloop rlm: runloopMode
 CFSetRef commonModes = rl->_commonModes
 CFStringRef curMode = rlm->_name
 遍历items分别调用使用:
 while(item){
 doit = item的mode(加入到runloop的item的mode，比如timer的mode)==curMode（表示现在runloop的mode） || (item的mode == kCFRunloopCommonModes && SetContainsValue(commonModes, curMode))
 if(doit){
 // 调用类似__CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__()的函数
 }
 }
 
 CFRunLoopAddTimer
 CFRunLoopAddObserver
 CFRunLoopAddSource
 CFSetAddValue(rl->_commonModeItems, rlt)

 
 [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];的addTimer的底层
 ->__CFRunLoopAddItemsToCommonMode
 ->CFRunLoopAddTimer(rl, rlt, modeName){// rlt = CFRunloopTimerRef
 if(modeName == KCFRunLoopCommonModes){
 // 把timer（即item）添加到commonModeItems
 } else {
 
 }
 
 }
 
 // CF_Timer
 - (void)cfTimerDemo{
     CFRunLoopTimerContext context = {
         0,
         ((__bridge void *)self),
         NULL,
         NULL,
         NULL
     };
     CFRunLoopRef rlp = CFRunLoopGetCurrent();
 
      参数一:用于分配对象的内存
      参数二:在什么是触发 (距离现在)
      参数三:每隔多少时间触发一次
      参数四:未来参数
      参数五:CFRunLoopObserver的优先级 当在Runloop同一运行阶段中有多个CFRunLoopObserver 正常情况下使用0
      参数六:回调,比如触发事件,我就会来到这里
      参数七:上下文记录信息
     CFRunLoopTimerRef timerRef = CFRunLoopTimerCreate(kCFAllocatorDefault, 0, 1, 0, 0, lgRunLoopTimerCallBack, &context);
     CFRunLoopAddTimer(rlp, timerRef, kCFRunLoopDefaultMode);
 }

 void lgRunLoopTimerCallBack(CFRunLoopTimerRef timer, void *info){
     NSLog(@"%@---%@",timer,info);
 }
 
 // CF_Observer
 - (void)cfObseverDemo{
     
     CFRunLoopObserverContext context = {
         0,
         ((__bridge void *)self),
         NULL,
         NULL,
         NULL
     };
     CFRunLoopRef rlp = CFRunLoopGetCurrent();
     
      参数一:用于分配对象的内存
      参数二:你关注的事件
           kCFRunLoopEntry=(1<<0),
           kCFRunLoopBeforeTimers=(1<<1),
           kCFRunLoopBeforeSources=(1<<2),
           kCFRunLoopBeforeWaiting=(1<<5),
           kCFRunLoopAfterWaiting=(1<<6),
           kCFRunLoopExit=(1<<7),
           kCFRunLoopAllActivities=0x0FFFFFFFU
      参数三:CFRunLoopObserver是否循环调用
      参数四:CFRunLoopObserver的优先级 当在Runloop同一运行阶段中有多个CFRunLoopObserver 正常情况下使用0
      参数五:回调,比如触发事件,我就会来到这里
      参数六:上下文记录信息

     CFRunLoopObserverRef observerRef = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, lgRunLoopObserverCallBack, &context);
     CFRunLoopAddObserver(rlp, observerRef, kCFRunLoopDefaultMode);
 }

 void lgRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
     NSLog(@"%lu-%@",activity,info);
 }
 
 RunLoopObserver监听runloop的状态
 
 // 成员享有同一个地址，节省内存
 typedef union{
     char a;
     float b;
 } UnionType;
 
 UnionType type;
 type.a = 10;
 //地址一样
 NSLog(@"a=%p",&type.a);
 NSLog(@"b=%p",&type.b);
 NSLog(@"%zd",sizeof(UnionType));// 4
 位域
 
 struct __CFRunLoopSource {
 union {
 CFRunLoopSourceContext version0;
 CFRunLoopSourceContext version1;
 }_context;
 }
 
 source0 （处理app内部事件和app管理的事务（输入源触摸事件UIEvent，CFSocket等等））包含回调函数指针 不能主动触发，signal source0标记为待处理，wakeup唤醒runloop去处理事件
 source1 （处理port，线程之间通讯）包含mach_port & 回调函数指针
 
 // source0
 - (void)source0Demo{
     
     CFRunLoopSourceContext context = {
         0,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         schedule,
         cancel,
         perform,
     };
      
      参数一:传递NULL或kCFAllocatorDefault以使用当前默认分配器。
      参数二:优先级索引，指示处理运行循环源的顺序。这里我传0为了的就是自主回调
      参数三:为运行循环源保存上下文信息的结构
      
     CFRunLoopSourceRef source0 = CFRunLoopSourceCreate(CFAllocatorGetDefault(), 0, &context);
     CFRunLoopRef rlp = CFRunLoopGetCurrent();
     // source --> runloop 指定了mode  那么此时我们source就进入待绪状态
     CFRunLoopAddSource(rlp, source0, kCFRunLoopDefaultMode);
     // 一个执行信号
     CFRunLoopSourceSignal(source0);
     // 唤醒 run loop 防止沉睡状态
     CFRunLoopWakeUp(rlp);
     // 取消 移除
     CFRunLoopRemoveSource(rlp, source0, kCFRunLoopDefaultMode);
     CFRelease(rlp);
 }
 
 void schedule(void *info, CFRunLoopRef rl, CFRunLoopMode mode){
     NSLog(@"准备代发");
 }

 void perform(void *info){
     NSLog(@"执行吧,骚年");
 }

 void cancel(void *info, CFRunLoopRef rl, CFRunLoopMode mode){
     NSLog(@"取消了,终止了!!!!");
 }
 
 // port
 <NSPortDelegate>
 @property (nonatomic, strong) NSPort* subThreadPort;
 @property (nonatomic, strong) NSPort* mainThreadPort;
 
 - (void)setupPort{
     
     self.mainThreadPort = [NSPort port];
     self.mainThreadPort.delegate = self;
     // port - source1 -- runloop
     [[NSRunLoop currentRunLoop] addPort:self.mainThreadPort forMode:NSDefaultRunLoopMode];

     [self task];
 }

 - (void) task {
     NSThread *thread = [[NSThread alloc] initWithBlock:^{
         self.subThreadPort = [NSPort port];
         self.subThreadPort.delegate = self;
         
         [[NSRunLoop currentRunLoop] addPort:self.subThreadPort forMode:NSDefaultRunLoopMode];
         [[NSRunLoop currentRunLoop] run];
     }];
     
     [thread start];
 }
 
 - (void)handlePortMessage:(id)message {
     NSLog(@"%@", [NSThread currentThread]); // 3 1

     unsigned int count = 0;
     Ivar *ivars = class_copyIvarList([message class], &count);
     for (int i = 0; i<count; i++) {
         
         NSString *name = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
 //        NSLog(@"%@",name);
     }
     
     sleep(1);
     if (![[NSThread currentThread] isMainThread]) {

         NSMutableArray* components = [NSMutableArray array];
         NSData* data = [@"word" dataUsingEncoding:NSUTF8StringEncoding];
         [components addObject:data];

         [self.mainThreadPort sendBeforeDate:[NSDate date] components:components from:self.subThreadPort reserved:0];
     }
 }
 
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     
     NSMutableArray* components = [NSMutableArray array];
     NSData* data = [@"hello" dataUsingEncoding:NSUTF8StringEncoding];
     [components addObject:data];
     // 子线程发消息给主线程
     [self.subThreadPort sendBeforeDate:[NSDate date] components:components from:self.mainThreadPort reserved:0];
 }
 
 */
// MARK: ---LG_Category
/**
 objc_init
 
 
 attachLists(List * const* addedLists, uint32_t addedCount){
 
 if (hasArray()) {
 uint32_t oldCount = array()->count;
 uint32_t newCount = oldCount + addedCount;
 setArray(realloc(array(), array_t::byteSize(newCount)))
 array()->count = newCount;
 
 memmove()
 memcpy()
 }
 }
 */

// MARK: ---LG_KVC
/**
 大括号这里面的都是成员变量
 @interface Test : UIView {
     int age;// 成员变量
     UIButton *btn;// 成员变量也是实例变量
 }
 实例变量：是一种特殊的成员变量 通过class实例出来的变量
 属性：有默认的setter和getter方法
 
 llvm编译器，当他发现没有匹配成员变量的属性时，会自动创建带下划线的成员变量
 
 kvc: 是一种机制，间接访问成员变量
 
 [p valueForKey:@"name"]： 返回的是id类型是对象
 查找流程：
 1.找方法 get<Key>,<Key>,is<Key>,_<Key> 一般类型
 2.countOf<Key>, objectIn<Key>AtIndex 用于NSArray
 3.countOf<Key>, enumeratorOf<Key>, memberOf<Key> 用于NSSet，NSSet它是无序的
 4.
 + (BOOL)accessInstanceVariablesDirectly{// 默认YES
     return YES;
 }
 找变量_<Key>, _is<Key>,<Key>,is<Key>
 5.all fails,invoke valueForUndefinedKey:
 
 Basic Setter:
 1.方法set<Key>, _set<Key>
 2.
 + (BOOL)accessInstanceVariablesDirectly{// 默认YES
     return YES;
 }
 变量_<Key>, _is<Key>,<Key>,is<Key>
 3.setValue:forUndefinedKey
 
 @interface LGPerson : NSObject{
     @public
     NSString *name;
     NSString *_name;
     NSString *_isName;
     NSString *isName;
     
 }
 
 LGPerson *p = [[LGPerson alloc] init];
 [p setValue:@"ndl" forKey:@"name"];

 NSLog(@"%@",p->isName);// (null)
 NSLog(@"%@-%@",p->name,p->isName);// (null)-(null)
 NSLog(@"%@-%@-%@",p->name,p->isName,p->_isName);// (null)-(null)-(null)
 NSLog(@"%@-%@-%@-%@",p->name,p->isName,p->_name,p->_isName);// (null)-(null)-ndl-(null)
 
 NSLog(@"%@",[p valueForKey:@"name"]);// ndl
 
 如果实现了setName方法
 - (void)setName:(NSString *)name{
     NSLog(@"%s",__func__);
 }
 NSLog(@"%@",[p valueForKey:@"name"]);// (null)
 */

// MARK: ---LG_KVO
/**
 addObserver: forKeyPath: options: context:
 context: 打标签--用来区分 解决继承的相关问题 判断嵌套少，性能高
 必须要移除观察者
 // context
 static void *PersonNameContext = &PersonNameContext;
 
 @implementation LGPerson
 // 自动观察开关
 + (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
     if ([key isEqualToString:@"age"]) {
         return YES;
     }
     return NO;
 }
 
 // 手动观察
 - (void)setName:(NSString *)name
 {
     [self willChangeValueForKey:@"name"];
     _name = name;
     [self didChangeValueForKey:@"name"];
 }
 
 // 下载进度 -- writtenData/totalData
 + (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key{
     
     NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
     if ([key isEqualToString:@"downloadProgress"]) {
         NSArray *affectingKeys = @[@"totalData", @"writtenData"];
         keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
     }
     return keyPaths;
 }
 @end
 
 @interface LGPerson : NSObject
 @property (nonatomic, copy) NSString *name;
 @property (nonatomic, copy) NSString *nick;
 @property (nonatomic, copy) NSString *downloadProgress;
 @property (nonatomic, assign) double writtenData;
 @property (nonatomic, assign) double totalData;
 @property (nonatomic, strong) NSMutableArray *dateArray;
 @end
 
 KVO与KVC有关联，依赖于KVC
 重要：观察dateArray 集合类型的观察要通过KVC来取值
 [self.person.dateArray addObject:@"hello"];// 这个不触发KVO
 [[self.person mutableArrayValueForKey:@"dateArray"] addObject:@"hello"];// 这个触发，因为mutableArrayValueForKey是KVC
 
 KVO观察属性和成员变量，给属性赋值会走回调，给成员变量赋值不会走回调
 KVO默认是观察属性的setter方法
 
 ###子类重写父类的方法，方法的imp的地址就会改变###
 
 KVO原理:（isa_swizzling）
 addObserver的时候 动态生成子类： NSKVONotifying_xxxx,对象的isa指向它
 重写观察对象的setter方法，class方法，dealloc方法，添加了_isKVOA方法
 在重写setter方法中调用 – willChangeValueForKey和 – didChangeValueForKey
 向父类发送消息
 
 removeObserver原理：
 移除观察者，isa从指向动态生成的类到指回原来的类
 removeObserver之前的打印
 (lldb) po self.person
 <LGPerson: 0x600003305120>
 (lldb) po self.person.class
 LGPerson
 (lldb) po object_getClass(self.person)
 NSKVONotifying_LGPerson
 
 removeObserver之后的打印：
 动态生成的NSKVONotifying_LGPerson没有消失
 
 github: KVOController
 */

// MARK: ---LG_objc_init 应用初始化过程
/**
 
 */

// MARK: LG_单元测试
/**
 UIKit Tests
 Tests
 
 command + u
 */

// MARK: LG_CI
/**
 github:
 Travis CI // 绑定github上面的项目
 codecov // 要有代码覆盖率 需要有单元测试
 */

// MARK: ---LG_多线程
/**
 线程的定义：
 线程是进程的基本执行单元，一个进程的所有任务都在线程中执行
 进程要想执行任务，必须得有线程，进程至少要有一条线程
 程序启动会默认开启一条线程，这条线程被称为主线程或 UI 线程
 
 进程的定义：
 进程是指在系统中正在运行的一个应用程序
 每个进程之间是独立的，每个进程均运行在其专用的且受保护的内存
 
 终端: kill 线程号
 
 进程与线程的关系:
 地址空间：同一进程的线程共享本进程的地址空间，而进程之间则是独立的地址空间。
 资源拥有：同一进程内的线程共享本进程的资源如内存、I/O、cpu等，但是进程之间的资源是独立的。

 一个进程崩溃后，在保护模式下不会对其他进程产生影响，但是一个线程崩溃整个进程都死掉。所以多进程要比多线程健壮。
 进程切换时，消耗的资源大，效率高。所以涉及到频繁的切换时，使用线程要好于进程。同样如果要求同时进行并且又要共享某些变量的并发操作，只能用线程不能用进程
 执行过程：每个独立的进程有一个程序运行的入口、顺序执行序列和程序入口。但是线程不能独立执行，必须依存在应用程序中，由应用程序提供多个线程执行控制。
 线程是处理器调度的基本单位，但是进程不是。

 多线程的意义:
 * 优点
   * 能适当提高程序的执行效率
   * 能适当提高资源的利用率（CPU，内存）
   * 线程上的任务执行完成后，线程会自动销毁
 * 缺点
    * 开启线程需要占用一定的内存空间（默认情况下，每一个线程都占 512 KB）
    * 如果开启大量的线程，会占用大量的内存空间，降低程序的性能
    * 线程越多，CPU 在调用线程上的开销就越大
    * 程序设计更加复杂，比如线程间的通信、多线程的数据共享
    
 UI为什么要在主线程更新？
 UIKit 线程不安全，需要按照苹果的设计和标准
 
 耗时操作会阻塞主线程
 
 C与OC的桥接： __bridge只做类型转换，但是不修改对象（内存）管理权；

 __bridge_retained（也可以使用CFBridgingRetain）将Objective-C的对象转换为Core Foundation的对象，同时将对象（内存）的管理权交给我们，后续需要使用CFRelease或者相关方法来释放对象；

 __bridge_transfer（也可以使用CFBridgingRelease）将Core Foundation的对象转换为Objective-C的对象，同时将对象（内存）的管理权交给ARC
 
 互斥锁小结：
   * 保证锁内的代码，同一时间，只有一条线程能够执行！
   * 互斥锁的锁定范围，应该尽量小，锁定范围越大，效率越差！

 * 互斥锁参数
   * 能够加锁的任意 NSObject 对象
   * 注意：锁对象一定要保证所有的线程都能够访问
   * 如果代码中只有一个地方需要加锁，大多都使用 self，这样可以避免单独再创建一个锁对象
   
 ##GCD可以通过信号量（dispatch_semaphore_create(value) 控制有几条线程可以并发执行）控制并发数##
 
 
 nonatomic 非原子属性
 atomic 原子属性(线程安全)，针对多线程设计的，默认值

 保证同一时间只有一个线程能够写入(但是同一个时间多个线程都可以取值)
 atomic 本身就有一把锁(自旋锁)
 单写多读：单个线程写入，多个线程可以读取// 读写锁，写会影响读，读不会影响写

 atomic：线程安全，需要消耗大量的资源
 nonatomic：非线程安全，适合内存小的移动设备
 
 线程和Runloop的关系：
 1：runloop与线程是一一对应的，一个runloop对应一个核心的线程，为什么说是核心的，是因为runloop是可以嵌套的，但是核心的只能有一个，他们的关系保存在一个全局的字典里。
 2：runloop是来管理线程的，当线程的runloop被开启后，线程会在执行完任务后进入休眠状态，有了任务就会被唤醒去执行任务。
 3：runloop在第一次获取时被创建，在线程结束时被销毁。
 4：对于主线程来说，runloop在程序一启动就默认创建好了。
 5：对于子线程来说，runloop是懒加载的，只有当我们使用的时候才会创建，所以在子线程用定时器要注意：确保子线程的runloop被创建，不然定时器不会回调。timer依赖runloop

 runloop（do..while循环）通过dict[线程的指针] 创建的，管理线程里面的任务。保证线程不退出
 
 优先级高不一定先执行

 线程执行完，不会被销毁，过会会被线程池回收，线程池中这条线程很久没被调度就会被回收。
 
 MARK: ==LG_GCD==
 全称是 Grand Central Dispatch
 纯 C 语言，提供了非常多强大的函数
 GCD 是苹果公司为多核的并行运算提出的解决方案
 GCD 会自动管理线程的生命周期（创建线程、调度任务、销毁线程）

 ##将==任务==添加到==队列==，并且指定==执行任务的函数==##
 异步是多线程的代名词
 
 这边的队列：fifo 先进先执行，任务执行依赖于线程，线程依赖于cpu调度
 
 __block int a = 0// 将a从栈区拷贝一份到struct 结构体里包含了a的指针和a的值
 
 // 1， 5 后面顺序不定
 dispatch_queue_t queue = dispatch_queue_create("cooci", DISPATCH_QUEUE_CONCURRENT);
     NSLog(@"1");
     dispatch_async(queue, ^{
         NSLog(@"2");
         NSLog(@"4");
     });
     
     dispatch_async(queue, ^{
             NSLog(@"22");
             NSLog(@"44");
         });
     NSLog(@"5");
 
 // 肯定1 后面顺序不定
 dispatch_queue_t queue = dispatch_queue_create("cooci", DISPATCH_QUEUE_CONCURRENT);
 NSLog(@"1");
 dispatch_async(queue, ^{
     NSLog(@"2");
     dispatch_async(queue, ^{
         NSLog(@"3");
     });
     NSLog(@"4");
 });
 NSLog(@"5");
 
 // 4,3的顺序是肯定的
 dispatch_queue_t queue = dispatch_queue_create("cooci", DISPATCH_QUEUE_SERIAL);
 NSLog(@"1");
 dispatch_async(queue, ^{
     NSLog(@"2");
     dispatch_async(queue, ^{
         NSLog(@"3");
     });
     NSLog(@"4");
 });
 NSLog(@"5");
 
 栅栏函数 dispatch_barrier_async:
 最直接的作用: 控制任务执行顺序,同步，保证线程安全
 dispatch_barrier_async    前面的任务执行完毕才会来到这里
 dispatch_barrier_sync        作用相同,但是这个会堵塞线程,影响后面的任务执行
 非常重要的一点:  栅栏函数只能控制##同一并发队列(自定义的)##,不利于封装

 ###可变数组 线程不安全：###
 dispatch_queue_t concurrentQueue = dispatch_queue_create("cooci", DISPATCH_QUEUE_CONCURRENT);
 // signal SIGABRT -- 线程BUG
 for (int i = 0; i<2000; i++) {
     dispatch_async(concurrentQueue, ^{
         NSString *imageName = [NSString stringWithFormat:@"%d.jpg", (i % 10)];
         NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
         NSData *data = [NSData dataWithContentsOfURL:url];
         UIImage *image = [UIImage imageWithData:data];
 
        // [self.mArray addObject:image]; 会崩溃
        // 解决方案： 或者用锁@synchronized (self)
         dispatch_barrier_async(concurrentQueue, ^{
             [self.mArray addObject:image];
         });
     });
 }
 
 调度组：
 最直接的作用: 控制任务执行顺序
 dispatch_group_create     创建组
 dispatch_group_async       进组任务
 dispatch_group_notify    进组任务执行完毕通知
 dispatch_group_wait        进组任务执行等待时间

 // 底层实现：进组底层signal（不能<1否则崩溃） 会+1，一直循环判断信号是否等于0，等于0就group_wakeup->dispatch_group_notify
 dispatch_group_enter        进组
 dispatch_group_leave        出组

 信号量dispatch_semaphore_t：
 dispatch_semaphore_create            创建信号量
 dispatch_semaphore_wait                信号量等待
 dispatch_semaphore_signal            信号量释放
 同步当锁,和控制GCD最大并发数
 
 1.dispatch_semaphore_create：创建一个Semaphore并初始化信号的总量
 2.dispatch_semaphore_signal：发送一个信号，让信号总量加1
 3.dispatch_semaphore_wait：可以使总信号量减1，当信号总量为0时就会一直等待（阻塞所在线程），否则就可以正常执行。
 dispatch_semaphore_wait的返回值也为long型。当其返回0时表示在timeout之前，该函数所处的线程被成功唤醒。
 当其返回不为0时，表示timeout发生。

 Dispatch_source：
 dispatch_source_create                        创建源
 dispatch_source_set_event_handler        设置源事件回调
 dispatch_source_merge_data                源事件设置数据
 dispatch_source_get_data                获取源事件数据
 dispatch_resume                                继续
 dispatch_suspend                            挂起
 
 @property (nonatomic, strong) dispatch_source_t source;
 // 参数4: 可以传Null，默认为全局队列
 self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
 dispatch_source_set_event_handler(self.source, ^{
     NSUInteger value = dispatch_source_get_data(self.source); // 取回来值 1 响应式
 });
 
 // 在任一线程上调用它的的一个函数 dispatch_source_merge_data 后，会执行 Dispatch Source 事先定义好的句柄（可以把句柄简单理解为一个 block ）
 这个过程叫 Custom event ,用户事件。是 dispatch source 支持处理的一种事件
 //句柄是一种指向指针的指针  它指向的就是一个类或者结构，它和系统有很密切的关系
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 dispatch_async(self.queue, ^{
     dispatch_source_merge_data(self.source, 1); // source 值响应
 });
 }
 
 // 封装了source ， 和 runloop source不一样
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     
 });

runloop用到了gcd的source（dispatch_source_t）
 */

// MARK: ===LG_网络==
/**
 wireshark
 
 ipv4:32位
 ipv6:128位
 
 MTU：最大传输单元 576-1500字节
 tcp:20 ip:20 头帧大小
 MSS：最大分段大小 576 - 20 - 20 = 536 取536的倍数
 分段传输
 ----------------------------------------
 UIWebView:
 - (void)webViewDidFinishLoad:(UIWebView *)webView{
     // tittle
     NSString *tittle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
 }
 
 
 <head>
     <meta charset="UTF-8">
     <title>OC与JS交互</title>
     <script>
         function showAlert(name){
             alert(name);
             return function handle(str){
                     alert('我是一个弹窗'+name+str);
                     return name + '返回给OC';
                 }
             }
     </script>
 </head>
 [self.webView stringByEvaluatingJavaScriptFromString:@"showAlert('111')('222')"];
 
 js调OC: 可通过url拦截
 
 js: <a href="lgedu:///getSum/helloword/js">点击跳转效应OC方法</a>
 (NSURLRequest *)request:
 request.URL.pathComponents
 
 JavaScriptCore:
 - (void)webViewDidFinishLoad:(UIWebView *)webView{
     //JSContext就为其提供着运行环境 H5上下文
     JSContext *jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
     self.jsContext = jsContext;
 
     // 提供全局变量
 [self.jsContext evaluateScript:@"var arr = [3, 'Cooci', 'abc'];"];
 
 // 因为是全局变量 可以直接获取
 JSValue *arrValue = self.jsContext[@"arr"];
 
 self.jsContext[@"showDict"] = ^(JSValue *value) {
     
     NSArray *args = [JSContext currentArguments];
     JSValue *dictValue = args[0];
     NSDictionary *dict = dictValue.toDictionary;
     NSLog(@"%@",dict);
     
     // 模拟用
     int num = [[arrValue.toArray objectAtIndex:0] intValue];
     num += 10;
     NSLog(@"arrValue == %@   num == %d",arrValue.toArray,num);
     dispatch_async(dispatch_get_main_queue(), ^{
         weakSelf.showLabel.text = dict[@"name"];
     });
 };
 
 //异常收集
 self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
     weakSelf.jsContext.exception = exception;
     NSLog(@"exception == %@",exception);
 };
     
     // 保存一段代码块
     //JS-OC
     jsContext[@"showMessage"] = ^{
         // 参数 (JS 带过来的)
         NSArray *args = [JSContext currentArguments];
         NSLog(@"args = %@",args);
        NSLog(@"currentThis   = %@",[JSContext currentThis]);// [object window]
        
 JSValue *cValue = [JSContext currentCallee];
 NSLog(@"cValue = %@",cValue);
 
        // OC-JS
        NSDictionary *dict = @{@"name":@"cooci",@"age":@18};
        [[JSContext currentContext][@"ocCalljs"] callWithArguments:@[dict,@"咸鱼"]];// 传以数组形式包装的参数
     };
 
 // JS 操作对象
 KC_JSObject *kcObject = [[KC_JSObject alloc] init];
 self.jsContext[@"kcObject"] = kcObject;
 NSLog(@"kcObject == %d",[kcObject getSum:20 num2:40]);
 
 }
 
 function openAlbumImage(){
     getImage();
     kcObject.letJSImage('123');
     alert(kcObject.getSum(10,20));
 }
 
 
 #import <JavaScriptCore/JavaScriptCore.h>

 @protocol KCProtocol <JSExport>

 - (void)letShowImage;
 // 协议 - 协议方法
 JSExportAs(getS, -(int)getSum:(int)num1 num2:(int)num2);

 @end

 @interface KC_JSObject : NSObject<KCProtocol>
 @end
 
 @implementation KC_JSObject;
 - (void)letShowImage{
     NSLog(@"打开相册,上传图片");
 }

 - (int)getSum:(int)num1 num2:(int)num2{
     // 传的参数少的话：int (nil) - jsvalue (0)
     return num1+num2;
 }

 @end
 
 - (NSString *)removeSpaceAndNewline:(NSString *)str
 {
     NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
     temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
     temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
     return temp;
 }
 
 ----------------------------------------
 WKWebView:
 - (void)viewDidLoad {
     [super viewDidLoad];
     
     WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
     NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
     WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
     WKUserContentController *wkUController = [[WKUserContentController alloc] init];
     [wkUController addUserScript:wkUScript];
     configuration.userContentController = wkUController;
     
     self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
     self.webView.navigationDelegate = self;
     self.webView.UIDelegate = self;
     [self.view addSubview:self.webView];
     
     NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
     NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
     [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
     
 }
 
 NSString *jsStr2 = @"var arr = [3, 'Cooci', 'abc']; ";
 [self.webView evaluateJavaScript:jsStr2 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
     NSLog(@"%@----%@",result, error);
 }];
 
 NSString *jsStr = [NSString stringWithFormat:@"showAlert('%@')",@"登陆成功"];
 [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
     NSLog(@"%@----%@",result, error);
 }];
 
 // url拦截
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
 {
     NSURL *URL = navigationAction.request.URL;
     NSString *scheme = [URL scheme];
     if ([scheme isEqualToString:@"lgedu"]) {
         NSString *host = [URL host];
         if ([host isEqualToString:@"jsCallOC"]) {
             NSMutableDictionary *temDict = [self decoderUrl:URL];
             NSString *username = [temDict objectForKey:@"username"];
             NSString *password = [temDict objectForKey:@"password"];
             NSLog(@"%@---%@",username,password);
         }else{
             NSLog(@"不明地址 %@",host);
         }
         decisionHandler(WKNavigationActionPolicyCancel);
         return;
     }
     decisionHandler(WKNavigationActionPolicyAllow);
 }
 
 #pragma mark - 解析URL地址
 - (NSMutableDictionary *)decoderUrl:(NSURL *)URL{
     NSArray *params =[URL.query componentsSeparatedByString:@"&"];
     NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
     for (NSString *paramStr in params) {
         NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
         if (dicArray.count > 1) {
             NSString *decodeValue = [dicArray[1] stringByRemovingPercentEncoding];
             [tempDic setObject:decodeValue forKey:dicArray[0]];
         }
     }
     return tempDic;
 }
 
 构成循环引用
 //self - webView - configuration - userContentController - self
 - (void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
     [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"messgaeOC"];
 }
// 必须写
 - (void)viewWillDisappear:(BOOL)animated{
     [super viewWillDisappear:animated];
     [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"messgaeOC"];
 }
 
 - (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
     if (message.name) {
     }
     
     NSLog(@"message == %@ --- %@",message.name,message.body);
 }
 
 function messgaeHandle(){
     window.webkit.messageHandlers.messgaeOC.postMessage("Cooci 消息");
 }
 
 ----------------------------------------
 WebViewJavascriptBridge:
 self.wjb = [WebViewJavascriptBridge bridgeForWebView:self.webView];
 // 如果你要在VC中实现 UIWebView的代理方法 就实现下面的代码(否则省略)
 [self.wjb setWebViewDelegate:self];
 
 [self.wjb registerHandler:@"jsCallsOC" handler:^(id data, WVJBResponseCallback responseCallback) {
     NSLog(@"currentThread == %@",[NSThread currentThread]);
     
     NSLog(@"data == %@ -- %@",data,responseCallback);
 }];
 
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
     [self.wjb callHandler:@"OCCallJSFunction" data:@"oc调用JS咯" responseCallback:^(id responseData) {
         NSLog(@"currentThread == %@",[NSThread currentThread]);
         
         NSLog(@"调用完JS后的回调：%@",responseData);
     }];
 });
 
 <script>
    
    function setupWebViewJavascriptBridge(callback) {
        if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
        if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
        window.WVJBCallbacks = [callback];
        var WVJBIframe = document.createElement('iframe');
        WVJBIframe.style.display = 'none';
        WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
        document.documentElement.appendChild(WVJBIframe);
        setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
    }
 
     setupWebViewJavascriptBridge(function(bridge) {
      // JS 被调用的方法  OCCallJSFunction 定义的标识
         bridge.registerHandler('OCCallJSFunction', function(data, responseCallback) {
             alert('JS方法被调用:'+data);
             responseCallback('js执行过了');
         })
      })
                              
                              
      function showWBJ(){
          WebViewJavascriptBridge.callHandler('jsCallsOC', {'Cooci': '18'}, function(response) {
               alert(response);
           })
      }
    
 </script>
 
 ##编辑器:##
 ZSSRichTextEditor
 
 ---------------------------------------
 WK:
 get cookie:
 NSHTTPCookieStorage *storages = [NSHTTPCookieStorage sharedHTTPCookieStorage];
 for (NSHTTPCookie *cookie in [storages cookies]) {
     NSLog(@"%@",cookie);
 }
 
 set cookie:
 - (void)setCookieWithDomain:(NSString*)domainValue
                 sessionName:(NSString *)name
                sessionValue:(NSString *)value
                 expiresDate:(NSDate *)date{
     
     NSURL *url = [NSURL URLWithString:domainValue];
     NSString *domain = [url host];
     
     //创建字典存储cookie的属性值
     NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
     //设置cookie名
     [cookieProperties setObject:name forKey:NSHTTPCookieName];
     //设置cookie值
     [cookieProperties setObject:value forKey:NSHTTPCookieValue];
     //设置cookie域名
     [cookieProperties setObject:domain forKey:NSHTTPCookieDomain];
     //设置cookie路径 一般写"/"
     [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
     //设置cookie版本, 默认写0
     [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
     //设置cookie过期时间
     if (date) {
         [cookieProperties setObject:date forKey:NSHTTPCookieExpires];
     }else{
         [cookieProperties setObject:[NSDate dateWithTimeIntervalSince1970:([[NSDate date] timeIntervalSince1970]+365*24*3600)] forKey:NSHTTPCookieExpires];
     }
     [[NSUserDefaults standardUserDefaults] setObject:cookieProperties forKey:@"app_cookies"];
     //删除原cookie, 如果存在的话
     NSArray * arrayCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
     for (NSHTTPCookie * cookice in arrayCookies) {
         [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookice];

     }
     //使用字典初始化新的cookie
     NSHTTPCookie *newcookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
     //使用cookie管理器 存储cookie
     [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:newcookie];
 }
 
 [self setCookieWithDomain:@"http://www.baidu.com" sessionName:@"cooci_token_UIWebView" sessionValue:@"123456789" expiresDate:nil];
 NSDictionary *headerDict = [NSHTTPCookie requestHeaderFieldsWithCookies:[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies];
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
 request.allHTTPHeaderFields = headerDict;
 [self.webView loadRequest:request];
 
 WK请求，沙盒会有WebKit的文件夹
 
 这样加载wk带不上cookie的问题：
 self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
 self.webView.navigationDelegate = self;
 [self.view addSubview:self.webView];
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
 [self.webView loadRequest:request];
 
 这样加载wk能带上cookie：但是点击进入下级页面，跨域（就是路由变了）请求就又丢了
 self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
 self.webView.navigationDelegate = self;
 [self.view addSubview:self.webView];
 [self.webView loadRequest:[self cookieAppendRequest]];
 
 // 手动加入cookie
 - (NSURLRequest *)cookieAppendRequest{
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
     NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
     //Cookies数组转换为requestHeaderFields
     NSDictionary *requestHeaderFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
     //设置请求头
     request.allHTTPHeaderFields = requestHeaderFields;
     NSLog(@"%@",request.allHTTPHeaderFields);
     return request;
 }
 
 // 跨域请求就又丢了cookie的处理
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
     
     [[WKCookieManager shareManager] fixNewRequestCookieWithRequest:navigationAction.request];
     decisionHandler(WKNavigationActionPolicyAllow);
 }
 
 还可以通过注入脚本的方式：但推荐上面的方法
 WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
 WKUserContentController *contoller = [[WKUserContentController alloc] init];
 [contoller addUserScript:[[WKCookieManager shareManager] futhureCookieScript]];
 configuration.userContentController = contoller;
 self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
 self.webView.navigationDelegate = self;
 [self.view addSubview:self.webView];
 [self.webView loadRequest:[self cookieAppendRequest]];
 
 也可以处理cookie 但这个是iOS11才有
 ##WKWebsiteDataStore##
 // WKWebView
 https://www.jianshu.com/p/56738af0724c
 https://www.jianshu.com/p/52668d5b2e68
 
 构建HTTP网络框架：
 url处理 // 百分号编码
 URL编码(URL encoding)也称为百分号编码(Percent-encoding)
 
 URI的字符类型：
 URI所允许的字符分成保留与未保留：
 保留字符是那些具有特殊含义的字符. 例如, /字符用于URL不同部分的分节符(https://www.baidu.com/news)
 未保留字符没有这些特殊含义. 百分号编码把保留字符表示为特殊字符序列, 根据URI的版本的不同略有变化
 下面是 RFC 3986的保留字符, 与未保留字符:
 保留: ! * ' ( ) ; : @ & = + $ , / ? # [ ]
 未保留: A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 - _ . ~
 除此之外, URI中的其它字符必须用百分号编码.

 在URL中?key1=val1&key2=val2中的val1中如果有保留字符&或者*,那么这里保留字符用于其他目的, 需要编码
 
 百分号编码一个保留字符, 首先需要把该字符的ASCII的值表示为两个16进制的数字, 然后在其前面放置转义字符("%"), 置入URI中的相应位置. (对于非ASCII字符, 需要转换为UTF-8字节序, 然后每个字节按照上述方式表示.)
 !   #   $   &   '   (   )   *   +   ,   /   :   ;   =   ?   @   [   ]
 %21 %23 %24 %26 %27 %28 %29 %2A %2B %2C %2F %3A %3B %3D %3F %40 %5B %5D

 在URI的查询部分(?字符后的部分)中, 例如/仍然是保留字符但是没有特殊含义, 除非一个特定的URI有其它规定. 该/字符在没有特殊含义时不需要百分号编码.例如https://www.baidu.com/news?name=p/p&age=13, 其中name=p/p中的/是保留字符但是没有特殊含义, 在实际使用中可以不用给它进行百分号编码.

 未保留字符不需要百分号编码
 
 iOS中：
 HTTP协议里面在URL中传递参数,是在?后面使用key=value这种键值对方式, 如果有多个参数传递, 就需要用&进行分割, 例如?key1=val1&key2=val2&key3=val3, 当服务器收到请求以后, 会用&分割出每个key=value参数, 然后用=分割出具体的键值
 现在如果在我们的参数key-value中就有=或者&怎么办? 这样后台在解析参数的时候, 就会产生歧义. 因此解决方法就是对参数进行百分号编码
 
 stringByAddingPercentEscapesUsingEncoding
 当URL中有汉字时候, 用上面的方法, 会将汉字转化成 unicode 编码的结果, 但是对于复杂场景这个方法并不能满足需求, 例如&符号
 NSString *queryWord = @"汉字&ss";
 NSString *urlString = [NSString stringWithFormat:@"https://www.baidu.com/s?ie=UTF-8&wd=%@", queryWord];
 NSString *escapedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 NSLog(@"%@", escapedString); // https://www.baidu.com/s?ie=UTF-8&wd=%E6%B1%89%E5%AD%97&ss
 这个实例在开发中很常见(我们项目中是将某个人的昵称当做参数传递给后台), 后台在收到这种被转义以后的URL取得的参数如下:
 ["ie": "UTF-8", "wd" : "汉字", "ss": nil]
 因为stringByAddingPercentEscapesUsingEncoding方法并不会对&字符进行百分号编码
 
 iOS中正确的使用百分号编码：
 如果要想自己控制哪些内容被编码, 哪些内容不会被编码, iOS提供了另外一个方法 -- stringByAddingPercentEncodingWithAllowedCharacters:
 这个方法会对字符串进行更彻底的转义，但是需要传递一个参数: 这个参数是一个字符集，表示: 在进行转义过程中，不会对这个字符集中包含的字符进行转义, 而保持原样保留下来
 NSString *queryWord = @"汉字&ss";
 NSString *escapedQueryWord = [queryWord stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
 NSLog(@"%@", escapedQueryWord); // %E6%B1%89%E5%AD%97%26ss
 NSString *urlString = [NSString stringWithFormat:@"https://www.baidu.com/s?ie=UTF-8&wd=%@", escapedQueryWord];
 NSLog(@"%@", urlString); // https://www.baidu.com/s?ie=UTF-8&wd=%E6%B1%89%E5%AD%97%26ss
 传递参数[NSCharacterSet letterCharacterSet]来保证字母不被转义。所以被转义之后的参数值是：%E6%B1%89%E5%AD%97%26ss，这样&就能够正确被百分号编码
 
 如果实际场景中, 可能出现如下情况:
 https://www.baidu.com/s?person[contact]=13801001234&person[address]=北京&habit[]=游泳&habit[]=骑行
 此时, 需要自己构建 AllowedCharacters, 因为其中的[和]是不需要转意的
 NSMutableCharacterSet *mutableCharSet = [[NSMutableCharacterSet alloc] init];
 [mutableCharSet addCharactersInString:@"[]"]; // 允许'['和']'不被转义
 NSCharacterSet *charSet = mutableCharSet.copy;
 NSMutableString *mutableString = [NSMutableString string];
 for (unit in queryString) {
     NSString *escapedField = [unit.field stringByAddingPercentEncodingWithAllowedCharacters:charSet];
     NSString *escapedValue = [unit.value stringByAddingPercentEncodingWithAllowedCharacters:charSet];
     [mutableString addFormat:@"%@=%@", escapedField, escapedValue];
 }
 构建AllowedCharacters的NSCharacterSet
 针对参数的k-v值, 进行遍历, 将针对key和value分别调用stringByAddingPercentEncodingWithAllowedCharacters进行百分号编码.
 用@"?%@=%@&%@=%@"进行kv参数拼接, 和不同参数的拼接
 
 percent-escaped string:百分比转义字符串
 
 AFNetworking的处理:
 @{
     @"name": @"小A",
     @"phone": @{@"mobile": @"xx", @"home": @"xx"},
     @"families": @[@"father", @"mother"],
     @"nums": [NSSet setWithObjects:@"1", @"2", nil],
 };
 ->
 @[
      field: @"name", value: @"小A",
      field: @"phone[mobile]", value: @"xx",
      field: @"phone[home]", value: @"xx",
      field: @"families[]", value: @"father",
      field: @"families[]", value: @"mother",
      field: @"nums", value: @"1",
      field: @"nums", value: @"2",
 ]
 ->
 name=%E5%B0%8FA&phone[mobile]=xx&phone[home]=xx&families[]=father&families[]=mother&nums=1&num=2
 
 @{
     @"does_not_include": @"/?",
     @"space": @" ",
     @"GeneralDelimitersToEncode": @":#[]@",
     @"SubDelimitersToEncode": @"!$&'()*+,;=",
 };
 ->
 @[
      field: @"does_not_include", value: @"/?",
      field: @"space", value: @" ",
      field: @"GeneralDelimitersToEncode", value: @":#[]@",
      field: @"SubDelimitersToEncode", value: @"!$&'()*+,;=",
 ]
 ->
 https://www.baidu.com?GeneralDelimitersToEncode=%3A%23%5B%5D%40&SubDelimitersToEncode=%21%24%26%27%28%29%2A%2B%2C%3B%3D&does_not_include=/?&space=%20
 
 -> URL Decode以后
 https://www.baidu.com?GeneralDelimitersToEncode=:#[]@&SubDelimitersToEncode=!$&'()*+,;=&does_not_include=/?&space=
 
 ------------------------------------------
 终端命令:
 rvictl -x device_uuid 关闭虚拟网卡
 rvictl -s device_uuid 建立虚拟网卡
 
 // netCAT 监听8041，充当服务器
 nc -lk 8041
 
 UDP(⽤户数据报协议) 只管发送，不确认对方是否接收到 将数据及源和⽬的封装成数据包中，不需要建立连接 每个数据报的⼤小限制在64K之内 因为无需连接，因此是不可靠协议 不需要建立连接，速度快
 应用场景:多媒体教室/⽹络流媒体
 
TCP(传输控制协议) 建立连接，形成传输数据的通道 在连接中进行大数据传输(数据⼤小不收限制) 通过三次握⼿完成连接，是可靠协议，安全送达 必须建⽴连接，效率会稍低
 
 数据在两个 Socket 间通过 IO 传输
 
 socket数据处理：
 1.标识符用来分割数据
 2.数据长度+数据类型+数据 （推荐）
 
 ====================CocoaAsyncSocket源码解析
 localhost与127.0.0.1的区别:
 localhost也叫local ，正确的解释是:本地服务器 127.0.0.1
 
 localhot(local)是不经网卡传输！这点很重要，它不受网络防火墙和网卡相关的的限制。
 127.0.0.1是通过网卡传输，依赖网卡，并受到网络防火墙和网卡相关的限制。
 本机IP 也是通过网卡传输的，依赖网卡，并受到网络防火墙和网卡相关的限制。
 但是本机IP与127.0.0.1的区别是： 127.0.0.1 只能通过本机访问，而本机IP通过本机访问也能通过外部访问
 
 localhost不会解析成ip，也不会占用网卡、网络资源。
 
 环回地址是主机用于向自身发送通信的一个特殊地址（也就是一个特殊的目的地址）。
 
 localhost 是一个域名，在过去它指向 127.0.0.1 这个IP地址。在操作系统支持 ipv6 后，它同时还指向ipv6 的地址 [::1]
 
 loopback 是一个特殊的网络接口(可理解成虚拟网卡)
 
 ###
 整个127.* 网段通常被用作 loopback 网络接口的默认地址，按惯例通常设置为 127.0.0.1。这个地址在其他计算机上不能访问，就算你想访问，访问的也是自己，因为每台带有TCP/IP协议栈的设备基本上都有 localhost/127.0.0.1。
 ###
 
 当IP层接收到目的地址为127.0.0.1
 （准确的说是：网络号为127的IP）的数据包时，不调用网卡驱动进行二次封装，而是立即转发到本机IP层进行处理，由于不涉及底层操作。因此，ping 127.0.0.1一般作为测试本机TCP/IP协议栈正常与否的判断之一。
 
 本机地址通常指的是绑定在物理或虚拟网络接口上的IP地址，可供其他设备访问到。
 
 127.0.0.1 是绑定在 loopback 接口上的地址，如果服务端套接字绑定在它上面，你的客户端程序就只能在本机访问。
 
 - (NSString *)blockReturn {
     //创建信号量
     dispatch_semaphore_t signal = dispatch_semaphore_create(0);
     __block NSString *str = @"sst";
 // block异步性
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         str = @"SunSatan";
         //信号量+1
         dispatch_semaphore_signal(signal);
     });
     //信号量等待
     dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
     return str;
 }
 不加信号量可能返回的str = @"sst"
 
 // block中使用return ，宏定义 -- 预编译 -- return（return是函数） -  提前准备好，防止编译器走到这块时（代码段被编译时未识别return）直接跳过往下执行
 #define return_from_block  return
 
 0.0.0.0为广播地址
 */

// MARK: ===LG_性能优化===
/**
 MARK: ---内存管理
 内存布局:
 0xc0000000 = 3221225472 让他除以1024再除以1024再除以1024 = 3
 
 BSS段:未初始化的全局变量，静态变量 （静态区）
 数据段: 初始化的全局变量，静态变量 （常量区）
 text:程序代码，加载到内存中
 
 栈区内存地址:⼀般为:0x7开头
 堆区内存地址:一般为:0x6开头
 数据段，BSS内存地址:一般为:0x1开头
 
 TaggedPointer: 小对象 NSNumber，NSDate
 标记，编码，解码
 ～：按位取反
 <<: 左移
 ^:异或
 TaggedPointer它是一个值，不是真正的对象
 objc_msgSend 如果是对象是nil或者taggedPointer就直接返回
 
 它的地址就代表了 = 值+类型（类型:地址最后位，即最右边）
 
 [NSString stringWithFormat:@"abc"]// NSTaggedPointerString
 
 源码：
 objc_setProperty() ->reallySetProperty() 里面有objc_retain()和objc_release(oldValue)  他们里面都有obj->isTaggedPointer()的判断 retain的话直接返回，没有引用计数的处理
 
 NONPOINTER_ISA:⾮指针型isa
 union isa_t {
    isa位域
 }
 共64位
 1位：nonpointer:表示是否对 isa 指针开启指针优化 0:纯isa指针，1:不止是类对象地址,isa 中包含了类信息、对象的引用计数等
 1位：has_assoc:关联对象标志位，0没有，1存在
 1位：has_cxx_dtor:该对象是否有 C++ 或者 Objc 的析构器,如果有析构函数,则需要做析构逻辑, 如果没有,则可以更快的释放对象
 33位：shiftcls:
 存储类指针的值。开启指针优化的情况下，在 arm64 架构中有 33 位用来存储类指针。
 6位：magic:⽤于调试器判断当前对象是真的对象还是没有初始化的空间
 1位：weakly_referenced:标志对象是否被指向或者曾经指向一个 ARC 的弱变量，没有弱引⽤的对象可以更快释放。
 1位：deallocating:标志对象是否正在释放内存
 1位：has_sidetable_rc:当对象引⽤计数⼤于 10 时，则需要借⽤该变量存储进位
 19位：extra_rc:当表示该对象的引用计数值，实际上是引用计数值减 1， 例如，如果对象的引用计数为 10，那么 extra_rc 为 9。如果引用计数⼤于 10， 则需要使用到has_sidetable_rc。
 
 散列表:引用计数表，弱引用表
 获取散列表: 源码array[indexOfPointer].value
 
 MARK: ---MRC&ARC
 ARC是LLVM（编译器）和Runtime配合的结果
 
 MRC:
 Person *p = [[Person alloc] init];
 // alloc出来的引用计数为0
 [p retainCount];// 但这边打印1 源码：uintptr_t rc = 1 + bits.extra_rc;
 [p retain];// retain()->rootRetain(),  1.extra_rc + 1 2.如果上溢出overflow，分开存储，一半存到散列表 sidetable_rc + 1
 [p retainCount];// 2
 [p release];// release()->rootRelease()，1.extra_rc - 1 2.如果下溢出  如果散列表存在newisa.has_sidetable_rc就去散列表借来的RC_HALF - 1存到extra_rc 3.如果release借了散列表的引用计数还是下溢出就调用dealloc
 [p retainCount];// 1
 
 MARK: ---dealloc底层实现:
 dealloc
 ->
 _objc_rootDealloc(self)
 
 _objc_rootDealloc(id obj) {
 obj->rootDealloc()
 }
 ->
 objc_object::rootDealloc(){
 if(fastpath(isa.nonpointer && !isa.weakly_referenced && !isa.hasassoc && !isa.has_cxx_dtor && !isa.has_sidetable_rc)){
 free(this)
 }else {
 object_dispose((id)this)
 }
 }
 ->
 id object_dispose(id obj){
 objc_destructInstance(obj);
 free(obj)
 return nil
 }
 ->
 void *objc_destructInstance(id obj){
 if(obj){
 bool cxx = obj->hasCxxDtor() // dtor: 析构函数
 bool assoc = obj->hasAssociatedObjects()
 if (cxx) object_cxxDestruct(obj)
 if (assoc) _object_remove_associations(obj)
 obj->clearDeallocating()
 }
 return obj
 }
 ->
 void objc_object::clearDeallocating(){
 if(slowpath(!isa.nonpointer)){
 sidetable_clearDealllocating();
 } else if (slowpath(isa.weakly_referenced || isa.has_sidetable_rc)){
 clearDeallocating_slow();
 }
 }
 ->
 sidetable_clearDealllocating(){
 SideTable& table = SiideTable()[this]
 
 table.lock()
 RefcountMap::iterator it = table.refcnts.find(this);
 if (it!= table.refcnts.end()){
 if(it->second & SIDE_TABLE_WEAKLY_REFERENCED){
 weak_clear_no_lock(&table.weak_table, (id)this)
 }
 table.refcnts.erase(it);
 }
 table.unlock();
 }
 
 void objc_object::clearDeallocating_slow(){
 SideTable& table = SiideTable()[this]
 table.lock()
 if(isa.weakly_referenced){
 weak_clear_no_lock(&table.weak_table, (id)this)
 }
 if(isa.has_sidetable_rc){
 table.refcnts.erase(this);
 }
 table.unlock()
 }
 
 ->
 void weak_clear_no_lock(weak_table_t *weak_table, id referent_id){
 objc_object *referent = (ojc_object *)referent_id;
 weak_entry_t *entry = weak_entry_for_referent(weak_table, referent))
 if(entry == nil){
 return;
 }
 
 weak_referrer_t *referrers;
 size_t count;
 if(entry->out_of_line()){
 referrers = entry->referrers;
 count = TABLE_SIZE(entry);
 } else {
 referrers = entry->inline_referrers;
 count = WEAK_INLINE_COUNT;
 }
 
 for(size_t i = 0; i<count;++i){
 objc_object **referrer = referrers[i];
 if(referrer){
 if(*referrer == referent){
 *referrer = nil;
 }
 }
 }
 
 weak_entry_remove(weak_table, entry)
 
 }
 ->
 static void weak_entry_remove(weak_table_t weak_table, weak_entry_t *entry){
 // out of line: 超越了界限
 if (entry->out_of_line()) free(entry->referrers)
 bzero(entry, sizeof(*entry))
 weak_table->num_entries--;
 }
 
 
 
 
 MARK: ---weak底层原理：
 -(void)dealloc{__weak typeof(self)weakSelf =  self;}// 会崩溃
 objc[4572]: Cannot form weak reference to instance (0x160f6f890) of class MFChatRoomBoardController. It is possible that this object was over-released, or is in the process of deallocation.
 (lldb)
 error: empty command
 (lldb) bt
 * thread #1: tid = 0x35914d, 0x0000000182307aac libobjc.A.dylib`_objc_trap(), queue = ‘com.apple.main-thread‘, stop reason = EXC_BREAKPOINT (code=1, subcode=0x182307aac)
   * frame #0: 0x0000000182307aac libobjc.A.dylib`_objc_trap()
     frame #1: 0x0000000182307b24 libobjc.A.dylib`_objc_fatal(char const*, ...) + 88
     frame #2: 0x0000000182319890 libobjc.A.dylib`weak_register_no_lock + 316
     frame #3: 0x0000000182320688 libobjc.A.dylib`objc_initWeak + 224
     frame #4: 0x000000010022bf8c MakeFriends`-[MFChatRoomBoardController dealloc](self=0x0000000160f6f890, _cmd="dealloc") + 36 at MFChatRoomBoardController.m:31
 不允许在 dealloc 的时候取 weak self.
 id
 weak_register_no_lock(weak_table_t *weak_table, id referent_id, id *referrer_id)
 {
     objc_object *referent = (objc_object *)referent_id;// 参照物
     objc_object **referrer = (objc_object **)referrer_id;// 引用者

     if (!referent  ||  referent->isTaggedPointer()) return referent_id;

     // ensure that the referenced object is viable
     bool deallocating;
     if (!referent->ISA()->hasCustomRR()) {
         deallocating = referent->rootIsDeallocating();
     }
     else {
         BOOL (*allowsWeakReference)(objc_object *, SEL) =
             (BOOL(*)(objc_object *, SEL))
             object_getMethodImplementation((id)referent,
                                            SEL_allowsWeakReference);
         if ((IMP)allowsWeakReference == _objc_msgForward) {
             return nil;
         }
         deallocating =
             ! (*allowsWeakReference)(referent, SEL_allowsWeakReference);
     }

     if (deallocating) {
         _objc_fatal("Cannot form weak reference to instance (%p) of "
                     "class %s. It is possible that this object was "
                     "over-released, or is in the process of deallocation.",
                     (void*)referent, object_getClassName((id)referent));
     }

     // now remember it and where it is being stored
     weak_entry_t *entry;
     if ((entry = weak_entry_for_referent(weak_table, referent))) {
         append_referrer(entry, referrer);
     }
     else {
         weak_entry_t new_entry;
         new_entry.referent = referent;
         new_entry.out_of_line = 0;
         new_entry.inline_referrers[0] = referrer;
         for (size_t i = 1; i < WEAK_INLINE_COUNT; i++) {
             new_entry.inline_referrers[i] = nil;
         }

         weak_grow_maybe(weak_table);
         weak_entry_insert(weak_table, &new_entry);
     }

     // Do not set *referrer. objc_storeWeak() requires that the
     // value not change.

     return referent_id;
 }
 
 void _objc_fatal(const char *fmt, ...)
 {
     va_list ap;
     char *buf1;
     char *buf2;

     va_start(ap,fmt);
     vasprintf(&buf1, fmt, ap);
     va_end (ap);

     asprintf(&buf2, "objc[%d]: %s\n", getpid(), buf1);
     _objc_syslog(buf2);
     _objc_crashlog(buf2);

     _objc_trap();
 }
 
 objc_initWeak->
 storeWeak
 ->
 storeWeak(){
 // clean up old value
 if(haveOld){
 weak_unregister_no_lock(&oldTable->weak_table, oldObj, location)
 }
 // assign new value
 if (haveNew){
 weakregister_no_lock(&newTable->weak_table, newObj, location, crashIfDeallocating)
 }
 }
 ->
 weakregister_no_lock(){
 weak_entry_t *entry;
 if ((entry = weak_entry_for_referent(weak_table, referent))){
 append_referrer(entry, referrer)
 } else {
 weak_entry_t new_entry(referent, referrer)// 创建entry
 weak_grow_maybe(weak_table)// 容量准备
 weak_entry_insert(weak_table, &new_entry);// 插入entry
 }
 
 }
 ->
 weak_entry_for_referent:
 weak_entry_t* weak_entry_for_referent(weak_table_t *wek_table, objc_object *referent){
 weak_entry_t *weak_entries = weak_table->weak_entries;
 size_t begin = hash_pointer(referent) & weak_table->mask;
 size_t index = begin
 while(weak_table->weak_entriesp[index].referent != referent){
 index = (index + 1) & weak_table->mask;
 ...
 }
 return &weak_table->weak_entries[index];
 }
 
 append_referrer:
 new_referrer---The new weak pointer to be added
 static void append_referrer(weak_entry_t *entry, objc_objcet **new_referrer){
 if(!entry->out_of_line()){
 // try to insert inline
 for(size_t i = 0; i<WEAK_INLINE_COUNT;i++){
 if(entry->inline_referrers[i]==nil){
 entry->inline_referrers[i] = new_referrer
 return
 }
 }
 
 // could't insert inline.Allocate out of line
 weak_referrer_t *new_referrers = (weak_referrer_t *)calloc(WEAK_INLINE_COUNT, sizeof(weak_referrer_t))
 // will  fix it and rehash it
 for(size_t i = 0; i<WEAK_INLINE_COUNT;i++){
 new_referrers[i]= entry->inline_referrers[i];
 }
 }
 }
 
 entry->inline_referrers[i] = new_referrer;
 new_referrers[i] = entry->inline_referrers[i]
 entry->referrers = new_referrers;
 
 weak_entry_t结构体的初始化方法：
 weak_entry_t(objc_object *newReferent, objc_object **newReferrer): referent(newReferent){
inline_referrers[0] = newReferrer;
 for(int i = 1; i<WEAK_INLINE_COUNT;i++){
 inline_referrers[i] = nil;
 }
 }
 
 NSObject *obj = [[NSObject alloc] init]
 id __weak obj1 = obj;
 referent: 指示物
 referrer: 推荐人,引荐人 这边指弱引用指针,obj1
 
 MARK: ---strong
 void objc_storeStrong(id *location, id obj){
 id prev = *location
 if(obj == prev){
 return;
 }
 objc_retain(obj);
 *location = obj;
 objc_release(prev);
 }
 
 // 内存管理，查看变量修饰符
 static void _class_lookUpIvar(){
 
 }
 
 // strong
 class_getIvarLayout()
 
 // weak
 const uint8_t *class_getWeakIvarLayout(Class cls){
 if (cls) return cls->data()->ro->weakIvarLayout;
 else return nil
 }
 
 //
 bool isARC() {
 return data()->ro->flags & RO_IS_ARC;
 }
 
 MARK: ---autoreleasepool
 自动释放池：双向链表,用来容纳变量
 AutoreleasePoolPage
 page: 属性 56字节
 pageSize(一页所能容纳的大小): 4096
 
 (4096-56)/8 = 505
 
 next: 指向最新添加的autoreleased对象的下一个位置，初始化时指向begin()
 
 ARC:
 extern void _objc_autoreleasePoolPrint(void);// 用来打印信息
 需要Buid Settings->Objective-C Automatic Reference Counting: No
 @autoreleasepool {
 for (int i =0;i<505;i++){
 NSObject *objc = [[[NSObject alloc]init] autorelease]
 }
 _objc_autoreleasePoolPrint();
 }
 
 16进制的38 = 3*16+8=56
 0x103803000---PAGE (full) (cold)
 0x103803038###POOL 0x103803038 边界符
 之间相差8
 0x103803040
 。。
 。。
 0x103803ff8
 0x104801000---PAGE (hot)
 0x104801038
 
 static inline void* push(){
 id *dest;
 if(DebugPoolAllocation){
 // each autorelease pool starts on a new pool page
 dest = autoreleaseNewPage(POOL_BOUNDARY);
 }else {
 dest = autoreleaseFast(POOL_BOUNDARY);
 }
 return dest;
 }
 
 static __attribute__((noinline)) id *autoreleaseNewPage(id obj){
 AutoreleasePoolPage *page = hotPage();
 if (page) return autoreleaseFullPage(obj, page);
 else return autoreleaseNoPage(obj);
 }
 
 static __attribute__((noinline)) id *autoreleaseFullPage(id obj, AutoreleasePoolPage *page){
 do{
 if (page->child) page = page->child;
 else page = new AutoreleasePoolPage(page);
 }while(page->full())
 setHotPage(page);
 return page->add(obj);
 }
 
 id *autoreleaseNoPage(id obj){
 bool pushExtraBoundary = false;
 if(haveEmptyPoolPlaceholder()){
 pushExtraBoundary = true;
 } else if(){
 
 } else if(){
 
 }
 AutoreleasePoolPage *page = new AutoreleasePoolPage(nil);
 setHotPage(page);
 if(pushExtraBoundary){
 page->add(POOL_BOUNDARY);
 }
 return page->add(obj);
 }
 
 MARK: ---循环引用
 解决方式
 1.
 __weak typeof(self) weakSelf = self;
 self.block = ^{
     __strong typeof(self) strongSelf = weakSelf;
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         NSLog(@"%@",strongSelf.name); // self - nil name - nil
     });
 };
 self.block();
 
 2.
 __block LGViewController *vc = self; // vc 结构体
 self.block = ^{
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         NSLog(@"%@",vc.name); // self - nil name - nil
         vc = nil;
     });
 };
 self.block();
 
 3.
 self.blockVc = ^(LGViewController *vc){
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         NSLog(@"%@",vc.name); // self - nil name - nil
     });
 };
 self.blockVc(self);
 
 MARK: ---强引用
 NSTiner解决方式
 1.中间层（Wrapper）
 2.NSProxy
 
 */8:30


// MARK: ---LG_flutter
/**
 打开文件时提示【文件已损坏，请移至废纸篓】
 打开文件时提示【文件来自身份不明的开发者】
 系统是OS Sierra(10.12)以上
 sudo spctl --master-disable
 
 App 在macOS Catalina下提示已损坏无法打开解决办法
 sudo xattr -d com.apple.quarantine /Applications/xxxx.app
 重启App
 
 https://flutterchina.club/
 https://github.com/flutter/flutter/releases
 
 VSCode:
 Extensions: Install Extension->flutter
 View->Command Palette->Flutter: Run Flutter Doctor
 View->Command Palette->Flutter: New Project
 
 unzip ~/Downloads/flutter_macos_v1.12.13+hotfix.5-stable.zip
 
 flutter doctor
 升级flutter sdk:
 flutter upgrade
 
 支持热重载: r
 restart: R
 
 flutter create flutter_demo
 cd flutter_demo->flutter run
 flutter run -d "iPhone X"
 
 rm /opt/flutter/bin/cache/lockfile
 
 Widget(部件):
 有状态的Stateful
 无状态的Stateless
 
 class MyWidget extends StatelessWidget {
 // build
 }
 
 */
