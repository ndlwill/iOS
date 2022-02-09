//
//  CellRowRule.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2021/12/16.
//  Copyright © 2021 dzcx. All rights reserved.
//

import UIKit

protocol CellRowRule {
    var title: String { get }
    var controller: UIViewController { get }
}
