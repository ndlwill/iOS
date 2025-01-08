//
//  CapturingBodyMotionViewController.swift
//  TestAR
//
//  Created by youdun on 2023/8/17.
//


import RealityKit
import ARKit
import Combine

// MARK: - Capturing Body Motion in 3D
/**
 use an iOS device with A12 chip or later.
 
 Track a person in the physical environment and visualize their motion by applying the same body movements to a virtual character.
 
 https://developer.apple.com/documentation/arkit/arkit_in_ios/content_anchors/rigging_a_model_for_motion_capture
 https://developer.apple.com/documentation/arkit/arkit_in_ios/content_anchors/validating_a_model_for_motion_capture
 */
class CapturingBodyMotionViewController: UIViewController {
    @IBOutlet var arView: ARView!
    
    // The 3D character to display.
    var character: BodyTrackedEntity?
    let characterOffset: SIMD3<Float> = [-1.0, 0, 0] // Offset the character by one meter to the left
    let characterAnchor = AnchorEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arView.session.delegate = self
        
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }
        
        // Run a body tracking configration.
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        // scene add AnchorEntity
        arView.scene.addAnchor(characterAnchor)
        
        // Asynchronously load the 3D character.
        /**
         AnyCancellable:
         
         A type-erasing cancellable object that executes a provided closure when canceled.
         */
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadBodyTrackedAsync(named: "usdz/character/robot").sink(receiveCompletion: { completion in
            // if case let .failure(error) = completion {
            if case .failure(let error) = completion {
                print("Error: Unable to load model: \(error.localizedDescription)")
            }
            cancellable?.cancel()
        }, receiveValue: { (characterEntity: BodyTrackedEntity) in
            // Scale the character to human size
            characterEntity.scale = [1.0, 1.0, 1.0]
            self.character = characterEntity
            cancellable?.cancel()
        })
    }

}

// MARK: - ARSessionDelegate
extension CapturingBodyMotionViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        print(#function)
        
        for anchor in anchors {
            // MARK: - ARBodyAnchor
            /**
             An anchor representing a body in the world.
             */
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            // Update the position of the character anchor's position.
            /**
             bodyPosition 是物体在世界坐标系中的位置，即物体的当前位置
             */
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            characterAnchor.position = bodyPosition + characterOffset
            
            /**
             Also copy over the rotation of the body anchor, because the skeleton's pose in the world is relative to the body anchor's rotation.
             
             ARBodyAnchor 是一个表示人体骨架的锚点，它的位置和旋转表示人体的整体位置和方向。
             它的 transform 包含了位置（平移）和方向（旋转）信息。
             */
            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
            
            if let characterEntity = character, characterEntity.parent == nil {
                // Attach the character to its anchor as soon as
                // 1. the body anchor was detected and
                // 2. the character was loaded.
                
                // AnchorEntity add Entity
                characterAnchor.addChild(characterEntity)
            }
        }
    }
}
