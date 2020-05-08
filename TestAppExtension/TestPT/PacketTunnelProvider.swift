//
//  PacketTunnelProvider.swift
//  TestPT
//
//  Created by youdone-ndl on 2019/12/31.
//  Copyright © 2019 youdone-ndl. All rights reserved.
//

// MARK: ==App extension==
/*
 https://juejin.im/user/58ec343861ff4b00691b4f26/posts
 https://juejin.im/post/5acefc0e6fb9a028e1205688
 https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/index.html#//apple_ref/doc/uid/TP40014214-CH20-SW1
 
 app : 就是我们正常手机里的每个应用程序，即Xcode运行后生成的程序。一个app可以包含一个或多个target,每个target将产生一个product
 app extension : 为了扩展特定app的功能并且依赖于一个特定的app的一条进程
 containing app：一个app包含一个或多个extension称为containing app
 target : 在项目中新建一个target来创建app extension.任意一个target指定了应用程序中构建product的设置信息和文件
 host app : 我们可以把它理解为宿主的App，能够调起extension的app被称为host app，比如：Safari app 里面网页分享到微信, Safari就是 host app
 
 NEVPNManager API提供给我们去创建和管理个人VPN的配置
 在 iOS 9 中，开发者可以用 NETunnelProvider 扩展核心网络层，从而实现非标准化的私密VPN技术。最重要的两个类是 NETunnelProviderManager 和 NEPacketTunnelProvider
 
 NETunnelProviderManager ：配置并控制由Tunnel Provider app extension提供的VPN 连接
 可以理解为建立VPN连接前负责配置基本参数信息保存设置到系统(即一般vpn app中都会在第一次打开时授权并保存到系统的VPN设置中)
 containing app使用NETunnelProviderManager去创建和管理使用自定义协议配置VPN
 */

import NetworkExtension

class PacketTunnelProvider: NEPacketTunnelProvider {

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        // Add code here to start the process of connecting the tunnel.
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code here to start the process of stopping the tunnel.
        completionHandler()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle the message.
        if let handler = completionHandler {
            handler(messageData)
        }
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
    }
    
    override func wake() {
        // Add code here to wake up.
    }
}
