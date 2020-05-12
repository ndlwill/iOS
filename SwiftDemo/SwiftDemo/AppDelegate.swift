//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by dzcx on 2019/7/17.
//  Copyright © 2019 dzcx. All rights reserved.
//

// MARK: swift查看内存地址小工具Mems
// https://github.com/CoderMJLee/Mems.git

// MARK: 工具
// Zeplin Lookin3

// =====github=====
// https://github.com/devicekit/DeviceKit

// 大哥blog: swift编程规范
// https://note.u-inn.cn/ios-swift-style/

// github swift demo
// https://github.com/hilen/TSWeChat

// RxSwift
// https://www.jianshu.com/p/f61a5a988590

// RxSwift 中文文档
// https://beeth0ven.github.io/RxSwift-Chinese-Documentation/

// ##swift##
// http://www.hangge.com/blog/cache/category_72_1.html

// Moya-ObjectMapper
// https://github.com/ivanbruel/Moya-ObjectMapper

// ###RxSwiftCommunity###
// https://github.com/RxSwiftCommunity
// RxAlamofire
// https://github.com/RxSwiftCommunity/RxAlamofire
// RxDataSources
// https://github.com/RxSwiftCommunity/RxDataSources

// Date
// https://github.com/malcommac/SwiftDate

// MARK: 写时复制(copy-on-write)
/**
 var array1: [Int] = [0, 1, 2, 3]
 var array2 = array1

 print(address: array1) //0x600000078de0
 print(address: array2) //0x600000078de0

 array2.append(4)
 print(address: array2) //0x6000000aa100
 */

// MARK: gitlab
/**
 Gitlab-CI是GitLab Continuous Integration（Gitlab持续集成）的简称
 持续集成是一个软件工程概念，表示不断的将代码集成到主干分支的行为
 每次我们集成代码的时候，我们希望系统能够帮助我们完成一些事情，比如说构建项目，打包，自动化测试等等，也就是所谓的持续递交
 
 Gitlab-CI配置起来也很方便，只需要开启Gitlab-runner和书写.gitlab-ci.yml文件即可完成
 Runner的作用是运行定义在.gitlab-ci.yml文件里的代码。Runner可以看做一种虚拟机
 Runner分为两种，一种是可以作用于任何项目的Runner，叫做Shared Runner。还有一种只能作用于特定的项目，叫做Specified Runner
 如果若干个项目拥有相似的需求，那么就可以使用Shared Runner，避免使空闲的Runner过多。如果某个项目的CI活动非常频繁，那么可以考虑使用Specified Runner
 
 一般不要在安装了Gitlab的机器上面部署Runner，因为两者都会消耗大量的内存，会引起性能问题
 
 https://docs.gitlab.com/runner/install/osx.html // runner
 */

// MARK: git
/**
 git push <远程主机名> <本地分支名>  <远程分支名>
 
 git push origin master
 如果远程分支被省略，如上则表示将本地分支推送到与之存在追踪关系的远程分支（通常两者同名），如果该远程分支不存在，则会被新建
 */

// MARK: 原子操作
/**
 对于一个资源，在写入或读取时，只允许在一个时刻一个角色进行操作，则为原子操作
 对于 let 声明的资源，永远是原子性的。
 对于 var 声明的资源，是非原子性的，对其进行读写时，必须使用一定的手段，确保其值的正确性
 */

/*
 RxSwift: 响应式编程
 Rx 是 ReactiveX 的缩写 (reactive:有反应的)
 http://reactivex.io/
 */

// Swift4.0
/*
 Swift3 新增了 #keyPath()
 Swift4 中直接用 \ 作为开头创建 KeyPath
 类型可以定义为 class、struct
 定义类型时无需加上 @objc 等关键字
 user1.value(forKeyPath: #keyPath(User.name)) 返回的类型是 Any，user1[keyPath: \User.name] 直接返回 String 类型
 使用 appending 方法向已定义的 Key Path 基础上填加新的 Key Path。
 let keyPath1 = \User.phone
 let keyPath2 = keyPath1.appending(path: \.number)
 
 类与协议的组合类型:
 #在 Swift4 中，可以把类（Class）和协议（Protocol）用 & 组合在一起作为一个类型使用
 #在 Swift4 中, private 属性作用域扩大到 extension
 
 下标支持泛型:
 下标的返回类型支持泛型
 下标类型同样支持泛型
 struct GenericDictionary<Key: Hashable, Value> {
 private var data: [Key: Value]
 
 init(data: [Key: Value]) {
 self.data = data
 }
 
 subscript<T>(key: Key) -> T? {
 return data[key] as? T
 }
 }
 
 Codable 序列化:
 如果要将一个对象持久化，需要把这个对象序列化。过去的做法是实现 NSCoding 协议，但实现 NSCoding 协议的代码写起来很繁琐，尤其是当属性非常多的时候。
 Swift4 中引入了 Codable 协议，可以大大减轻了我们的工作量。我们只需要让需要序列化的对象符合 Codable 协议即可，不用再写任何其他的代码
 struct Language: Codable {
 var name: String
 var version: Int
 }
 
 Encode 操作
 let swift = Language(name: "Swift", version: 4)
 
 //encoded对象
 let encodedData = try JSONEncoder().encode(swift)
 
 //从encoded对象获取String
 let jsonString = String(data: encodedData, encoding: .utf8)
 print(jsonString)
 
 Decode 操作
 let decodedData = try JSONDecoder().decode(Language.self, from: encodedData)
 print(decodedData.name, decodedData.version)
 
 Swift 4 中有一个很大的变化就是 String 可以当做 Collection 来用，并不是因为 String 实现了 Collection 协议:
 
 swap() 方法将会被废弃，建议使用 tuple（元组）特性来实现值交换，也只需要一句话就能实现：
 var a = 1
 var b = 2
 (b, a) = (a, b)
 
 
 过去的情况（Swift3）如果想把 Swift 写的 API 暴露给 Objective-C 调用，需要增加 @objc。在 Swift 3 中，编译器会在很多地方为我们隐式的加上 @objc
 比如当一个类继承于 NSObject，那么这个类的所有方法都会被隐式的加上 @objc。
 class MyClass: NSObject {
 func print() { } // 包含隐式的 @objc
 func show() { } // 包含隐式的 @objc
 }
 在 Swift 4 中隐式 @objc 自动推断只会发生在下面这种必须要使用 @objc 的情况
 覆盖父类的 Objective-C 方法
 符合一个 Objective-C 的协议
 
 大多数地方必须手工显示地加上 @objc。
 class MyClass: NSObject {
 @objc func print() { } //显示的加上 @objc
 @objc func show() { } //显示的加上 @objc
 }
 如果在类前加上 @objcMembers，那么它、它的子类、扩展里的方法都会隐式的加上 @objc
 如果在扩展（extension）前加上 @objc，那么该扩展里的方法都会隐式的加上 @objc
 如果在扩展（extension）前加上 @nonobjc，那么该扩展里的方法都不会隐式的加上 @objc
 
 MARK:单例
 1.静态常量
 class MyClass {
 static let shared = MyClass()
 private init() { }
 }
 
 2.全局变量
 fileprivate let sharedInstance = MyClass()
 class MyClass {
 
 static var shared: MyClass {
 return sharedInstance
 }
 
 fileprivate init() { }
 }
 
 Swift在初始化过程中定义了这么多规则, 归根到底是为了所有属性能被初始化
 便利构造器是对类初始化方法的补充
 convenience的一般用法: 扩展类的构造函数
 */

