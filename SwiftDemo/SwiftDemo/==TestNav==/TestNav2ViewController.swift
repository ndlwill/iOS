//
//  TestNav2ViewController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/2/2.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

class TestNav2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        let leftItem = UIBarButtonItem.itemWithNormalImage("nav_btn_back_nor", highlightedImage: "nav_btn_back_pre", target: self, action: #selector(backDidClicked))
        navigationItem.leftBarButtonItems = [leftItem]
        
        let label = UILabel()
        label.textColor = UIColor.red
        label.text = "nidongle"
        navigationItem.titleView = label
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        print("==TestNav2ViewController viewDidLayoutSubviews==")
//        let leftBarButtonItems = navigationItem.leftBarButtonItems
//        if let items = leftBarButtonItems, items.count > 0 {
//            let firstItem = items.first
//            if let item = firstItem {
//                let resultView = item.customView?.superview?.superview?.superview
//                if let constraintView = resultView {
//                    for constraint in constraintView.constraints {
//                        // iphone8:16 iphone11:20
//                        if abs(constraint.constant) == 16 {
//                            constraint.constant = 0
//                        }
//                    }
//                }
//            }
//        }
    }
    
    @objc func backDidClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
