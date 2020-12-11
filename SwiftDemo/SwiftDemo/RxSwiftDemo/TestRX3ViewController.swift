//
//  TestRX3ViewController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/10/11.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// Observable创建
class TestRX3ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    var datepicker: UIDatePicker!
    var button1: UIButton!// male
    var button2: UIButton!// female
    
    var uiswitch: UISwitch!
    var uislider: UISlider!
    
    var tf: UITextField!
    var tv: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 空序列，没有序列，只能complete
        let emptyOb = Observable<Int>.empty()
        emptyOb.subscribe(onNext: { (number) in
            
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }, onDisposed: {
            print("释放回调")
        })
        
        // 单个信号序列
        let array = ["111", "222"]
        Observable<[String]>.just(array).subscribe { (event) in
            
        }.disposed(by: disposeBag)
        
        // 多个元素, of
        Observable<String>.of("111", "222").subscribe { (event) in
            
        }.disposed(by: disposeBag)
        
        // from, 有可选项处理，更安全
        Observable<[String]>.from(optional: ["111", "222"]).subscribe { (event) in
            
        }.disposed(by: disposeBag)
        
        // deferred, 动态序列，根据外界的标识，动态输出
        var flag = true
        Observable<Int>.deferred { () -> Observable<Int> in
            flag = !flag
            if flag {
                return Observable.of(1, 3)
            }
            return Observable.of(2, 4)
        }.subscribe { (event) in
            
        }.disposed(by: disposeBag)

        // range
        Observable.range(start: 2, count: 5).subscribe { (event) in
            
        }.disposed(by: disposeBag)
        
        // generate,只有当提供的所有的判断条件都为true的时候，才会给出Observable序列, 类似遍历循环
        Observable.generate(initialState: 0,// 初始值
                            condition: { $0 < 10 },// 条件1
                            iterate: { $0 + 2 })// 条件2
        .subscribe { (event) in
                
        }.disposed(by: disposeBag)
        // 数组遍历
        let arr111 = ["111", "222", "333"]
        Observable.generate(initialState: 0, condition: { $0 < arr111.count }, iterate: { $0 + 1 })
            .subscribe { (event) in
                
        }
        
        // timer 第一次响应距离现在的时间， 时间间隔， 线程
        Observable<Int>.timer(5, period: 2, scheduler: MainScheduler.instance).subscribe { (evnet) in
            
        }
        // 一次性的
        Observable<Int>.timer(2, scheduler: MainScheduler.instance)
        
        // interval
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
        // repeatElement 无限发出给定元素的序列（永不终止）
        Observable<Int>.repeatElement(5).subscribe { (event) in
            
        }
        
        // error
        Observable<String>.error(NSError.init(domain: "domian", code: 1000, userInfo: ["reason": "unknown"])).subscribe { (event) in
            
        }
        
        // never: 永远不会发出event（也不会终止）的序列
        Observable<String>.never().subscribe { (event) in
            
        }
        
        // datepicker
//        let birthdayOb = datepicker.rx.date.map{ DatePickerValidator.isValidDate(date: $0) }
//        birthdayOb.map { $0 ? UIColor.red : UIColor.green }.subscribe {}
        
        // 当我们创建一个 Observable 的时候就要预先将要发出的数据都准备好，等到有人订阅它时再将数据通过 Event 发出去。
        // 但有时我们希望 Observable 在运行时能动态地“获得”或者说“产生”出一个新的数据，再通过 Event 发送出去
        /**
         Subjects 既是订阅者，也是 Observable：
         说它是订阅者，是因为它能够动态地接收新的值。
         说它又是一个 Observable，是因为当 Subjects 有了新的值之后，就会通过 Event 将新值发出给他的所有订阅者。
         */
        // 性别
        let genderSelectedOb = Variable<Gender>(.notSelected)
        button1.rx.tap.map { Gender.male }.bind(to: genderSelectedOb).disposed(by: disposeBag)
        button2.rx.tap.map { Gender.female }.bind(to: genderSelectedOb).disposed(by: disposeBag)
        genderSelectedOb.asObservable().subscribe(onNext: { (gender) in
            
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }
        
        //
        uiswitch.rx.value.map { $0 ? 0.25 : 0 }
            .bind(to: uislider.rx.value).disposed(by: disposeBag)
        
        // text源码 封装的event
        // 为什么会打印两次：第一次是初始化 第二次是点击textfield，event事件 edit begin， 可以用skip(1)跳过第一次
        tf.rx.text.subscribe(onNext: { (text) in
            print("tf: \(text)")
        })
        // text源码 封装的通知
        tv.rx.text.subscribe(onNext: { (text) in
            print("tv: \(text)")
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 上面打印不一样
        tf.text = "111"
        tf.sendActions(for: .allEditingEvents)// 主动触发"111"
        tv.text = "222"
    }

}

enum Gender {
    case notSelected
    case male
    case female
}
