//
//  TestGestureViewController.swift
//  SwiftDemo
//
//  Created by ndl on 2020/2/20.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

class TestGestureViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray

        let wrapperView = UIView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 200))
        wrapperView.backgroundColor = UIColor.white
        self.view.addSubview(wrapperView)
        
        let pan = UIPanGestureRecognizer()
        pan.delegate = self
        pan.addTarget(self, action: #selector(onPanned(_:)))
        
        wrapperView.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer()
        tap.delegate = self
        tap.addTarget(self, action: #selector(onTapped(_:)))
        wrapperView.addGestureRecognizer(tap)
        
        // test button
//        let button = UIButton(type: .custom)
//        button.backgroundColor = UIColor.red
//        button.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
//        button.addTarget(self, action: #selector(buttonDidClicked), for: .touchUpInside)
//        wrapperView.addSubview(button)
        
        // test scrollView
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.frame = wrapperView.bounds
        scrollView.contentSize = CGSize(width: self.view.frame.width * 2.0, height: wrapperView.frame.height)
        scrollView.backgroundColor = UIColor.yellow
        wrapperView.addSubview(scrollView)
        
//
//        print("scrollView.panGestureRecognizer.delegate = \(scrollView.panGestureRecognizer.delegate)")
    }
    
    @objc func onPanned(_ gesture: UIGestureRecognizer) {
        print("onPanned: \(gesture.self)")
    }
    
    @objc func onTapped(_ gesture: UIGestureRecognizer) {
        print("onTapped: \(gesture.self)")
    }
    
    @objc func buttonDidClicked() {
        print("buttonDidClicked")
    }
    
    // MARK: 总结
    /**
     1.
     对于 UIButton，UISwitch，UISegmentedControl，UIStepper、UIPageControl 进行单击操作，如果父视图有轻敲手势需要识别，依然会按照响应链来处理，先响应这些控件的单击事件，这仅适用于与控件的默认操作重叠的手势识别

     
     */
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("gestureRecognizer = \(gestureRecognizer) otherGestureRecognizer = \(otherGestureRecognizer)")
        
        return true
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        print("touch.view = \(touch.view)")
//        if let flag = touch.view?.isKind(of: UIScrollView.self), flag {
//            print("===scrollview")
//            return false
//        }
//
//        return true
//    }
    

}
