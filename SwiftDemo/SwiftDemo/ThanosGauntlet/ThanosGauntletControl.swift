//
//  ThanosGauntletControl.swift
//  SwiftDemo
//
//  Created by dzcx on 2019/9/9.
//  Copyright © 2019 dzcx. All rights reserved.
//

import UIKit

protocol ThanosGauntletControlDelegate: class {
    func ThanosGauntletControlDidSnapped()
    func ThanosGauntletControlDidReversed()
}


class ThanosGauntletControl: UIControl {

    enum ActionState {
        case snapState
        case reverseState
    }
    
    private var actionState: ActionState?
    
    weak var delegate: ThanosGauntletControlDelegate?
    
    // 在子类重写父类的必要构造器时，必须在子类的构造器前也添加required修饰符，表明该构造器要求也应用于继承链后面的子类。在重写父类中必要的指定构造器时，不需要添加override修饰符
    // 在类的构造器前添加required修饰符表明所有该类的子类都必须实现该构造器
    // 当我们使用storyboard实现界面的时候，程序会调用这个初始化器
    // 这是NSCoding protocol定义的，遵守了NSCoding protocol的所有类必须继承
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        
    }
    
    override func layoutSubviews() {
        
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        print("beginTracking")
        return super.beginTracking(touch, with: event)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        print("endTracking")
    }
}
