//
//  TestDismiss1ViewController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/2/3.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

class TestDismiss1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red

        NotificationCenter.default.addObserver(self, selector: #selector(onDismiss), name: Notification.Name("dismiss"), object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        present(TestDismiss2ViewController(), animated: true, completion: nil)
    }
    
    @objc func onDismiss() {
        dismiss(animated: true, completion: nil)
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
