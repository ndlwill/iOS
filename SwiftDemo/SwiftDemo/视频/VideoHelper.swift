//
//  VideoHelper.swift
//  SwiftDemo
//
//  Created by dzcx on 2019/9/6.
//  Copyright © 2019 dzcx. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class VideoHelper {
    static func presentImagePicker(delegate: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate, sourceType: UIImagePickerController.SourceType) {
        
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        
        let vc = UIImagePickerController()
        vc.sourceType = sourceType
        vc.mediaTypes = [kUTTypeMovie as String]
        vc.allowsEditing = true
        vc.delegate = delegate
        delegate.present(vc, animated: true, completion: nil)
    }
}
