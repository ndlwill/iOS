//
//  TestSceneKitViewController.swift
//  TestAR
//
//  Created by youdun on 2024/5/21.
//

import UIKit
import ARKit

// MARK: - Providing 3D Virtual Content with SceneKit
/**
 Use SceneKit to add realistic three-dimensional objects to your AR experience.
 
 
 Follow Best Practices for Designing 3D Assets:
 1. Use the SceneKit physically based lighting model for materials for a more realistic appearance. (See the SCNMaterial class and the Badger: Advanced Rendering in SceneKit sample code project.)
 https://developer.apple.com/documentation/scenekit/scnmaterial
 https://developer.apple.com/library/archive/samplecode/Badger/Introduction/Intro.html#//apple_ref/doc/uid/TP40017309

 2. Bake ambient occlusion shading so that objects appear properly lit in a wide variety of scene lighting conditions.

 3. If you create a virtual object that you intend to place on a real-world flat surface in AR, include a transparent plane with a soft shadow texture below the object in your 3D asset.
 */
class TestSceneKitViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        providing3DVirtualContentWithSceneKit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    /**
     Because ARKit automatically matches SceneKit space to the real world, placing a virtual object so that it appears to maintain a real-world position requires that you set the object's SceneKit position appropriately.
     For example, in a default configuration, the following code places a 10-centimeter cube 20 centimeters in front of the camera's initial position:
     
     The code places an object directly in the view’s SceneKit scene.
     The object automatically appears to track a real-world position because ARKit matches SceneKit space to real-world space.
     
     Alternatively, you can use the ARAnchor class to track real-world positions, either by creating anchors yourself and adding them to the session or by observing anchors that ARKit automatically creates.
     For example, when plane detection is enabled, ARKit adds and updates anchors for each detected plane.
     To add visual content for these anchors, implement ARSCNViewDelegate methods such as the following:
     */
    func providing3DVirtualContentWithSceneKit() {
        sceneView.delegate = self
        
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1,
                                                height: 0.1,
                                                length: 0.1,
                                                chamferRadius: 0))
        cubeNode.position = SCNVector3(0, 0, -0.2) // SceneKit/AR coordinates are in meters
        sceneView.scene.rootNode.addChildNode(cubeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print(#function, "no planeAnchor")
        // This visualization covers only detected planes.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        print(#function, planeAnchor, node)
        print("==========\n")
        
        // Create a SceneKit plane to visualize the node using its position and extent.
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x),
                             height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        // SCNPlanes are vertically oriented in their local coordinate space.
        // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)

        // ARKit owns the node corresponding to the anchor, so make the plane a child node.
        node.addChildNode(planeNode)
    }
}
