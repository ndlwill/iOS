//
//  TestProtocol.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/5/20.
//  Copyright © 2020 dzcx. All rights reserved.
//

import Foundation

protocol Greetable {
    var name: String { get }
    func greet()
}

struct Person_n: Greetable {
    let name: String
    func greet() {
        print("你好 \(name)")
    }
}

struct Cat_n: Greetable {
    let name: String
    func greet() {
        print("meow~ \(name)")
    }
}

protocol P {
    func myMethod()
}
