//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by dzcx on 2019/7/17.
//  Copyright © 2019 dzcx. All rights reserved.
//

// RxSwift
// https://www.jianshu.com/p/f61a5a988590

// RxSwift 中文文档
// https://beeth0ven.github.io/RxSwift-Chinese-Documentation/

// ##swift##
// http://www.hangge.com/blog/cache/category_72_1.html

// Moya-ObjectMapper
// https://github.com/ivanbruel/Moya-ObjectMapper

// RxSwiftCommunity
// https://github.com/RxSwiftCommunity
// RxAlamofire
// https://github.com/RxSwiftCommunity/RxAlamofire
// RxDataSources
// https://github.com/RxSwiftCommunity/RxDataSources

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
 在 Swift4 中，可以把类（Class）和协议（Protocol）用 & 组合在一起作为一个类型使用
 
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
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = TestViewController()
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
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

