//
//  MergeVideoViewController.swift
//  SwiftDemo
//
//  Created by dzcx on 2019/9/6.
//  Copyright © 2019 dzcx. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import Photos
import CoreMedia

// 选择两个视频和一首歌曲，该应用程序将合并这两个视频并混合音乐
class MergeVideoViewController: UIViewController {
    
    var asset1: AVAsset?
    var asset2: AVAsset?
    var audioAsset: AVAsset?
    var loadingAsset1Flag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loadAsset1(_ sender: Any) {
        if savedPhotosAlbumAvailable() {
            loadingAsset1Flag = true
            VideoHelper.presentImagePicker(delegate: self, sourceType: .savedPhotosAlbum)
        }
    }
    @IBAction func loadAsset2(_ sender: Any) {
        if savedPhotosAlbumAvailable() {
            loadingAsset1Flag = false
            VideoHelper.presentImagePicker(delegate: self, sourceType: .savedPhotosAlbum)
        }
    }
    @IBAction func loadAudio(_ sender: Any) {
        let mediaPickerVC = MPMediaPickerController(mediaTypes: .any)
        mediaPickerVC.delegate = self
        mediaPickerVC.prompt = "Select Audio"
        present(mediaPickerVC, animated: true, completion: nil)
    }
    @IBAction func merge(_ sender: Any) {
        guard let asset_1 = asset1, let asset_2 = asset2 else { return }
        
        // 合并
        // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        let mixComposition = AVMutableComposition()
        // 2 - Create two video tracks
        // Adds an empty track to a mutable composition
        guard let firstTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }
        do {
            try firstTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset_1.duration), of: asset_1.tracks(withMediaType: .video)[0], at: CMTime.zero)
        } catch {
            print("Failed to load first track")
            return
        }
        
        guard let secondTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }
        do {
            try secondTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset_2.duration), of: asset_2.tracks(withMediaType: .video)[0], at: asset_1.duration)
        } catch {
            print("Failed to load second track")
            return
        }
        
        // instruction: 操作指南
//        // 2.1
//        let mainInstruction = AVMutableVideoCompositionInstruction()
//        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeAdd(asset_1.duration, asset_2.duration))
//        // 2.2
//        let layerInstruction1 = videoCompositionLayerInstruction(firstTrack, asset: asset_1)
//        layerInstruction1.setOpacity(0.0, at: asset_1.duration)
//        let layerInstruction2 = videoCompositionLayerInstruction(secondTrack, asset: asset_2)
        
        // 5 - Create Exporter
        
        // optimize: 使最优化
    }
    
    func savedPhotosAlbumAvailable() -> Bool {
        guard !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else {
            return true
        }
        
        let alertVC = UIAlertController(title: "Not Available", message: "No Saved Album found", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
        return false
    }
    
    func videoCompositionLayerInstruction(_ track: AVMutableCompositionTrack, asset: AVAsset) -> AVMutableVideoCompositionLayerInstruction {
        
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        
//        let assetTrack = asset.tracks(withMediaType: .video)[0]
//        let assetTransform = asset.preferredTransform
//        let assetInfo = orientationFromTransform(assetTransform)
//
//        var scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.width
//        if assetInfo.isPortrait {
//            scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
//            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
//            layerInstruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor), at: CMTime.zero)
//        }
        
        return layerInstruction
    }
    
    // 使用默认iPhone相机应用程序录制的所有电影和图像文件都将视频帧设置为横向，因此iPhone会以横向模式保存媒体
    // Portrait: 竖向的 Orientation: 方向
    func orientationFromTransform(_ transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }
        return (assetOrientation, isPortrait)
    }
}

extension MergeVideoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            else { return }

        let asset = AVAsset(url: url)
        var message = ""
        if loadingAsset1Flag {
            message = "Video1 loaded"
            asset1 = asset
        } else {
            message = "Video2 loaded"
            asset2 = asset
        }
        
        let alertVC = UIAlertController(title: "Asset Loaded", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension MergeVideoViewController: UINavigationControllerDelegate {
    
}

// 从音乐库中选择音频文件，您将使用MPMediaPickerController
extension MergeVideoViewController: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        dismiss(animated: true) {
            let items = mediaItemCollection.items
            guard let item = items.first else {
                return
            }
            
            let url = item.value(forProperty: MPMediaItemPropertyAssetURL) as? URL
            self.audioAsset = (url == nil) ? nil : AVAsset(url: url!)
            
            let title = (url == nil) ? "Asset Not Available" : "Asset Loaded"
            let message = (url == nil) ? "Audio Not Loaded" : "Audio Loaded"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
}
