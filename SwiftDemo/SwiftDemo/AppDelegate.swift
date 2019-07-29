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

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

