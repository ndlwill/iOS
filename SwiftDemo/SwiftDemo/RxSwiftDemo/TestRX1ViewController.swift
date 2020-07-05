//
//  TestRX1ViewController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/6/25.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TestRX1ViewController: UIViewController {
    let person = SwiftPerson()
    let disposeBag = DisposeBag()
    let button = UIButton()
    let tf = UITextField()
    let scrollView = UIScrollView()
    var timer: Observable<Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray

//        testKVO()
//        testButton()
//        testTextfield()
//        testScrollView()
//        testGesture()
//        testNotification()
//        testTimer()
        testObserver()
    }
    
    func testKVO() {
        person.rx.observeWeakly(String.self, "name")
            .subscribe(onNext: { (value) in
                print(value)// 默认会走一次 第一次为""
            }).disposed(by: disposeBag)
    }
    
    func testButton() {
        button.rx.tap
            .subscribe(onNext: { _ in
                print("clicked")
            })
            .disposed(by: disposeBag)
        
        button.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { (_) in
                
            })
            .disposed(by: disposeBag)
    }
    
    func testTextfield() {
        tf.rx.text.orEmpty
            .subscribe(onNext: { (txt) in
                print(txt)
            })
            .disposed(by: disposeBag)
        
        tf.rx.text.orEmpty
            .bind(to: button.rx.title())
            .disposed(by: disposeBag)
    }
    
    func testScrollView() {
        scrollView.rx.contentOffset
            .subscribe(onNext: { [weak self] (offset) in
                
            })
            .disposed(by: disposeBag)
    }
    
    func testGesture() {
        let tap = UITapGestureRecognizer()
        
        
        tap.rx.event
            .subscribe(onNext: { (tap) in
            
            }).disposed(by: disposeBag)
    }
    
    func testNotification() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).subscribe(onNext: { (noti) in
            
            }).disposed(by: disposeBag)
    }
    
    func testTimer() {
        // 无限
        timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer.subscribe(onNext: { (num) in
            
            }).disposed(by: disposeBag)
    }
    
    func testObserver() {
        // 有穷
        let ob = Observable.just([1, 2, 3])
        ob.subscribe(onNext: { (value) in
            
        }, onCompleted: {
            
            }).disposed(by: disposeBag)
        
        let ob1 = Observable<Any>.create { (observer) -> Disposable in
            // 发送信号
            observer.onNext("111")
            // error和complete 二选一
            observer.onError(NSError.init(domain: "domain", code: 10086, userInfo: nil))
//            observer.onCompleted()
            return Disposables.create()
        }
        ob1.subscribe(onNext: { (anyValue) in
            
        }, onError: { (error) in
            
        }, onCompleted: {
            
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        person.name = person.name + "#"
    }

}
