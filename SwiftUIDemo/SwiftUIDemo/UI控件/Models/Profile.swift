//
//  Profile.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/28.
//

import Foundation

// 个人中心设置
struct Profile {
    var username: String
    var prefersNotifications: Bool
    var seasonalPhoto: Season
    var goalDate: Date
    
    enum Season: String, CaseIterable {
        case spring = "🌷"
        case summer = "🌞"
        case autumn = "🍂"
        case winter = "☃️"
    }
    
    static let `default` = Self(username: "g_kumar", prefersNotifications: true, seasonalPhoto: .winter)
    
    init(username: String, prefersNotifications: Bool = true, seasonalPhoto: Season = .winter) {
        self.username = username
        self.prefersNotifications = prefersNotifications
        self.seasonalPhoto = seasonalPhoto
        self.goalDate = Date()
    }
    
}
