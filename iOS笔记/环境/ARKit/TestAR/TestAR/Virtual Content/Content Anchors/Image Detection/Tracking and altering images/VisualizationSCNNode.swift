//
//  VisualizationSCNNode.swift
//  TestAR
//
//  Created by youdun on 2025/1/10.
//

import SceneKit

class VisualizationSCNNode: SCNNode {
    
    /**
     The images to fade between
     
     The sample’s VisualizationNode fades between two images of differing style, which creates the effect that the tracked image is constantly transforming into a new look.
     You accomplish this effect by defining two SceneKit nodes.
     One node displays the current altered image, and the other displays the previous altered image.
     */
    private let currentImageNode: SCNNode
    private let previousImageNode: SCNNode
    
    // The duration of the fade animation, in seconds.
    private let fadeDuration = 1.0
    
    // An object to notify of fade animation completion.
    weak var delegate: VisualizationSCNNodeDelegate?
    
    init(_ size: CGSize) {
        /**
         Because `SCNPlane` is defined in the XY-plane, but `ARImageAnchor` is defined in the XZ plane, you rotate by 90 degrees to match.
         */
        currentImageNode = createPlaneNode(size: size,
                                           rotation: -.pi / 2,
                                           contents: UIColor.clear)
        previousImageNode = createPlaneNode(size: size,
                                            rotation: -.pi / 2,
                                            contents: UIColor.clear)
        
        super.init()
        
        addChildNode(currentImageNode)
        addChildNode(previousImageNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func display(_ alteredImage: CVPixelBuffer) {
        /**
         Put the previous image on the second plane and update the current plane's texture with the given stylized image.
         */
        previousImageNode.geometry?.firstMaterial?.diffuse.contents = currentImageNode.geometry?.firstMaterial?.diffuse.contents
        currentImageNode.geometry?.firstMaterial?.diffuse.contents = alteredImage.toCGImage()
        
        currentImageNode.opacity = 0.0
        previousImageNode.opacity = 1.0
        
        // You fade between these two nodes by running an opacity animation:
        SCNTransaction.begin()
        SCNTransaction.animationDuration = fadeDuration
        currentImageNode.opacity = 1.0
        previousImageNode.opacity = 0.0
        SCNTransaction.completionBlock = {
            self.delegate?.visualizationSCNNodeDidFinishFade(self)
        }
        SCNTransaction.commit()
    }
    
}


protocol VisualizationSCNNodeDelegate: AnyObject {
    func visualizationSCNNodeDidFinishFade(_ visualizationSCNNode: VisualizationSCNNode)
}


// Creates a SceneKit node with plane geometry, to the argument size, rotation, and material contents.
func createPlaneNode(size: CGSize, rotation: Float, contents: Any?) -> SCNNode {
    let plane = SCNPlane(width: size.width, height: size.height)
    plane.firstMaterial?.diffuse.contents = contents
    
    let planeNode = SCNNode(geometry: plane)
    
    planeNode.eulerAngles.x = rotation
    return planeNode
}
