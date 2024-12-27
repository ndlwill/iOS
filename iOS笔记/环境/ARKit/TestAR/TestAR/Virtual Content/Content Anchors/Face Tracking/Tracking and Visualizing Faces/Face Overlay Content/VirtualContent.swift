//
//  VirtualContent.swift
//  TestAR
//
//  Created by youdun on 2024/12/20.
//

import ARKit

/**
 Transforms
 Texture
 3D Overlay
 Video Texture
 Blend Shapes
 */
enum VirtualContentType: Int {
    case transforms, texture, geometry, videoTexture, blendShape
    
    func makeController() -> VirtualContentController {
        switch self {
        case .transforms:
            return TransformVisualization()
        case .texture:
            return TexturedFace()
        case .geometry:
            return FaceOcclusionOverlay()
        case .videoTexture:
            return VideoTexturedFace()
        case .blendShape:
            return BlendShapeCharacter()
        }
    }
}


protocol VirtualContentController: ARSCNViewDelegate {
    /// The root node for the virtual content.
    var contentNode: SCNNode? { get set }
    
    /*
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode?
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor)
    */
}
