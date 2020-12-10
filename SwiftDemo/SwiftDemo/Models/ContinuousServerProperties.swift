//
//  ContinuousServerProperties.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/11/12.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

public typealias ContinuousServerPropertiesDictionary = [String: ContinuousServerProperties]

public class ContinuousServerProperties: NSObject {
    
    public let serverId: String
    public let load: Int
    public let score: Double
    
    override public var description: String {
        return
            "ServerID: \(serverId)\n" +
            "Load: \(load)\n" +
            "Score: \(score)"
    }
    
    public init(serverId: String, load: Int, score: Double) {
        self.serverId = serverId
        self.load = load
        self.score = score
        super.init()
    }
    
    public init(dic: JSONDictionary) throws {
        serverId = try dic.stringOrThrow(key: "ID") //"ID": "ABC"
        load = try dic.intOrThrow(key: "Load") //"Load": "15"
        score = try dic.doubleOrThrow(key: "Score") //"Score": "1.4454542"
        super.init()
    }
}
