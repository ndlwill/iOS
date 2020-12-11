//
//  TestRX4ViewController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/10/20.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TestRX4ViewController: UIViewController {
    
    var tf: UITextField!
    var titleLabel: UILabel!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 多次订阅， 1.会多次请求网络，2.并回调是在子线程，3.错误事件影响流程
//        let result = tf.rx.text.skip(1).flatMap { [weak self] (oString) -> Observable<Any> in
//            return (self?.dealWithString(text: oString ?? ""))!
//        }
        // 解决方式
        let result = tf.rx.text.skip(1).flatMap { [weak self] (oString) -> Observable<Any> in
            return (self?.dealWithString(text: oString ?? ""))!
                .observeOn(MainScheduler.instance)// 在主线程观察
                .catchErrorJustReturn("有错误")// 错误处理
        }.share(replay: 1, scope: .whileConnected)// 状态共享，网络请求没有重复执行
        
        result.subscribe(onNext: { (element) in
            print("subscribe:\(element)")
        })
        
        result.subscribe(onNext: { (element) in
            print("subscribe1:\(element)")
        })
        // 或者更好的
        let result1 = tf.rx.text.orEmpty
            .asDriver()// observable->driver
            .flatMap {
                return self.dealWithString(text: $0)
                .asDriver(onErrorJustReturn: "有错误")
            }
        
        result1.map { "string count: \(($0 as! String).count)" }
            .drive(self.titleLabel.rx.text)
        
        result1.map { "string count: \(($0 as! String).count)" }
        .drive(self.titleLabel.rx.text)
        
        
    }
    
    func dealWithString(text: String) -> Observable<Any> {
        return Observable<Any>.create { (observer) -> Disposable in
            if text == "111" {
                observer.onError(NSError.init(domain: "", code: 100, userInfo: nil))
            }
            
            DispatchQueue.global().async {
                observer.onNext("result: \(text)")
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func testStartWith() {
        Observable.of("1", "2").startWith("A").startWith("B").subscribe(onNext: { (str) in
            
            }).disposed(by: disposeBag)// BA12
    }
    
    func testMerge() {
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        // 任何一个onNext都会走闭包
        Observable.of(subject1, subject2).merge().subscribe(onNext: { (str) in
        // ndl
        }).disposed(by: disposeBag)
        subject1.onNext("n")
        subject1.onNext("d")
        subject2.onNext("l")
    }
    
    func testZip() {
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        // 只有两个序列同时有值的时候才会响应，否则存储
        Observable.zip(stringSubject, intSubject) { str, int in
            "\(str) \(int)"
        }.subscribe(onNext: { (str) in
        
        }).disposed(by: disposeBag)
        
        stringSubject.onNext("1")
        stringSubject.onNext("2")// 到这里存储了1, 2， 但不会响应 除非intSubject onNext
        
        intSubject.onNext(1)// 响应1个
        intSubject.onNext(2)// 响应另1个
        
        stringSubject.onNext("3")// 存一个
        intSubject.onNext(3)// 响应
    }
    
    func testCombineLatest() {
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        // 比如帐号密码同时满足才能登录，不管账号密码怎么变化，只要最后都有值就可以
        Observable.combineLatest(stringSubject, intSubject) { (str, int) in
            "\(str) \(int)"
        }.subscribe(onNext: { (str) in
        
        }).disposed(by: disposeBag)
        
        stringSubject.onNext("a")// 存a
        stringSubject.onNext("b")// 存b并覆盖a 和zip不一样
        intSubject.onNext(1)// 发现stringSubject也有值，响应b1
        intSubject.onNext(2)// 2覆盖1 响应b2
        stringSubject.onNext("c")// c2
    }
    
    func testSwitchLatest() {
        let s1 = BehaviorSubject(value: "1")
        let s2 = BehaviorSubject(value: "2")
        let subject = BehaviorSubject(value: s1)// 选择了s1就不会监听s2
        
        //
        subject.asObservable().switchLatest().subscribe(onNext: { (str) in
            
            }).disposed(by: disposeBag)
        
        s1.onNext("s1")
        s1.onNext("s11")
        s2.onNext("s2")
        s2.onNext("s22")// s2, s22都不会被监听，但是会保存s2覆盖2，s22覆盖s2
        
        subject.onNext(s2)// 切换到s2
        
        s1.onNext("s111")
        s2.onNext("s222")
    }
    
    func testMap() {
        let ob = Observable.of(1, 2)
        ob.map { (number) -> Int in
            return number + 2
        }.subscribe(onNext: {
            print("\($0)")
        })
    }
    
    func testFlatMap() {
        
    }
    
    func testFlatMapLatest() {
        
    }
    
    func testMulticast() {
        let networkOB = Observable<Any>.create { (observer) -> Disposable in
            sleep(2)
            print("start network")
            observer.onNext("data")
            observer.onNext("1111")
            observer.onCompleted()
            return Disposables.create {
                print("销毁回调了")
            }
        }.publish()
        
        networkOB.subscribe(onNext: { (any) in
            print("1: \(any)")
            }).disposed(by: disposeBag)
        
        networkOB.subscribe(onNext: { (any) in
            print("2: \(any)")
        }).disposed(by: disposeBag)
        
        networkOB.connect()
    }
    
    

}
