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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

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
        
        
        
        
        
        let str = "123"
        let s = str.subString(from: 1, length: 6)
        let subStr = str.prefix(4)
        
        
//        print("\()")

        // 数组map
//        var arr1 : [Int] = [1, 2, 3] // print: ==1== ==2== ==3==
        // 可选类型map
        var arr1 : [Int]? = [1, 2, 3]// print: ==[1, 2, 3]==
        arr1.map {
            print("==\($0)==")
        }

        
        // 可选类型
        let num: Int? = 1
        switch num {
        case .none:
            print("nil")
        case .some(let intNum):
            print("intNum = \(intNum)")
        }
        
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
