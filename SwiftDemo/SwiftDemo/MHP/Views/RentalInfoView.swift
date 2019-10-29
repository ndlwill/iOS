//
//  RentalInfoView.swift
//  SwiftDemo
//
//  Created by ndl on 2019/9/30.
//  Copyright © 2019 dzcx. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

// 租赁信息view
class RentalInfoView: UIView {

    var typeLabel: UILabel!
    var descriptionLabel: UILabel!
    var lineView1: UIView!
    var timeLabel: UILabel!
    var lineView2: UIView!
    var addressContentView: UIView!
    var addressLabel: UILabel!
    var addressDetailLabel: UILabel!
    var navigationButton: UIButton!
    var lineView3: UIView!
    var contactButton: UIButton!
    
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
        typeLabel = UILabel()
        self.addSubview(typeLabel)
        
        descriptionLabel = UILabel()
        self.addSubview(descriptionLabel)
        
        lineView1 = UIView()
        self.addSubview(lineView1)
        
        timeLabel = UILabel()
        self.addSubview(timeLabel)
        
        lineView2 = UIView()
        self.addSubview(lineView2)
        
        addressContentView = UIView()
        self.addSubview(addressContentView)
        
        addressLabel = UILabel()
        addressContentView.addSubview(addressLabel)
        
        addressDetailLabel = UILabel()
        addressContentView.addSubview(addressDetailLabel)
        
        navigationButton = UIButton(type: .custom)
        addressContentView.addSubview(navigationButton)
        
        lineView3 = UIView()
        self.addSubview(lineView3)
        
        contactButton = UIButton(type: .custom)
        self.addSubview(contactButton)
    }
    
    private func makeConstraints() {
        typeLabel.snp.makeConstraints {
            $0.left.equalTo(self).offset(16.0)
            $0.top.equalTo(self).offset(29.0)
            $0.right.equalTo(self).offset(-16.0)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.left.right.equalTo(typeLabel)
            $0.top.equalTo(typeLabel.snp_bottom)
        }
        
        lineView1.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp_bottom).offset(10.0)
            $0.left.right.equalTo(descriptionLabel)
            $0.height.equalTo(lineViewHeight)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(lineView1.snp_bottom).offset(10.0)
            $0.left.right.equalTo(lineView1)
        }
        
        lineView2.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp_bottom).offset(10.0)
            $0.left.right.equalTo(timeLabel)
            $0.height.equalTo(lineViewHeight)
        }
        
        addressContentView.snp.makeConstraints {
            $0.top.equalTo(lineView2.snp_bottom).offset(10.0)
            $0.left.right.equalTo(lineView2)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.left.equalTo(addressContentView)
            $0.right.equalTo(addressContentView).offset(-40.0)
        }
        
        addressDetailLabel.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp_bottom)
            $0.left.right.equalTo(addressLabel)
            $0.bottom.equalTo(addressContentView)
        }
        
        navigationButton.snp.makeConstraints {
            $0.right.equalTo(addressContentView).offset(-7.0)
            $0.width.height.equalTo(26.0)
            $0.centerY.equalTo(addressContentView)
        }
        
        lineView3.snp.makeConstraints {
            $0.top.equalTo(addressContentView.snp_bottom).offset(10.0)
            $0.left.right.equalTo(addressContentView)
            $0.height.equalTo(lineViewHeight)
        }
        
        contactButton.snp.makeConstraints {
            $0.top.equalTo(lineView3.snp_bottom).offset(12.0)
            $0.centerX.equalTo(self)
            $0.bottom.equalTo(self).offset(-16.0)
        }
    }

}
