//
//  Untitled.swift
//  AiJiaSuClientIos
//
//  Created by youdun on 2026/1/26.
//  Copyright © 2026 AiJiaSu Inc. All rights reserved.
//

import NetworkExtension

public enum VPNStatus: Int, Sendable {
    case invalid = 0
    case disconnected = 1
    case connecting = 2
    case connected = 3
    case reasserting = 4
    case disconnecting = 5
}

extension VPNStatus {
    init(neVPNStatus: NEVPNStatus) {
        switch neVPNStatus {
        case .invalid: self = .invalid
        case .disconnected: self = .disconnected
        case .connecting: self = .connecting
        case .connected: self = .connected
        case .reasserting: self = .reasserting
        case .disconnecting: self = .disconnecting
        @unknown default:
            self = .invalid
        }
    }
}

protocol VPNStatusProviding {
    var currentVPNStatus: VPNStatus { get }
}

final class NEVPNStatusProvider: VPNStatusProviding, Sendable {
    var currentVPNStatus: VPNStatus {
        VPNStatus(neVPNStatus: VpnManager.shared.currentVPNConnection()?.status ?? .invalid)
    }
}

final class VPNStatusObserver {

    static let shared = VPNStatusObserver()

    private(set) var currentStatus: NEVPNStatus

    private var continuations: [UUID: AsyncStream<NEVPNStatus>.Continuation] = [:]
    private let lock = NSLock()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private init() {
        currentStatus = VpnManager.shared.currentVPNConnection()?.status ?? .invalid

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onStatusChanged),
            name: .NEVPNStatusDidChange,
            object: nil
        )
    }

    func statusStream() -> AsyncStream<NEVPNStatus> {
        let id = UUID()

        return AsyncStream { continuation in
            lock.lock()
            continuations[id] = continuation
            lock.unlock()

            // 新监听者立刻收到当前状态
            continuation.yield(currentStatus)

            continuation.onTermination = { @Sendable _ in
                self.lock.lock()
                self.continuations.removeValue(forKey: id)
                self.lock.unlock()
            }
        }
    }

    @objc
    private func onStatusChanged(_ notification: Notification) {
        guard let session = notification.object as? NETunnelProviderSession else { return }

        let status = session.status
        currentStatus = status

        lock.lock()
        let targets = continuations.values
        lock.unlock()

        for continuation in targets {
            continuation.yield(status)
        }
    }
}
