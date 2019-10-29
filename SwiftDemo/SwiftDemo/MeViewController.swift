//
//  MeViewController.swift
//  SwiftDemo
//
//  Created by dzcx on 2019/9/4.
//  Copyright © 2019 dzcx. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MeViewController: UIViewController {
    var person1: Person1!
    var animal: Animal!
    
    let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("MeViewController: Person1 = \(person1!) Animal = \(animal!)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
//        self.navigationController?.navigationBar.barStyle = .black
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
        }
        
        person1 = Person1()
        let person2 = Person1()
        if person1 == person2 {
            print("person1 == person2")
        } else {
            print("person1 != person2")// ###log here
        }
        animal = Animal(name: "dog", age: 1)
        
        
        // MARK: AnyObject
        /**
         NSDate: Class
         Date: Struct
         */
        // 1.AnyObject: The protocol to which all classes implicitly conform
        // NSString 和 String 会自动bridge
        // NSDate 和 Date 可自动 bridge
        // Array 是值类型, struct
        let str: AnyObject = "ndl" as NSString
        print(str is NSString)// true
        print(str is String)// true
        
        // 2.AnyObject 只支持 class type，NSDate 是引用类型，而 Date 是个 struct
        var array = [AnyObject]()
        array.append(NSDate())
//        array.append(Date())// 报错
        
        
        