// MARK:swift源码解析
// https://www.jianshu.com/u/a4b11b398b1e

// MARK: Swift 3.0
/**
 在 Swift 3 中，编译器会在很多地方为我们隐式的加上 @objc。
 当一个类继承于 NSObject，那么这个类的所有方法都会被隐式的加上 @objc。
 class MyClass: NSObject {
     func print() { } // 包含隐式的 @objc
     func show() { } // 包含隐式的 @objc
 }
 但这样做很多并不需要暴露给 Objective-C 也被加上了 @objc。而大量 @objc 会导致二进制文件大小的增加
 
 swift 4.0
 在 Swift 4 中隐式 @objc 自动推断只会发生在下面这种必须要使用 @objc 的情况：
 覆盖父类的 Objective-C 方法
 符合一个 Objective-C 的协议
 
 大多数地方必须手工显示地加上 @objc。
 class MyClass: NSObject {
     @objc func print() { } //显示的加上 @objc
     @objc func show() { } //显示的加上 @objc
 }
 
 如果在类前加上 @objcMembers，那么它、它的子类、扩展里的方法都会隐式的加上 @objc。
 @objcMembers
 class MyClass: NSObject {
     func print() { } //包含隐式的 @objc
     func show() { } //包含隐式的 @objc
 }
  
 extension MyClass {
     func baz() { } //包含隐式的 @objc
 }
 
 如果在扩展（extension）前加上 @objc，那么该扩展里的方法都会隐式的加上 @objc。
 class SwiftClass { }
  
 @objc extension SwiftClass {
     func foo() { } //包含隐式的 @objc
     func bar() { } //包含隐式的 @objc
 }
 
 如果在扩展（extension）前加上 @nonobjc，那么该扩展里的方法都不会隐式的加上 @objc。
 @objcMembers
 class MyClass : NSObject {
     func wibble() { } //包含隐式的 @objc
 }
  
 @nonobjc extension MyClass {
     func wobble() { } //不会包含隐式的 @objc
 }
 
 */

/*
 MARK:Swift4.0
 
 Swift 的静态语言特性，每个函数的调用在编译期间就可以确定
 
 CaseInterable协议:
 
 检查序列元素是否符合条件:
 let scores = [86, 88, 95, 92]
 //返回一个BOOL
 let passed = scores.allSatisfy({ $0 > 85 })
 
 布尔切换:
 toggle()方法
 
 #warning和#error编译指令:
 */

/*
 MARK:static 与 class 的区别:
 static 可以在类、结构体、或者枚举中使用。而 class 只能在类中使用。
 static 可以修饰存储属性，static 修饰的存储属性称为静态变量(常量)。而 class 不能修饰存储属性。
 static 修饰的计算属性不能被重写。而 class 修饰的可以被重写。
 static 修饰的静态方法不能被重写。而 class 修饰的类方法可以被重写。
 class 修饰的计算属性被重写时，可以使用 static 让其变为静态属性。
 class 修饰的类方法被重写时，可以使用 static 让方法变为静态方法
 */

// MARK: 函数式编程
/**
 Functor 和 Monad 都是函数式编程的概念
 
 Functor意味着实现了 map 方法，而Monad意味着实现了flatMap
 因此 Optional 类型和 Array 类型都既是 Functor 又是 Monad，与Result一样，它们都是一种复合类型，或者叫 Wrapper 类型
 
 map 方法：传入的 transform 函数的 入参是 Wrapped 类型，返回的是 Wrapped 类型
 flatMap 方法：传入的 transform 函数的 入参是 Wrapped 类型，返回的是 Wrapper 类型
 */

struct Point {
    var x: Double
    var y: Double
}

struct TestPoint {
    let x: Double
    let y: Double
    let isFilled: Bool
}

enum Season{
    case spring(Int,Int,Int),
         summer(String,String,String),
         autumn(Bool,Bool,Bool),
         winter(Int,Int),
         unknown(Bool)
}

import UIKit
import Accelerate

@UIApplicationMain
// markdown
/**
 # 一级标题
 1.
 2.
 ## 二级标题
 -
 -
 [官网](https:XXX) 链接
 */

// markup语法 只在playground中能用
//: # 一级标题

// MARK: swift支持多行注释的嵌套
/*
 1
 /*
 ======
 */
 2.
 */

