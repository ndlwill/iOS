//
//  ReusableView.swift
//  AiJiaSuClientIos
//
//  Created by youdone-ndl on 2020/1/6.
//  Copyright © 2020 AiJiaSu Inc. All rights reserved.
//
import UIKit
protocol ReusableView: AnyObject {
    static var defaultReusableID: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReusableID: String {
        return NSStringFromClass(self)
    }
}
