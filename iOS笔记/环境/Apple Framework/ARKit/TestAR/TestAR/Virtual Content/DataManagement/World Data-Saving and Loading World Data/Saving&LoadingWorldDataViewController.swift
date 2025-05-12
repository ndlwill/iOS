//
//  Saving&LoadingWorldDataViewController.swift
//  TestAR
//
//  Created by youdun on 2024/12/9.
//

import UIKit
import ARKit

// MARK: - Saving and Loading World Data
/**
 Serialize a world-tracking session to resume it later on.
 
 1. Run the app. You can look around and tap to place a virtual 3D object on real-world surfaces. (Tap again to relocate the object.)

 2. After you’ve explored the environment, the Save Experience button becomes available. Tap it to save ARKit’s world-mapping data to local storage.

 3. Tap the Load Experience button. (You can do this immediately, or after quitting and relaunching the app, even if the app has been terminated in the background.)

 4. While ARKit attempts to resume an AR session from the saved world-mapping data, the app displays a snapshot of the camera view from the time that data was saved.
 For best results, move the device so that the camera view matches the screenshot.
 */
class Saving_LoadingWorldDataViewController: UIViewController {
    
    @IBOutlet weak var loadButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var sessionView: UIVisualEffectView!
    @IBOutlet weak var sessionInfoLabel: UILabel!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var snapshotThumbnail: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    lazy var mapSaveURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: true).appendingPathComponent("map.arexperience")
        } catch {
            fatalError("Can't get file save URL: \(error.localizedDescription)")
        }
    }()
    
    var mapDataFromFile: Data? {
        return try? Data(contentsOf: mapSaveURL)
    }
    
    // MARK: - AR session management
    var isRelocalizingMap = false

    var defaultConfiguration: ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }
    
    // MARK: - Placing AR Content
    var virtualObjectAnchor: ARAnchor?
    let virtualObjectAnchorName = "virtualObject"
    
    var virtualObject: SCNNode = {
        guard let sceneURL = Bundle.main.url(forResource: "cup", withExtension: "scn", subdirectory: "Assets.scnassets/cup"),
              let referenceNode = SCNReferenceNode(url: sceneURL) else {
            fatalError("can't load virtual object")
        }
        referenceNode.load()
        
        return referenceNode
    }()
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)

        if mapDataFromFile != nil {
            self.loadButton.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
        
        sceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
                """)
        }
        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        
        // ARSessionDelegate
        sceneView.session.delegate = self
        sceneView.session.run(defaultConfiguration)
        
        // Prevent the screen from being dimmed after a while as users will likely
        // have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
    }

    // Load and Relocalize to a Saved Map
    @IBAction func loadDidClicked(_ sender: Any) {
        print(#function)
        
        /**
         An ARWorldMap object contains a snapshot of all the spatial mapping information that ARKit uses to locate the user’s device in real-world space.
         */
        let worldMap: ARWorldMap = {
            guard let data = mapDataFromFile else { fatalError("Map data should already be verified to exist before Load button is enabled.") }
            
            do {
                guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) else {
                    fatalError("No ARWorldMap in archive.")
                }
                return worldMap
            } catch {
                fatalError("Can't unarchive ARWorldMap from file data: \(error)")
            }
        }()
        
        // Display the snapshot image stored in the world map to aid user in relocalizing.
        if let snapshotData = worldMap.snapshotAnchor?.imageData, let snapshot = UIImage(data: snapshotData) {
            self.snapshotThumbnail.image = snapshot
        } else {
            print("No snapshot image in world map")
        }
        
        // Remove the snapshot anchor from the world map since we do not need it in the scene.
        worldMap.anchors.removeAll(where: { $0 is SnapshotAnchor })
        
        let configuration = self.defaultConfiguration // this app's standard world tracking settings
        configuration.initialWorldMap = worldMap
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        isRelocalizingMap = true
        virtualObjectAnchor = nil
    }
    
    @IBAction func saveDidClicked(_ sender: Any) {
        print(#function)
        
        // async
        sceneView.session.getCurrentWorldMap { worldMap, error in
            print(Thread.current)
            guard let map = worldMap else {
                self.showAlert(title: "Can't get current world map", message: error!.localizedDescription)
                return
            }
            
            // Add a snapshot image indicating where the map was captured.
            guard let snapshotAnchor = SnapshotAnchor(capturing: self.sceneView) else { fatalError("Can't take snapshot") }
            map.anchors.append(snapshotAnchor)
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try data.write(to: self.mapSaveURL, options: [.atomic])
                
                DispatchQueue.main.async {
                    self.loadButton.isHidden = false
                    self.loadButton.isEnabled = true
                }
            } catch {
                fatalError("Can't save map: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func restartDidClicked(_ sender: Any) {
        print(#function)
        
        resetTracking()
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        print(#function)
        
        // Disable placing objects when the session is still relocalizing
        if isRelocalizingMap && virtualObjectAnchor == nil {
            return
        }
        
        // Hit test to find a place for a virtual object.
        guard let hitTestResult = sceneView.hitTest(sender.location(in: sceneView),
                                                    types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane]).first
        else { return }
        
        // Remove exisitng anchor and add new anchor
        if let existingAnchor = virtualObjectAnchor {
            sceneView.session.remove(anchor: existingAnchor)
        }
        
        virtualObjectAnchor = ARAnchor(name: virtualObjectAnchorName, transform: hitTestResult.worldTransform)
        sceneView.session.add(anchor: virtualObjectAnchor!)
    }
    
    private func resetTracking() {
        /**
         resetTracking:
         
         By default, when you call the run(_:options:) method on a session that has run before or is already running, the session resumes device position tracking from its last known state. (For example, an ARAnchor object keeps its apparent position relative to the camera.) When you call the run(_:options:) method with a configuration of the same type as the session's current configuration, you can add this option to force device position tracking to return to its initial state.
         When you call the run(_:options:) method with a configuration of a different type than the session's current configuration, the session always resets tracking (that is, this option is implicitly enabled).
         In either case, when you reset tracking, ARKit also removes any existing anchors from the session.
         */
        sceneView.session.run(defaultConfiguration, options: [.resetTracking, .removeExistingAnchors])
        isRelocalizingMap = false
        virtualObjectAnchor = nil
    }
    
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        print(#function)
        
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String
        
        snapshotThumbnail.isHidden = true
        
        switch (trackingState, frame.worldMappingStatus) {
        case (.normal, .mapped), (.normal, .extending):
            if frame.anchors.contains(where: { $0.name == virtualObjectAnchorName }) {
                // User has placed an object in scene and the session is mapped, prompt them to save the experience
                message = "Tap 'Save Experience' to save the current map."
            } else {
                message = "Tap on the screen to place an object."
            }
        case (.normal, _) where mapDataFromFile != nil && !isRelocalizingMap:
            message = "Move around to map the environment or tap 'Load Experience' to load a saved experience."
        case (.normal, _) where mapDataFromFile == nil:
            message = "Move around to map the environment."
        case (.limited(.relocalizing), _) where isRelocalizingMap:
            message = "Move your device to the location shown in the image."
            snapshotThumbnail.isHidden = false
        default:
            message = trackingState.localizedString
        }
        
        sessionInfoLabel.text = message
        sessionView.isHidden = message.isEmpty
    }
}

extension Saving_LoadingWorldDataViewController: ARSCNViewDelegate {
    
    /**
     In this app, after relocalizing to a previously saved world map, the virtual object placed in the previous session automatically appears at its saved position.
     
     The same ARSCNView delegate method renderer(_:didAdd:for:) fires both when you directly add an anchor to the session and when the session restores anchors from a world map.
     To determine which saved anchor represents the virtual object, this app uses the ARAnchor name property.
     */
    func renderer(_ renderer: any SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print(#function)
        
        guard anchor.name == virtualObjectAnchorName else { return }
        
        // save the reference to the virtual object anchor when the anchor is added from relocalizing
        if virtualObjectAnchor == nil {
            virtualObjectAnchor = anchor
        }
        node.addChildNode(virtualObject)
    }
}

extension Saving_LoadingWorldDataViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        print(#function)
        
        /**
         ARKit provides a worldMappingStatus value that indicates whether it’s currently a good time to capture a world map (or if it’s better to wait until ARKit has mapped more of the local environment).
         */
        // Enable Save button only when the mapping status is good and an object has been placed
        switch frame.worldMappingStatus {
        case .extending, .mapped:
            saveButton.isEnabled = virtualObjectAnchor != nil && frame.anchors.contains(virtualObjectAnchor!)
        default:
            saveButton.isEnabled = false
        }
        
        statusLabel.text = """
        Mapping: \(frame.worldMappingStatus.description)
        Tracking: \(frame.camera.trackingState.description)
        """
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    // MARK: - ARSessionObserver
    func sessionWasInterrupted(_ session: ARSession) {
        print(#function)
        sessionInfoLabel.text = "Session was interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print(#function)
        // Reset tracking and/or remove existing anchors if consistent tracking is required.
        sessionInfoLabel.text = "Session interruption ended"
    }
    
    func session(_ session: ARSession, didFailWithError error: any Error) {
        print(#function)
        
        sessionInfoLabel.text = "Session failed: \(error.localizedDescription)"
        
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        // Remove optional error messages.
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "The AR session failed.",
                                                    message: errorMessage,
                                                    preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
                self.resetTracking()
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        print(#function)
        return true
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print(#function)
        
        if let frame = session.currentFrame {
            updateSessionInfoLabel(for: frame, trackingState: camera.trackingState)
        }
    }
    
    /*
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print(#function)
    }
     */
}

// MARK: - Utilities

extension ARCamera.TrackingState {
    var localizedString: String {
        switch self {
        case .normal:// Camera position tracking is providing optimal results.
            // No planes detected; provide instructions for this app's AR interactions.
            return "Move around to map the environment."
            
        case .notAvailable:// Camera position tracking is not available.
            return "Tracking unavailable."
            
        case .limited(.excessiveMotion):
            return "Move the device more slowly."
            
        case .limited(.insufficientFeatures):
            return "Point the device at an area with visible surface detail, or improve lighting conditions."
            
        case .limited(.relocalizing):
            return "Resuming session — move to where you were when the session was interrupted."
            
        case .limited(.initializing):
            return "Initializing AR session."
        case .limited:// Tracking is available, but the quality of results is questionable.
            return "Tracking limited - unspecified reason"
        }
    }
}

// MARK: - CGImagePropertyOrientation
/**
 CGImagePropertyOrientation 是一个描述图像方向的枚举，用于解析或设置图像元数据中的方向。
 它在旋转、翻转和图像处理时非常重要，尤其是在处理相机拍摄的照片时。
 */
extension CGImagePropertyOrientation {
    /// Preferred image presentation orientation respecting the native sensor orientation of iOS device camera.
    init(cameraOrientation: UIDeviceOrientation) {
        switch cameraOrientation {
        /**
         将 UIDeviceOrientation.portrait 映射到 CGImagePropertyOrientation.right 是正确的
         因为它反映了 iOS 设备相机的传感器方向与图像编码方向之间的关系。
         这种映射基于设备相机传感器的原始方向和图像的默认呈现方式。
         
         相机传感器的默认方向
         iOS 设备相机的传感器原始方向通常是 横向（landscapeLeft）。
         当设备以纵向（portrait）持握时，图像需要**顺时针旋转 90°**才能在显示屏上正确呈现。
         
         CGImagePropertyOrientation 的含义
         CGImagePropertyOrientation.right 表示图像已经顺时针旋转了 90°。
         这与纵向模式下的实际显示需求一致：由于传感器捕获的图像是横向的，需要顺时针旋转 90°以正确显示。
         
         UIDeviceOrientation 的定义
         UIDeviceOrientation.portrait 表示设备顶部朝上。
         在这种情况下，传感器捕获的图像方向需要映射为 CGImagePropertyOrientation.right 才能正确显示。
         
         以下是传感器原始方向、设备方向和所需图像方向之间的关系：
         设备方向 (UIDeviceOrientation)    传感器原始图像方向    图像需旋转的方向    CGImagePropertyOrientation 映射
         portrait    横向（landscapeLeft）    顺时针旋转 90°    .right
         landscapeLeft    横向（landscapeLeft）    无需旋转    .up
         landscapeRight    横向（landscapeLeft）    顺时针旋转 180°    .down
         portraitUpsideDown    横向（landscapeLeft）    顺时针旋转 270°    .left
         
         
         可以通过拍摄照片并检查其 EXIF 元数据中的 Orientation 属性来验证映射是否正确:
         如果设备处于 portrait 模式，EXIF 中的 Orientation 通常为 6（对应 .right）
         if let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any],
            let orientationValue = properties[kCGImagePropertyOrientation as String] as? UInt32 {
             print("Orientation value: \(orientationValue)") // 输出应为 6
         }

         */
        case .portrait:
            self = .right
        case .portraitUpsideDown:
            self = .left
        case .landscapeLeft:
            self = .up
        case .landscapeRight:
            self = .down
        default:
            self = .right
        }
    }
}

extension UIViewController {
    func showAlert(title: String,
                   message: String,
                   buttonTitle: String = "OK",
                   showCancel: Bool = false,
                   buttonHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler))
        if showCancel {
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension ARWorldMap {
    var snapshotAnchor: SnapshotAnchor? {
        return anchors.compactMap { $0 as? SnapshotAnchor }.first
    }
}

extension ARFrame.WorldMappingStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notAvailable:
            return "Not Available"
        case .limited:
            return "Limited"
        case .extending:
            return "Extending"
        case .mapped:
            return "Mapped"
        @unknown default:
            return "Unknown"
        }
    }
}

extension ARCamera.TrackingState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .normal:
            return "Normal"
        case .notAvailable:
            return "Not Available"
        case .limited(.initializing):
            return "Initializing"
        case .limited(.excessiveMotion):
            return "Excessive Motion"
        case .limited(.insufficientFeatures):
            return "Insufficient Features"
        case .limited(.relocalizing):
            return "Relocalizing"
        case .limited:
            return "Unspecified Reason"
        }
    }
}