// MARK: Bool
/**
 /*
 C语言和OC并没有真正的Bool类型
 C语言的Bool类型非0即真
 OC中if可以是任何整数(非0即真),
 OC语言的Bool类型是typedef signed char BOOL;

 Swift引入了真正的Bool类型
 Bool true false
 Swift中的if的条件只能是一个Bool的值或者是返回值是Bool类型的表达式(==/!=/>/<等等)
 */
 */

// MARK:static、const、extern
/**
 static关键字：
 修饰局部变量时：
 1、使得局部变量只初始化一次
 2、局部变量在程序中只有一份内存
 3、局部变量作用域不变，但是生命周期改变了（程序结束才能销毁）
 修饰全局变量：
 1、全局变量的作用域仅限当前文件，外部类是不可以访问到该全局变量的。
 
 被const修饰的变量是只读的：
 基本数据类型：
 int const a = 10; 和const int b = 20; 效果是一样的 只读常量
 指针类型：
 NSString *p;
 *p是地址中的值，p是指针地址。
 NSString const *p 表示地址中的值没法改变，但是指针的指向可以改变；
 而 NSString *const p 表示指针的指向不能改变，但是地址里的内容是可以改变的
 
 extern 外部常量的最佳方法：
 extern const 关键字，表示这个变量已经声明，只是引用，且不可修改
 .m文件中定义的常量，用const修饰代表常量。其中const CGFloat a = 10.f; 和 CGFloat const a = 10.f;两种写法是一样的，都代表a值为常量，不可修改。但是外部可通过extern CGFloat a;引用该变量
 全局变量若只想被该文件所持有，不希望被外界引用，则用static修饰，也就是static const CGFloat a = 10.f;和 static CGFloat const a = 10.f；
 */

// MARK: 大佬优化blog
/**
 https://juejin.im/user/5b9b0ef16fb9a05d353c6418/posts
 冷启动优化
 https://juejin.im/post/5e4bbbe15188254945385eb5
 
 
 
 
 MLeaksFinder 是 WeRead 团队开源的iOS内存泄漏检测工具
 https://github.com/Tencent/MLeaksFinder
 */

// MARK: ==Charles==
/**
 设置网络，进行抓包:
 将移动设备和电脑设备设置为同一个网络，即连接同一个Wi-Fi。
 利用电脑查询IP地址
 设置移动设备的网络代理模式 进入连接的无线网的高级模式
 进入HTTP代理模式，然后选择手动，并在服务器中填写自己查到的IP地址，然后在端口中填写8888，最后存储设置。

 */

