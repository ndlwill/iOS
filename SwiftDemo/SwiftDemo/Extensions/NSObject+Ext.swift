//
//  NSObject+Ext.swift
//  SwiftDemo
//
//  Created by ndl on 2020/2/2.
//  Copyright © 2020 dzcx. All rights reserved.
//

import Foundation

public extension NSObject
{
    
    var className: String {
        get {
            let name = type(of: self).description()
            if (name.contains(".")) {
                return name.components(separatedBy: ".")[1];
            } else {
                return name;
            }
        }
    }
}
