//
//  PlayVideoViewController.swift
//  SwiftDemo
//
//  Created by dzcx on 2019/9/4.
//  Copyright © 2019 dzcx. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit

class PlayVideoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK:UIColor: Class
        view.backgroundColor = UIColor.cyan

        
    }

    @IBAction func selectAndPlay(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else {
            return;
        }
        
        let vc = UIImagePickerController()
        vc.sourceType = .savedPhotosAlbum
        vc.mediaTypes = [kUTTypeMovie as String]
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension PlayVideoViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            else { return }
        
        dismiss(animated: true) {
            let player = AVPlayer(url: url)
            let playerVC = AVPlayerViewController()
            playerVC.player = player
            self.present(playerVC, animated: true, completion: nil)
        }
    }
}

extension PlayVideoViewController: UINavigationControllerDelegate {
    
}
