//
//  DetectingImagesViewController.swift
//  TestAR
//
//  Created by youdun on 2024/5/27.
//

import UIKit
import ARKit

// MARK: - Detecting Images in an AR Experience
/**
 React to known 2D images in the user’s environment, and use their positions to place AR content.
 
 Many AR experiences can be enhanced by using known features of the user’s environment to trigger the appearance of virtual content. For example, a museum app might show a virtual curator when the user points their device at a painting, or a board game might place virtual pieces when the player points their device at a game board. 
 In iOS 11.3 and later, you can add such features to your AR experience by enabling image detection in ARKit: Your app provides known 2D images, and ARKit tells you when and where those images are detected during an AR session.

 This example app looks for any of the several reference images included in the app’s asset catalog. 
 When ARKit detects one of those images, the app shows a message identifying the detected image and a brief animation showing its position in the scene.
 
 Important:
 The images included with this sample are designed to fit the screen sizes of various Apple devices.
 To try the app using these images, choose an image that fits any spare device you have, and display the image full screen on that device. Then run the sample code project on a different device, and point its camera at the device displaying the image. Alternatively, you can add your own images; see the steps in Provide Your Own Reference Images, below.
 
 Note:
 ARKit requires an iOS device with an A9 (or later) processor. ARKit isn’t available in iOS Simulator.
 */

// MARK: - Provide Your Own Reference Images
/**
 To use your own images for detection (in this sample or in your own project), you’ll need to add them to your asset catalog in Xcode.
 1.Open your project’s asset catalog, then use the Add button (+) to add a new AR resource group.
 2.Drag image files from the Finder into the newly created resource group.
 3.For each image, use the inspector to describe the physical size of the image as you’d expect to find it in the user’s real-world environment, and optionally include a descriptive name for your own use.

 Note:
 Put all the images you want to look for in the same session into a resource group.
 Use separate resource groups to hold sets of images for use in separate sessions.
 For example, an art museum app might use separate sessions (and thus separate resource groups) for detecting paintings in different wings of the museum.

 Be aware of image detection capabilities. Choose, design, and configure reference images for optimal reliability and performance:
 1.Enter the physical size of the image in Xcode as accurately as possible.
 ARKit relies on this information to determine the distance of the image from the camera. Entering an incorrect physical size will result in an ARImageAnchor that’s the wrong distance from the camera.
 2.When you add reference images to your asset catalog in Xcode, pay attention to the quality estimation warnings Xcode provides. Images with high contrast work best for image detection.
 3.Use only images on flat surfaces for detection. If an image to be detected is on a nonplanar surface, like a label on a wine bottle, ARKit might not detect it at all, or might create an image anchor at the wrong location.
 4.Consider how your image appears under different lighting conditions. If an image is printed on glossy paper or displayed on a device screen, reflections on those surfaces can interfere with detection.
 */

// MARK: - Apply Best Practices
/**
 Use detected images to set a frame of reference for the AR scene. Instead of requiring the user to choose a place for virtual content, or arbitrarily placing content in the user’s environment, use detected images to anchor the virtual scene. You can even use multiple detected images. For example, an app for a retail store could make a virtual character appear to emerge from a store’s front door by detecting posters placed on either side of the door and then calculating a position for the character directly between the posters.
 
 Design your AR experience to use detected images as a starting point for virtual content.
 ARKit doesn’t track changes to the position or orientation of each detected image.
 If you try to place virtual content that stays attached to a detected image, that content may not appear to stay in place correctly.
 Instead, use detected images as a frame of reference for starting a dynamic scene.
 For example, your app might detect theater posters for a sci-fi film and then have virtual spaceships appear to emerge from the posters and fly around the environment.
 
 Consider when to allow detection of each image to trigger (or repeat) AR interactions. ARKit adds an image anchor to a session exactly once for each reference image in the session configuration’s detectionImages array. If your AR experience adds virtual content to the scene when an image is detected, that action will by default happen only once. To allow the user to experience that content again without restarting your app, call the session’s remove(anchor:) method to remove the corresponding ARImageAnchor. After the anchor is removed, ARKit will add a new anchor the next time it detects the image.
 For example, in the case described above, where spaceships appear to fly out of a movie poster, you might not want an extra copy of that animation to appear while the first one is still playing. Wait until the animation ends to remove the anchor, so that the user can trigger it again by pointing their device at the image.
 */
class DetectingImagesViewController: UIViewController {
    
    
    
    @IBOutlet weak var arscnView: ARSCNView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    

