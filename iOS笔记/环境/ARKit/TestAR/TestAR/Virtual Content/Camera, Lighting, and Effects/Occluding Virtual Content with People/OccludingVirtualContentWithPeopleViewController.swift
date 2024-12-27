//
//  OccludingVirtualContentWithPeopleViewController.swift
//  TestAR
//
//  Created by youdun on 2024/12/18.
//

import RealityKit
import ARKit

// MARK: - Occluding Virtual Content with People
/**
 Cover your app’s virtual content with people that ARKit perceives in the camera feed.
 
 By default, virtual content covers anything in the camera feed.
 For example, when a person passes in front of a virtual object, the object is drawn on top of the person, which can break the illusion of the AR experience.
 
 To cover your app’s virtual content with people that ARKit perceives in the camera feed, you enable people occlusion.
 Your app can then render a virtual object behind people who pass in front of the camera.
 ARKit accomplishes the occlusion by identifying regions in the camera feed where people reside, and preventing virtual content from drawing into that region’s pixels.
 
 To enable people occlusion in Metal apps, see Effecting People Occlusion in Custom Renderers.
 https://developer.apple.com/documentation/arkit/arkit_in_ios/camera_lighting_and_effects/effecting_people_occlusion_in_custom_renderers
 
 
 People occlusion is supported on Apple A12 and later devices.
 
 Note
 If your device doesn’t support people occlusion, the sample stops.
 However, if the user’s device doesn’t support people occlusion, you should continue your AR experience without it.
 */
class OccludingVirtualContentWithPeopleViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    @IBOutlet weak var messageLabel: RoundedLabel!
    
    @IBOutlet weak var coachingOverlayView: ARCoachingOverlayView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        coachingOverlayView.delegate = self
        /**
         或者
         coachingOverlayView.session = arView.session
         */
        coachingOverlayView.sessionProvider = self
        
        /**
         RealityKit supports loading entities from USD (.usd, .usda, .usdc, .usdz) and Reality files (.reality).
         */
        
        do {
            let vaseEntity = try ModelEntity.load(named: "vase")
            vaseEntity.scale = [1, 1, 1] * 0.006
            
            /**
             AnchorEntity:
             
             An anchor that tethers entities to a scene.
             Use anchor entities to control how RealityKit places virtual objects into your scene.
             AnchorEntity conforms to the HasAnchoring protocol, which gives it an AnchoringComponent instance.
             */
            // Place model on a horizontal plane.
            let anchor = AnchorEntity(.plane(.horizontal,
                                             classification: .table,
                                             minimumBounds: [0.15, 0.15]))// 最小平面尺寸 15cm x 15cm
            anchor.children.append(vaseEntity)
            arView.scene.anchors.append(anchor)
            /*
            anchor.addChild(vaseEntity)
            arView.scene.addAnchor(anchor)
             */
        } catch {
            fatalError("Failed to load asset.")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        togglePeopleOcclusion()
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        togglePeopleOcclusion()
    }
    
    private func togglePeopleOcclusion() {
        guard let config = arView.session.configuration as? ARWorldTrackingConfiguration else {
            fatalError("Unexpectedly failed to get the configuration.")
        }
        
        /**
         People occlusion is supported on Apple A12 and later devices.
         Before attempting to enable people occlusion, verify that the user’s device supports it.
         
         Note:
         If your device doesn’t support people occlusion, the sample stops.
         However, if the user’s device doesn’t support people occlusion, you should continue your AR experience without it.
         
         The personSegmentationWithDepth option specifies that a person occludes a virtual object only when the person is closer to the camera than the virtual object.
         
         Alternatively, the personSegmentation frame semantic gives you the option of always occluding virtual content with any people that ARKit perceives in the camera feed irrespective of depth.
         This technique is useful, for example, in green-screen scenarios.
         */
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            fatalError("People occlusion is not supported on this device.")
        }
        
        switch config.frameSemantics {
        case [.personSegmentationWithDepth]:
            config.frameSemantics.remove(.personSegmentationWithDepth)
            messageLabel.displayMessage("People occlusion off", duration: 1.0)
        default:
            config.frameSemantics.insert(.personSegmentationWithDepth)
            messageLabel.displayMessage("People occlusion on", duration: 1.0)
        }
        arView.session.run(config)
    }
    
}

extension OccludingVirtualContentWithPeopleViewController: ARCoachingOverlayViewDelegate {
    
}

extension OccludingVirtualContentWithPeopleViewController: ARSessionProviding {
    var session: ARSession {
        return arView.session
    }
}
