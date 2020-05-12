//
//  TestIPadViewController.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/5/11.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

// 一次只有一个选项可以被选择的情况下，枚举是非常好的
// Swift 中的选项集合结构体使用了高效的位域来表示，但是这个结构体本身表现为一个集合，它的成员则为被选择的选项
struct OptionTest: OptionSet {

    // RawRepresentable协议，rawValue 是位域底层的存储单元
var rawValue: UInt8

    // 每个选项都应该是静态的常量，并使用适当的值初始化了其位域
static let Sunday = OptionTest(rawValue: 1 << 0)

static let Monday = OptionTest(rawValue: 1 << 1)

static let Tuesday = OptionTest(rawValue: 1 << 2)

static let Wednesday = OptionTest(rawValue: 1 << 3)

static let Thursday = OptionTest(rawValue: 1 << 4)

static let Friday = OptionTest(rawValue: 1 << 5)

static let Saturday = OptionTest(rawValue: 1 << 6)

}


class TestIPadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 80)
        button.backgroundColor = UIColor.red
        self.view.addSubview(button)
        
        // The value in this property is used primarily when displaying the view controller’s content in a popover but may also be used in other situations.
//        self.preferredContentSize

        
        // UIAlertController和UIActivityViewController在ipad上存在兼容性
        delay(by: 3.0) {
            // alert
//            let alert = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
//            // iPhone不崩溃(但有约束警告) IPad崩溃
////            let alert = UIAlertController(title: "title", message: "message", preferredStyle: .actionSheet)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(okAction)
//            alert.modalPresentationStyle = .fullScreen
//            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            
            
            // actionSheet
//            let alert = UIAlertController(title: "title", message: "message", preferredStyle: .actionSheet)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//            alert.addAction(okAction)
//            alert.addAction(cancelAction)
//            
//            // for ipad
//            alert.modalPresentationStyle = .popover
//            if let popover = alert.popoverPresentationController {
//                popover.sourceView = button
//                popover.sourceRect = button.bounds
//                popover.permittedArrowDirections = [.up]
//            }
//            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            
            // MARK: ==UIActivityViewController==
            let items = [UIImage(named: "google") as Any, "shareText", URL(string: "") as Any] as [Any]
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            let userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
            let popoverTest: UIPopoverPresentationController? = activityViewController.popoverPresentationController
            if userInterfaceIdiom == .phone {
                print("iphone popoverTest = \(popoverTest)")// nil
                activityViewController.modalPresentationStyle = .fullScreen
                UIApplication.shared.keyWindow?.rootViewController?.present(activityViewController, animated: true, completion: nil)
            } else if userInterfaceIdiom == .pad {
                print("pad popoverTest = \(popoverTest)")// UIPopoverPresentationController
                if let popover = activityViewController.popoverPresentationController {
                    if let keyWindow = UIApplication.shared.keyWindow {
                        popover.sourceView = keyWindow
                        popover.sourceRect = CGRect(x: keyWindow.bounds.midX, y: keyWindow.bounds.midY, width: 1.0, height: 1.0)
                        keyWindow.rootViewController?.present(activityViewController, animated: true, completion: nil)
                        }
                }
            }
            
        }
        
        
        // Swift不能和C语言混编
        // MARK: ==OptionSet==
        let test: OptionTest = [OptionTest.Sunday, OptionTest.Monday]// rawValue : 3 = 1 + 2
        let op1: OptionTest = test.union(.Wednesday)// rawValue : 11 = 1 + 2 + 8
        
        if test.contains(.Monday) {
            print("Monday")// Monday
        }
        
        if test.contains([.Sunday, .Friday]) {
            print("Sunday-Friday")
        }
        
        let singleTest: OptionTest = .Tuesday
        if singleTest == .Tuesday {
            print("true")// true
        }
        
        // 在实战中经常遇到Option作为参数的运用。比如给一个view设置一个或两个圆角
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        
        
        
        
    }

}
