//
//  Bundle+Ext.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/6/29.
//  Copyright © 2020 dzcx. All rights reserved.
//

import Foundation

private let kBundle = "bundle"
private let kBundleURLTypes = "CFBundleURLTypes"
private let kBundleURLSchemes = "CFBundleURLSchemes"

public extension Bundle {
    typealias BundleClass = AnyClass
    
    @objc static func ndl_bundle(with bundleClass: BundleClass) -> Bundle {
        let className = String(describing: bundleClass)
        let path = Bundle(for: bundleClass).path(forResource: className, ofType: kBundle) ?? ""
        return Bundle(path: path) ?? Bundle.main
    }
    
    @objc static let ndl_bundleURLSchemes: [String] = {
        guard let urlTypes = main.infoDictionary?[kBundleURLTypes] as? [[String: Any]] else { return [] }
        
        var result: [String] = []
        for urlTypeDic in urlTypes {
            guard let urlSchemes = urlTypeDic[kBundleURLSchemes] as? [String] else { continue }
            guard let firstUrlScheme = urlSchemes.first else { continue }
            result.append(firstUrlScheme)
        }
        
        return result
    }()
}
