//
//  CarPickUpInfoViewModel.swift
//  SwiftDemo
//
//  Created by ndl on 2019/9/30.
//  Copyright © 2019 dzcx. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ValidationResult {
    case success
    case fail(message: String)
}

class CarPickUpInfoViewModel {
    let filteredCarPickerText: Driver<String>
    let filteredMobileNumberText: Driver<String>
//    let validationResult: Driver<ValidationResult>
    
    init(input: (carPickerText: Driver<String>, mobileNumberText: Driver<String>)) {
        filteredCarPickerText = input.carPickerText.map({ (text) -> String in
            if text.count > 6 {
                return (text as NSString).substring(to: 6)
            } else {
                return text
            }
        })

        filteredMobileNumberText = input.mobileNumberText.map({ (text) -> String in
            if text.count > 11 {
                return (text as NSString).substring(to: 11)
            } else {
                return text
            }
        })
        
    }
    
}
