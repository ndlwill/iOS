//
//  SurfaceDetectionViewController.swift
//  TestAR
//
//  Created by youdun on 2023/8/16.
//

import UIKit
import ARKit

// MARK: - ARKit requires an iOS device with an A9 or later processor. ARKit is not available in iOS Simulator.

// MARK: - SurfaceDetection
/**
 On supported devices, ARKit can recognize many types of real-world surfaces
 
 The ARSCNView class is a SceneKit view that includes an ARSession object that manages the motion tracking and image processing required to create an augmented reality (AR) experience.
 
 Run your session only when the view that will display it is onscreen.
 
 Important
 If your app requires ARKit for its core functionality, use the arkit key in the section of your app’s Info.plist file to make your app available only on devices that support ARKit.
 If AR is a secondary feature of your app, use the isSupported property to determine whether to offer AR-based features.
 
 diffuseTexcoord
 漫反射（Diffuse）贴图采样的纹理坐标。漫反射贴图是一种常用的纹理，用于模拟物体表面的光照和反射特性。
 
 SIMD 表示 "Single Instruction, Multiple Data"，是一种计算机处理的概念
 这种技术通常用于高性能计算、图形处理、科学计算等领域，可以加速向量和矩阵计算等任务。
 在 iOS 和 macOS 开发中，SIMD 也是一种数据类型和库，用于执行高效的向量和矩阵计算。
 Apple 引入了 SIMD 支持，使开发者能够在应用中更高效地执行数学和计算密集型任务。
 import simd
 */
class SurfaceDetectionViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var sessionInfoVEView: UIVisualEffectView!
    
    @IBOutlet weak var sessionInfoLabel: UILabel!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /**
         Prevent the screen from being dimmed after a while as users will likely have long periods of interaction without touching the screen or buttons.
         */
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // StartARSession
        // Start the view's AR session with a configuration that uses the rear camera
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration)
        
        // Set a delegate to track the number of plane anchors for providing UI feedback.
        sceneView.session.delegate = self
        
        // Show debug UI to view performance metrics (e.g. frames per second).
        sceneView.showsStatistics = true
        
        sceneView.delegate = self
        
        // MARK: - xyz坐标轴（rgb）
        /*
        let rootNode = sceneView.scene.rootNode

        // 创建一个新的节点作为坐标系节点
        let coordinateNode = SCNNode()

        // 设置坐标系节点的位置（可选）
        coordinateNode.simdPosition = float3(0, 0, 0) // 坐标系中心在原点

        // 创建 X 轴
        let xAxis = SCNBox(width: 1.0, height: 0.01, length: 0.01, chamferRadius: 0)
        xAxis.firstMaterial?.diffuse.contents = UIColor.red // X 轴为红色
        let xAxisNode = SCNNode(geometry: xAxis)
        xAxisNode.simdPosition = float3(0.5, 0, 0) // 将红色轴放置在 X 轴方向

        // 创建 Y 轴
        let yAxis = SCNBox(width: 0.01, height: 1.0, length: 0.01, chamferRadius: 0)
        yAxis.firstMaterial?.diffuse.contents = UIColor.green // Y 轴为绿色
        let yAxisNode = SCNNode(geometry: yAxis)
        yAxisNode.simdPosition = float3(0, 0.5, 0) // 将绿色轴放置在 Y 轴方向

        // 创建 Z 轴
        let zAxis = SCNBox(width: 0.01, height: 0.01, length: 1.0, chamferRadius: 0)
        zAxis.firstMaterial?.diffuse.contents = UIColor.blue // Z 轴为蓝色
        let zAxisNode = SCNNode(geometry: zAxis)
        zAxisNode.simdPosition = float3(0, 0, 0.5) // 将蓝色轴放置在 Z 轴方向

        // 将轴节点添加到坐标系节点中
        coordinateNode.addChildNode(xAxisNode)
        coordinateNode.addChildNode(yAxisNode)
        coordinateNode.addChildNode(zAxisNode)

        // 将坐标系节点添加到根节点中
        rootNode.addChildNode(coordinateNode)
         */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's AR session.
        sceneView.session.pause()
    }

    // MARK: - private methods
    private func updateSessionInfoLabel(with frame: ARFrame, trackingState: ARCamera.TrackingState) {
        let message: String
        
        switch trackingState {
        case .normal where frame.anchors.isEmpty:
            // No planes detected
            message = "Move the device around to detect horizontal and vertical surfaces."
        case .notAvailable:
            message = "Tracking unavailable."
        case .limited(.initializing):
            message = "Initializing AR session."
        case .limited(.excessiveMotion):
            message = "Tracking limited - Move the device more slowly."
        case .limited(.insufficientFeatures):
            message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions."
        case .limited(.relocalizing):
            message = "Tracking limited - Relocalizing."
        default:
            // No feedback needed when tracking is normal and planes are visible.(Nor when in unreachable limited-tracking states.)
            message = ""
        }
        sessionInfoLabel.text = message
        sessionInfoVEView.isHidden = message.isEmpty
    }
    
    private func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
}

