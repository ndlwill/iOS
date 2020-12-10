//
//  TestRX5ViewController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/10/25.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

// 调度者
class TestRX5ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: map源码分析 源序列和新序列的关系
        /**
         Map.swift
        源序列提供的是响应
         
         _source.subscribe(sink)// subscribe括号里的是订阅者
         sink: MapSink
         
         即源序列的响应由sink来订阅
         */
        let subject = PublishSubject<Any>()
        subject.map {
            return $0
        }
        .subscribe(onNext: { (item) in// subscribe: 我的理解是###被订阅###
            
        })
        .dispose()
        //52
    }

}
