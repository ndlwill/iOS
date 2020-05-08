//
//  TestNav1ViewController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/2/2.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

class TestNav1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        print(TestNav1ViewController.self)// TestNav1ViewController.Type print: TestNav1ViewController
        print(TestNav1ViewController.classForCoder())// AnyClass print: TestNav1ViewController
        // MARK: public typealias AnyClass = AnyObject.Type
        print(self.classForCoder)// AnyClass print: TestNav1ViewController
        
        // type(of: (对象或者XX.Type))
        print(type(of: self))// print: TestNav1ViewController
        print(type(of: TestNav1ViewController.self))// print: TestNav1ViewController.Type
        
        // 都是TestNav1ViewController
        print(self.className)
        
        let name: AnyClass? = object_getClass(self)// SwiftDemo.TestNav1ViewController
        let name1: AnyClass? = object_getClass(TestNav1ViewController.self)// SwiftDemo.TestNav1ViewController
        let className = NSStringFromClass(TestNav1ViewController.self)// "SwiftDemo.TestNav1ViewController"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(TestNav2ViewController(), animated: true)
    }

}