// MARK: ==离屏渲染 （Offscreen rendering）==
/**
 iOS 9.0 之前UIimageView跟UIButton设置圆角都会触发离屏渲染。
 iOS 9.0 之后UIButton设置圆角会触发离屏渲染，而UIImageView里png图片设置圆角不会触发离屏渲染了，如果设置其他阴影效果之类的还是会触发离屏渲染的
 1.通过设置layer的属性
 maskToBounds会触发离屏渲染，GPU在当前屏幕缓冲区外新开辟了一个渲染缓冲区进行工作，也就是离屏渲染，这会给我们带来额外的性能损耗，如果这样的圆角操作达到一定数量，会触发缓冲区的频繁合并和上下文的频繁切换，性能的代价会宏观的表现在用户体验上<掉帧>
 
 对于文本视图实现圆角（UILabel, UIView, UITextField, UITextView）
 均只进行cornerRadius设置，不进行masksToBounds的设置
 对于UILabel, UIView, UITextField来说，实现了圆角的设置，并没有产生离屏渲染；
 而对于UITextView，产生了离屏渲染
 
 2.使用贝塞尔曲线UIBezierPath和Core Graphics框架画出一个圆角
 UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
  imageView.image = [UIImage imageNamed:@"TestImage.jpg"];
  // 开始对imageView进行画图
  UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0);
  // 使用贝塞尔曲线画出一个圆形图
  [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:imageView.frame.size.width] addClip];
  [imageView drawRect:imageView.bounds];
  imageView.image = UIGraphicsGetImageFromCurrentImageContext();
  // 结束画图
  UIGraphicsEndImageContext();
  [self.view addSubview:imageView];
 
 UIGraphicsBeginImageContextWithOption(CGSize size, BOOL opaque, CGFloat scale)各参数的含义：
 size ---新创建的文图上下文大小
 opaque --- 透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
 scale --- 缩放因子。虽然这里可以用[UIScreen mainScreen].scale来获取，但实际上设为0后，系统会自动设置正确的比例

  3.使用Core Graphics框架画出一个圆角
 UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
 imageView.image = [UIImage imageNamed:@"TestImage.jpg"];

 // 开始对imageView进行画图
 UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0);

 // 获取图形上下文
 CGContextRef ctx = UIGraphicsGetCurrentContext();

 // 设置一个范围
 CGRect rect = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);

 // 根据一个rect创建一个椭圆
 CGContextAddEllipseInRect(ctx, rect);

 // 裁剪
 CGContextClip(ctx);

 // 讲原照片画到图形上下文
 [imageView.image drawInRect:rect];

 // 从上下文上获取裁剪后的照片
 UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

 // 关闭上下文
 UIGraphicsEndImageContext();
 imageView.image = image;
 [self.view addSubview:imageView];

  4.使用CAShapeLayer和UIBezierPath设置圆角
 UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
 imageView.image = [UIImage imageNamed:@"TestImage.jpg"];
 UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners
 cornerRadii:imageView.bounds.size];
 CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
 // 设置大小
 maskLayer.frame = imageView.bounds;
 // 设置图形样子
 maskLayer.path = maskPath.CGPath;
 imageView.layer.mask = maskLayer;
 [self.view addSubview:imageView];
 第四种方法并不可取，存在离屏渲染.掉帧更加严重。基本上不能使用
 
 5.混合图层
 在需要裁剪的视图上面添加一层视图，以达到圆角的效果
 - (void)drawRoundedCornerImage {
     UIImageView *iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
     iconImgV.image = [UIImage imageNamed:@"icon"];
     [self.view addSubview:iconImgV];
     
     [iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(iconImgV.size);
         make.top.equalTo(self.view.mas_top).offset(500);
         make.centerX.equalTo(self.view);
     }];
     
     UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
     [self.view addSubview:imgView];
     
     [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(imgView.size);
         make.top.equalTo(iconImgV.mas_top);
         make.leading.equalTo(iconImgV.mas_leading);
     }];
     
     // 圆形
     imgView.image = [self drawCircleRadius:100 outerSize:CGSizeMake(200, 200) fillColor:[UIColor whiteColor]];
 }

 // 绘制圆形
 - (UIImage *)drawCircleRadius:(float)radius outerSize:(CGSize)outerSize fillColor:(UIColor *)fillColor {
     UIGraphicsBeginImageContextWithOptions(outerSize, false, [UIScreen mainScreen].scale);
     
     // 1、获取当前上下文
     CGContextRef contextRef = UIGraphicsGetCurrentContext();
     
     //2.描述路径
     // ArcCenter:中心点 radius:半径 startAngle起始角度 endAngle结束角度 clockwise：是否逆时针
     UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(outerSize.width * 0.5, outerSize.height * 0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:NO];
     [bezierPath closePath];
     
     // 3.外边
     [bezierPath moveToPoint:CGPointMake(0, 0)];
     [bezierPath addLineToPoint:CGPointMake(outerSize.width, 0)];
     [bezierPath addLineToPoint:CGPointMake(outerSize.width, outerSize.height)];
     [bezierPath addLineToPoint:CGPointMake(0, outerSize.height)];
     [bezierPath addLineToPoint:CGPointMake(0, 0)];
     [bezierPath closePath];
     
     //4.设置颜色
     [fillColor setFill];
     [bezierPath fill];
     
     CGContextDrawPath(contextRef, kCGPathStroke);
     UIImage *antiRoundedCornerImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     return antiRoundedCornerImage;
 }


 
 在Application这一层中主要是CPU在操作，而到了Render Server这一层，CoreAnimation会将具体操作转换成发送给GPU的draw calls（以前是call OpenGL ES，现在慢慢转到了Metal），显然CPU和GPU双方同处于一个流水线中，协作完成整个渲染工作。

 离屏渲染的定义:
 如果要在显示屏上显示内容，我们至少需要一块与屏幕像素数据量一样大的frame buffer，作为像素数据存储区域，而这也是GPU存储渲染结果的地方。如果有时因为面临一些限制，无法把渲染结果直接写入frame buffer，而是先暂存在另外的内存区域，之后再写入frame buffer，那么这个过程被称之为离屏渲染。
 
 CPU”离屏渲染“
 如果我们在UIView中实现了drawRect方法，就算它的函数体内部实际没有代码，系统也会为这个view申请一块内存区域，等待CoreGraphics可能的绘画操作。
 对于类似这种“新开一块CGContext来画图“的操作，有很多文章和视频也称之为“离屏渲染”（因为像素数据是暂时存入了CGContext，而不是直接到了frame buffer）
 其实所有CPU进行的光栅化操作（如文字渲染、图片解码），都无法直接绘制到由GPU掌管的frame buffer，只能暂时先放在另一块内存之中，说起来都属于“离屏渲染”。
 CPU渲染并非真正意义上的离屏渲染
 
 另一个证据是，如果你的view实现了drawRect，此时打开Xcode调试的“Color offscreen rendered yellow”开关，你会发现这片区域不会被标记为黄色，说明Xcode并不认为这属于离屏渲染
 
 其实通过CPU渲染就是俗称的“软件渲染”，而真正的离屏渲染发生在GPU
 
 主要的渲染操作都是由CoreAnimation的Render Server模块，通过调用显卡驱动所提供的OpenGL/Metal接口来执行的。
 通常对于每一层layer，Render Server会遵循“画家算法”，按次序输出到frame buffer，后一层覆盖前一层，就能得到最终的显示结果
 在iOS中，设备主存和GPU的显存共享物理内存，这样可以省去一些数据传输开销
 
 作为“画家”的GPU虽然可以一层一层往画布上进行输出，但是无法在某一层渲染完成之后，再回过头来擦除/改变其中的某个部分——因为在这一层之前的若干层layer像素数据，已经在渲染中被永久覆盖了。这就意味着，对于每一层layer，要么能找到一种通过单次遍历就能完成渲染的算法，要么就不得不另开一块内存，借助这个临时中转区域来完成一些更复杂的、多次的修改/剪裁操作。
 
 如果要绘制一个带有圆角并剪切圆角以外内容的容器，就会触发离屏渲染
 
 https://zhuanlan.zhihu.com/p/72653360
 */


// MARK: swift 常用第三方库
/**
 https://www.jianshu.com/p/f4282df18537
 
 */

