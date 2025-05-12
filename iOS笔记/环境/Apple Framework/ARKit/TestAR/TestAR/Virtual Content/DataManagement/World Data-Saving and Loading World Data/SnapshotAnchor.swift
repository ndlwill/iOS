//
//  SnapshotAnchor.swift
//  TestAR
//
//  Created by youdun on 2024/12/10.
//

import ARKit

class SnapshotAnchor: ARAnchor, @unchecked Sendable {
    let imageData: Data
    
    override class var supportsSecureCoding: Bool {
        return true
    }
    
    convenience init?(capturing sceneView: ARSCNView) {
        
        guard let frame = sceneView.session.currentFrame else { return nil }
        let ciImage = CIImage(cvPixelBuffer: frame.capturedImage)
        let imageOrientation = CGImagePropertyOrientation(cameraOrientation: UIDevice.current.orientation)
        
        let context = CIContext(options: [.useSoftwareRenderer: false])
        let jpegData = context.jpegRepresentation(of: ciImage,
                                                  colorSpace: CGColorSpaceCreateDeviceRGB(),
                                                  options: [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption: 0.7])
        guard let data = jpegData else { return nil }
        let transform = frame.camera.transform
        
        print("transform = ", transform)
        
        self.init(imageData: data, transform: transform)
    }
    
    init(imageData: Data, transform: float4x4) {
        self.imageData = imageData
        super.init(name: "snapshot", transform: transform)
    }
    
    required init(anchor: ARAnchor) {
        self.imageData = (anchor as! SnapshotAnchor).imageData
        super.init(anchor: anchor)
    }
    
    // NSKeyedUnarchiver.unarchivedObject
    required init?(coder: NSCoder) {
        // 解码方法
        if let snapshot = coder.decodeObject(of: NSData.self, forKey: "snapshot") as? Data {
            self.imageData = snapshot
        } else {
            return nil
        }
        
        super.init(coder: coder)
    }
    
    // NSKeyedArchiver.archivedData
    // 将对象序列化（编码）为可以存储或传输的二进制数据
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        
        coder.encode(imageData, forKey: "snapshot")
    }
    
    
    
    
}
