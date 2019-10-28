//
//  Person1.swift
//  SwiftDemo
//
//  Created by ndl on 2019/10/16.
//  Copyright © 2019 dzcx. All rights reserved.
//

import UIKit

class Person1: NSObject {
    var name: String
    var age: Int
    
    override init() {
        self.name = "Person1"
        self.age = 10
        
        super.init()
    }
    
    override var description: String {
        return String(format: "{Person1:%p name = \(name), age = \(age)}", self)
    }
}
