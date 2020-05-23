//
//  TestPointerViewController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/5/6.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit
import AddressBook

struct TestPointer {
    let a: Int
    let b: Bool
}

class Resolution {
    var width = 0
    var height = 0
}

struct Resolution1 {
    var width = 0
    var height = 0
}

// MARK: ===swift指针===
// https://juejin.im/post/5d0dde2cf265da1baa1e7d50

class TestPointerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray

//        let id: ABRecordID = ABRecordID()
//        // @available(iOS, introduced: 2.0, deprecated: 9.0, message: "use [[CNContactStore alloc] init]")
//        let addressBook: Unmanaged<ABAddressBook>! = ABAddressBookCreateWithOptions(nil, nil)
//        /**
//         如果一个函数名中包含Create或Copy，则调用者获得这个对象的同时也获得对象所有权，返回值Unmanaged需要调用takeRetainedValue()方法获得对象。调用者不再使用对象时候，Swift代码中不需要调用CFRelease函数放弃对象所有权，这是因为Swift仅支持ARC内存管理
//         */
//        // Create Rule - retained
//        let addBook: ABAddressBook = addressBook.takeRetainedValue()
//        // Get Rule - unretained
//        if let record: ABRecord = ABAddressBookGetPersonWithRecordID(addBook, id).takeUnretainedValue() {
//            
//        }
        
        // TestPointer()这么创建的话，TestPointer里面的变量都需要初始化
        var test = TestPointer(a: 100, b: true)
        print("===start===")
//        passPointer(&test)
        
        // MARK: ===withUnsafePointer===withMemoryRebound===bindMemory===
        // 大->小
        withUnsafePointer(to: &test) { (pointer) -> Void in
            print("pointee = \(pointer.pointee)")
            
            // 类型转换
            // 通过这个方法我们就可以获取到这个结构体的每个字节了，方法就是将其 cast 到 UInt8 类型的指针。
            pointer.withMemoryRebound(to: Int.self, capacity: 1) { (pointer2) -> Void in
                // p2 就是一个 Int 类型的指针了
                print("pointer2.pointee = \(pointer2.pointee)")// 100
            }
        }
        // 或者
        withUnsafePointer(to: &test) { (pointer) -> Void in
            print("pointee = \(pointer.pointee)")
            
            // 类型转换
            print(UnsafeRawPointer(pointer).bindMemory(to: Int.self, capacity: 1).pointee)// 100
        }
        
        
        // withUnsafeBufferPointer Buffer 则提供了一系列操作数组的便利方法
        [1, 2, 3].withUnsafeBufferPointer { (pointer) -> Void in
            // baseAddress: A pointer to the first element of the buffer.
            print(pointer.baseAddress) // 得到 UnsafePointer<Int> 对象
            print(pointer.first) // 得到起始地址指向的 Int 对象
        }
        
        // MARK: ===unsafeDowncast===AnyObject之间的转换
        let strObj: NSObject = NSString(string: "1008")
        let resultVal = unsafeDowncast(strObj, to: NSString.self)// 1008

        // MARK: ==打印对象地址==
        let one = Resolution()
        // 0x000060000342c700
        print("one地址为: \(Unmanaged<AnyObject>.passUnretained(one as AnyObject).toOpaque())")
        let two = one
        // 0x000060000342c700
        print("two地址为:\(Unmanaged<AnyObject>.passUnretained(two as AnyObject).toOpaque())")
        
        var structOne = Resolution1()
        // passRetained
        print("structOne地址为:\(Unmanaged<AnyObject>.passRetained(structOne as AnyObject).toOpaque())")
        // 崩溃 passUnretained
//        print("structOne地址为:\(Unmanaged<AnyObject>.passUnretained(structOne as AnyObject).toOpaque())")
        print(structOne)
        
        // 同一个内容，同一个地址。改变了内容，新的地址
        let intValue = 100
        let intObject = intValue as AnyObject// NSNumber
        // 0xf985adf5c494622f
        print("intValue地址为:\(Unmanaged<AnyObject>.passUnretained(intValue as AnyObject).toOpaque())")
        var otherInt = intValue
        // 0xf985adf5c494622f
        print("otherInt地址为:\(Unmanaged<AnyObject>.passUnretained(otherInt as AnyObject).toOpaque())")
        otherInt = 120
        // 0xf985adf5c49463ef
        print("otherInt地址为:\(Unmanaged<AnyObject>.passUnretained(otherInt as AnyObject).toOpaque())")
        
        // public struct Array
        var arr1 = ["a","b","c"]
        var arr2 = arr1
        print(arr1,arr2)// ["a", "b", "c"] ["a", "b", "c"]
        arr1.remove(at: 0)
        print(arr1,arr2)// ["b", "c"] ["a", "b", "c"]
        // 崩溃
//        print("arr1地址为:\(Unmanaged<AnyObject>.passUnretained(arr1 as AnyObject).toOpaque())")
//        print("arr2地址为:\(Unmanaged<AnyObject>.passUnretained(arr2 as AnyObject).toOpaque())")
        
    }
    
    func passPointer(_ pointer: UnsafePointer<TestPointer>) {
        // pointer.pointee = x 就类似 C 中的 *pointer = x
        // MARK: ===advanced===
        /**
         地址计算：
         使用 advanced(by:) 函数可以得到一个偏移后的指针对象，这里地址计算的行为与 C 一致，地址偏移是根据指针类型的大小来计算的，而不是根据字节数。
         */
        print(pointer.pointee)
    }

}
