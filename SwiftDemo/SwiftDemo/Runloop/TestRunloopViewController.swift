//
//  TestRunloopViewController.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/10/30.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

class TestRunloopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .red
        button.frame = CGRect(x: 100, y: 100, width: UIScreen.main.bounds.width - 200, height: 60)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        view.addSubview(button)

        addObserver()
        
        delay(by: 3.0) {
            print("===1")
            DispatchQueue.main.async {
                print("===3")
            }
            print("===2")
        }
    }
    
    func addObserver() {
        /**
         The run loop observer is not automatically added to a run loop. To add the observer to a run loop, use CFRunLoopAddObserver(_:_:_:). An observer can be registered to only one run loop, although it can be added to multiple run loop modes within that run loop.
         
         public static var entry: CFRunLoopActivity { get }// 进入工作

         public static var beforeTimers: CFRunLoopActivity { get }// 即将处理Timers事件

         public static var beforeSources: CFRunLoopActivity { get }// 即将处理Source事件

         public static var beforeWaiting: CFRunLoopActivity { get }// 即将休眠

         public static var afterWaiting: CFRunLoopActivity { get }// 被唤醒

         public static var exit: CFRunLoopActivity { get }// 退出RunLoop

         public static var allActivities: CFRunLoopActivity { get }// 监听所有事件
         
         如果此时添加了Timer事件, 并且随时触发Source事件的话, 通过下面的打印, 可以判断一些情况:
         当App程序启动的时候, RunLoop会进入UIInitializationRunLoopMode模式, 这时在处理UI的准备工作
         随后RunLoop会进入工作
         ---在即将处理事件的时候, RunLoop会从休眠中被唤醒, 进入被唤醒的状态kCFRunLoopAfterWaiting
         然后会第一时间处理Timer的事件
         处理之后, 查看是否还有Timer需要处理
         然后检查是否还有Source需要处理
         这时没有事件需要处理, 则准备进行休眠, 并且进行休眠
         当Timer再次触发时, RunLoop被唤醒, 并继续进行上面---开始的步骤
         */
        let runloopObserver = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault,
                                           CFRunLoopActivity.allActivities.rawValue,
                                           true,
                                           0) { (observer, activity: CFRunLoopActivity) in
            switch (activity) {
            case .entry:
                print("entry")
            case .beforeTimers:
                print("beforeTimers")
            case .beforeSources:
                print("beforeSources")
            case .beforeWaiting:
                print("beforeWaiting")
            case .afterWaiting:
                print("afterWaiting")
            case .exit:
                print("exit")
            default:
                print("default")
            }
        }
        
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), runloopObserver, CFRunLoopMode.defaultMode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // MARK: 1
        /**
         点击屏幕触发
         Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)写的话：
         afterWaiting
         beforeTimers
         beforeSources
         ===touchesBegan===
         beforeTimers
         beforeSources
         beforeTimers
         beforeSources
         beforeWaiting
         afterWaiting
         beforeTimers
         beforeSources
         beforeTimers
         beforeSources
         beforeWaiting
         
         afterWaiting
         updateTimer currentMode: Optional("kCFRunLoopDefaultMode")
         beforeTimers
         beforeSources
         beforeWaiting
         
         没写的话：
         afterWaiting
         beforeTimers
         beforeSources
         ===touchesBegan===
         beforeTimers
         beforeSources
         beforeTimers
         beforeSources
         beforeWaiting
         afterWaiting
         beforeTimers
         beforeSources
         beforeTimers
         beforeSources
         beforeWaiting
         */
        print("===touchesBegan===")
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc
    func updateTimer() {
        print("updateTimer currentMode: \(String(describing: RunLoop.current.currentMode?.rawValue))")
    }
    
    @objc
    func buttonClicked() {
        // MARK: 2
        /**
         当touchesBegan已点击，定时器已开启的情况下:
         afterWaiting
         beforeTimers
         beforeSources
         beforeTimers
         beforeSources
         beforeTimers
         beforeSources
         beforeWaiting
         afterWaiting
         beforeTimers
         beforeSources
         ===buttonClicked===
         beforeTimers
         beforeSources
         beforeWaiting
         
         当touchesBegan未点击，定时器未开启的情况下:
         afterWaiting
         beforeTimers
         beforeSources
         beforeTimers
         beforeSources
         beforeTimers
         beforeSources
         beforeWaiting
         afterWaiting
         beforeTimers
         beforeSources
         ===buttonClicked===
         beforeTimers
         beforeSources
         beforeWaiting
         */
        print("===buttonClicked===")
    }

}
