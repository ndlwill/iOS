//
//  TestClosureViewController.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/5/15.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

class SimpleClass {
    var value: Int = 0
}

class TestClosureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        
        // MARK: ==closure==
        var a = 0
        var b = 0
        let closure = { [a] in //
            // a = a + 1// 报错 'a' is an immutable capture
            
            print("a = \(a) b = \(b)")
        }
        a = 10
        b = 8
        closure()// 0, 8
        
        // 当捕获的变量类型有引用语义时，则没有这种区别
        var x = SimpleClass()
        x.value = 10
        var y = SimpleClass()
        y.value = 100
        
        let closure1 = { [x] in
            
            print(x.value, y.value)
        }
        x.value = 18
        y.value = 108
        closure1()// 18, 108
        
        // 如果表达式值的类型是一个类，您可以在捕获列表中将表达式标记为weak或unowned，以捕获对表达式值的weak或unowned引用
        let fun1 = {// implicit strong capture
            print(Unmanaged<AnyObject>.passUnretained(self as AnyObject).toOpaque())
        }
        let fun2 = { [self] in // explicit strong capture
            print(Unmanaged<AnyObject>.passUnretained(self as AnyObject).toOpaque())
        }
        let fun3 = { [weak self] in // weak capture
            print(Unmanaged<AnyObject>.passUnretained(self as AnyObject).toOpaque())
        }
        let fun4 = { [unowned self] in // unowned capture
            print(Unmanaged<AnyObject>.passUnretained(self as AnyObject).toOpaque())
        }
        fun1()// 0x00007ff5afc13950
        fun2()// 0x00007ff5afc13950
        fun3()// 0x00007ff5afc13950
        fun4()// 0x00007ff5afc13950
        
    }


}
