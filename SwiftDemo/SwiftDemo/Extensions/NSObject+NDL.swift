//
//  NSObject+NDL.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/7/15.
//  Copyright © 2020 dzcx. All rights reserved.
//

import Foundation
import UIKit

public struct NdlSwift<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol NdlSwiftCompatible {
    associatedtype CompatibleType
    static var ndl: NdlSwift<CompatibleType>.Type { get }
    var ndl: NdlSwift<CompatibleType> { get set }
}

public extension NdlSwiftCompatible {
    // “Self”仅在协议中可用，或者作为类中方法的结果
    // Self指的是符合协议的类型,也包括了这个类型的子类 self指的是该类型内的值
    // .self可以用在类型后面取得类型本身，也可以用在实例后面取得这个实例本身
    // public typealias AnyClass = AnyObject.Type
    // 通过 AnyObject.Type 这种方式得到的是一个元类型（Meta）
    static var ndl: NdlSwift<Self>.Type {
        return NdlSwift<Self>.self
    }
    
    var ndl: NdlSwift<Self> {
        get {
            return NdlSwift(self)
        }
        set{}
    }
}

extension NSObject: NdlSwiftCompatible {}

public extension NdlSwift where Base: UIScreen {
    static var width: CGFloat { return UIScreen.main.bounds.width }
    static var height: CGFloat { return UIScreen.main.bounds.height }
}

let w = UIScreen.ndl.width
