//
//  UIViewController+Ext.swift
//  AiJiaSuClientIos
//
//  Created by ndl on 2020/2/1.
//  Copyright © 2020 AiJiaSu Inc. All rights reserved.
//

import UIKit
public extension UIViewController {
    func ajs_present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        self.present(viewControllerToPresent, animated: animated, completion: completion)
    }
}
