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
        // MARK: ===CFArray===
        let allocator: CFAllocator = CFAllocatorGetDefault().takeUnretainedValue()
        // Ownership follows the The Create Rule
        // 得到的是一个托管对象, 所以我们不需要再使用CFRelease来释放它了
        let arr: CFMutableArray! = CFArrayCreateMutable(allocator, 0, nil)
        let name: NSString = "qwer"
        let name1: NSString = "1234"
        // toOpaque: Unsafely converts an unmanaged class reference to a pointer.
        CFArrayAppendValue(arr, Unmanaged.passRetained(name).autorelease().toOpaque())
//        CFArrayAppendValue(arr, Unmanaged.passUnretained(name).toOpaque())
        CFArrayAppendValue(arr, Unmanaged.passUnretained(name1).toOpaque())
        
        // CFArrayGetValues
        let valuePointer: UnsafeMutablePointer<UnsafeRawPointer?> = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        // CFArrayGetValues获取到的是一个指向了一个数组的指针
        CFArrayGetValues(arr, CFRange(location: 0, length: 2), valuePointer)
        // 通过这个指针我们可以创建一个Buffer指针(Swift里Buffer可理解为一个数组的指针)
        let valueBuffer: UnsafeMutableBufferPointer<UnsafeRawPointer?> = UnsafeMutableBufferPointer.init(start: valuePointer, count: 2)
        // 遍历这个Buffer集合可以得到一个UnsafeRawPointer,这实际就是一个非托管对象的指针
        valueBuffer.forEach { (rawPointer) in
            if let rawP = rawPointer {
                // Unmanaged<NSString>.fromOpaque()方法得到一个非托管对象,然后通过takeUnretainedValue()拿到它的值
                print(Unmanaged<NSString>.fromOpaque(rawP).takeUnretainedValue())
            }
        }
        
        // CFArrayGetValueAtIndex: return UnsafeRawPointer
        let firstValue: UnsafeRawPointer! = CFArrayGetValueAtIndex(arr, 0)
         
        // fromOpaque: Unsafely turns an opaque C pointer into an unmanaged class reference.
        let result = Unmanaged<NSString>.fromOpaque(firstValue).takeUnretainedValue()
        print("result = \(result)")
        
        
        
        addRunloopOberver1()
    }
    
    func addRunloopOberver1() {
        // passRetained下面takeUnretainedValue 返回到前一页不会调==TestCFViewController deinit== 导致内存泄漏
        let controllerPoint = Unmanaged<TestCFViewController>.passUnretained(self).toOpaque()
        
        var content = CFRunLoopObserverContext(version: 0, info: controllerPoint, retain: nil, release: nil, copyDescription: nil)
        
        let runloopObserver = CFRunLoopObserverCreate(nil, CFRunLoopActivity.beforeWaiting.rawValue, true, 0, { (oberver, activity, info) in
            
            if info == nil {//如果没有取到  直接返回
                return
            }
            
            // 上边passUnretained这边takeRetainedValue: 会==TestCFViewController deinit==，导致下面崩溃。我的理解调takeRetainedValue，相当于CF那边会release
            let controller = Unmanaged<TestCFViewController>.fromOpaque(info!).takeUnretainedValue()
            
            if controller.isKind(of: TestCFViewController.self) {
                print("===###===")
            }
        }, &content)
        
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), runloopObserver, CFRunLoopMode.commonModes)
    }
    
    
}