// MARK: - ARSCNViewDelegate
extension SurfaceDetectionViewController: ARSCNViewDelegate {
    // PlaceARContent
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("=====didAdd node=====")
        
        let rootNode = sceneView.scene.rootNode
        print("=====rootNode: ", rootNode)
        print(rootNode.simdTransform)
        print(rootNode.simdPosition)
        print(rootNode.simdRotation)
        print(rootNode.simdEulerAngles)
        print(rootNode.simdOrientation)
        print(rootNode.simdScale)
        print(rootNode.simdPivot)
        
        for childNode in rootNode.childNodes {
            print("=====childNode: ", childNode)
        }
        
        print("=====node: ", node)
        print(node.simdTransform)
        print(node.simdPosition)
        print(node.simdRotation)
        print(node.simdEulerAngles)
        print(node.simdOrientation)
        print(node.simdScale)
        print(node.simdPivot)
        
        // Place content only for anchors found by plane detection.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Create a custom object to visualize the plane geometry and extent.
        let planeNode = PlaneNode(anchor: planeAnchor, in: sceneView)
        
        // Add the visualization to the ARKit-managed node so that it tracks changes in the plane anchor as plane estimation continues.
        node.addChildNode(planeNode)
    }
    
    // UpdateARContent
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print("#####didUpdate node#####")
        
        // Update only anchors and nodes set up by `renderer(_:didAdd:for:)`.
        guard let planeAnchor = anchor as? ARPlaneAnchor,
              let planeNode = node.childNodes.first as? PlaneNode else { return }
        
        // Update ARSCNPlaneGeometry to the anchor's new estimated shape.
        if let planeGeometry = planeNode.meshNode.geometry as? ARSCNPlaneGeometry {
            planeGeometry.update(from: planeAnchor.geometry)
        }
        
        // Update extent visualization to the anchor's new bounding rectangle.
        if let extentGeometry = planeNode.extentNode.geometry as? SCNPlane {
            extentGeometry.width = CGFloat(planeAnchor.extent.x)
            extentGeometry.height = CGFloat(planeAnchor.extent.z)
            planeNode.extentNode.simdPosition = planeAnchor.center
        }
        
        // Update the plane's classification and the text position
        if #available(iOS 12.0, *),
            let classificationNode = planeNode.classificationNode,
            let classificationGeometry = classificationNode.geometry as? SCNText {
            let currentClassification = planeAnchor.classification.description
            if let oldClassification = classificationGeometry.string as? String, oldClassification != currentClassification {
                classificationGeometry.string = currentClassification
                classificationNode.centerAlign()
            }
        }
    }
}

// MARK: - ARSessionDelegate
extension SurfaceDetectionViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print(#function)
        guard let frame = session.currentFrame else { return }
        updateSessionInfoLabel(with: frame, trackingState: frame.camera.trackingState)
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        print(#function)
        guard let frame = session.currentFrame else { return }
        updateSessionInfoLabel(with: frame, trackingState: frame.camera.trackingState)
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print(#function)
        guard let frame = session.currentFrame else { return }
        updateSessionInfoLabel(with: frame, trackingState: camera.trackingState)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print(#function)
        sessionInfoLabel.text = "Session was interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print(#function)
        sessionInfoLabel.text = "Session interruption ended"
        resetTracking()
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        print(#function, "CurrentThread = \(Thread.current)")
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
            let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
                self.resetTracking()
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
