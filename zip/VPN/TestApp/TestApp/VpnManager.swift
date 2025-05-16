//
//  VpnManager.swift
//  AiJiaSuClientIos
//
//  Created by ndl on 2022/6/10.
//  Copyright © 2022 AiJiaSu Inc. All rights reserved.
//

import Foundation
import NetworkExtension

/*
public enum VpnError {
    
}

extension VpnError: LocalizedError {
    public var errorDescription: String? {
        
    }
}
 */

public class VpnManager {
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private init() {
        // Posted after the VPN configuration stored in the Network Extension preferences changes.
        // NSNotification.Name.NEVPNConfigurationChange
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onVpnStatusDidChanged(_:)),
                                               name: NSNotification.Name.NEVPNStatusDidChange,
                                               object: nil)
    }
    
    static let shared: VpnManager = {
        let instance = VpnManager()
        return instance
    }()
    
    // An object to create and manage the tunnel provider’s VPN configuration.
    private var tpManager: NETunnelProviderManager?
    
    /**
     case invalid = 0
     case disconnected = 1
     case connecting = 2
     case connected = 3
     case reasserting = 4
     case disconnecting = 5
     */
    // 当前vpn状态
    public private(set) var vpnStatus: NEVPNStatus = NEVPNStatus.invalid
    
    private static let kVpnErrorLimitCount = 3
    private var vpnErrorCounting = 0
    var vpnErrorLimitReachedHandler: (() -> Void)?
    
    var vpnStatusChangedHandler: ((_ lastStatus: NEVPNStatus, _ curStatus: NEVPNStatus) -> Void)?
    
    /*
    @available(iOS 13.0.0, *)
    public func loadManager() async throws {}
     */
    
    // MARK: - public methods
    func localizedVpnStatusText() -> String {
        var resultVPNStatusText = ""
        
        switch self.vpnStatus {
        case .invalid:// 0
            // 未启用(未配置)
            resultVPNStatusText = NSLocalizedString("VpnStatusInvalid", comment: "")
        case .disconnected:// 1
            resultVPNStatusText = NSLocalizedString("VpnStatusDisconnected", comment: "")
        case .connecting:// 2
            resultVPNStatusText = NSLocalizedString("VpnStatusConnecting", comment: "")
        case .connected:// 3
            resultVPNStatusText = NSLocalizedString("VpnStatusConnected", comment: "")
        case .reasserting:// 4
            resultVPNStatusText = NSLocalizedString("VpnStatusReasserting", comment: "")
        case .disconnecting:// 5
            resultVPNStatusText = NSLocalizedString("VpnStatusDisconnecting", comment: "")
        @unknown default:
            break
        }
            
        return resultVPNStatusText
    }
    
    func prepared() -> Bool {
        // 表示loadAllFromPreferences的回调执行完成了
        return self.tpManager != nil
    }
    
    func vpnConfigurationEnabled() -> Bool {
        guard let manager = self.tpManager else { return false }
        return manager.isEnabled
    }
    
    func isVpnConfiged() -> Bool {
        return self.tpManager?.protocolConfiguration?.username != nil
    }
    
    func loadManager(completionHandler: @escaping (String?) -> Void) {
        /**
         NETunnelProviderManager
         
         async
         
         Read all of the VPN configurations created by the calling app that have previously been saved to the Network Extension preferences.
         
         loadAllFromPreferences：
         asynchronously Read all of the VPN configurations created by the calling app that have previously been saved to disk and returns them as NETunnelProviderManager objects
         completionHandler：
         A block that takes an array NETunnelProviderManager objects. The array passed to the block may be empty if no NETunnelProvider configurations were successfully read from the disk.  The NSError passed to this block will be nil if the load operation succeeded, non-nil otherwise
         
         This block will be executed on the caller’s main thread after the load operation is complete.
         
         1. 当vpn配置尚未配置时并当调用loadAllFromPreferences时
         不会走onVpnStatusDidChanged回调，因为vpn状态没有发生改变（status=0）。
         2. 当vpn配置已配置时并当调用loadAllFromPreferences时
         不管当前vpn处于哪种状态并且状态没有发生变化时都会先走onVpnStatusDidChanged回调，再走loadAllFromPreferences的回调
         
         loadAllFromPreferences必须得调用
         */
        NETunnelProviderManager.loadAllFromPreferences { [weak self] (tunnelProviderManagers, error) in
            print("loadAllFromPreferences callback start")
            
            // main thread
            // 如果没有配置，tunnelProviderManagers为空数组(Array<NETunnelProviderManager>)
            
            guard let `self` = self else { return }
            
            var errorText: String?
            if let vpnError = error {
                errorText = self.vpnErrorText(by: vpnError)
                self.handleVpnErrorCounting()
            }
            
            guard let tpManagers = tunnelProviderManagers else { return }

            if tpManagers.count > 0 {
                print("\(String(describing: (tpManagers[0].protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier))")
                self.tpManager = tpManagers[0]
            }

            if self.tpManager == nil {
                self.tpManager = NETunnelProviderManager()
            }
            
            completionHandler(errorText)
        }
    }
    
    func loadCurrentVpnConfiguration(completionHandler: @escaping () -> Void) {
        /**
         loadFromPreferences
         This function loads the current VPN configuration from the caller's VPN preferences.
         
         async

         Load the VPN configuration from the Network Extension preferences
         ###
         You must call this method at least once before calling saveToPreferencesWithCompletionHandler: for the first time after your app launches
         ###
         
         completionHandler:
         A block that takes an NSError object. This block will be executed on the caller's main thread after the load operation is complete. If the configuration does not exist in the preferences or is loaded successfully, the error parameter will be nil. If an error occurred while loading the configuration, the error parameter will be set to an NSError object containing details about the error. See NEVPN Errors for a list of possible errors
         */
        self.tpManager?.loadFromPreferences(completionHandler: { error in
            print("\(String(describing: error?.localizedDescription))")
            
            completionHandler()
        })
    }
    
    // 配置系统设置中的VPN
    func configVpnSettingWith(displayName: String?, serverAddress: String?, userName: String?, passwordRef: Data?) {
        // NETunnelProviderProtocol: Configuration parameters for a VPN tunnel.
        let vpnProtocol = NETunnelProviderProtocol()
        vpnProtocol.serverAddress = serverAddress
        vpnProtocol.username = userName
        vpnProtocol.passwordReference = passwordRef
        vpnProtocol.disconnectOnSleep = false
        
        // A Boolean used to toggle the enabled state of the VPN configuration.
        self.tpManager?.isEnabled = true
        self.tpManager?.localizedDescription = displayName
        self.tpManager?.protocolConfiguration = vpnProtocol
        self.tpManager?.isOnDemandEnabled = false
    }
    
    func saveVpnConfiguration(completionHandler: @escaping ((String, Bool)?) -> Void) {
        /*
         saveToPreferences:
         You must call loadFromPreferences(completionHandler:): at least once before calling this method the first time after your app launches.

         总结：
         saveToPreferences不会触发onVpnStatusDidChanged的回调
         loadFromPreferences只有当vpn的状态发生变化时才会触发onVpnStatusDidChanged的回调，否则不会触发onVpnStatusDidChanged的回调
         
         尚未进行vpn配置时，调用saveToPreferences：
         1. saveToPreferences回调中不调用loadFromPreferences的情况下，没有onVpnStatusDidChanged，vpn状态没有变化
         
         再使用相同的节点或者不同的节点进行配置，调用loadFromPreferences，因为saveToPreferences是在loadFromPreferences的回调中调用的，
         所以在saveToPreferences之前会先走onVpnStatusDidChanged的回调，vpn状态变化为 0 -> 1（因为状态有变化），走saveToPreferences时，没有onVpnStatusDidChanged，vpn状态没有变化。
         再重复执行先前的loadFromPreferences操作，因为vpn状态没有变化（状态为1），所以没有走onVpnStatusDidChanged，vpn状态没有变化
         
         2. saveToPreferences回调中调用loadFromPreferences的情况下，loadFromPreferences会触发onVpnStatusDidChanged的回调，vpn状态变化为 0 -> 1（因为状态有变化）
         
         再使用相同的节点或者不同的节点进行配置，调用loadFromPreferences，因为vpn状态没有变化（状态为1），所以没有走onVpnStatusDidChanged，vpn状态没有变化
         再重复执行先前的loadFromPreferences操作，因为vpn状态没有变化（状态为1），所以没有走onVpnStatusDidChanged，vpn状态没有变化
         */
        
        self.tpManager?.saveToPreferences(completionHandler: { error in
            if let vpnError = error as? NEVPNError {
                var permissionDenied: Bool = false
                
                let errorText = self.vpnErrorText(by: vpnError)
                self.handleVpnErrorCounting()
                /**
                 无法安装配置
                 Domain=NEVPNErrorDomain Code=5 "permission denied" UserInfo={NSLocalizedDescription=permission denied}
                 */
                if vpnError.code == .configurationReadWriteFailed {
                    permissionDenied = true
                }
                completionHandler((errorText, permissionDenied))
            } else {
                completionHandler(nil)
            }
        })
    }
    
    /// return: errorText
    func startVpn(with options: [String: NSObject]?) -> String? {
        guard let tunnelProviderManager = self.tpManager else { return nil }
        
        /**
         The NEVPNConnection object used for controlling the VPN tunnel
         tunnelProviderManager.connection: NEVPNConnection
         
         Possible errors include:
         1. NEVPNErrorConfigurationInvalid
         2. NEVPNErrorConfigurationDisabled
         vpnManager.isEnabled = false 就会走下边的catch， NEVPNErrorConfigurationDisabled
         
         如果options中设置错误的密码，不会走下面的catch，vpn状态变化是 1 -> 2 -> 5 -> 1
         */
        do {
            try tunnelProviderManager.connection.startVPNTunnel(options: options)
            return nil
        } catch let vpnError as NSError {
            handleVpnErrorCounting()
            return self.vpnErrorText(by: vpnError)
        }
    }
    
    func stopVpn() {
        if let tunnelProviderManager = self.tpManager {
            // this function returns immediately
            // stopVPNTunnel: connected = 3 -> disconnecting = 5 -> disconnected = 1
            tunnelProviderManager.connection.stopVPNTunnel()
        }
    }
    
    /*
    func sendProviderMessage(_ message: String) {
        // each NETunnelProviderManager object has an associated NETunnelProviderSession as a read-only property.
        guard let tunnelProviderManager = self.tpManager,
              let session = tunnelProviderManager.connection as? NETunnelProviderSession else { return }
        
        session.sendProviderMessage()
    }
     */
    
    // MARK: - private methods
    private func handleVpnErrorCounting() {
        vpnErrorCounting += 1
        
        if vpnErrorCounting > Self.kVpnErrorLimitCount {
            vpnErrorCounting = 0

            vpnErrorLimitReachedHandler?()
        }
    }
    
    // MARK: - Notification
    @objc
    func onVpnStatusDidChanged(_ notification: Notification) {
        // NETunnelProviderSession : NEVPNConnection
        if let tpSession = notification.object as? NETunnelProviderSession {
            print("onVpnStatusDidChanged: notification.description = \(notification.description) status = \(tpSession.status.rawValue)")
            
            let lastStatus = self.vpnStatus
            vpnStatus = tpSession.status
            
            print("onVpnStatusDidChanged: lastStatus = \(lastStatus.rawValue) curStatus = \(vpnStatus.rawValue)")
            
            self.vpnStatusChangedHandler?(lastStatus, self.vpnStatus)
        }
    }
    
    // MARK: - utils
    private func vpnErrorText(by vpnError: Error) -> String {
        let vpnStatusText = self.localizedVpnStatusText()
        
        if vpnStatusText == NSLocalizedString("VpnStatusInvalid", comment: "") {
            return vpnStatusText
        }
        
        var errorText = "(\(vpnError.localizedDescription))"
        if !vpnStatusText.isEmpty {
            errorText = vpnStatusText + errorText
        }
        
        return errorText
    }
}