    /*
    weak var statusViewController: StatusViewController?
     */
    
    lazy var statusViewController: StatusViewController = {
        return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
    
    var session: ARSession {
        return arscnView.session
    }
    
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".serialUpdateQueue")
    
    /// Prevents restarting the session while a restart is in progress.
    var isRestartAvailable = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        arscnView.delegate = self
        arscnView.session.delegate = self
        
        /**
         For each new child view controller you add to your interface, perform the following steps in order:

         Call the addChild(_:) method of your container view controller to configure the containment relationship.

         Add the child’s root view to your container’s view hierarchy.

         Add constraints to set the size and position of the child’s root view.

         Call the didMove(toParent:) method of the child view controller to notify it that the transition is complete.
         
         
         Establishing a container-child relationship between view controllers prevents UIKit from interfering with your interface unintentionally.
         UIKit normally routes information to each of your app’s view controllers independently.
         When a container-child relationship exists, UIKit routes many requests through the container view controller first, giving it a chance to alter the behavior for any child view controllers.
         For example, a container view controller may override the traits of its children, forcing them to adopt a specific appearance or behavior.
         */
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        if let statusVC = storyboard.instantiateViewController(identifier: "StatusVC") as? StatusViewController {
            // Add the view controller to the container.
            addChild(statusVC)
            view.addSubview(statusVC.view)
                    
            statusVC.view.frame = CGRect(x: 0,
                                         y: 100.0,
                                         width: UIScreen.main.bounds.width,
                                         height: 100.0)
             
            // Notify the child view controller that the move is complete.
            statusVC.didMove(toParent: self)
         
            self.statusViewController = statusVC
        }
         */
        
        // MARK: - Remove a child view controller from your content
        /**
         To remove a child view controller from your container, perform the following steps in order:

         Call the child’s willMove(toParent:) method with the value nil.

         Deactivate or remove any constraints for the child’s root view.

         Call removeFromSuperview() on the child’s root view to remove it from the view hierarchy.

         Call the child’s removeFromParent() method to finalize the end of the container-child relationship.
         */

        statusViewController.restartARExperienceHandler = { [unowned self] in
            self.restartARExperience()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true

        // Start the AR experience
        resetTracking()
    }
    
    // MARK: - Enable Image Detection
    /**
     Image detection is an add-on feature for world-tracking AR sessions.
     
     To enable image detection:

     Load one or more ARReferenceImage resources from your app’s asset catalog.

     Create a world-tracking configuration and pass those reference images to its detectionImages property.

     Use the run(_:options:) method to run a session with your configuration.
     */
    func resetTracking() {
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        statusViewController.scheduleMessage("Look around to detect images",
                                             inSeconds: 7.5,
                                             messageType: .contentPlacement)
    }
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
        ])
    }

}

// MARK: - ARSCNViewDelegate (Visualize Image Detection Results)
// ARImageAnchor-Visualizing
extension DetectingImagesViewController: ARSCNViewDelegate {
    /**
     When ARKit detects one of your reference images, the session automatically adds a corresponding ARImageAnchor to its list of anchors.
     To respond to an image being detected, implement an appropriate ARSessionDelegate, ARSKViewDelegate, or ARSCNViewDelegate method that reports the new anchor being added to the session.
     
     To use the detected image as a trigger for AR content, you’ll need to know its position and orientation, its size, and which reference image it is.
     The anchor’s inherited transform property provides position and orientation, and its referenceImage property tells you which ARReferenceImage object was detected.
     If your AR content depends on the extent of the image in the scene, you can then use the reference image’s physicalSize to set up your content
     */
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print(#function, Thread.current)
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        
        updateQueue.async {
            // Create a plane to visualize the initial position of the detected image.
            let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                 height: referenceImage.physicalSize.height)
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 0.25
            
            /*
             `SCNPlane` is vertically oriented in its local coordinate space, but
             `ARImageAnchor` assumes the image is horizontal in its local space, so
             rotate the plane to match.
             */
            planeNode.eulerAngles.x = -.pi / 2
            
            /*
             Image anchors are not tracked after initial detection, so create an
             animation that limits the duration for which the plane visualization appears.
             */
            planeNode.runAction(self.imageHighlightAction)
            
            // Add the plane visualization to the scene.
            node.addChildNode(planeNode)
        }
        
        DispatchQueue.main.async {
            let imageName = referenceImage.name ?? ""
            self.statusViewController.cancelAllScheduledMessages()
            self.statusViewController.showMessage("Detected image “\(imageName)”")
        }
    }
}
