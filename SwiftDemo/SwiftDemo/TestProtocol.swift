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

protocol Nameable {
    var name: String { get }
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

struct TestName: Greetable, Nameable {
    /*
     extension都没有默认实现name
    // 1.如果有一个类型，需要同时实现两个协议的话，它必须提供一个 name 属性，来同时满足两个协议的要求
    let name: String
     */
    
    /**
     // 4.都提供了默认扩展时，我们需要在具体的类型中明确地提供实现。这里我们将 TestName 中的 name 进行实现就可以了
     let name: String
     */
    
}

protocol P {
    func myMethod()
}

// 协议扩展：就是我们可以为一个协议提供默认的实现
extension Greetable {
    // 3.如果extension都有默认实现name，TestName 无法编译
    //var name: String { return "Greetable name" }
    func greet() {
        print("extension Greetable: greet")
    }
}


// 2.为其中的某个协议进行了扩展，在其中提供了默认的 name 实现。TestName可以不写let name: String
extension Nameable {
    var name: String { return "Nameable name" }
}

// MARK: Protocol Demo
enum HTTPMethod: String {
    case GET
    case POST
}

protocol Request {
    var host: String { get }
    var path: String { get }
    
    var method: HTTPMethod { get }
    var parameter: [String: Any] { get }
    
    // 我们想要这个 send 方法对于所有的 Request 都通用，所以显然回调的参数类型不能是 User。通过在 Request 协议中添加一个关联类型，我们可以将回调参数进行抽象。在 Request 最后添加：
    associatedtype Response
    func parse(data: Data) -> Response?
}

struct UserRequest: Request {
    let name: String
    
    let host = "https://api.onevcat.com"
    var path: String {
        return "/users/\(name)"
    }
    let method: HTTPMethod = .GET
    let parameter: [String: Any] = [:]
    
    typealias Response = User
    func parse(data: Data) -> User? {
        return User(data: data)
    }
}

// 为了任意请求都可以通过同样的方法发送，我们将发送的方法定义在 Request 协议扩展上
extension Request {
    // 我们定义了可逃逸的 (User?) -> Void，在请求完成后，我们调用这个 handler 方法来通知调用者请求是否完成，如果一切正常，则将一个 User 实例传回，否则传回 nil
    // 我们可以用 Response 代替具体的 User，让 send 一般化
    func send(handler: @escaping (Response?) -> Void) {
        // 通过拼接 host 和 path，可以得到 API 的 entry point
        let url = URL(string: host.appending(path))!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // 在示例中我们不需要 `httpBody`，实践中可能需要将 parameter 转为 data
        // request.httpBody = ...
        
        let task = URLSession.shared.dataTask(with: request) {
            data, res, error in
            // 处理结果
            print(data)
            // 剩下的工作就是将回调中的 data 转换为合适的对象类型，并调用 handler 通知外部调用者了。对于 User 我们知道可以使用 User.init(data:)，但是对于一般的 Response，我们还不知道要如何将数据转为模型。
            // 在 Request 里再定义一个 parse(data:) 方法，来要求满足该协议的具体类型提供合适的实现
            // 这样一来，提供转换方法的任务就被“下放”到了 UserRequest
            if let data = data, let res = self.parse(data: data) {
                DispatchQueue.main.async { handler(res) }
            } else {
                DispatchQueue.main.async { handler(nil) }
            }
        }
        task.resume()
    }
}

// 重构，关注点分离
/**
 Request 管理了太多的东西。一个 Request 应该做的事情应该仅仅是定义请求入口和期望的响应类型，而现在 Request 不光定义了 host 的值，还对如何解析数据了如指掌
 
 最后 send 方法被绑死在了 URLSession 的实现上，而且是作为 Request 的一部分存在.因为这意味着我们无法在不更改请求的情况下更新发送请求的方式，它们被耦合在了一起。
 
 首先我们将 send(handler:) 从 Request 分离出来。我们需要一个单独的类型来负责发送请求。这里基于 POP 的开发方式，我们从定义一个可以发送请求的协议开始:
 protocol Client {
     // 编译错误
     func send(_ r: Request, handler: @escaping (Request.Response?) -> Void)
 }
 但是因为 Request 是含有关联类型的协议，所以它并不能作为独立的类型来使用，我们只能够将它作为类型约束，来限制输入参数 request
 protocol Client {
     func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void)

     var host: String { get }
 }
 除了使用 <T: Request> 这个泛型方式以外，我们还将 host 从 Request 移动到了 Client 里，这是更适合它的地方
 */

