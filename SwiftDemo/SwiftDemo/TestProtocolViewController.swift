//
//  TestProtocolViewController.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/5/20.
//  Copyright © 2020 dzcx. All rights reserved.
//


import UIKit

// MARK: swift面向协议编程（POP）
// MARK: Protocol协议
/**
 https://onevcat.com/#blog
 所谓协议，就是一组属性和/或方法的定义，而如果某个具体类型想要遵守一个协议，那它需要实现这个协议所定义的所有这些内容。
 
 OOP 的第一个大困境，那就是我们很难在不同继承关系的类里共用代码。
 class ViewCotroller: UIViewController 向其中添加一个 myMethod
 class AnotherViewController: UITableViewController 也想向其中添加同样的 myMethod
 想要解决这个问题，我们有几个方案：
 1.Copy & Paste
 2.引入 BaseViewController
 在一个继承自 UIViewController 的 BaseViewController 上添加需要共享的代码，或者干脆在 UIViewController 上添加 extension。看起来这是一个稍微靠谱的做法，但是如果不断这么做，会让所谓的 Base 很快变成垃圾堆。职责不明确，任何东西都能扔进 Base，你完全不知道哪些类走了 Base，而这个“超级类”对代码的影响也会不可预估。
 3.依赖注入
 通过外界传入一个带有 myMethod 的对象，用新的类型来提供这个功能。
 这是一个稍好的方式，但是引入额外的依赖关系，可能也是我们不太愿意看到的。
 4.多继承
 当然，Swift 是不支持多继承的。不过如果有多继承的话，我们确实可以从多个父类进行继承，并将 myMethod 添加到合适的地方。有一些语言选择了支持多继承 (比如 C++)，但是它会带来 OOP 中另一个著名的问题：菱形缺陷。
 但是多继承有一个无法回避的问题，就是两个父类都实现了同样的方法时，子类该怎么办？我们很难确定应该继承哪一个父类的方法.
 因为多继承的拓扑结构是一个菱形，所以这个问题又被叫做菱形缺陷 (Diamond Problem)。
 
 横切关注点 (Cross-Cutting Concerns) 那就是我们很难在不同继承关系的类里共用代码! 现在我们通过面向协议的方式
 
 Objective-C 是不安全的，编译器默认你知道某个方法确实有实现，这是消息发送的灵活性所必须付出的代价。
 
 我们可以使用 POP 来解耦，通过组合的方式让代码有更好的重用性
 */

struct User {
    let name: String
    let message: String
    
    init?(data: Data) {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        guard let name = obj["name"] as? String else {
            return nil
        }
        guard let message = obj["message"] as? String else {
            return nil
        }
        
        self.name = name
        self.message = message
    }
}


class TestProtocolViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        
        // 将协议作为标准类型，来对方法调用进行动态派发了
        // 动态派发安全性的问题: 如果其他类没有实现greet(),Compiler Error:因此不存在消息误发送的情况
        let array: [Greetable] = [
                Person_n(name: "person_n"),
                Cat_n(name: "cat_n")]
        for obj in array {
            obj.greet()
        }

        let request = UserRequest(name: "onevcat")
        request.send { user in
            if let user = user {
                print("\(user.message) from \(user.name)")
            }
        }
        
    }


}