// MARK: Swift 常用UI
/**
 // UI库
 https://github.com/Ramotion/swift-ui-animation-components-and-libraries
 
 // tab-bar
 https://github.com/Ramotion/animated-tab-bar
 */

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func incrementor(ptr: UnsafeMutablePointer<Int>) {
        ptr.pointee += 1
    }
    
    func incrementor1(num: inout Int) {
        num += 1
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: deinit
        /**
         先UIViewController deinit->再它里面的view deinit
         */
        
        // MARK:MemoryLayout-内存中的布局
        /**
         汇编中MOV为赋值指令，MOV后面的字母为操作数长度，b（byte）为一个字节
         $代表着字面量，%开头的是CPU的寄存器
         movb $0x2, 0x500f(%rip)这一句汇编代码的意思就是将2这个常量赋值给寄存器%rip中的地址加上0x500f
         
         callq 0x100002700: 就是调用0x100002700所在的函数
         
         callq  *0x78(%rcx)// 将%rcx的值加上0x78，得出一个函数地址值，并且调用这个函数
         
         枚举:
         枚举的内存大小受关联值的影响，也就是说枚举的关联值是存储在枚举内部的:
         以Season枚举为例子:
         枚举值分配的空间是按照最大的枚举值来分配的，Season类型的枚举summer(String,String,String)需要占用49个字节（一个Stirng占16个字节，3 * 16 + 1 = 49）
         所以Season会给所有的枚举值分配49个字节，并在第49个字节存放枚举值。
         由于内存对齐长度为8个字节，系统分配的内存必须为8的倍数。所以系统会分配56个字节给Season类型的枚举值。
         
         结论: 单个枚举所占空间是按照枚举关联值所占字节总和最高的枚举字节数+1个字节的方式来分配的。
         在没有关联值的情况下，枚举在内存中占1个字节且所占内存的大小不受原始值影响。
         关联值会保存在枚举的内存中，影响着枚举所占内存的大小。
         
         类:
         class Animal{
             var age:Int = 0
             var height:Int = 10
             init() {
             }
         }
         var animal = Animal.init()
         size: 8
         stride: 8
         alignment: 8
         无论往Person对象中增加还是减少存储属性，通过MemoryLayout类方法打印出的内存占用都是8个字节，这是因为Animal对象存储在堆中
         animal变量内部保存着Animal对象的内存地址
         MemoryLayout打印的是animal这个变量所占用的内存，所以无论如何打印出来的都是swift指针大小，也就是8个字节
         
         如何查看Animal对象的大小呢?
         通过汇编查看:
         movq %rax, 0x4cd2(%rip) // 赋值
         lldb: register read rax
         得到Animal对象地址值
         
         Animal对象实际占用24个字节，由于堆空间内存对齐的长度为16个字节，意味着Animal对象占用的内存必须为16的倍数，所以系统实际给Animal对象分配了32个字节
         前8个字节是类型信息，第9～16个字节保存的是引用计数
         第17～24个字节保存着age变量
         
         结论: class的对象的前8个字节保存着type的meta data，其中包括了方法的地址
         由于类的实例对象保存在堆空间中，系统需要通过检查引用计数的情况来确定是否需要回收对象（ARC中系统已经帮我们处理堆内存的管理，程序员不需要关心引用计数，但这并不代表引用计数不存在），所以对象中需要留出8个字节保存引用计数情况。类可以被继承，由于面向对象语言的多态特性，在调用类的实例对象方法时，编译器需要动态地获取对象方法所在的函数地址，所以需要留出8个字节保存类的类型信息，比如对象方法的地址就保存在类型信息中。
         所以当类的实例对象在调用对象方法时，性能的开销相比结构体以及枚举调用方法要大，因为多态的存在，系统会先找到该对象的前8个字节（type meta data）加上一个偏移值得到函数的地址，再找到这个函数去调用。
         
         结构体:
         struct Person {
             var age:Int = 10
             var man:Bool = true
             func test() {
                 print("test")
             }
         }
         let per = Person()
         size: 16
         stride: 9
         alignment: 8
         
         由于结构体是值类型，相较于类而言其不能被子类继承，也不需要引用计数来管理其内存的释放。
         所以在存储属性相同的情况下，结构体的内存要比类小。
         结构体由于不能继承，其方法地址在编译的时候就能确定。
         */
        let size = MemoryLayout<TestPoint>.size// 17
        let stride = MemoryLayout<TestPoint>.stride// 24
        let alignment = MemoryLayout<TestPoint>.alignment// 8
        
        // MARK: 指针UnsafePointer和托管Unmanaged
        /**
         但是Swift的&操作和C语言不同的一点是，Swift不允许直接获取对象的指针，比如下面的代码就会编译不通过。
         let a = NSData()
         let b = &a //编译出错
         
         UnsafePointer<T> 是不可变的。当然对应地，它还有一个可变变体，UnsafeMutablePointer<T>
         C 中的指针都会被以这两种类型引入到 Swift 中：C 中 const 修饰的指针对应 UnsafePointer (最常见的应该就是 C 字符串的 const char * 了)
         对于一个 UnsafePointer<T> 类型，我们可以通过 pointee 属性对其进行取值
         如果这个指针是可变的 UnsafeMutablePointer<T> 类型，我们还可以通过 pointee 对它进行赋值
         
         UnsafeMutablePointer:我们如果想要新建一个指针，需要做的是使用 allocate(capacity:) 这个类方法。该方法根据参数 capacity: Int 向系统申请 capacity 个数的对应泛型类型的内存
         
         Swift 中存在表示一组连续数据指针的 UnsafeBufferPointer<T>
         
         托管: TestPointerViewController.swift
         https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFMemoryMgmt/Concepts/Ownership.html
         
         当我们从CF函数中获取到Unmanaged<T>对象的时候，我们需要调用takeRetainedValue或者takeUnretainedValue获取到对象T
         如果一个函数名中包含Create或Copy，则调用者获得这个对象的同时也获得对象所有权，返回值Unmanaged需要调用takeRetainedValue()方法获得对象。调用者不再使用对象时候，Swift代码中不需要调用CFRelease函数放弃对象所有权，这是因为Swift仅支持ARC内存管理
         如果一个函数名中包含Get，则调用者获得这个对象的同时不会获得对象所有权，返回值Unmanaged需要调用takeUnretainedValue()方法获得对象
         */
        
        var aa = 10
        // 这里和 C 的指针使用类似，我们通过在变量名前面加上 & 符号就可以将指向这个变量的指针传递到接受指针作为参数的方法中去
        incrementor(ptr: &aa)
        print("aa = \(aa)")// 11
        // 与这种做法类似的是使用 Swift 的 inout 关键字。我们在将变量传入 inout 参数的函数时，同样也使用 & 符号表示地址。不过区别是在函数体内部我们不需要处理指针类型，而是可以对参数直接进行操作
        incrementor1(num: &aa)
        print("aa = \(aa)")// 12
        
        // 指针初始化和内存管理
        var intPtr = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        // 内存进行了分配，并且值已经被初始化. 这种状态下的指针是可以保证正常使用的
        intPtr.initialize(to: 10)// 在完成初始化后，我们就可以通过 pointee 来操作指针指向的内存值了
        intPtr.pointee = 11
        print(intPtr, intPtr.pointee)// 地址， 11
        
        // 注意其实在这里对于 Int 这样的在 C 中映射为 int 的 “平凡值” 来说，deinitialize 并不是必要的，因为这些值被分配在常量段上。但是对于像类的对象或者结构体实例来说，如果不保证初始化和摧毁配对的话，是会出现内存泄露的。所以没有特殊考虑的话，不论内存中到底是什么，保证 initialize: 和 deinitialize 配对会是一个好习惯。
        let rawPtr: UnsafeMutableRawPointer = intPtr.deinitialize(count: 1)
        print(intPtr, intPtr.pointee, rawPtr)
        intPtr.deallocate()
        
        print("\(Int.max)")
        
        // ======
        let intPointer = UnsafeMutablePointer<Int>.allocate(capacity: 4)
        for i in 0..<4 {
            (intPointer + i).initialize(to: i)
        }
        print(intPointer.pointee)
        intPointer.deallocate()
        
        // MARK: 指向数组的指针
        /**
         在 Swift 中将一个数组作为参数传递到 C API 时，Swift 已经帮助我们完成了转换
         
         public func vDSP_vadd(_ __A: UnsafePointer<Float>, _ __IA: vDSP_Stride, _ __B: UnsafePointer<Float>, _ __IB: vDSP_Stride, _ __C: UnsafeMutablePointer<Float>, _ __IC: vDSP_Stride, _ __N: vDSP_Length)
         
         对于一般的接受 const 数组的 C API，其要求的类型为 UnsafePointer，
         而非 const 的数组则对应 UnsafeMutablePointer。
         使用时，对于 const 的参数，我们直接将 Swift 数组传入 (上例中的 a 和 b)；而对于可变的数组，在前面加上 & 后传入即可
         
         对于传参，Swift 进行了简化，使用起来非常方便。
         但是如果我们想要使用指针来像之前用 pointee 的方式直接操作数组的话，就需要借助一个特殊的类型：UnsafeMutableBufferPointer
         Buffer Pointer 是一段连续的内存的指针，通常用来表达像是数组或者字典这样的集合类型
         */
        let a: [Float] = [1, 2, 3, 4]
        let b: [Float] = [0.5, 0.25, 0.125, 0.0625]
        var result: [Float] = [0, 0, 0, 0]
        vDSP_vadd(a, 1, b, 1, &result, 1, 4)// // result now contains [1.5, 2.25, 3.125, 4.0625]

        var array = [1, 2, 3, 4, 5]
        var arrayPtr = UnsafeMutableBufferPointer<Int>(start: &array, count: array.count)// baseAddress 是第一个元素的指针，类型为 UnsafeMutablePointer<Int>
        if let basePtr: UnsafeMutablePointer<Int> = arrayPtr.baseAddress {
            print(basePtr.pointee)  // 1
            basePtr.pointee = 10
            print(basePtr.pointee) // 10, array数组的第一个元素也为10了
            
            //下一个元素
            let nextPtr = basePtr.successor()
            print(nextPtr.pointee) // 2
        }
        
        // MARK: 指针操作和转换
        /**
         在 Swift 中不能像 C 里那样使用 & 符号直接获取地址来进行操作
         如果我们想对某个变量进行指针操作，我们可以借助 withUnsafePointer 或 withUnsafeMutablePointer 这两个辅助方法
         这两个方法接受两个参数，第一个是 inout 的任意类型，第二个是一个闭包
         Swift 会将第一个输入转换为指针，然后将这个转换后的 Unsafe 的指针作为参数，去调用闭包。withUnsafePointer 或 withUnsafeMutablePointer 的差别是前者转化后的指针不可变，后者转化后的指针可变
         */
        var test = 10
        test = withUnsafeMutablePointer(to: &test, { (ptr: UnsafeMutablePointer<Int>) -> Int in
            ptr.pointee += 1
            return ptr.pointee
        })
        print("test = \(test)")// 11
        
        
        
        // MARK: "@"
        /**
         @IBOutlet
         如果你用@IBOutlet属性标记一个属性，那么Interface Builder（IB）将识别那个变量，并且你将能够通过提供的“outlet”机制将你的源代码与你的XIB或者Storyboard连接起来
         
         @IBAction
         @IBAction同样是连接代码和Interface Builder的桥梁，只不过@IBAction连接的是func函数，而不是属性。被标记的方法将直接接收由用户界面触发的事件。
         
         @IBInspectable
         我们经常用Interface Builder的属性编辑面板对控件的属性进行设置，但是还有一些属性并没有暴露在Interface Builder的设置面板中。用@IBInspectable标记一个NSCodable的属性将会使它可以很容易地在Interface Builder的属性面板编辑器中进行编辑
         
         @IBDesignable
         当给一个UIView的子类应用@IBDesignable时，这个类就可以显示在Interface Builder中，使我们的代码变得“所见即所写”，我们对代码的修改也可以实时的反馈在Interface Builder中。
         
         @UIApplicationMain
         这个属性使被标记的类作为本应用的代理。通常来说，这个代理类都是系统自动创建的AppDelegate.swift文件。
         
         @available
         通过@available使得被标记的方法或属性适用于不同的平台或系统版本。
         @available(swift 4.1)
         @available(iOS 11, *)
         
         @objcMembers
         通常在项目中如果想把Swift写的API暴露给Objective-C调用，需要增加@objc。这个@objcMembers是一个便捷方法来标记一个类的全部方法都加上@objc。不过这个属性会引起性能问题。
         
         @escaping

         如果你希望被标记的值可以存储起来以便后续代码继续使用，你可以将闭包的参数标记为@escaping，换句话说，被标记的值的可以超越原来的生命周期范围，被外界调用。
         
         @discardableResult
         默认情况下，如果调用一个函数，但函数的返回值并未使用，那么编译器会发出警告。你可以通过给func使用@discardableResult来抑制警告。
         
         @autoclosure
         如果一个func有一个闭包参数，这个闭包参数没有形参但有返回类型。@autoclosure可以神奇地把这样的func转换成有一个参数且这个参数的类型就是闭包的返回值类型的func。这样的好处是在调用这个带闭包的func时，传的实参不用非得是闭包类型，只要是闭包返回值类型的就可以了，@autoclosure会自动把这个值转换成闭包类型。
         
         @objc: TestClass.swift
         这个属性就是关联Swift对象和OC对象的桥梁。你还可以通过@objc提供一个标识符，这个标识符就是对应到OC中的类或方法。
         
         @nonobjc
         使用这个属性来禁止隐式添加@objc属性。@nonobjc告诉编译器当前声明的内容不能在OC中使用
         
         @convention特性是在 Swift 2.0 中引入的，用于修饰函数类型，它指出了函数调用的约定
         @convention(swift) : 表明这个是一个swift的闭包
         @convention(block) ：表明这个是一个兼容oc的block的闭包
         @convention(c) : 表明这个是兼容c的函数指针的闭包。

         它用来修饰func，而且它还带有一个参数，这个参数的取值一般是：swift、c、block。被修饰的func可以用来匹配其他语言平台的函数指针类型的形参
         1. 当调用C函数的时候，可以传入被@convention(c)修饰的swift函数，来匹配C函数形参中的函数指针。
         2. 当调用OC方法的时候，可以传入被@convention(block)修饰的swift函数，来匹配OC方法形参中的block参数。
         
         CGFloat myCFunc(CGFloat (callback)(CGFloat x, CGFloat y)) {
            return callback(1.1, 2.2)
         }
         
         let swiftCallback: @convention(c) (CGFloat, CGFloat) -> CGFloat = {
            (x, y) -> CGFloat in
            return x + y
         }
         
         let result = myCFunc( swiftCallback )// 3.3
         */
        
        
        // MARK: String
        /**
         NSString对象使用UTF-16编码
         
         endIndex是最后一个元素后边的那个元素，因此不能直接访问，否则会崩溃。
         不同的字符可能需要不同数量的内存来存储，因此为了确定哪个Character位于特定位置，您必须从每个Unicode标量的开始或结尾处遍历String。因此，Swift字符串不能用整数值索引。(不能用整数下标随机访问)
         
         Swift标准库只支持的三种下标访问String字符串的方法:
         Range<String.Index>：元素为String.Index类型的Range（开区间）
         String.Index：String.Index元素
         ClosedRange<String.Index>：元素为String.Index类型的CloseRange（闭区间）
         
         Swift的String类型是基于Unicode标量建立的，先来介绍一下Unicode和Unicode标量
         人类使用的文字和符号要想被计算机所理解必须要经过编码，Unicode就是其中的一种编码标准。
         码点：Unicode标准为世界上几乎所有的书写系统里所使用的每一个字符或符号定义了一个唯一的数字。这个数字叫做码点（code points），以U+xxxx这样的格式写成，格式里的xxxx代表四到六个十六进制的数。例如U+0061表示小写的拉丁字母(LATIN SMALL LETTER A)("a")，U+1F425表示小鸡表情(FRONT-FACING BABY CHICK) ("🐥")

         编码格式：通过字符到码点之间的映射，人们得以用统一的方式表示符号，但还需要定义另一种编码来确定码点与其存储在内存和硬盘中的值的对应关系。有三种Unicode支持的编码格式：

         UTF-8：表示一个码点需要1～4个八位的码元。利用字符串的utf8属性进行访问。
         UTF-16：用一或两个16位的码元表示一个吗点。利用字符串的utf16属性进行访问。
         21位的 Unicode 标量值集合，也就是字符串的UTF-32编码格式，用21位的码元表示一个码点。利用字符串的unicodeScalars属性进行访问。
         
         如“é”, “김”, and “🇮🇳”是作为独立的character存在的，这些独立的character可能是由多个Unicode码点组成的。
         */
        let testStr = "abc123"
        print("start = \(testStr[testStr.startIndex])")// a
        let endIndex = testStr.index(before: testStr.endIndex)// 最后一个元素
        let endValue: Character = testStr[endIndex]
        print("endValue = \(endValue)")
//        print("end = \(testStr[testStr.endIndex])")// Fatal error: String index is out of bounds
        
        let string = "e\u{301}" // é
        let charFromNSString = (string as NSString).character(at: 0)  //101 说明此方法的索引对象是字符串对应的UTF-16码元。所以返回了索引为0的码元，即101.对于这种情况OC中有专门的字符串正规化处理办法，也可以判断一个字符的码元长度
        let charFromString = string[string.startIndex]  //é
        
        let enclosedEAcute: Character = "\u{E9}\u{20DD}"
        // enclosedEAcute 是 é⃝
        let regionalIndicatorForUS: Character = "\u{1F1FA}\u{1F1F8}"
        // regionalIndicatorForUS 是 🇺🇸
        print("enclosedEAcute = \(enclosedEAcute) regionalIndicatorForUS = \(regionalIndicatorForUS)")
        
        
        // ========================================
        // 数组map
//        var arr1 : [Int] = [1, 2, 3] // print: ==1== ==2== ==3==
        // 可选类型map
        var arr1 : [Int]? = [1, 2, 3]// print: ==[1, 2, 3]==
        arr1.map {
            print("==\($0)==")
        }

        // ========================================
        // 可选类型
        let num: Int? = 1
        switch num {
        case .none:
            print("nil")
        case .some(let intNum):
            print("intNum = \(intNum)")
        }
        
        // ========================================
        // 会创建多个线程
        DispatchQueue.global().async {
            print("1.\(Thread.current)")
        }
        
        DispatchQueue.global().async {
            print("2.\(Thread.current)")
        }
        
        DispatchQueue.global().async {
            print("3.\(Thread.current)")
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        UserDefaults.standard.set("100", forKey: "StringKey")
    }


}

