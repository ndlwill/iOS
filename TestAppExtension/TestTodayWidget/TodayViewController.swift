//
//  TodayViewController.swift
//  TestTodayWidget
//
//  Created by youdone-ndl on 2020/1/2.
//  Copyright © 2020 youdone-ndl. All rights reserved.
//

import UIKit
import NotificationCenter

// MARK: Today Extension
/*
 Today Extension只能通过openURL的方式来调起app
 */

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        }
        
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        print("\(maxSize)")
        
        if activeDisplayMode == .expanded {
            
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
