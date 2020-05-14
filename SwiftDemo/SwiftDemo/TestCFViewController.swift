//
//  TestCFViewController.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/5/13.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit
import AddressBook


class TestCFViewController: UIViewController {
    
    deinit {
        print("==TestCFViewController deinit==")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        
        // MARK: ===Unmanaged===takeRetainedValue===takeUnretainedValue
        /**
         https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFMemoryMgmt/Concepts/Ownership.html
         Swift 仅支持 ARC，所以也没有地方调用 CFRelease
         
         分两种情况:
         注明 的 API，Swift 能够在上下文中严格遵循注释描述对 CoreFoundation API 进行内存管理，并以同样内存安全的方式桥接到 Objective-C 或 Swift 类型上。
         对于没有明确注明的 API，Swift 则会通过 Unmanaged 类型把工作交给开发者。
         
         虽然大多数的 CoreFoundation API 都有注明是否可自动管理，但一些重要的部分还没有得到充分重视。
         
         从一个 Unmanaged 实例中获取一个 Swift 值的方法有两种：
         takeRetainedValue()：返回该实例中 Swift 管理的引用，并在调用的同时减少一次引用次数，所以可以按照 Create 规则来对待其返回值。

         takeUnretainedValue()：返回该实例中 Swift 管理的引用而 不减少 引用次数，所以可以按照 Get 规则来对待其返回值。
         */
        
        // MARK: ===passRetained===passUnretained===
        /**
         将一个对象声明为非托管有两个方法：
         passRetained
         passUnretained

         如果这个非托管对象的使用全程，能够保障被封装对象一直存活，我们就可以使用 passUnretained 方法，对象的生命周期还归编译器管理。
         
         如果非托管对象使用周期超过了编译器认为的生命周期，比如超出作用域，编译器自动插入 release 的 ARC 语义，那么这个非托管对象就是一个野指针了，此时我们必须手动 retain 这个对象，也就是使用 passRetained 方法。
         一旦你手动 retain 了一个对象，就不要忘记 release 掉它，方法就是调用非托管对象的 release 方法，或者用 takeRetainedValue 取出封装的对象，并将其管理权交回 ARC。
         
         但注意，一定不要对一个用 passUnretained 构造的非托管对象调用 release 或者 takeRetainedValue，这会导致原来的对象被 release 掉，从而引发异常。
         */
        
        /*
         takeUnretainedValue:
        This is useful when a function returns an unmanaged reference and you know that you’re not responsible for releasing the result.
         Gets the value of this unmanaged reference as a managed reference without consuming an unbalanced retain of it.
         
         takeRetainedValue:
         This is useful when a function returns an unmanaged reference and you know that you’re responsible for releasing the result.
         Gets the value of this unmanaged reference as a managed reference and consumes an unbalanced retain of it.
         */
        
        let allocator: CFAllocator = CFAllocatorGetDefault().takeRetainedValue()
        let arr: CFMutableArray? = CFArrayCreateMutable(allocator, 0, nil)
        let name: NSString = "qwer"
        // toOpaque: Unsafely converts an unmanaged class reference to a pointer.
        CFArrayAppendValue(arr, Unmanaged.passRetained(name).autorelease().toOpaque())
//        CFArrayAppendValue(arr, Unmanaged.passUnretained(name).toOpaque())
        
        // UnsafeRawPointer
        let firstValue: UnsafeRawPointer! = CFArrayGetValueAtIndex(arr, 0)
         
        // fromOpaque: Unsafely turns an opaque C pointer into an unmanaged class reference.
        let result = Unmanaged<NSString>.fromOpaque(firstValue).takeUnretainedValue()
        print("result = \(result)")
        
        
        
        
    }
    
    
}
