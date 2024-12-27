//
//  BlendShapeCharacter.swift
//  TestAR
//
//  Created by youdun on 2024/12/24.
//

import SceneKit
import ARKit

/**
 Animate a Character with Blend Shapes:
 
 In addition to the face mesh shown in the earlier examples, ARKit also provides a more abstract representation of the user’s facial expressions.
 You can use this representation (called blend shapes) to control animation parameters for your own 2D or 3D assets, creating a character that follows the user’s real facial movements and expressions.
 
 To get the user’s current facial expression, read the blendShapes dictionary from the face anchor in the renderer(_:didUpdate:for:) delegate callback.
 Then, examine the key-value pairs in that dictionary to calculate animation parameters for your 3D content and update that content accordingly.
 
 In this sample, the BlendShapeCharacter class performs this calculation, mapping the eyeBlinkLeft and eyeBlinkRight parameters to one axis of the scale factor of the robot’s eyes, and the jawOpen parameter to offset the position of the robot’s jaw.
 */
class BlendShapeCharacter: NSObject, VirtualContentController {
    var contentNode: SCNNode?
    
    private var originalJawY: Float = 0
    
    private lazy var jawNode = contentNode!.childNode(withName: "jaw", recursively: true)!
    private lazy var eyeLeftNode = contentNode!.childNode(withName: "eyeLeft", recursively: true)!
    private lazy var eyeRightNode = contentNode!.childNode(withName: "eyeRight", recursively: true)!
    
    private lazy var jawHeight: Float = {
        let (min, max) = jawNode.boundingBox
        return max.y - min.y
    }()
    
    func renderer(_ renderer: any SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }
        
        contentNode = SCNReferenceNode(named: "robotHead")
        originalJawY = jawNode.position.y
        
        // Assign a random color to the eyes.
        let material = SCNMaterial.materialWithColor(anchor.identifier.toRandomColor())
        contentNode?.childNode(withName: "eyeLeft", recursively: true)?.geometry?.materials = [material]
        contentNode?.childNode(withName: "eyeRight", recursively: true)?.geometry?.materials = [material]
        
        return contentNode
    }
    
    func renderer(_ renderer: any SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        /**
         用途
         面部表情捕捉：
         通过 blendShapes 的值，开发者可以实时获取用户的面部表情特征，例如嘴巴张开的程度、眼睛闭合的程度等。
         驱动虚拟角色：
         使用 blendShapes 的值驱动虚拟角色（如 3D 模型或表情符号）来模仿用户的表情。
         
         blendShapes:
         A dictionary of named coefficients representing the detected facial expression in terms of the movement of specific facial features.
         
         Each key in this dictionary (an ARFaceAnchor.BlendShapeLocation constant) represents one of many specific facial features recognized by ARKit.
         The corresponding value for each key is a floating point number indicating the current position of that feature relative to its neutral configuration, ranging from 0.0 (neutral) to 1.0 (maximum movement).
         
         You can use blend shape coefficients to animate a 2D or 3D character in ways that follow the user’s facial expressions.
         ARKit provides many blend shape coefficients, resulting in a detailed model of a facial expression; however, you can use as many or as few of the coefficients as you desire to create a visual effect.
         For example, you might animate a simple cartoon character using only the jawOpen, eyeBlinkLeft, and eyeBlinkRight coefficients.
         A professional 3D artist could create a detailed character model rigged for realistic animation using a larger set, or the entire set, of coefficients.
         
         You can also use blend shape coefficients to record a specific facial expression and reuse it later.
         The ARFaceGeometry init(blendShapes:) initializer creates a detailed 3D mesh from a dictionary equivalent to this property’s value;
         the serialized form of a blend shapes dictionary is more portable than that of the face mesh those coefficients describe.
         */
        let blendShapes = faceAnchor.blendShapes
        
        guard let eyeBlinkLeft = blendShapes[.eyeBlinkLeft] as? Float,
              let eyeBlinkRight = blendShapes[.eyeBlinkRight] as? Float,
              let jawOpen = blendShapes[.jawOpen] as? Float else { return }
        
        eyeLeftNode.scale.z = 1 - eyeBlinkLeft
        eyeRightNode.scale.z = 1 - eyeBlinkRight
        
        jawNode.position.y = originalJawY - jawHeight * jawOpen
    }
}
