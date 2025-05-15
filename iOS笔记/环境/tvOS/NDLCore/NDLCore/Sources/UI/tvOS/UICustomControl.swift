//
//  UICustomControl.swift
//  NDLCore
//
//  Created by youdun on 2024/1/29.
//

import UIKit

open class UICustomControl: UIControl {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("=====init frame=====")
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print("=====init coder=====")
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        print("=====awakeFromNib=====")
    }
    
    open override var canBecomeFocused: Bool {
        return true
    }

    open override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesEnded(presses, with: event)
        
        if let press = presses.first, press.type == .select {
            sendActions(for: .primaryActionTriggered)
        }
    }

    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        if isFocused {
            coordinator.addCoordinatedAnimations {
                self.transform = CGAffineTransformMakeScale(1.03, 1.03)
            }
        } else {
            coordinator.addCoordinatedAnimations {
                self.transform = CGAffineTransformIdentity
            }
        }
    }
    
}
