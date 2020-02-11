//
//  String+Ext.swift
//  AiJiaSuClientIos
//
//  Created by youdone-ndl on 2020/1/9.
//  Copyright © 2020 AiJiaSu Inc. All rights reserved.
//
import Foundation
public extension String {
    var fv_isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    var fv_isValidPhoneNumber: Bool {
        let phoneNumberRegEx = "^(1[3-9])\\d{9}$"
        let phoneNumberPredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegEx)
        return phoneNumberPredicate.evaluate(with: self)
    }
    
    func isLatestVersion(_ responseVersion: String) -> Bool {
        let curTempArray: [Substring] = self.split(separator: ".")
        let responseTempArray: [Substring] = responseVersion.split(separator: ".")
        let curArray: [String] = curTempArray.compactMap {
            "\($0)"
        }
        let responseArray: [String] = responseTempArray.compactMap {
            "\($0)"
        }
        
        let curCount = curArray.count
        let responseCount = responseArray.count
        let arrayMaxCount = curCount > responseCount ? curCount : responseCount
        
        for idx in 0..<arrayMaxCount {
            var curNumber = 0
            var responseNumber = 0
            
            if idx < curCount {
                curNumber = Int(curArray[idx]) ?? 0
            }
            if idx < responseCount {
                responseNumber = Int(responseArray[idx]) ?? 0
            }
            
            if curNumber < responseNumber {
                return false
            } else if curNumber > responseNumber {
                return true
            }
        }
        
        return true
    }
    
}
