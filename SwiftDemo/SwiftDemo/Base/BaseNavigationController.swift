//
//  BaseNavigationController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/2/2.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("==BaseNavigationController viewDidLayoutSubviews==")
        
//        adjustNavigationBarItemsSpacing()
//        let leftBarButtonItems = navigationItem.leftBarButtonItems
//        if let items = leftBarButtonItems, items.count > 0 {
//            let firstItem = items.first
//            if let item = firstItem {
//                let resultView = item.customView?.superview?.superview
//                if let constraintView = resultView {
//                    for constraint in constraintView.constraints {
//                        if abs(constraint.constant) == 16 {
//                            constraint.constant = 0
//                        }
//                    }
//                }
//            }
//        }
    }
    
    private func adjustNavigationBarItemsSpacing() {
        if #available(iOS 11, *) {
            for subview in self.navigationBar.subviews {
                if NSStringFromClass(subview.classForCoder).contains("UINavigationBarContentView") {
                    for constant in subview.constraints {
                        if constant.constant >= 16 || constant.constant <= -16 {
                            constant.constant = 0
                        }
                    }
                }
            }
        }
    }
    
    // ??????
    /**
     
     extension UIViewController {
         
         /// 给系统导航栏添加左边View(删除左边20间隔)
         ///
         /// - Parameter leftView: leftView
         func addNavigationBarLeftView(_ leftView: UIView) {
             let leftItem = UIBarButtonItem(customView: leftView)
             if #available(iOS 11, *) {
                 self.navigationItem.leftBarButtonItems = [leftItem]
             } else {
                 // 用于消除左边空隙，要不然按钮顶不到最左边
                 let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                 leftSpace.width = -20
                 self.navigationItem.leftBarButtonItems = [leftSpace, leftItem]
             }
         }
         
         /// 给系统导航栏添加右边View(删除右边20间隔)
         ///
         /// - Parameter rightView: rightView
         func addNavigationBarRightView(_ rightView: UIView) {
             let rightItem = UIBarButtonItem(customView: rightView)
             if #available(iOS 11, *) {
                 self.navigationItem.rightBarButtonItems = [rightItem]
             } else {
                 // 用于消除右边空隙，要不然按钮顶不到最右边
                 let rightSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                 rightSpace.width = -20
                 self.navigationItem.rightBarButtonItems = [rightSpace, rightItem]
             }
         }
     }
     */

}
