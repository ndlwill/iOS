//
//  UIScrollView+Ext.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/10/26.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

public extension UIScrollView {
    
    private struct AssociatedKeys {
        static var animator: String = "animator"
    }
    
    private var animator: ScrollViewAnimator? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.animator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.animator) as? ScrollViewAnimator
        }
    }
    
    func setContentOffset(_ contentOffset: CGPoint, duration: TimeInterval, timingFunction: ScrollTimingFunction = .linear, completion: (() -> Void)? = nil) {
        if animator == nil {
            animator = ScrollViewAnimator(scrollView: self, timingFunction: timingFunction)
        }
        animator!.closure = { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.animator = nil
            }
            completion?()
        }
        animator!.setContentOffset(contentOffset, duration: duration)
    }
    
}

