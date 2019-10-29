//
//  COBMessagePanel.swift
//  CodebaseUIMessageBar
//
//  Created by ndl on 2019/10/24.
//

/*
import UIKit
import SnapKit
import CodebaseUICore

/// COBMessagePanelStyle
public struct COBMessagePanelStyle {
    public enum IconType: Int {
        case success
        case fail
        case info
    }
    
    /// spaceToHorizontalEdge
    public var spaceToHorizontalEdge: CGFloat = 0.0
    
    /// icon type
    public var iconType: IconType = .info
    
    /// title font
    public var titleFont: UIFont = .boldSystemFont(ofSize: 14.0)
    /// title color
    public var titleColor: UIColor = .black
    /// message font
    public var messageFont: UIFont = .systemFont(ofSize: 12.0)
    /// message color
    public var messageColor: UIColor = .black
    /// default button font
    public var defaultButtonFont: UIFont = .boldSystemFont(ofSize: 14.0)
    /// default button title color
    public var defaultButtonTitleColor: UIColor = .black
    /// other button font
    public var otherButtonFont: UIFont = .systemFont(ofSize: 12.0)
    /// other button title color
    public var otherButtonTitleColor: UIColor = .black
}

public class COBMessagePanel: UIView {
    private let contentView = UIView()
    private let actionsContentView = UIView()
    private var iconImageView: UIImageView = UIImageView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = self.style.titleFont
        label.textColor = self.style.titleColor
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = self.style.messageFont
        label.textColor = self.style.messageColor
        return label
    }()
    
    private var buttons: [UIButton] = []
    
    private var iconName: String {
        switch style.iconType {
        case .success:
            return "message_bar_success"
        case .fail:
            return "message_bar_warning"
        case .info:
            return "message_bar_info"
        }
    }
    
    private var finalY: CGFloat {
        let topVC = UIWindow.cob_keyWindowTopMostController?.cob_topMostController

        if let nav = topVC?.navigationController {
            return UIApplication.shared.statusBarFrame.height + nav.navigationBar.frame.height
        } else {
            if #available(iOS 13.0, *) {
                return 0.0
            } else {
                return UIApplication.shared.statusBarFrame.height
            }
        }
    }
    
    private var selfWidth: CGFloat {
        return UIScreen.main.bounds.size.width - 2 * style.spaceToHorizontalEdge
    }
    private var animDuration: TimeInterval = 1.0
    private var style: COBMessagePanelStyle = COBMessagePanelStyle()
    private var titleText: String?
    private var messageText: String?
    private var defaultActionTitle: String?
    private var defaultActionHandler: (() -> Void)?
    private var otherActionTitle: String?
    private var otherActionHandler: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .lightGray
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        setupContentUI()
        setupActionsContentUI()
        addToTopController()
    }
    
    private func setupContentUI() {
        self.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self)
        }
        
        iconImageView.image = UIImage.image(named: iconName)
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentView).offset(5.0)
            make.width.height.equalTo(20.0)
        }
        
        if let titleStr = titleText, !titleStr.isEmpty {
            titleLabel.text = titleStr
            contentView.addSubview(titleLabel)
            
            titleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(iconImageView.snp.right).offset(10.0)
                make.right.equalTo(contentView).offset(-5.0)
                make.centerY.equalTo(iconImageView)
            })
            
            if let messageStr = messageText, !messageStr.isEmpty {
                messageLabel.text = messageStr
                contentView.addSubview(messageLabel)
                
                messageLabel.snp.makeConstraints { (make) in
                    make.left.right.equalTo(titleLabel)
                    make.top.equalTo(titleLabel.snp.bottom).offset(5.0)
                    make.bottom.equalTo(contentView).offset(-10.0)
                }
            } else {
                iconImageView.snp.makeConstraints { (make) in
                    make.bottom.equalTo(contentView).offset(-5.0)
                }
            }
        } else {
            if let messageStr = messageText, !messageStr.isEmpty {
                messageLabel.text = messageStr
                contentView.addSubview(messageLabel)
                
                messageLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(iconImageView.snp.right).offset(10.0)
                    make.top.equalTo(iconImageView)
                    make.right.equalTo(contentView).offset(-5.0)
                    make.bottom.equalTo(contentView).offset(-10.0)
                }
            } else {
                iconImageView.snp.makeConstraints { (make) in
                    make.bottom.equalTo(contentView).offset(-5.0)
                }
            }
        }
    }
    
    private func setupActionsContentUI() {
        if let otherTitle = otherActionTitle {
            let button = UIButton(type: .custom)
            button.titleLabel?.font = style.otherButtonFont
            button.setTitleColor(style.otherButtonTitleColor, for: .normal)
            button.setTitle(otherTitle, for: .normal)
            button.addTarget(self, action: #selector(otherButtonDidClicked), for: .touchUpInside)
            self.buttons.append(button)
        }
        
        if let defaultTitle = defaultActionTitle {
            let button = UIButton(type: .custom)
            button.titleLabel?.font = style.defaultButtonFont
            button.setTitleColor(style.defaultButtonTitleColor, for: .normal)
            button.setTitle(defaultTitle, for: .normal)
            button.addTarget(self, action: #selector(defaultButtonDidClicked), for: .touchUpInside)
            self.buttons.append(button)
        }
    
        if !buttons.isEmpty {
            let count = buttons.count
            self.addSubview(actionsContentView)
            actionsContentView.snp.makeConstraints { (make) in
                make.top.equalTo(contentView.snp.bottom)
                make.height.equalTo(44.0)
                make.left.bottom.right.equalTo(self)
            }
            
            let horizontalLineView = UIView()
            horizontalLineView.backgroundColor = .black
            actionsContentView.addSubview(horizontalLineView)
            horizontalLineView.snp.makeConstraints { (make) in
                make.left.top.right.equalTo(actionsContentView)
                make.height.equalTo(0.5)
            }
            
            let lineWidth: CGFloat = 0.5
            let buttonWidth = (selfWidth - CGFloat((count - 1)) * lineWidth) / CGFloat(count)
            for (index, button) in buttons.enumerated() {
                actionsContentView.addSubview(button)
                
                button.snp.makeConstraints { (make) in
                    make.top.bottom.equalTo(actionsContentView)
                    make.width.equalTo(buttonWidth)
                    make.left.equalTo(actionsContentView).offset(CGFloat(index) * (buttonWidth + lineWidth))
                }
                
                if count > 1 {
                    if index != count - 1 {
                        let verticalLineView = UIView()
                        verticalLineView.backgroundColor = .black
                        actionsContentView.addSubview(verticalLineView)
                        
                        verticalLineView.snp.makeConstraints { (make) in
                            make.top.bottom.equalTo(actionsContentView)
                            make.width.equalTo(lineWidth)
                            make.left.equalTo(actionsContentView).offset(buttonWidth + CGFloat(index) * (buttonWidth + lineWidth))
                        }
                    }
                }
            }
        } else {
            contentView.snp.makeConstraints { (make) in
                make.bottom.equalTo(self)
            }
        }
    }
    
    private func addToTopController() {
        let topVC = UIWindow.cob_keyWindowTopMostController?.cob_topMostController
        if let vc = topVC {
            let parentView: UIView! = vc.view
            parentView.addSubview(self)
            
            self.snp.makeConstraints { (make) in
                make.left.equalTo(parentView).offset(style.spaceToHorizontalEdge)
                make.width.equalTo(selfWidth)
                make.bottom.equalTo(parentView.snp.top)
            }
            parentView.layoutIfNeeded()
        }
    }
    
    private func startAnimation() {
        if let parentView = self.superview {
            self.snp.updateConstraints { (make) in
                make.bottom.equalTo(parentView.snp.top).offset(finalY + self.bounds.height)
            }
            
            UIView.animate(withDuration: animDuration, animations: {
                parentView.layoutIfNeeded()
            })
        }
    }
    
    private func hideAnimation() {
        if let parentView = self.superview {
            self.snp.updateConstraints { (make) in
                make.bottom.equalTo(parentView.snp.top)
            }
            
            UIView.animate(withDuration: animDuration, animations: {
                parentView.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
    
    @objc private func defaultButtonDidClicked() {
        if let handler = defaultActionHandler {
            handler()
        }
        hideAnimation()
    }
    
    @objc private func otherButtonDidClicked() {
        if let handler = otherActionHandler {
            handler()
        }
        hideAnimation()
    }
}

///
public extension COBMessagePanel {
    ///
    func animDuration(duration: TimeInterval) -> Self {
        self.animDuration = duration
        return self
    }
    ///
    func style(style: COBMessagePanelStyle) -> Self {
        self.style = style
        return self
    }
    ///
    func title(title: String?) -> Self {
        self.titleText = title
        return self
    }
    ///
    func message(message: String?) -> Self {
        self.messageText = message
        return self
    }
    ///
    func defaultActionTitle(title: String?, handler: (() -> Void)? = nil) -> Self {
        self.defaultActionTitle = title
        self.defaultActionHandler = handler
        return self
    }
    ///
    func otherActionTitle(title: String?, handler: (() -> Void)? = nil) -> Self {
        self.otherActionTitle = title
        self.otherActionHandler = handler
        return self
    }
    ///
    func show() {
        setupUI()
        startAnimation()
    }
}
*/
