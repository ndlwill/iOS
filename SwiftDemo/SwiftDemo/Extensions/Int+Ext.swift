//
//  Int+Ext.swift
//  AiJiaSuClientIos
//
//  Created by youdone-ndl on 2020/1/22.
//  Copyright © 2020 AiJiaSu Inc. All rights reserved.
//

public extension Int {
    // 秒->00:00:00
    func convertSecondsToHourMinuteSecond() -> String {
        let hour = String(format: "%02ld", self / 3600)
        let minute = String(format: "%02ld", (self % 3600) / 60)
        let second = String(format: "%02ld", self % 60)
        return hour + ":" + minute + ":" + second
    }
}
