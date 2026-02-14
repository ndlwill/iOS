//
//  SelectedServerStore.swift
//  AiJiaSuClientIos
//
//  Created by youdun on 2026/1/13.
//  Copyright © 2026 AiJiaSu Inc. All rights reserved.
//

/**
 Action → Store（副作用） → State → UI
 
 SelectedServerStore: 状态拥有者
 
 UI 层只做三件事：
 读状态 · 显示状态 · 响应用户输入
 不产生业务副作用
 
 让 UI 方法变成“纯函数 + 绑定”
 */
final class SelectedServerStore {

    static let shared = SelectedServerStore()

    private(set) var selectedServer: FVModelServer?
    
    private let vpnManager = VpnManager.shared
    private var appGroupUserDefaults = FVMainAppGroupUserDefaults()

    func refreshSelectedServer() {
        if let server = FVNetClient.responseUserLogin.getCachedServer(FVGlobal.selectedServerId) {
            apply(server)
            return
        }

        // fallback 到 recent
        let recentServers = FVUserRecentServersStorage.recent().getServers()
        if let recent = recentServers.first,
           let server = FVNetClient.responseUserLogin.getCachedServer(recent.id) {
            FVGlobal.selectedServerId = recent.id
            apply(server)
            return
        }

        clear()
    }

    private func apply(_ server: FVModelServer) {
        selectedServer = server
        appGroupSaveServer(server)

        if vpnManager.prepared(),
           vpnManager.vpnStatus == .invalid || vpnManager.vpnStatus == .disconnected {
            FVPing.Instance().pingSingle(server)
        }
    }

    private func clear() {
        selectedServer = nil
        appGroupResetServer()
    }
    
    private func appGroupSaveServer(_ server: FVModelServer) {
        appGroupUserDefaults.saveServerId(server.id)
        appGroupUserDefaults.saveServerAddress(server.ServerHost)
        appGroupUserDefaults.saveServerPortUdp(String(server.ParamPortUdp))
        appGroupUserDefaults.saveServerPortProxy(String(server.ParamPortProxy))
    }
    
    private func appGroupResetServer() {
        appGroupUserDefaults.saveServerId("")
        appGroupUserDefaults.saveServerAddress("")
        appGroupUserDefaults.saveServerPortUdp("")
        appGroupUserDefaults.saveServerPortProxy("")
    }
}
