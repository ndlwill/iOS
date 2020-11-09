//
//  NDLAlertService.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/11/4.
//  Copyright © 2020 dzcx. All rights reserved.
//

import Foundation
import UIKit

// MARK: module
/**
 每个module代表了swift中的一个命名空间
 
 只需在类名前加上module的名称(也就是target名称)
 
 在同一个target中,也有另一个解决方法:
 将名字重复的类型定义到不同的struct中,以此避免冲突.
 */

// MARK: test

// MARK: AlertActionType
public enum AlertActionType {
    case confirmative
    case destructive
    case cancel
}

extension AlertActionType {
    var alertButtonStyle: UIAlertAction.Style {
        switch self {
        case .confirmative:
            return .default
        case .destructive:
            return .destructive
        case .cancel:
            return .cancel
        }
    }
}

public struct AlertAction {
    public let title: String
    public let style: AlertActionType
    public let handler: (() -> Void)?
    
    public init(title: String, style: AlertActionType, handler: (() -> Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

// MARK: SystemAlert
public protocol SystemAlert: AnyObject {// class protocol 'SystemAlert'
    var title: String? { get set }
    var message: String? { get set }
    var actions: [AlertAction] { get set }
    var isError: Bool { get }// 'let' declarations cannot be computed properties
    var dismiss: (() -> Void)? { get set }
}

extension SystemAlert {
    public static var className: String {
        return String(describing: self)
    }
    
    public var className: String {
        return String(describing: type(of: self))
    }
}

// MARK: SuccessNotificationAlert
public class SuccessNotificationAlert: SystemAlert {
    public var title: String?
    public var message: String?
    public var actions = [AlertAction]()
    
    public let isError: Bool = false
    // 或者
//    public var isError: Bool {
//        return false
//    }
    
    public var dismiss: (() -> Void)?
    
    public init(message: String) {
        self.message = message
    }
}

// MARK: ErrorNotificationAlert
public class ErrorNotificationAlert: SystemAlert {
    public var title: String? = "Unknown error"
    public var message: String?
    public var actions = [AlertAction]()
    public let isError: Bool = true
    public var dismiss: (() -> Void)?
    public var accessibilityIdentifier: String?
    
    public init(error: Error) {
        message = error.localizedDescription
        let nsError = error as NSError
        accessibilityIdentifier = "Error notification with code \(nsError.code)"
    }
}

public class UnknownErrortAlert: SystemAlert {
    public var title: String? = "Unknown error"
    public var message: String?
    public var actions = [AlertAction]()
    public let isError: Bool = true
    public var dismiss: (() -> Void)?
    
    public init(error: Error, confirmHandler: (() -> Void)?) {
        message = error.localizedDescription
        actions.append(AlertAction(title: "ok", style: .confirmative, handler: confirmHandler))
    }
}
