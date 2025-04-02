//
//  ARQuickLookViewController.swift
//  TestAR
//
//  Created by youdun on 2025/1/22.
//

import UIKit
import ARKit
import QuickLook

// MARK: - Previewing a Model with AR Quick Look
/**
 Display a model or scene that the user can move, scale, and share with others.
 
 You provide content for your AR experience in .usdz or .reality format:
 To browse a library of .usdz files, see the AR Quick Look Gallery.
 To browse a library of .reality assets, use Reality Composer. For more information, see Creating 3D Content with Reality Composer.
 
 Note
 If you include a Reality Composer file (.rcproject) in your app's Copy Files build phase, Xcode automatically outputs a converted .reality file in your app bundle at build time.
 */
class ARQuickLookViewController: UIViewController, QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    // class ARQuickLookPreviewItem : NSObject, QLPreviewItem
    /**
     To prevent the user from scaling your virtual content or to customize the default share sheet behavior, use ARQuickLookPreviewItem instead of QLPreviewItem.
     
     Display an AR Experience in Your Web Page
     In your web page, you enable AR Quick Look by linking a supported input file.

     <div>
         <a rel="ar" href="/assets/models/my-model.usdz">
             <img src="/assets/models/my-model-thumbnail.jpg">
         </a>
     </div>
     
     When the user clicks the link in Safari or within a web view that's displayed in your app, iOS presents your scene in an AR Quick Look view on your behalf.
     For more information, see Viewing Augmented Reality Assets in Safari for iOS.
     https://webkit.org/blog/8421/viewing-augmented-reality-assets-in-safari-for-ios/
     */
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> any QLPreviewItem {
        guard let path = Bundle.main.path(forResource: "robot", ofType: "usdz") else {
//        guard let path = Bundle.main.path(forResource: "myScene", ofType: "reality") else {
            fatalError("Couldn't find the supported input file.")
        }
        let url = URL(fileURLWithPath: path)
        
        return url as QLPreviewItem
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let previewController = QLPreviewController()
        previewController.dataSource = self
        present(previewController, animated: true, completion: nil)
    }

}
