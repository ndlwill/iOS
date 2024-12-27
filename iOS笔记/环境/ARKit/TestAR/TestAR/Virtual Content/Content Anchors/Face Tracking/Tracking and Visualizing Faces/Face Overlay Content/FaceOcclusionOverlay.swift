//
//  FaceOcclusionOverlay.swift
//  TestAR
//
//  Created by youdun on 2024/12/24.
//

import SceneKit
import ARKit

class FaceOcclusionOverlay: NSObject, VirtualContentController {
    var contentNode: SCNNode?
    // 遮挡节点
    var occlusionNode: SCNNode!
    
    /**
     Another use of the face mesh that ARKit provides is to create occlusion geometry in your scene.
     An occlusion geometry is a 3D model that doesn’t render any visible content (allowing the camera image to show through), but obstructs the camera’s view of other virtual content in the scene.
     
     This technique creates the illusion that the real face interacts with virtual objects, even though the face is a 2D camera image and the virtual content is a rendered 3D object.
     For example, if you place an occlusion geometry and virtual glasses on the user’s face, the face can obscure the frame of the glasses.
     
     To create an occlusion geometry for the face, start by creating an ARSCNFaceGeometry object
     However, instead of configuring that object’s SceneKit material with a visible appearance, set the material to render depth but not color during rendering:
     
     Because the material renders depth, other objects rendered by SceneKit correctly appear in front of it or behind it.
     But because the material doesn’t render color, the camera image appears in its place.
     
     Note
     The ARFaceGeometry.obj file included in this sample project represents ARKit’s face geometry in a neutral pose. 
     You can use this as a template to design your own 3D art assets for placement on a real face.
     */
    /**
     在 3D 渲染中，球体的**“前面”和“后面”**是相对的概念，取决于观察者（相机）和球体表面法线的方向。
     */
    func renderer(_ renderer: any SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let sceneView = renderer as? ARSCNView,
              anchor is ARFaceAnchor else { return nil }
        
#if targetEnvironment(simulator)
        #error("ARKit is not supported in iOS Simulator. Connect a physical iOS device and select it as your Xcode run destination, or select Generic iOS Device as a build-only destination.")
#else
        if let device = sceneView.device {
            if let faceGeometry = ARSCNFaceGeometry(device: device),
               let material: SCNMaterial = faceGeometry.firstMaterial {
                // 是完全禁止对颜色缓冲区的写入，适用于深度测试、遮挡效果等场景。
                material.colorBufferWriteMask = []
                occlusionNode = SCNNode(geometry: faceGeometry)
                /**
                 renderingOrder:
                 The order the node’s content is drawn in relative to that of other nodes.
                 Nodes with greater rendering orders are rendered last. Defaults to zero.
                 */
                occlusionNode.renderingOrder = -1
                
                // Add 3D asset positioned to appear as "glasses".
                let faceOverlayContent = SCNReferenceNode(named: "overlayModel")
                // Assign a random color to the text.
                let material = SCNMaterial.materialWithColor(anchor.identifier.toRandomColor())
                faceOverlayContent.childNode(withName: "text", recursively: true)?.geometry?.materials = [material]
                
                contentNode = SCNNode()
                contentNode?.addChildNode(occlusionNode)
                contentNode?.addChildNode(faceOverlayContent)
            }
        }
#endif
        
        return contentNode
    }
    
    
    func renderer(_ renderer: any SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceGeometry = occlusionNode.geometry as? ARSCNFaceGeometry,
              let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
    }
}
