//
//  ViewController.swift
//  TestApp
//
//  Created by youdun on 2023/9/26.
//

import UIKit

class ViewController: UIViewController {
    
    private let vpnManager = VpnManager.shared
    private let netClient = FVNetClientObjc()
    
    private let isSimulator = (TARGET_OS_SIMULATOR == 1)

    @IBOutlet weak var vpnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configVpnManager()
    }
    
    private func configVpnManager() {
        vpnManager.vpnErrorLimitReachedHandler = { [weak self] in
            guard let self = self else { return }
            
        }
        
        vpnManager.vpnStatusChangedHandler = { [weak self] (lastStatus, curStatus) -> Void in
            guard let self = self else { return }
            
            /**
             除了invalid状态之外，重复的状态就不要更新了，免得把原先的提示信息覆盖了(status == .disconnected && lastStatus != .invalid 显示错误信息)
             */
            if curStatus == lastStatus {
                print("same vpn status = \(curStatus.rawValue)")
                
                var returnFlag = true
                
                if curStatus == .invalid {
                    returnFlag = false
                }
                
                if returnFlag {
                    return
                }
            }

            // MARK: - updateVpnStatus-(invalid || disconnected)
            /**
             当vpn出于已连接状态下
             
             disconnected:
             手动断开，异常断开
             invalid:
             系统设置中删除vpn配置
             */
            if curStatus == .invalid || curStatus == .disconnected {
                if curStatus == .invalid {
                    self.vpnButton.setTitle("Invalid", for: .normal)
                } else {
                    self.vpnButton.backgroundColor = UIColor.systemRed
                    self.vpnButton.setTitle("Disconnected", for: .normal)
                }
            }
            // MARK: - updateVpnStatus-(connecting)
            else if curStatus == .connecting {
                self.vpnButton.setTitle("Connecting", for: .normal)
            }
            // MARK: - updateVpnStatus-(disconnecting)
            else if curStatus == .disconnecting {
                self.vpnButton.setTitle("Disconnecting", for: .normal)
            }
            // MARK: - updateVpnStatus-(connected)
            else if curStatus == .connected {
                self.vpnButton.backgroundColor = UIColor.systemGreen
                self.vpnButton.setTitle("Connected", for: .normal)
            } else {// .reasserting
                self.vpnButton.setTitle("Reasserting", for: .normal)
            }
        }
        
        if !vpnManager.prepared() {
            print("vpnManager.loadManager")
            vpnManager.loadManager { [weak self] errorText in
                guard let self = self else { return }
                
            }
        }
    }
    
    private func deviceId() -> String {
        var id: String = ""
        if isSimulator {
            id = "1234567890123456"
        } else {
            var bytes = [UInt8](repeating: 0, count: 16)
            (UUID() as NSUUID).getBytes(&bytes)
            for b in bytes {
                id += String(format: "%02x", b)
            }
        }
        
        return id
    }
    
    private func doConnect() {
        if !self.vpnManager.prepared() {
            return
        }

        vpnManager.loadCurrentVpnConfiguration(completionHandler: {
            self.vpnManager.configVpnSettingWith(displayName: "TestAppleTV",
                                            serverAddress: "36.139.100.84",// 重庆222
                                            userName: "13162293307",
                                            passwordRef: "12345678".data(using: .utf8))
            
            self.vpnManager.saveVpnConfiguration { (errorTuple: (errorText: String, permissionDenied: Bool)?) in
                if let errorText = errorTuple?.errorText {
                    return
                }
                
                // 必须再load一次才能start。否则，首次连接的时候(第一次点击连接，允许进行vpn配置后连接)，会有错误。
                self.vpnManager.loadCurrentVpnConfiguration {
                    let userName = "u.b1gewhhk8wk"
            
                    let password = "272701f15f862c589e0152172b10be28"
                    let clientUniqueId = "6512687602aab316400d"// self.netClient.appClientUniqueId()
                    let networkFlag = false
                    let reconnectType = 0
                    
                    /**
                     NEVPNConnectionStartOptionUsername: AuthName
                     NEVPNConnectionStartOptionPassword: AuthPassword
                     */
                    let options: [String: NSObject] = [
                        "UserName": userName as NSString,
                        "Password": password as NSString,
                        "ImplType": String(0) as NSString,// 通过options传递或者通过AppGroup共享数据
                        "NetworkLock": NSNumber(value: networkFlag),
                        "ReconnectType": NSNumber(value: reconnectType),
                        "ServerId": "vvn-4466-7190" as NSString,
                        "ServerAddress": "36.139.100.84" as NSString,
                        "ServerPortUdp":  String(12754) as NSString,
                        "ServerPortProxy":  String(10961) as NSString,
                        "ClientUniqueId": clientUniqueId as NSString,
                        "ClientVersion": "4.8.8.5" as NSString,
                        "ClientSite": "ajs" as NSString,
                        "ClientExtra": "" as NSString,
                        "OsDevice": "iPhone9,1" as NSString,// FVSupport.deviceType()
                        "OsVersion": "15.7.9" as NSString,// UIDevice.current.systemVersion
                        "OsDeviceId": "U122bb5be84f94245b5b4def151abacac" as NSString,// ("U" + self.deviceId())
                        "OsDeviceIdMap": "did=U122bb5be84f94245b5b4def151abacac" as NSString// ("did=U" + self.deviceId())
                    ]
                    
                    print("options = \(options)")
                    
                    if let errorText = self.vpnManager.startVpn(with: options), !errorText.isEmpty {
                        print("errorText = \(errorText)")
                    }
                }
            }
        })
    }
    
    private func doDisconnect() {
        vpnManager.stopVpn()
    }
    
    @IBAction func vpnButtonDidClicked(_ sender: Any) {
        print("===vpnButtonDidClicked===")
        
        if vpnManager.vpnStatus == .invalid || vpnManager.vpnStatus == .disconnected {
            doConnect()
        } else {
            doDisconnect()
        }
    }
    
}

