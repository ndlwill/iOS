//
//  TestDismiss2ViewController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/2/3.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

class TestDismiss2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: false, completion: {
            NotificationCenter.default.post(name: NSNotification.Name("dismiss"), object: nil)
        })
        
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
