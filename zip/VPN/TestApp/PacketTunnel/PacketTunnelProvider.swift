//
//  PacketTunnelProvider.swift
//  PacketTunnel
//
//  Created by youdun on 2023/9/27.
//

import NetworkExtension

class PacketTunnelProvider: PacketTunnelProviderObjc {
    
    /*
    override func startTunnel(options: [String : NSObject]? = nil, completionHandler: @escaping (Error?) -> Void) {
        print("===startTunnel")
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        print("===stopTunnel")
    }
     */

    override func wake() {
        print("===wake")
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        print("===sleep")
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)? = nil) {
        print("===handleAppMessage")
    }
    
}
