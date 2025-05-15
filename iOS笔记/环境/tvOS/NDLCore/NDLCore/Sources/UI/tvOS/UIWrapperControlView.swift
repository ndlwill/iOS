//
//  UIWrapperControlView.swift
//  NDLCore
//
//  Created by youdun on 2024/1/29.
//

import UIKit

final public class UIWrapperControlView: UIView {
    
    var control: UICustomControl!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("=====init frame=====")
        initUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print("=====init coder=====")
        initUI()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        print("=====awakeFromNib=====")
    }
    
    private func initUI() {
        control = UICustomControl(frame: .zero)
        addSubview(control)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        control.frame = bounds
    }

}
