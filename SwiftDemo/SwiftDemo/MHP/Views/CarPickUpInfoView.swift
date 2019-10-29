//
//  CarPickUpInfoView.swift
//  SwiftDemo
//
//  Created by ndl on 2019/9/30.
//  Copyright © 2019 dzcx. All rights reserved.
//

import UIKit

// 取车信息view
class CarPickUpInfoView: UIView {

    var carPickUpInfoLabel: UILabel!
    var lineView1: UIView!
    var carPickerLabel: UILabel!
    var carPickerTextField: UITextField!
    var lineView2: UIView!
    var mobileNumberLabel: UILabel!
    var mobileNumberTextField: UITextField!
    
    let lineViewHeight = 1.0

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUIs()
        makeConstraints()
    }

    private func setupUIs() {
        carPickUpInfoLabel = UILabel()
        // 0, 0, 0
        carPickUpInfoLabel.font = UIFont(name: "PingFangSC-Medium", size: 15.0)
        carPickUpInfoLabel.text = "取车信息"
        self.addSubview(carPickUpInfoLabel)
        
        lineView1 = UIView()
        // 216, 216, 216
        lineView1.backgroundColor = UIColor.lightGray
        self.addSubview(lineView1)
        
        carPickerLabel = UILabel()
        // 0, 0, 0
        carPickerLabel.font = UIFont(name: "PingFangSC-Regular", size: 14.0)
        carPickerLabel.text = "取车人"
        self.addSubview(carPickerLabel)
        
        carPickerTextField = UITextField()
        carPickerTextField.attributedPlaceholder = textFieldAttributedPlaceholder("取车人姓名")
        self.addSubview(carPickerTextField)
        
        lineView2 = UIView()
        lineView2.backgroundColor = UIColor.lightGray
        self.addSubview(lineView2)
        
        mobileNumberLabel = UILabel()
        mobileNumberLabel.text = "手机号"
        self.addSubview(mobileNumberLabel)
        
        mobileNumberTextField = UITextField()
        mobileNumberTextField.keyboardType = UIKeyboardType.phonePad
        mobileNumberTextField.attributedPlaceholder = textFieldAttributedPlaceholder("手机号")
        self.addSubview(mobileNumberTextField)
    }
    
    private func textFieldAttributedPlaceholder(_ placeholder: String?) -> NSAttributedString? {
        guard let string = placeholder else {
            return nil
        }
        // 60, 60, 67, 0.6
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont(name: "PingFangSC-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)])
    }
    
    private func makeConstraints() {
        carPickUpInfoLabel.snp.makeConstraints {
            $0.top.equalTo(self).offset(12.0)
            $0.left.equalTo(self).offset(16.0)
            $0.right.equalTo(self).offset(-16.0)
        }
        
        lineView1.snp.makeConstraints {
            $0.top.equalTo(carPickUpInfoLabel.snp_bottom).offset(10.0)
            $0.left.right.equalTo(carPickUpInfoLabel)
            $0.height.equalTo(lineViewHeight)
        }
        
        carPickerLabel.snp.makeConstraints {
            $0.top.equalTo(lineView1.snp_bottom).offset(15.0)
            $0.left.equalTo(lineView1)
            $0.width.equalTo(80.0)
        }
        
        carPickerTextField.snp.makeConstraints {
            $0.left.equalTo(carPickerLabel.snp_right)
            $0.right.equalTo(lineView1)
            $0.centerY.equalTo(carPickerLabel)
        }
        
        lineView2.snp.makeConstraints {
            $0.top.equalTo(carPickerLabel.snp_bottom).offset(15.0)
            $0.left.right.equalTo(lineView1)
            $0.height.equalTo(lineViewHeight)
        }
        
        mobileNumberLabel.snp.makeConstraints {
            $0.top.equalTo(lineView2.snp_bottom).offset(15.0)
            $0.left.width.equalTo(carPickerLabel)
            $0.bottom.equalTo(self).offset(-20.0)
        }
        
        mobileNumberTextField.snp.makeConstraints {
            $0.left.equalTo(mobileNumberLabel.snp_right)
            $0.right.equalTo(lineView2)
            $0.centerY.equalTo(mobileNumberLabel)
        }
    }
    
}
