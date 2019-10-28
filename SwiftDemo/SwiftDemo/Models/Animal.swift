//
//  Animal.swift
//  SwiftDemo
//
//  Created by ndl on 2019/10/16.
//  Copyright © 2019 dzcx. All rights reserved.
//

import Foundation

struct Animal: Codable {
    var name: String
    var age: Int
}

extension Animal: CustomDebugStringConvertible {
    var debugDescription: String {
        return String(format: "{Animal: name = \(name), age = \(age)}")
    }
}
