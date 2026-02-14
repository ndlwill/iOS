//
//  ConnectVPNIntent.swift
//  AiJiaSuClientIos
//
//  Created by youdun on 2026/1/21.
//  Copyright © 2026 AiJiaSu Inc. All rights reserved.
//

import AppIntents

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public enum VPNIntentError: Error, CustomLocalizedStringResourceConvertible {
    case VPNNotConfiged
    
    public var localizedStringResource: LocalizedStringResource {
        switch self {
        case .VPNNotConfiged:
            return "尚未配置"
        @unknown default:
            return ""
        }
    }
}

/**
 func perform() async throws -> some IntentResult {}:
 
 openAppWhenRun: true
 sceneWillEnterForeground->AppIntent init()->perform()->sceneDidBecomeActive
 
 app没launch的情况：
 application(_:didFinishLaunchingWithOptions:)->application(_:configurationForConnecting:options:)->scene(_:willConnectTo:options:)->sceneWillEnterForeground(_:)->
 sceneDidBecomeActive(_:)->AppIntent init()->Main viewDidAppear->perform()
 
 openAppWhenRun: false
 app没launch的情况：
 点击intent
 application(_:didFinishLaunchingWithOptions:)->application(_:configurationForConnecting:options:)->scene(_:willConnectTo:options:)->FVTabBarController viewDidLoad->perform()
 再launch app
 sceneWillEnterForeground(_:)
 main viewDidLoad
 main viewWillAppear
 */
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
struct ConnectVPNIntent: AppIntent {
    
    static let title: LocalizedStringResource = "Connect VPN"
    
    static let description: IntentDescription? = "Connect to the VPN."
    
    @available(iOS 26.0, *)
    static var supportedModes: IntentModes {
        [.background]
    }

    /**
     When the system runs the intent, it calls `perform()`.
     
     Intents run on an arbitrary queue. Intents that manipulate UI need to annotate `perform()` with `@MainActor`
     so that the UI operations run on the main actor.
     */
    @MainActor
    func perform() async throws -> some IntentResult {
        Log.appIntents.info(#function)
        
        let vpnManager = VpnManager.shared
        
        try await vpnManager.loadManager()
        
        if !vpnManager.isVpnConfiged() {
            throw VPNIntentError.VPNNotConfiged
        }
        
        vpnManager.startVpn(with: nil)
        
        return .result()
    }
    
}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
@available(*, deprecated)
extension ConnectVPNIntent {
    /// Tell the system to bring the app to the foreground when the intent runs.
    static var openAppWhenRun: Bool {
        false
    }
}