//        self.navigationController?.navigationBar.backItem?.backBarButtonItem = UIBarButtonItem(title: "22", style: .plain, target: self, action: nil)
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "11", style: .plain, target: self, action: nil)
        
        // MARK: 泛型应用
        /**
         public protocol UserDefaultable {
             associatedtype E
             
             static func objectUserDefaults(forKey key: String) -> E?
         }

         extension UserDefaultable {
             public static func valueFromUserDefaults(forKey key: String) -> E? {
                 return UserDefaults.standard.value(forKey: key) as? E
             }
         }
         
         extension Bool: UserDefaultable {
             public typealias E = Bool
         }

         extension Int: UserDefaultable {
             public typealias E = Int
         }

         extension Int32: UserDefaultable {
             public typealias E = Int32
         }

         extension Int64: UserDefaultable {
             public typealias E = Int64
         }

         extension String: UserDefaultable {
             public typealias E = String
         }

         extension Double: UserDefaultable {
             public typealias E = Double
         }

         extension Data: UserDefaultable {
             public typealias E = Data
         }

         extension Array: UserDefaultable {
             public typealias E = Array
         }
         */
        // MARK: JSON
        let jsonData1 =
        """
        {
        "name": "ndlwill",
        "desc": "XXXXXX",
        "age": 20
        }
        """.data(using: .utf8)
        let jsonData2 =
        """
        {
        "name": "ndlwill",
        "desc": "XXXXXX",
        "age": 21
        }
        """.data(using: .utf8)
        do {
            if let data1 = jsonData1, let data2 = jsonData2 {
                let person_1 = try JSONDecoder().decode(Person.self, from: data1)
                let person_2 = try JSONDecoder().decode(Person.self, from: data2)
                print("person_1:", person_1)
                
                if person_1 == person_2 {
                    print("person_1 == person_2")// ###log here
                } else {
                    print("person_1 != person_2")
                }
                
                if person_1 < person_2 {
                    print("person_1 < person_2")// ###log here
                } else {
                    print("person_1 !< person_2")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        
        let animalData =
        """
        {
        "name": "cat",
        "age": 20
        }
        """.data(using: .utf8)
        if let data = animalData {
            let animal1 = try? JSONDecoder().decode(Animal.self, from: data)
            if let animal_1 = animal1 {
                print("animal1 = \(animal_1)")
            }
        }
        
        
        
        
        // MARK: test-combineLatest
//        let subject1 = PublishSubject<Int>()
//        let subject2 = PublishSubject<String>()
//
//        Observable.combineLatest(subject1, subject2) {
//            "\($0)\($1)"
//            }
//            .subscribe(onNext: { print($0) })
//            .disposed(by: disposeBag)
//        // 需要两个存在，并用最新数值组合
//        subject1.onNext(1)// 不输出
//        delay(by: 2.0) {
//            subject2.onNext("A")// 1A
//        }
//        delay(by: 4.0) {
//            subject1.onNext(2)// 2A
//        }
        
        // MARK: test-withLatestFrom
//        let subject1 = PublishSubject<String>()
//        let subject2 = PublishSubject<String>()
//        // 1-onNext 取2的最新数值
//        subject1.withLatestFrom(subject2).subscribe(onNext: { print($0) }).disposed(by: disposeBag)
//
//        subject1.onNext("A")// 此时2没数值
//        subject2.onNext("1")// 此时2有数值，但1没有onNext
//        subject1.onNext("B")// 1
        

        // MARK:Swift4.0 Codable
        /**
         JSON的编码和解析，使用JSONEncoder用于编码，使用JSONDecoder用于解析
         */
        
        // MARK:.Type 与 .self
        /**
         元类型就是类型的类型
         Swift 中的元类型用 .Type 表示。比如 Int.Type 就是 Int 的元类型
         .Type 是类型，类型的 .self 是元类型的值
         
         获得元类型后可以访问静态变量和静态方法
         
         AnyClass 其实就是一个元类型
         typealias AnyClass = AnyObject.Type
         AnyClass 就是一个任意类型元类型的别名
         
         Int.max
         等价于
         Int.self.max
         */
        let intMetatype: Int.Type = Int.self
        print(intMetatype)// Int
        
        let p = Person1()
        print(p.self)// <SwiftDemo.Person1: 0x600002310290>
        print(Person1.self)// Person1
        print(Person1.Type.self)// Person1.Type
        
        // .self 取到的是静态的元类型，声明的时候是什么类型就是什么类型
        // type(of:) 取的是运行时候的元类型，也就是这个实例 的类型
        let instanceMetaType: String.Type = type(of: "string")
        let staticMetaType: String.Type = String.self
        print(instanceMetaType, staticMetaType)// String String
        
        // Self 不仅指代的是 实现该协议的类型本身，也包括了这个类型的子类
        
        
        
        
        
        // MARK: UITextField && button
        let textField = UITextField()
        textField.backgroundColor = UIColor.lightGray
        textField.placeholder = "请输入"
        self.view.addSubview(textField)
        
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.red
        button.setTitle("111", for: .normal)
        button.setTitle("222", for: .selected)
        self.view.addSubview(button)
        
        textField.snp.makeConstraints {
            $0.top.left.equalTo(view).offset(100)
            $0.size.equalTo(CGSize(width: 200.0, height: 44.0))
        }
        
        button.snp.makeConstraints {
            $0.top.equalTo(textField.snp_bottom).offset(20)
            $0.left.equalTo(textField)
            $0.size.equalTo(CGSize(width: 60.0, height: 30.0))
        }
        
        let carPickUpInfoView = CarPickUpInfoView()
        carPickUpInfoView.backgroundColor = UIColor.white
        carPickUpInfoView.layer.cornerRadius = 8.0
        self.view.addSubview(carPickUpInfoView)

        carPickUpInfoView.snp.makeConstraints {
            $0.left.equalTo(self.view).offset(20.0)
            $0.right.equalTo(self.view).offset(-20.0)
            $0.top.equalTo(button.snp_bottom).offset(20)
        }
        
        let carPickerText = carPickUpInfoView.carPickerTextField.rx.text.orEmpty.asDriver()
        let mobileNumberText = carPickUpInfoView.mobileNumberTextField.rx.text.orEmpty.asDriver()
        

        
//        textField.rx.controlEvent(.editingChanged).asObservable().subscribe(onNext: {
//            print("editingChanged")
//
//            guard let _: UITextRange = textField.markedTextRange else {
//
//
//                return
//            }
//
//        })
        
//        textField.rx.text.orEmpty.asObservable().subscribe(onNext: {
//            print("\($0)")
//        })
        
        
        button.rx.tap.map {
            !button.isSelected
        }.bind(to: button.rx.isSelected).disposed(by: disposeBag)
        
        
        
        
        // MARK:test throttle
//        delay(by: 5.0) {
//            print("start =====")
//
//            textField.rx.text.orEmpty.throttle(5.0, scheduler: MainScheduler.instance)
//                .distinctUntilChanged().asObservable().subscribe(onNext: {
//                    print("throttle = \($0)")
//                })
//        }
        
        
//        button.rx.tap.flatMap {
//            textField.rx.text.orEmpty.asObservable()
//        }.subscribe(onNext: {
//            print("flatMap = \($0)")
//        })
        
//        button.rx.tap.flatMapLatest {
//            textField.rx.text.orEmpty.asObservable()
//        }.subscribe(onNext: {
//            print("flatMapLatest = \($0)")
//        })
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = MeViewController_1()
        vc.person1 = self.person1
        vc.animal = animal
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: 键盘不遮挡视图逻辑
//    private func addNotification() {
//    _ = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).takeUntil(self.rx.deallocated).subscribe(onNext: { [unowned self] notification in
//        print("===keyboardWillShowNotification===")
//        let userInfo = notification.userInfo
//
//        let keyBoardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
//        self.keyBoardAnimDuration = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//
//        let textFieldBottomY = self.carPickUpInfoView.convert(self.carPickUpInfoView.mobileNumberTextField.frame, to: UIApplication.shared.keyWindow).maxY
//
//        let updateValue = ScreenHeight - keyBoardHeight - 30.0
//
//        if textFieldBottomY - updateValue > 1.0 {
//            self.updateFlag = true
//            self.scrollView.snp.updateConstraints {
//                $0.top.equalTo(self.view).offset(updateValue - textFieldBottomY + self.scrollView.frame.origin.y)
//            }
//            UIView.animate(withDuration: self.keyBoardAnimDuration, animations: {
//                self.view.layoutIfNeeded()
//            })
//        }
//        }).disposed(by: disposeBag)
//
//        _ = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).takeUntil(self.rx.deallocated).subscribe(onNext: { [unowned self] _ in
//            print("===keyboardWillHideNotification===")
//            if self.updateFlag {
//                self.scrollView.snp.updateConstraints {
//                    $0.top.equalTo(self.view)
//                }
//                UIView.animate(withDuration: self.keyBoardAnimDuration, animations: {
//                    self.view.layoutIfNeeded()
//                })
//            }
//            }).disposed(by: disposeBag)
//    }

}
