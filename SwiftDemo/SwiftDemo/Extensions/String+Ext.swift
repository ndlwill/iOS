//
//  String+Ext.swift
//  AiJiaSuClientIos
//
//  Created by youdone-ndl on 2020/1/9.
//  Copyright © 2020 AiJiaSu Inc. All rights reserved.
//
import Foundation
public extension String {
    // eg: "123"->123  "123.1"->nil
    func toInt() -> Int? {
        return Int(self)
    }
    
    func toFloat() -> Float? {
        return Float(self)
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
    
    // MARK: String
    /**
     Swift 4 中有一个很大的变化就是 String 可以当做 Collection 来用
     
     typealias Distance = Double
     // 前面的就是后面的类型
     typealias SubSequence = Substring
     
     let str = "123"
     let subStr: Substring = str.prefix(0) // ""
     let subStr: Substring = str.prefix(1) // "1"
     let subStr: Substring = str.prefix(3) // "123"
     let subStr: Substring = str.prefix(5) // "123"
     
     str.dropFirst() // Substring: "23"
     
     为何要引入 Substring: 性能
     当我们用一些 Collection 的方式得到 String 里的一部分时，创建的都是 Substring。Substring 与原 String 是共享一个 Storage。这意味我们在操作这个部分的时候，是不需要频繁的去创建内存.
     而当我们显式地将 Substring 转成 String 的时候，才会 Copy 一份 String 到新的内存空间来，这时新的 String 和之前的 String 就没有关系了
     
     由于 Substring 与原 String 是共享存储空间的，只要我们使用了 Substring，原 String 就会存在内存空间中。只有 Substring 被释放以后，整个 String 才会被释放。
     而且 Substring 类型无法直接赋值给需要 String 类型的地方，我们必须用 String() 包一层。当然这时系统就会通过复制创建出一个新的字符串对象，之后原字符串就会被释放。
     
     let string: String = String(subStr)
     
     public struct Substring {
     }
     
     public struct Index {
     }
     
     let sss: Substring = str[str.startIndex..<str.endIndex]// "123"
     
     //  str[str.startIndex...str.endIndex] -> Fatal error: String index is out of bounds
     
     let s = "Swift"
     let i = s.index(s.startIndex, offsetBy: 4)
     print(s[i])// Prints "t"
     */
    
    // MARK: 元祖
    /**
     建议使用 tuple（元组）特性来实现值交换：
     var a = 1
     var b = 2
     (b, a) = (a, b)
     
     var a = 1
     var b = 2
     var c = 3
     (a, b, c) = (b, c, a)
     */
    
    // MARK: 数组
    /**
     var fruits = ["apple", "pear", "grape", "banana"]
     //交换元素位置（第2个和第3个元素位置进行交换）
     fruits.swapAt(1, 2)
     */
    
    // MARK: swift4.0
    /**
     Swift3:
     在项目中如果想把 Swift 写的 API 暴露给 Objective-C 调用，需要增加 @objc。在 Swift 3 中，编译器会在很多地方为我们隐式的加上 @objc。
     比如当一个类继承于 NSObject，那么这个类的所有方法都会被隐式的加上 @objc。
     class MyClass: NSObject {
         func print() { } // 包含隐式的 @objc
         func show() { } // 包含隐式的 @objc
     }
     但这样做很多并不需要暴露给 Objective-C 也被加上了 @objc。而大量 @objc 会导致二进制文件大小的增加。
     
     在 Swift 4 中隐式 @objc 自动推断只会发生在下面这种必须要使用 @objc 的情况：
     覆盖父类的 Objective-C 方法
     符合一个 Objective-C 的协议
     
     1.大多数地方必须手工显示地加上 @objc:
     class MyClass: NSObject {
         @objc func print() { } //显示的加上 @objc
         @objc func show() { } //显示的加上 @objc
     }
     
     2.如果在类前加上 @objcMembers，那么它、它的子类、扩展里的方法都会隐式的加上 @objc:
     @objcMembers
     class MyClass: NSObject {
         func print() { } //包含隐式的 @objc
         func show() { } //包含隐式的 @objc
     }
      
     extension MyClass {
         func baz() { } //包含隐式的 @objc
     }
     
     3.如果在扩展（extension）前加上 @objc，那么该扩展里的方法都会隐式的加上 @objc:
     class SwiftClass { }
      
     @objc extension SwiftClass {
         func foo() { } //包含隐式的 @objc
         func bar() { } //包含隐式的 @objc
     }
     
     4.如果在扩展（extension）前加上 @nonobjc，那么该扩展里的方法都不会隐式的加上 @objc:
     @objcMembers
     class MyClass : NSObject {
         func wibble() { } //包含隐式的 @objc
     }
      
     @nonobjc extension MyClass {
         func wobble() { } //不会包含隐式的 @objc
     }
     */
    
    func subString(to index: Int) -> String {
        return String(self.prefix(index))
    }
    
    // "123": index = 1->"23"
    func subString(from index: Int) -> String {
        if index >= self.count {
            return ""
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: index)
        let endIndex = self.endIndex
        return String(self[startIndex..<endIndex])
    }
    
    func subString(from fromIndex: Int, to toIndex: Int) -> String {
        if fromIndex < toIndex {
            let startIndex = self.index(self.startIndex, offsetBy: fromIndex)
            let endIndex = self.index(self.endIndex, offsetBy: toIndex)
            return String(self[startIndex..<endIndex])
        }
        return ""
    }
    
    func subString(from index: Int, length: Int = -1) -> String {
        var len = length
        if len == -1 || len > self.count - index {
            len = self.count - index
        }
        let stIndex = self.index(startIndex, offsetBy: index)
        let endIndex = self.index(stIndex, offsetBy: len)
        return String(self[stIndex..<endIndex])
    }
    
    func substring(range: Range<Int>) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: range.upperBound)
        let r: Range<String.Index> = fromIndex..<toIndex
        return String(self[r])
    }
    
    // 去除字符串两端的空白字符
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    var fv_isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    var fv_isValidPhoneNumber: Bool {
        let phoneNumberRegEx = "^(1[3-9])\\d{9}$"
        let phoneNumberPredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegEx)
        return phoneNumberPredicate.evaluate(with: self)
    }
    
    func isLatestVersion(_ responseVersion: String) -> Bool {
        let curTempArray: [Substring] = self.split(separator: ".")
        let responseTempArray: [Substring] = responseVersion.split(separator: ".")
        let curArray: [String] = curTempArray.compactMap {
            "\($0)"
        }
        let responseArray: [String] = responseTempArray.compactMap {
            "\($0)"
        }
        
        let curCount = curArray.count
        let responseCount = responseArray.count
        let arrayMaxCount = curCount > responseCount ? curCount : responseCount
        
        for idx in 0..<arrayMaxCount {
            var curNumber = 0
            var responseNumber = 0
            
            if idx < curCount {
                curNumber = Int(curArray[idx]) ?? 0
            }
            if idx < responseCount {
                responseNumber = Int(responseArray[idx]) ?? 0
            }
            
            if curNumber < responseNumber {
                return false
            } else if curNumber > responseNumber {
                return true
            }
        }
        
        return true
    }
    
}
