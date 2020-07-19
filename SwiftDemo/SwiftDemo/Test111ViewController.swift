//
//  Test111ViewController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/4/28.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

class Test111ViewController: UIViewController {
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Test111ViewController")
        
        A.classMethod()
        
        let anyClass: AnyClass = A.self
        (anyClass as! A.Type).classMethod()
        
        // A.Type 代表的是A这个类型的类型【也就是类 类型】
        let typeA: A.Type = A.self// 声明一个元类型来存储A这个类型本身
        let objA: A = A().self

    }


}
