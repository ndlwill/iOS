//
//  CommonUtils.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/10/16.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

//class CommonUtils {
//
//}

struct CommonUtils {
    
    // MARK: - 判断是否越狱
    public static var isJailbroken: Bool {
        return jailbreakFileExists || sandboxBreached || evidenceOfSymbolLinking
    }
    
    private static var jailbreakFileExists: Bool {
        let jailbreakFilePaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/"
        ]
        let fileManager = FileManager.default
        return jailbreakFilePaths.contains { path in
            if fileManager.fileExists(atPath: path) {
                return true
            }
            if let file = fopen(path, "r") {
                fclose(file)
                return true
            }
            return false
        }
    }
    
    private static var sandboxBreached: Bool {
        guard (try? " ".write(
            toFile: "/private/jailbreak.txt",
            atomically: true, encoding: .utf8)) == nil else {
                return true
        }
        return false
    }
    
    private static var evidenceOfSymbolLinking: Bool {
        var s = stat()
        guard lstat("/Applications", &s) == 0 else { return false }
        return (s.st_mode & S_IFLNK == S_IFLNK)
    }
    
    static func keyWindow(by view: UIView? = nil) -> UIWindow? {
        if let v = view, let keyWindow = v.window {
            return keyWindow
        } else {
            if #available(iOS 13, *) {
                let resultWindow = UIApplication.shared.connectedScenes // Set<UIScene>
                    .compactMap { $0 as? UIWindowScene } // [UIWindowScene]
                    .flatMap { $0.windows }// [UIWindow]
                    .first { $0.isKeyWindow }
                return resultWindow
            } else {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    return appDelegate.window
                }
                
                // 新创建的window可以设置为makeKeyAndVisible,可能不准
                // return UIApplication.shared.keyWindow
            }
        }
        return nil
    }
    
}
