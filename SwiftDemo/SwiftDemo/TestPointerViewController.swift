//
//  TestPointerViewController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/5/6.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit
import AddressBook

class TestPointerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray

        let id: ABRecordID = ABRecordID()
        // @available(iOS, introduced: 2.0, deprecated: 9.0, message: "use [[CNContactStore alloc] init]")
        let addressBook: Unmanaged<ABAddressBook>! = ABAddressBookCreateWithOptions(nil, nil)
        /**
         如果一个函数名中包含Create或Copy，则调用者获得这个对象的同时也获得对象所有权，返回值Unmanaged需要调用takeRetainedValue()方法获得对象。调用者不再使用对象时候，Swift代码中不需要调用CFRelease函数放弃对象所有权，这是因为Swift仅支持ARC内存管理
         */
        // Create Rule - retained
        let addBook: ABAddressBook = addressBook.takeRetainedValue()
        // Get Rule - unretained
        if let record: ABRecord = ABAddressBookGetPersonWithRecordID(addBook, id).takeUnretainedValue() {
            
        }
    }

}
