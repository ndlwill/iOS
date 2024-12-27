//
//  TexturedFace.swift
//  TestAR
//
//  Created by youdun on 2024/12/24.
//

import SceneKit
import ARKit

class TexturedFace: NSObject, VirtualContentController {
    var contentNode: SCNNode?
    
    /**
     ARFaceGeometry
     ARKit
     提供人脸的几何顶点数据 (vertices)、纹理坐标 (textureCoordinates) 和三角形索引 (triangleIndices)。
     
     ARSCNFaceGeometry
     ARKit + SceneKit
     用于直接在 SceneKit 中渲染面部几何数据
     */
    /**
     Your AR experience can use this mesh to place or draw content that appears to attach to the face.
     For example, by applying a semitransparent texture to this geometry you could paint virtual tattoos or makeup onto the user’s skin.
     
     To create a SceneKit face geometry, initialize an ARSCNFaceGeometry object with the Metal device your SceneKit view uses for rendering, and assign that geometry to the SceneKit node tracking the face anchor.
     
     Note
     This example uses a texture with transparency to create the illusion of colorful grid lines painted onto a real face. 
     You can use the wireframeTexture.png image included with this sample code project as a starting point to design your own face textures.
     
     ARKit updates its face mesh conform to the shape of the user’s face, even as the user blinks, talks, and makes various expressions.
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
                // #imageLiteral(resourceName: "wireframeTexture")
                material.diffuse.contents = #imageLiteral(resourceName: "wireframeTexture")
                material.lightingModel = .physicallyBased
                
                contentNode = SCNNode(geometry: faceGeometry)
            }
        }
#endif
        
        return contentNode
    }
    
    func renderer(_ renderer: any SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
              let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
    }
    
}