// MARK: 闭包(Closure)
/**
 闭包有三种形式:
 全局函数，有名字的闭包并且不捕获任何值(定义的一般函数)
 嵌套函数，有名字的闭包，可以在闭包所在函数内部捕获值(函数里嵌套函数)
 闭包表达式，没有名字的闭包，使用简洁的语法，可以在包裹闭包的上下文捕获值(闭包)

 //Global function
 func block() {
     print("block")    //block
 }
 
 //Nested function
 func block(){
     let name = "block"
     func printStr() {
         print(name)
     }
     printStr()
 }
 block()    //block
 
 //Closure expression
 let block = {
     print("block")
 }
 block()    //block
 
 
 func makeIncrementer(from start: Int, amount: Int) -> ()->Int {
     var number = start
     return {
         number += amount
         return number
     }
 }
 let incrementer = makeIncrementer(from: 0, amount: 1)
 incrementer()  //1
 incrementer()  //2
 incrementer()  //3
 每次调用incrementer()都会执行闭包里面的操作，而闭包的上下文就是makeIncrementer函数
 
 //block
 NSInteger number = 1;
 NSMutableString *str = [NSMutableString stringWithString: @"hello"];
 void(^block)() = ^{
   NSLog(@"%@--%ld", str, number);
 };
 [str appendString: @" world!"];
 number = 5;
 block();    //hello world!--1
 
 //closure
 var str = "hello"
 var number = 1
 let block = {
     print(str + "--" + " \(number)")
 }
 str.append(" world!")
 number = 5
 block()    //hello world!--5
 
 逃逸闭包，指的是当一个函数有闭包作为参数，但是闭包的执行比函数的执行要迟
 这个闭包的作用域本来是在当前函数里面的，然后它要逃出这个作用域，不想和函数同归于尽
 那么闭包怎么逃逸呢？最简单的方法是把闭包赋值给外面的变量
 
 如果逃逸闭包访问的是类里面的成员，必须带上self来访问
 
 自动闭包作为函数参数，不写"{}"，直接写返回值
 */

