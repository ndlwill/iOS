//
//  ViewModelType.swift
//  SwiftDemo
//
//  Created by ndl on 2019/9/25.
//  Copyright © 2019 dzcx. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
