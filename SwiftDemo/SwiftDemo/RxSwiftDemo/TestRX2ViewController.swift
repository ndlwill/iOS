//
//  TestRX2ViewController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/6/25.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit
import RxSwift
//import RxCocoa

class TestRX2ViewController: UIViewController {
    
    var disposeBag = DisposeBag.init()
    
    var userNameTF: UITextField!
    var passwordTF: UITextField!
    var userNameValidLabel: UILabel!
    var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let userNameValid = userNameTF.rx.text.orEmpty.map { (text) -> Bool in
            return text.count >= 5
        }
        let passwordValid = passwordTF.rx.text.orEmpty.map { (text) -> Bool in
            return text.count >= 6
        }
        userNameValid.bind(to: userNameValidLabel.rx.isHidden).disposed(by: disposeBag)
        
        Observable.combineLatest(userNameValid, passwordValid) {
            $0 && $1
            }
        .bind(to: loginButton.rx.isEnabled)
        .disposed(by: disposeBag)
    }

}