// MARK: ---MJ---
// MARK: swift
/**
 2014.6月发布的
 2019.6 swift 5.1
 
 swift5.1  Xcode11  macos10.14
 
 OC的编译器前端是Clang，编译器后端是LLVM
 Swift的编译器前端是swiftc，编译器后端是LLVM
 编译器前端：词法分析
 编译器后端：LLVM 生成对应平台的二进制代码
 
 想运行在ios系统，最终生成的是ARM架构的代码
 
 生成swift语法树
 swiftc -dump-ast main.swift
 生成最简洁的sil代码
 swiftc -emit-sil main.swift
 生成LLVM IR代码
 swiftc -emit-ir main.swift -o main.ll
 生成汇编代码
 swift -emit-assembly main.swift -o main.s
 
 对汇编代码进行分析，能真正掌握编程语言的本质
 
 import PlaygroundSupport
 PlaygroundPage.current.liveView = view
 
 // 元祖
 let tuple1 = (404, "Not Found")
 let tuple2 = (code: 404, msg: "Not Found")
 let (statusCode, statusMsg) = tuple1
 let (statusCode, _) = tuple1
 print(statusCode)
 
 if 后面的条件只能是bool类型，不像oc里面 非0的就是true
 
 // 不加var默认是let
 for var i in 0...3 {
 i+=5
 print(i)
 }
 
 区间运算符用在数组上,names是个数组
 for name in names[0...3] {
 
 }
 
 区间类型
 ClosedRange: 1...3
 Range: 1..<3
 PartialRangeThrough: ...5
 
 带间隔的区间值
 let hours = 11
 let hourInterval = 2
 从4开始，累加2，不s超过11
 for tickMark in stride(from: 4, through: hours, by: hourInterval) {
 // 4,6,8,10
 }
 
 ASCII
 "\0"..."~"
 
 swicth默认可以不写break，并不会贯穿到后面
 fallthrough实现贯穿效果
 如果使用了fallthrough 语句，则会继续执行之后的 case 或 default 语句，不论条件是否满足都会执行。
 case，default后面至少要有一条语句，default不处理的话加break
 枚举类型可以不必使用default
 支持String，Character
 复合条件：case "jack", "rose":
 区间匹配：case 1..<5:
 元祖匹配:
 let point = (1, 1)
 case (0,0):
 case (_, 0):
 case (-2...2, -2...2): // 匹配这个
 值绑定: let point = (2, 0)
 case (let x, 0): // 0匹配，把2赋值给x
 case let (x, y):
 where:
 let point = (1, -1)
 case let (x, y) where x == -y:
 
 numbers是数组
 for num in numbers where num > 0 {
 
 }
 
 41:23
 */

// MARK: 字面量
/**
 可存ASCII字符，Unicode字符
 let ch: Character = ""
 
 let doubleDecimal = 125.0 // 1.25e2 等价于1.25*(10^2)
 
 // 16进制
 0xFp2 等价于 15*(2^2)
 
 1000000 等价于 100_0000
 
 000123.456
 
 let array = [1, 2, 3]
 */

// MARK:类型转换
/**
 let int1: UInt16 = 2_000
 let int2: UInt8 = 1
 let int3 = int1 + UInt16(int2) // 把内存占用小的转成大的
 */



// MARK: ---汇编
/**
 指令:
 callq 表示函数调用
 addq 加法
 */
