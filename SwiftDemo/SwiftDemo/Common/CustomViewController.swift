//
//  CustomViewController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/5/8.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {
    
    var text: String!
    
    // 自定义指定构造器
//    init(with text: String) {
//        // 调用父类的designated方法
//        super.init(nibName: nil, bundle: nil)
//        self.text = text
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    // 或者
    // 自定义便利构造器(便利构造器必须调用同类中定义的其他构造器，最终导致一个指定z构造器被调用)
    convenience init(with text: String) {
        self.init()// 实际调用过程self.init()->self.init(nibName: nil, bundle: nil)->super.init(nibName: nil, bundle: nil)
        self.text = text
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
