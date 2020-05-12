//
//  CountDownButton.swift
//  AiJiaSuClientIos
//
//  Created by youdone-ndl on 2020/1/8.
//  Copyright © 2020 AiJiaSu Inc. All rights reserved.
//

import UIKit

//typealias ClickHandler = (() -> Void)
//
//class CountDownButton: UIButton {
//
//    private(set) lazy var sourceTimer: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
//    
//    var clickHandler: ClickHandler?
//    
//    var normalTitle = "发送验证码"
//    var normalColor = UIColor(netHex: 0x4580ff)
//    var disabledColor = UIColor(netHex: 0x999999)
//    
//    var countDownSeconds = 60
//    var curSecond = 60
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        setupConfiguration()
//    }
//    
//    deinit {
//        
//    }
//
//}
//
//extension CountDownButton {
//    private func setupConfiguration() {
//        backgroundColor = UIColor(netHex: 0xffffff)
//        
//        curSecond = countDownSeconds
//        
//        addTarget(self, action: #selector(selfDidClicked(sender:)), for: .touchUpInside)
//        
//        sourceTimer.schedule(deadline: .now(), repeating: .seconds(1))
//        sourceTimer.setEventHandler { [weak self] in
//            guard let self = self else { return }
//            
//            self.curSecond -= 1
//            
//            if self.curSecond <= 0 {
//                self.sourceTimer.suspend()
//                self.curSecond = self.countDownSeconds
//                
//                DispatchQueue.main.async {
//                    self.isEnabled = true
//                    self.layer.borderColor = self.normalColor.cgColor
//                    self.setTitle(self.normalTitle, for: .normal)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.setTitle("\(self.curSecond)", for: .disabled)
//                }
//            }
//        }
//    }
//    
//    @objc private func selfDidClicked(sender: UIButton) {
//        sender.isEnabled = false
//        self.layer.borderColor = self.disabledColor.cgColor
//        
//        sourceTimer.resume()
//        
//        clickHandler?()
//    }
//}
