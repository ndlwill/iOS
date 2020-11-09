//
//  UIAlertService.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/11/6.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

//public protocol UIAlertServiceFactory {
//    func makeUIAlertService() -> UIAlertService
//}

public protocol UIAlertService: class {
    static func test()
    func displayAlert(_ alert: SystemAlert, on vc: UIViewController?)
//    func displayAlert(_ alert: SystemAlert)
}
