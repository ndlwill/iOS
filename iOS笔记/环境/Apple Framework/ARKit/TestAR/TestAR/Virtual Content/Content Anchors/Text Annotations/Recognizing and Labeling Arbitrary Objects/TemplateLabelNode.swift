//
//  TemplateLabelNode.swift
//  TestAR
//
//  Created by youdun on 2025/1/2.
//

import SpriteKit

// MARK: - SKReferenceNode
/**
 Node that references an external serialized node graph
 
 A node that's defined in an archived .sks file.
 
 SKReferenceNode is used within an archived .sks file to refer to node defined in another .sks file without duplicating its definition.
 This way, a change to the referenced node propagates to all the references in other files.
 
 Note
 SKReferenceNode is mostly used in conjunction with Xcode's SpriteKit Scene editor, but it's possible to instantiate it yourself and use the resolve() function as a handy way to restore a node's appearance.
 
 As an example, you might want to share an enemy ship across two different levels, Scene1.sks and Scene2.sks, in a level-based game.
 Reference nodes allow you to do that without creating copies of the shared node and its properties.
 
 To use a reference node:
 Create the shared content in a separate archive
 Add references to the shared archive within your scene archives
 
 When each scene is loaded, the reference nodes are resolved dynamically, and therefore you only need to configure a shared object in one place.
 */
class TemplateLabelNode: SKReferenceNode {
    private let text: String
    
    init(text: String) {
        self.text = text
        // Force call to designated init(fileNamed: String?), not convenience init(fileNamed: String)
        super.init(fileNamed: Optional.some("LabelScene"))
        setScale(0.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didLoad(_ node: SKNode?) {
        // Apply text to both labels loaded from the template.
        guard let parent = node?.childNode(withName: "LabelNode") else {
            fatalError("misconfigured SpriteKit template file")
        }
        for case let label as SKLabelNode in parent.children {
            label.name = text
            label.text = text
        }
    }
}
