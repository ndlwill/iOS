//
//  Log.swift
//  AiJiaSuClientIos
//
//  Created by youdun on 2025/12/29.
//  Copyright © 2025 AiJiaSu Inc. All rights reserved.
//

import os

enum Log {
    private static let subsystem = Bundle.main.bundleIdentifier ?? ""
    
    // MARK: - App
    static let app = Logger(subsystem: subsystem, category: "App")
    
    static let appLifeCycle = Logger(subsystem: subsystem, category: "App.LifeCycle")
    
    // MARK: - AppIntents
    static let appIntents = Logger(subsystem: subsystem, category: "AppIntents")
}
