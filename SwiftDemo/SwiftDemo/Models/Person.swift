//
//  Person.swift
//  SwiftDemo
//
//  Created by ndl on 2019/10/15.
//  Copyright © 2019 dzcx. All rights reserved.
//

import Foundation

// MARK: Coadble
// Swift4.0 有一个有趣的新特性： Coadble
/**
 public typealias Codable = Decodable & Encodable
 protocol CodingKey
 
 Encodable 这个协议用在那些需要被编码的类型上
 Decodable这个协议跟 Encodable 相反，它表示那些能够被解档的类型
 
 使用JSONEncoder用于编码，使用JSONDecoder用于解析
 */

// MARK: Hashable
/**
 Dictionary 和 Set 的中的 Key 类型都要求是 Hashable
 */

// CustomDebugStringConvertible只是为了更好打印
class Person: Codable {
    var name: String
    var description: String
    var age: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case description = "desc"
        case age
    }
}

extension Person: CustomDebugStringConvertible {
    var debugDescription: String {
        return """
        {
        "name": \(name),
        "description": \(description),
        "age": \(age)
        }
        """
    }
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Person: Comparable {
    static func < (lhs: Person, rhs: Person) -> Bool {
        return lhs.age < rhs.age
    }
}

