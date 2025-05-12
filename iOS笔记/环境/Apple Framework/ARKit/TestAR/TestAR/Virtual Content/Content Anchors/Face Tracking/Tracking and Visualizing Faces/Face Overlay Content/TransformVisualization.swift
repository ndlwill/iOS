//
//  TransformVisualization.swift
//  TestAR
//
//  Created by youdun on 2024/12/24.
//

import SceneKit
import ARKit

/**
 单位矩阵与对角矩阵的关系
 单位矩阵：
 单位矩阵是对角矩阵的特殊形式，其对角线上的所有元素均为 1。
 单位矩阵在数学中表示不变变换，类似于加法中的“0”或乘法中的“1”。
 
 
 先旋转再平移和先平移再旋转不一样，因为矩阵乘法的顺序决定了变换的应用顺序，而矩阵乘法不交换（非交换性），即
 𝐴⋅𝐵
 ≠
 𝐵⋅𝐴

 simdTransform
 定义：描述一个节点（或实体）的整体变换，包含位移（Translation）、旋转（Rotation）、缩放（Scale）在内的组合。
 作用范围：应用于节点的全局坐标系，用来定义该节点的最终位置、方向和大小。
 功能：
 simdTransform 是直接定义一个节点相对于父节点的最终变换。例如：
 设置一个对象在场景中的位置。
 改变对象的缩放或旋转。
 
 simdPivot
 定义：描述节点的旋转和缩放操作相对于的参考点（或称“枢轴点”）。
 作用范围：在节点的局部坐标系中，用于改变旋转和缩放的基准点。
 功能：
 simdPivot 是用来调整节点内部的参考点。默认情况下，节点的旋转和缩放是围绕其局部坐标系的原点（0, 0, 0）进行的。如果希望改变这个参考点，比如让旋转围绕节点的某个边角进行，可以通过设置 simdPivot 实现。
 */
class TransformVisualization: NSObject, VirtualContentController {
    
    var contentNode: SCNNode?
    
    // Load multiple copies of the axis origin visualization for the transforms this class visualizes.
    lazy var rightEyeNode = SCNReferenceNode(named: "coordinateOrigin")
    lazy var leftEyeNode = SCNReferenceNode(named: "coordinateOrigin")
    
    
    /**
     When face tracking is active, ARKit automatically adds ARFaceAnchor objects to the running AR session, containing information about the user’s face, including its position and orientation. (ARKit detects and provides information about only face at a time. If multiple faces are present in the camera image, ARKit chooses the largest or most clearly recognizable face.)
     
     In a SceneKit-based AR experience, you can add 3D content corresponding to a face anchor in the renderer(_:nodeFor:) or renderer(_:didAdd:for:) delegate method.
     ARKit manages a SceneKit node for the anchor, and updates that node’s position and orientation on each frame, so any SceneKit content you add to that node automatically follows the position and orientation of the user’s face.
     */
    /**
     Implement this to provide a custom node for the given anchor.
     
     @discussion This node will automatically be added to the scene graph.
     If this method is not implemented, a node will be automatically created.
     If nil is returned the anchor will be ignored.
     @param renderer The renderer that will render the scene.
     @param anchor The added anchor.
     @return Node that will be mapped to the anchor or nil.
     */
    func renderer(_ renderer: any SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // This class adds AR content only for face anchors.
        guard anchor is ARFaceAnchor else { return nil }
        
        // Load an asset from the app bundle to provide visual content for the anchor.
        contentNode = SCNReferenceNode(named: "coordinateOrigin")
        
        // Add content for eye tracking in iOS 12.
        self.addEyeTransformNodes()
        
        return contentNode
    }
    
    func renderer(_ renderer: any SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard #available(iOS 12.0, *),
              let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        rightEyeNode.simdTransform = faceAnchor.rightEyeTransform
        leftEyeNode.simdTransform = faceAnchor.leftEyeTransform
    }
    
    func addEyeTransformNodes() {
        guard #available(iOS 12.0, *),
              let anchorNode: SCNNode = contentNode else { return }
        
        // MARK: - simdPivot
        /**
         The default pivot is the identity matrix, specifying that the node’s position locates the origin of its coordinate system, its rotation is about an axis through its center, and its scale is also relative to that center point.
         */
        // Scale down the coordinate axis visualizations for eyes.
        rightEyeNode.simdPivot = float4x4(diagonal: [3, 3, 3, 1])
        leftEyeNode.simdPivot = float4x4(diagonal: [3, 3, 3, 1])
        
        anchorNode.addChildNode(rightEyeNode)
        anchorNode.addChildNode(leftEyeNode)
    }
    
}
