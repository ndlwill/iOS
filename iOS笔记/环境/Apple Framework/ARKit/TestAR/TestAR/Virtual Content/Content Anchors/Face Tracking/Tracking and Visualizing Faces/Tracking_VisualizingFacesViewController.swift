//
//  Tracking&VisualizingFacesViewController.swift
//  TestAR
//
//  Created by youdun on 2024/12/20.
//

import UIKit
import ARKit

// MARK: - Tracking and Visualizing Faces
/**
 Detect faces in a front-camera AR experience, overlay virtual content, and animate facial expressions in real-time.
 
 This sample app presents a simple interface allowing you to choose between five augmented reality (AR) visualizations on devices with a TrueDepth front-facing camera.
 1. An overlay of x/y/z axes indicating the ARKit coordinate system tracking the face (and in iOS 12, the position and orientation of each eye).

 2. The face mesh provided by ARKit, showing automatic estimation of the real-world directional lighting environment, as well as a texture you can use to map 2D imagery onto the face.

 3. Virtual 3D content that appears to attach to (and interact with) the user’s real face.

 4. Live camera video texture-mapped onto the ARKit face mesh, with which you can create effects that appear to distort the user’s real face in 3D.

 5. A simple robot character whose facial expression animates to match that of the user, showing how to use ARKit’s animation blend shape values to create experiences like the system Animoji app.
 
 Use the tab bar to switch between these modes.
 
 Important:
 Face tracking supports devices with Apple Neural Engine in iOS 14 and iPadOS 14 and requires a device with a TrueDepth camera on iOS 13 and iPadOS 13 and earlier.
 To run the sample app, set the run destination to an actual device; the Simulator doesn’t support augmented reality.
 */
class Tracking_VisualizingFacesViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    var faceAnchorsAndContentControllers: [ARFaceAnchor: VirtualContentController] = [:]
    
    var selectedVirtualContentType: VirtualContentType! {
        didSet {
            print(#function, "=====")
            guard oldValue != nil, oldValue != selectedVirtualContentType else { return }
            print(#function, "#####")
            
            // Remove existing content when switching types.
            for contentController in faceAnchorsAndContentControllers.values {
                contentController.contentNode?.removeFromParentNode()
            }
            
            /**
             If there are anchors already (switching content), create new controllers and generate updated content.
             Otherwise, the content controller will place it in `renderer(_:didAdd:for:)`.
             */
            for anchor: ARFaceAnchor in faceAnchorsAndContentControllers.keys {
                print("=====faceAnchorsAndContentControllers.keys=====")
                let contentController = selectedVirtualContentType.makeController()
                // Returns the SceneKit node associated with the specified AR anchor
                if let node = sceneView.node(for: anchor),
                let contentNode = contentController.renderer?(sceneView, nodeFor: anchor) {
                    node.addChildNode(contentNode)
                    faceAnchorsAndContentControllers[anchor] = contentController
                }
            }
        }
    }
    
    // Hide the status bar to maximize immersion in AR experiences.
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Auto-hide the home indicator to maximize immersion in AR experiences.
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !ARFaceTrackingConfiguration.isSupported {
            fatalError("ARFaceTrackingConfiguration.isSupported == false")
        } else {
            
            sceneView.delegate = self
            sceneView.session.delegate = self
            sceneView.automaticallyUpdatesLighting = true
            
            tabBar.selectedItem = tabBar.items?.first
            if let selectedItem = tabBar.selectedItem {
                selectedVirtualContentType = VirtualContentType(rawValue: selectedItem.tag)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        // "Reset" to run the AR session for the first time.
        resetTracking()
    }
    
    // MARK: - Start a Face-Tracking Session in a SceneKit View
    /**
     Like other uses of ARKit, face tracking requires configuring and running a session (an ARSession object) and rendering the camera image together with virtual content in a view.
     */
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        if #available(iOS 13.0, *) {
            configuration.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
        }
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        faceAnchorsAndContentControllers.removeAll()
    }
    
    func displayErrorMessage(title: String, message: String) {
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
    
}


// MARK: - ARSCNViewDelegate
extension Tracking_VisualizingFacesViewController: ARSCNViewDelegate {
    
    /**
     Called when a new node has been mapped to the given anchor.
     
     @param renderer The renderer that will render the scene.
     @param node The node that maps to the anchor.
     @param anchor The added anchor.
     */
    func renderer(_ renderer: any SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print(#function, Thread.current, "anchor = \(anchor)")
        
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        DispatchQueue.main.async {
            let contentController = self.selectedVirtualContentType.makeController()
            
            if node.childNodes.isEmpty,
               let contentNode = contentController.renderer?(renderer, nodeFor: faceAnchor) {
                node.addChildNode(contentNode)
                self.faceAnchorsAndContentControllers[faceAnchor] = contentController
            }
        }
    }
    
    /**
     Called when a node has been updated with data from the given anchor.
     
     @param renderer The renderer that will render the scene.
     @param node The node that was updated.
     @param anchor The anchor that was updated.
     */
    func renderer(_ renderer: any SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print(#function, Thread.current, "anchor = \(anchor)")
        
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let contentController = faceAnchorsAndContentControllers[faceAnchor],
              let contentNode = contentController.contentNode else { return }
        
        // 必须用 contentNode，而不是 node (例如: TexturedFace.swift)
        // renderer? 表示调用的方法是 optional func renderer
        contentController.renderer?(renderer, didUpdate: contentNode, for: anchor)
    }
    
    /**
     Called when a mapped node has been removed from the scene graph for the given anchor.
     
     @param renderer The renderer that will render the scene.
     @param node The node that was removed.
     @param anchor The anchor that was removed.
     */
    func renderer(_ renderer: any SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print(#function, Thread.current, "anchor = \(anchor)")
        
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        faceAnchorsAndContentControllers[faceAnchor] = nil
    }
    
}

// MARK: - ARSessionDelegate
extension Tracking_VisualizingFacesViewController: ARSessionDelegate {
    func session(_ session: ARSession, didFailWithError error: any Error) {
        print(#function, Thread.current)
        
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }
}

// MARK: - UITabBarDelegate
extension Tracking_VisualizingFacesViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(#function)
        
        guard let type = VirtualContentType(rawValue: item.tag) else { return }
        selectedVirtualContentType = type
    }
    
}
