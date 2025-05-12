//
//  ViewController.swift
//  TestAR
//
//  Created by youdun on 2023/8/11.
//

import UIKit
import ARKit

extension float4x4 {
    var translation: SIMD3<Float> {
        let translation = self.columns.3
        return SIMD3<Float>(translation.x, translation.y, translation.z)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var arscnView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBox()
        addTapGestureToSceneView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        arscnView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arscnView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("======touchesBegan")
    }
    
    // MARK: - 1
    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(x, y, z)
        
        arscnView.scene.rootNode.addChildNode(boxNode)
    }
    
    func addTapGestureToSceneView() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(sceneViewDidTapped(withGestureRecognizer:)))
        arscnView.addGestureRecognizer(tap)
    }
    
    @objc
    func sceneViewDidTapped(withGestureRecognizer recognizer: UIGestureRecognizer) {
        print("======sceneViewDidTapped")
        /*
        let tapLocation = recognizer.location(in: arscnView)
        let hitTestResults = arscnView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else {
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            
                    if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                        let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                        addBox(x: translation.x, y: translation.y, z: translation.z)
                    }
            
            return
        }
        node.removeFromParentNode()
         */
    }

}

