//
//  NetworkUtils.swift
//  SwiftDemo
//
//  Created by youdun on 2022/10/28.
//  Copyright © 2022 dzcx. All rights reserved.
//

import Foundation


public struct NetworkUtils {
    
    /**
     IP地址一般是一个32位的二进制数意思就是如果将IP地址转换成二进制表示应该有32位那么长
     但是它通常被分割为4个“8位二进制数”（也就是4个字节，每个代表的就是小于2的8 次方）。
     IP地址通常用“点分十进制”表示成（a.b.c.d）的形式，其中，a,b,c,d都是0~255之间的十进制整数。
     例：点分十进IP地址（100.4.5.6），实际上是32位二进制数（01100100.00000100.00000101.00000110）
     */
    
    // 125.213.100.123 -> 2111136891
    /*
    static func ipValue(with ipStr: String) -> CLong {
        print("CLong.min = \(CLong.min) CLong.max = \(CLong.max)")
        let ipComponents = ipStr.components(separatedBy: ".")
        var retValue: CLong = 0
        let componentCount = ipComponents.count
        for (index, item) in ipComponents.enumerated() {
            if let itemValue = Int(item) {
                retValue += itemValue * NSDecimalNumber(decimal: pow(Decimal(256), componentCount - index - 1)).intValue
            }
        }
        return retValue
    }
     */
    
    // 125.213.100.123 -> 2111136891
    static func ipValue(with ipStr: String) -> CLong {
        let ipComponents = ipStr.components(separatedBy: ".")
        var retValue: CLong = 0
        let componentCount = ipComponents.count
        for item in ipComponents {
            if let itemValue = Int(item) {
                retValue = itemValue | retValue << 8
            }
        }
        return retValue
    }
    
    static func containIp(_ ip: String, from fromIp: String, to toIp: String) -> Bool {
        let ipValue = Self.ipValue(with: ip)
        let fromIpValue = Self.ipValue(with: fromIp)
        let toIpValue = Self.ipValue(with: toIp)
        return ipValue >= fromIpValue && ipValue <= toIpValue
    }
    
    /**
     let prefixLength = 24
     let subnetMaskString = prefixLengthToSubnetMask(prefixLength)
     print(subnetMaskString) // 输出：255.255.255.0
     
     在IP地址表示法中，24是指网络前缀长度，也可以称为子网掩码位数，它表示子网掩码中1的数量。
     要将24转换为点分十进制，需要将其转换为子网掩码的点分十进制表示。
     
     在IPv4中，子网掩码通常是32位的二进制数，其中前缀长度中的位数是1，其余位数为0。
     对于24位的子网掩码，它的二进制表示将会是前24位为1，后8位为0。
     */
    public static func prefixLengthToSubnetMask(_ prefixLength: Int) -> String {
        var maskValue: UInt32 = 0
        for i in 0..<prefixLength {
            maskValue |= 1 << (31 - i)
        }
        let maskString = subnetMaskToString(maskValue)
        return maskString
    }
    
    /**
     let maskValue: UInt32 = 0xffffff00
     let maskString = subnetMaskToString(maskValue)
     print(maskString) // 输出：255.255.255.0
     */
    public static func subnetMaskToString(_ mask: UInt32) -> String {
        var octets = [Int](repeating: 0, count: 4)
        for i in 0..<4 {
            octets[i] = Int((mask >> (i * 8)) & 0xff)
        }
        return octets.map({ String($0) }).joined(separator: ".")
    }
}
