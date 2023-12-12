//
//  PlaneNode.swift
//  TestAR
//
//  Created by youdun on 2023/8/17.
//

import ARKit

// VisualizePlane
class PlaneNode: SCNNode {
    let meshNode: SCNNode
    let extentNode: SCNNode
    var classificationNode: SCNNode?
    
    init(anchor: ARPlaneAnchor, in sceneView: ARSCNView) {
        #if targetEnvironment(simulator)
        #error("ARKit is not supported in iOS Simulator.")
        #else
        
        // Create a mesh to visualize the estimated shape of the plane.
        // ARSCNPlaneGeometry : SCNGeometry
        guard let planeMeshGeometry = ARSCNPlaneGeometry(device: sceneView.device!) else {
            fatalError("Can't create plane mesh geometry")
        }
        planeMeshGeometry.update(from: anchor.geometry)
        meshNode = SCNNode(geometry: planeMeshGeometry)
        print("===meshNode===", meshNode)
        print(meshNode.simdTransform)
        print(meshNode.simdPosition)
        print(meshNode.simdRotation)
        print(meshNode.simdEulerAngles)
        print(meshNode.simdOrientation)
        print(meshNode.simdScale)
        print(meshNode.simdPivot)
        
        // Create a node to visualize the plane's bounding rectangle.
        // SCNPlane : SCNGeometry, SCNGeometry : NSObject
        /**
         anchor.extent
         In iOS 16, use planeExtent instead.
         The framework sets the x and z components to the width and length of the plane, respectively. The y-component is unused, with a constant value of 0.
         */
        let extentPlane: SCNPlane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        extentNode = SCNNode(geometry: extentPlane)
        extentNode.simdPosition = anchor.center
        // `SCNPlane` is vertically oriented in its local coordinate space, so rotate it to match the orientation of `ARPlaneAnchor`.
        extentNode.eulerAngles.x = -.pi / 2
        print("===extentNode===", extentNode)
        
        super.init()
        
        self.setupMeshVisualStyle()
        self.setupExtentVisualStyle()
        
        // Add the plane extent and plane geometry as child nodes so they appear in the scene.
        addChildNode(meshNode)
        addChildNode(extentNode)
        
        // Display the plane's classification, if supported on the device
        if #available(iOS 12.0, *), ARPlaneAnchor.isClassificationSupported {
            print("===ClassificationSupported===")
            let classificationDesc = anchor.classification.description
            let textNode: SCNNode = self.makeTextNode(classificationDesc)
            
            classificationNode = textNode
            // Change the pivot of the text node to its center
            textNode.centerAlign()
            // Add the classification node as a child node so that it displays the classification
            extentNode.addChildNode(textNode)
        }
        
        #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMeshVisualStyle() {
        // Make the plane visualization semitransparent to clearly show real-world placement.
        meshNode.opacity = 0.25
        
        // Use color and blend mode to make planes stand out.
        guard let material = meshNode.geometry?.firstMaterial else { fatalError("ARSCNPlaneGeometry always has one material") }
        material.diffuse.contents = UIColor.planeMeshColor
    }
    
    private func setupExtentVisualStyle() {
        // Make the extent visualization semitransparent to clearly show real-world placement.
        extentNode.opacity = 0.6

        guard let material = extentNode.geometry?.firstMaterial else { fatalError("SCNPlane always has one material") }
        material.diffuse.contents = UIColor.planeExtentColor

        // Use a SceneKit shader modifier to render only the borders of the plane. wireframe: 线框
        guard let path = Bundle.main.path(forResource: "wireframe_shader", ofType: "metal", inDirectory: "SceneKitAsset.scnassets") else {
            fatalError("Can't find wireframe shader")
        }
        
        do {
            let shader = try String(contentsOfFile: path, encoding: .utf8)
            material.shaderModifiers = [.surface: shader]
        } catch {
            fatalError("Can't load wireframe shader: \(error)")
        }
    }
    
    private func makeTextNode(_ text: String) -> SCNNode {
        let textGeometry = SCNText(string: text, extrusionDepth: 1)
        textGeometry.font = UIFont(name: "Futura", size: 75)

        let textNode = SCNNode(geometry: textGeometry)
        // scale down the size of the text
        textNode.simdScale = SIMD3(0.0005, 0.0005, 0.0005)
        
        return textNode
    }
}
