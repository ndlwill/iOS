//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by dzcx on 2019/7/17.
//  Copyright © 2019 dzcx. All rights reserved.
//

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

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let num: Int? = 1
        switch num {
        case .none:
            print("nil")
        case .some(let intNum):
            print("intNum = \(intNum)")
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

