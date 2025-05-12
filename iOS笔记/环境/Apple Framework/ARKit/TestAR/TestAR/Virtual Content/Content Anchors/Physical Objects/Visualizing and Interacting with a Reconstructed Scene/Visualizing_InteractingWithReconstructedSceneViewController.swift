//
//  Visualizing_InteractingWithReconstructedSceneViewController.swift
//  TestAR
//
//  Created by youdun on 2024/12/11.
//

import ARKit
import RealityKit

// MARK: - Visualizing and Interacting with a Reconstructed Scene （iOS 13.4）
/**
 On a fourth-generation iPad Pro running iPad OS 13.4 or later, ARKit uses the LiDAR Scanner to create a polygonal model of the physical environment.
 The LiDAR Scanner quickly retrieves depth information from a wide area in front of the user, so ARKit can estimate the shape of the real world without requiring the user to move.
 ARKit converts the depth information into a series of vertices that connect to form a mesh.
 To partition the information, ARKit makes multiple anchors, each assigned a unique portion of the mesh.
 Collectively, the mesh anchors represent the real-world scene around the user.
 
 With these meshes, you can:
 1. More accurately locate points on real-world surfaces.

 2. Classify real-world objects that ARKit can recognize.

 3. Occlude your app’s virtual content with real-world objects that are in front of it.

 4. Have virtual content interact with the physical environment realistically, for example, by bouncing a virtual ball off a real-world wall and having the ball follow the laws of physics.
 
 
 presents an AR experience using RealityKit
 
 */

// MARK: - 物理行为（HasPhysics）、碰撞体（HasCollision）
/**
 在 RealityKit 中，HasPhysics 和 HasCollision 是两个不同的协议，它们分别用于管理物体的物理行为和碰撞检测。尽管它们常常一起使用，但它们的功能和目的各有侧重
 
 HasPhysics 是一个协议，表示实体可以参与物理模拟
 让实体在场景中受到物理引擎的影响，例如重力、碰撞反应和力的作用
 核心属性：
 physicsBody：定义实体的物理主体，包括质量、运动模式和物理属性。
 PhysicsBodyComponent 是这个属性的类型。
 核心参数：
 mode：
 .static：静止物体，不会受力，也不参与物理模拟（如地板）。
 .kinematic：受脚本控制，可以移动，但不会被其他物体影响（如门）。
 .dynamic：完全参与物理模拟，可以被力和碰撞影响（如球）。
 mass：物体的质量。
 friction：摩擦系数。
 restitution：弹性恢复系数（弹跳程度）。
 
 模拟重力作用:
 model.physicsBody = PhysicsBodyComponent(massProperties: .init(mass: 1.0),
                                          material: .default,
                                          mode: .dynamic)
 
 让物体被用户施加力移动:
 model.physicsBody?.applyForce([0, 5, 0], relativeTo: nil)

 
 HasCollision 是一个协议，表示实体可以检测到碰撞事件
 为实体定义碰撞体，使其能够参与碰撞检测。
 核心属性：
 collision：指定碰撞体的形状。
 CollisionComponent 是这个属性的类型。
 核心参数：
 shape：碰撞体的几何形状（球体、盒子、平面等）。
 filter：碰撞检测的分组和规则。
 mode：碰撞体的模式（.default, .trigger, .query 等）。
 
 可以监听碰撞事件（如开始和结束）:
 model.collision?.onCollisionBegin = { (otherEntity) in
     print("Collision began with: \(otherEntity)")
 }

 定义一个简单的碰撞体
 model.generateCollisionShapes(recursive: true)

 添加触控检测
 model.collision = CollisionComponent(shapes: [.generateBox(size: [1, 1, 1])])

 一个球（HasPhysics + HasCollision）与墙碰撞时，墙检测到碰撞（HasCollision），同时球的运动受到弹性恢复系数和摩擦力的影响（HasPhysics）。
 独立使用：
 仅有 HasCollision 的实体可以参与碰撞检测，但不会受力，例如检测到触控按钮时不会移动。
 仅有 HasPhysics 的实体可以受到力的作用，但如果没有碰撞体，就不会与其他物体发生碰撞反应。
 */
@available(iOS 13.4, *)
class Visualizing_InteractingWithReconstructedSceneViewController: UIViewController {
    
    @IBOutlet weak var arView: ARView!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var hideMeshButton: UIButton!
    
    @IBOutlet weak var planeDetectionButton: UIButton!
    
    let coachingOverlay = ARCoachingOverlayView()
    
    /**
     ModelEntity:
     
     A representation of a physical object that RealityKit renders and optionally simulates.
     */
    // Cache for 3D text geometries representing the classification values.
    var modelsForClassification: [ARMeshClassification: ModelEntity] = [:]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.4, *) {
            guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) else {
                fatalError("""
                Scene reconstruction requires a device with a LiDAR Scanner, such as the 4th-Gen iPad Pro.
                """)
            }
        }

        arView.session.delegate = self
        
        setupCoachingOverlay()
        
        if #available(iOS 13.4, *) {
            // ARView.Environment: A description of background, lighting, and acoustic properties for a view’s content.
            arView.environment.sceneUnderstanding.options = []
            
            // Turn on occlusion from the scene reconstruction's mesh.
            arView.environment.sceneUnderstanding.options.insert(.occlusion)
            
            // Turn on physics for the scene reconstruction's mesh.
            arView.environment.sceneUnderstanding.options.insert(.physics)
            
            // Display a debug visualization of the mesh.
            arView.debugOptions.insert(.showSceneUnderstanding)
            
            hideMeshButton.isHidden = false
        } else {
            hideMeshButton.isHidden = true
        }
        
        // For performance, disable render options that are not required for this app.
        arView.renderOptions = [.disablePersonOcclusion, .disableDepthOfField, .disableMotionBlur]
        
        /**
         Manually configure what kind of AR session to run since ARView on its own does not turn on mesh classification.
         
         When the automaticallyConfigureSession property of ARView is true, RealityKit disables classification by default because it isn’t required for occlusion and physics.
         */
        arView.automaticallyConfigureSession = false
        
        let configuration = ARWorldTrackingConfiguration()
        if #available(iOS 13.4, *) {
            configuration.sceneReconstruction = .meshWithClassification
        }
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        arView.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    @IBAction func resetDidClicked(_ sender: Any) {
        print(#function)
        
        if let configuration = arView.session.configuration {
            arView.session.run(configuration, options: .resetSceneReconstruction)
        }
    }
    
    @IBAction func toggleMeshButtonPressed(_ sender: Any) {
        print(#function)
        
        if #available(iOS 13.4, *) {
            let isShowingMesh = arView.debugOptions.contains(.showSceneUnderstanding)
            if isShowingMesh {
                arView.debugOptions.remove(.showSceneUnderstanding)
                hideMeshButton.setTitle("Show Mesh", for: [])
            } else {
                arView.debugOptions.insert(.showSceneUnderstanding)
                hideMeshButton.setTitle("Hide Mesh", for: [])
            }
        }
    }
    
    /**
     When an app enables plane detection with scene reconstruction, ARKit considers that information when making the mesh.
     Where the LiDAR scanner may produce a slightly uneven mesh on a real-world surface, ARKit smooths out the mesh where it detects a plane on that surface.
     */
    @IBAction func togglePlaneDetectionButtonPressed(_ sender: Any) {
        print(#function)
        
        guard let configuration = arView.session.configuration as? ARWorldTrackingConfiguration else {
            return
        }
        
        if configuration.planeDetection == [] {
            configuration.planeDetection = [.horizontal, .vertical]
            planeDetectionButton.setTitle("Stop Plane Detection", for: [])
        } else {
            configuration.planeDetection = []
            planeDetectionButton.setTitle("Start Plane Detection", for: [])
        }
        arView.session.run(configuration)
    }
    
    /**
     Places virtual-text of the classification at the touch-location's real-world intersection with a mesh.
     
     Locate a Point on an Object’s Surface:
     By considering the mesh, raycasts can intersect with nonplanar surfaces, or surfaces with little or no features, like white walls.
     
     
     */
    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        print(#function)
        
        /**
         1. Perform a ray cast against the mesh.
         Note: Ray-cast option ".estimatedPlane" with alignment ".any" also takes the mesh into account.
         */
        let tapLocation: CGPoint = sender.location(in: arView)
        print("tapLocation = ", tapLocation)
        
        if let result = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any).first {
            /**
             2. Visualize the intersection point of the ray with the real-world surface.
             When the user’s raycast returns a result, this app gives visual feedback by placing a small sphere at the intersection point.
             */
            let resultAnchor = AnchorEntity(world: result.worldTransform)
            resultAnchor.addChild(sphere(radius: 0.01, color: .lightGray))
            
            /**
             arView.scene.addAnchor()
             */
            arView.scene.addAnchor(resultAnchor, removeAfter: 3)
            
            /**
             3. Try to get a classification near the tap location.
             Classifications are available per face (in the geometric sense, not human faces).
             */
            nearbyFaceWithClassification(to: result.worldTransform.position) { centerOfFace, classification in
                DispatchQueue.main.async {
                    /**
                     4. Compute a position for the text which is near the result location, but offset 10 cm towards the camera (along the ray) to minimize unintentional occlusions of the text by the mesh.
                     
                     result.worldTransform.position - self.arView.cameraTransform.translation
                     这一表达式表示的是 从相机到目标位置的向量。是一个方向向量，但其长度等于相机和目标之间的实际距离
                     
                     A->B 的向量就是 B - A，和 A - B 是不一样的，方向相反
                     
                     归一化这个向量，使其变成一个单位向量（长度为 1），表示 方向，而不再关心距离。
                     这样可以确保在后续计算中，向量的方向保持不变，但大小固定为 1。这在场景中有多个用途，比如控制位移的幅度或方向。
                     
                     rayDirection 是从相机到目标位置的单位向量。
                     normalize 目的：消除距离的影响，使后续的位移计算只与方向相关
                     
                     如果不使用 normalize：
                     直接使用原始向量：它的长度等于相机和目标位置之间的距离，那么在乘以 0.1 时，偏移的结果会受距离的影响，导致偏移量无法被控制。
                     用归一化后的向量：长度被固定为 1，偏移量（rayDirection * 0.1）完全由 0.1 的倍数决定，与目标和相机之间的距离无关。
                     
                     归一化向量的应用:
                     精确控制偏移量：无论相机和目标位置相隔多远，始终能够偏移固定的 10 厘米。
                     保证方向的正确性：归一化后的向量不会因长度的变化而改变方向，从而准确地描述从目标到相机的方向。
                     */
                    let rayDirection = normalize(result.worldTransform.position - self.arView.cameraTransform.translation)
                    /**
                     rayDirection * 0.1: 表示沿该方向移动 10 厘米（0.1 米）。
                     textPositionInWorldCoordinates: 从目标位置沿着 rayDirection 向相机方向 偏移 10 厘米的位置。
                     */
                    let textPositionInWorldCoordinates = result.worldTransform.position - (rayDirection * 0.1)
                    
                    /**
                     相机:
                     
                     相机的位置就是用户在 3D 空间中的观察点（类似于眼睛的实际位置）。
                     如果用户站在某处（例如房间中央），相机的位置通常被初始化为 (0, 0, 0)，表示这个位置是 AR 世界的原点。
                     
                     相机的位置本质上就是用户设备在虚拟 3D 世界中的位置，类比为用户的“眼睛”。
                     */
                    
                    /**
                     5. Create a 3D text to visualize the classification result.
                     */
                    let textEntity = self.model(for: classification)
                    /**
                     6. Scale the text depending on the distance, such that it always appears with the same size on screen.
                     
                     这段代码的目的是调整文本的缩放比例，以确保文本在屏幕上始终看起来是相同的视觉大小，无论它在3D世界中的距离远近。
                     在 AR 环境中，文本或对象的缩放和视觉大小是两个不同的概念：
                     缩放（Scale）：对象在3D空间中的物理大小。
                     视觉大小：对象在屏幕上看起来占据的像素大小。
                     
                     如果一个文本对象始终保持固定的缩放（如 .scale = .one），当它距离摄像头很近时，会显得非常大；
                     反之，如果它距离很远，则会显得很小。
                     这种现象可能导致用户难以阅读文本。
                     
                     通过将缩放比例与距离成正比：
                     当文本远离摄像头时，放大其缩放比例，使其在屏幕上看起来大小不变。
                     当文本靠近摄像头时，缩小其缩放比例，避免显得过大。
                     
                     未调整缩放
                     文本在近处显得很大，远处几乎看不见。
                     按距离调整缩放
                     文本在近处和远处的屏幕视觉大小保持一致。
                     
                     在计算机图形学中，尤其是在3D场景的渲染中，透视投影是指随着物体距离相机越来越远，它的实际大小会在屏幕上显得越来越小。
                     这是因为远距离物体的视角投影变小，视觉上看起来物体就变得更小。
                     但如果直接根据距离调整缩放，远距离物体会变得非常小，近距离物体会变得非常大。
                     为了让物体无论距离多远都能保持视觉上类似的大小，需要通过合适的缩放因子来平衡这种效果。
                     textEntity.scale = .one * raycastDistance，raycastDistance 是一个与物体和相机之间的距离成正比的因子。
                     通过调整物体的缩放比例，目的是将物体的大小在视觉上保持恒定。
                     实际操作中，通常你不想物体随距离线性缩放，因为那样会导致不自然的视觉效果（例如物体会随着距离的变化而变得极端大或极端小）。
                     而是需要根据相机的视角或焦距来调整比例，使得无论物体多远，都能保持一个自然的大小感知。
                     
                     焦距的定义：焦距是镜头的一个物理特性，通常以毫米（mm）为单位。
                     它定义了镜头光学中心到感光元件（如相机传感器）的距离，影响了相机的视场角（Field of View, FOV）和成像的放大倍数。

                     焦距的影响：
                     视野范围：焦距越短（如广角镜头），视场角越大，拍摄的场景会显得更加宽广。焦距越长（如长焦镜头），视场角越小，能够拍摄的场景会显得更加集中。
                     成像效果：焦距较长的镜头（长焦）会让远处的物体看起来更大，同时压缩前景和背景的深度，使得景深变浅。而焦距较短的镜头（广角）则使远处物体显得更小，景深较大。
                     */
                    let raycastDistance = distance(result.worldTransform.position, self.arView.cameraTransform.translation)
                    textEntity.scale = .one * raycastDistance
                    
                    /**
                     7. Place the text, facing the camera.
                     
                     文本将随着相机的位置和视角而旋转，使其始终朝向用户
                     
                     它是当前相机的变换矩阵（cameraTransform）
                     cameraTransform 是相机在世界坐标系中的位置、旋转和缩放信息的集合。这个矩阵表示了相机的位置、朝向以及任何变换。
                     self.arView.cameraTransform 是一个包含相机位置和相机旋转信息的 4x4 变换矩阵。这个矩阵描述了相机在 3D 空间中的位置和方向（旋转）
                     
                     Transform:
                     An entity acquires a Transform component, as well as a set of methods for manipulating the transform, by adopting the HasTransform protocol.
                     This is true for all entities, because the Entity base class adopts the protocol.
                     */
                    var resultWithCameraOrientation = self.arView.cameraTransform// 拷贝 cameraTransform 生成一个新转换矩阵
                    // 实现了文本始终面向相机的效果。
                    /**
                     它复制了相机的旋转部分（保持不变），并将平移部分（即相机的位置）更新为文本的位置。
                     这并不意味着相机会移动到文本的位置。相反，文本的位置被设置为距离相机适当的地方，同时保持相机的旋转，这样文本始终面向相机。
                     
                     旋转：resultWithCameraOrientation 继承了相机的旋转信息，这意味着文本的朝向（旋转）将始终和相机一致，朝向相机。
                     平移：通过更新 translation（平移部分）为 textPositionInWorldCoordinates，你实际上是改变了文本的位置，使其稍微偏离相机的位置（在 rayDirection * 0.1 的位置上）。
                     但这并不会影响相机的实际位置，因为你只是改变了 resultWithCameraOrientation 的平移部分。
                     */
                    resultWithCameraOrientation.translation = textPositionInWorldCoordinates// 新转换矩阵是在 cameraTransform 的基础上修改 translation
                    
                    let textAnchor = AnchorEntity(world: resultWithCameraOrientation.matrix)
                    textAnchor.addChild(textEntity)
                    self.arView.scene.addAnchor(textAnchor, removeAfter: 3)
                    
                    /**
                     8. Visualize the center of the face (if any was found) for three seconds.
                     It is possible that this is nil, e.g. if there was no face close enough to the tap location.
                     */
                    if let centerOfFace: SIMD3<Float> = centerOfFace {
                        let faceAnchor = AnchorEntity(world: centerOfFace)
                        faceAnchor.addChild(self.sphere(radius: 0.01, color: classification.color))
                        self.arView.scene.addAnchor(faceAnchor, removeAfter: 3)
                    }
                }
            }
        }
        
    }
    
    func sphere(radius: Float, color: UIColor) -> ModelEntity {
        let sphere = ModelEntity(mesh: .generateSphere(radius: radius),
                                 materials: [SimpleMaterial(color: color, isMetallic: false)])
        // Move sphere up by half its diameter so that it does not intersect with the mesh
        sphere.position.y = radius
        return sphere
    }
    
    func nearbyFaceWithClassification(to location: SIMD3<Float>,
                                      completionBlock: @escaping (SIMD3<Float>?, ARMeshClassification) -> Void) {
        guard let frame = arView.session.currentFrame else {
            completionBlock(nil, .none)
            return
        }
        
        var meshAnchors = frame.anchors.compactMap({ $0 as? ARMeshAnchor })
        /**
         Sort the mesh anchors by distance to the given location and filter out any anchors that are too far away (4 meters is a safe upper limit).
         */
        let cutoffDistance: Float = 4.0
        meshAnchors.removeAll { distance($0.transform.position, location) > cutoffDistance }
        meshAnchors.sort { distance($0.transform.position, location) < distance($1.transform.position, location) }
        
        // Perform the search asynchronously in order not to stall rendering.
        /**
         Every three vertices in the mesh form a triangle, called a face.
         ARKit assigns a classification for each face, so the sample searches through the mesh for a face near the intersection point.
         If the face has a classification, this app displays it on screen.
         Because this routine involves extensive processing, the sample does the work asynchronously, so the renderer does not stall.
         */
        DispatchQueue.global().async {
            for anchor: ARMeshAnchor in meshAnchors {
                /**
                 ARMeshAnchor:
                 An anchor for a physical object that ARKit detects and recreates virtually using a polygonal mesh.
                 
                 anchor.geometry
                 ARMeshGeometry:
                 3D information about the mesh such as its shape and classifications.
                 
                 ARMeshAnchor 提供了世界坐标系中的位置，而 ARMeshGeometry 提供了该位置上的网格数据。
                 */
                print("anchor.geometry.faces.count = ", anchor.geometry.faces.count)
                for index in 0..<anchor.geometry.faces.count {
                    // Get the center of the face so that we can compare it to the given location.
                    // anchor.geometry: ARMeshGeometry - Geometry of the mesh in anchor's coordinate system.
                    let geometricCenterOfFace = anchor.geometry.centerOf(faceWithIndex: index)
                    
                    // Convert the face's center to world coordinates.
                    // 构造局部变换矩阵
                    var centerLocalTransform = matrix_identity_float4x4
                    /**
                     将几何中心点 (x, y, z) 放入矩阵的第四列（对应平移分量）。
                     这样，centerLocalTransform 就成为了一个表示该点位置的变换矩阵。
                     */
                    centerLocalTransform.columns.3 = SIMD4<Float>(geometricCenterOfFace.0,
                                                                  geometricCenterOfFace.1,
                                                                  geometricCenterOfFace.2, 1)
                    /**
                     anchor.transform: A matrix encoding the position, orientation, and scale of the anchor relative to the world coordinate space of the AR session the anchor is placed in.
                     
                     World coordinate space in ARKit always follows a right-handed convention
                     
                     在计算机图形学和 AR 应用中，变换矩阵的相乘 是一种核心操作，用于将一个点或对象从一个坐标系转换到另一个坐标系。
                     
                     变换矩阵的含义：
                     局部变换矩阵 (centerLocalTransform)：描述一个点（如几何中心）在局部坐标系中的位置和变换。
                     世界变换矩阵 (anchor.transform)：描述一个对象的局部坐标系相对于世界坐标系的变换关系。
                     
                     矩阵乘法规则：
                     矩阵乘法是将变换的结果逐步累积的过程。
                     如果你希望将一个局部坐标的点转换到世界坐标系，需要先应用对象的局部变换，再应用该对象到世界的变换。
                     
                     anchor.transform：
                     定义了局部坐标系（如 ARMeshAnchor 的坐标系）相对于世界坐标系的变换。
                     包括旋转、缩放和平移。
                     
                     相乘的结果：
                     当 anchor.transform 左乘 centerLocalTransform 时，相当于将局部变换矩阵的结果嵌入世界坐标系。
                     
                     worldTransform=anchor.transform×centerLocalTransform
                     这个新的矩阵描述了几何中心点相对于世界坐标系的位置。
                     
                     anchor.transform * centerLocalTransform 的本质是坐标系变换的叠加。
                     它将几何中心点从局部坐标系转换到世界坐标系。
                     
                     ###
                     各个矩阵的意义:
                     
                     ##anchor.transform 是用来将局部坐标系转换到世界坐标系的矩阵##
                     
                     anchor.transform:
                     这是锚点（anchor）的世界变换矩阵。
                     描述了 anchor 的局部坐标系如何映射到世界坐标系，包括旋转、缩放和平移信息。
                     
                     centerLocalTransform:
                     这是几何中心点在 anchor 的局部坐标系中的变换矩阵。
                     描述了中心点相对于 anchor 局部坐标系原点的位置（通常是一个平移矩阵）。
                     
                     worldTransform:
                     是几何中心点的世界变换矩阵。
                     描述了几何中心点如何从世界坐标系原点变换到几何中心点的位置。
                     
                     ###
                     */
                    let centerWorldPosition = (anchor.transform * centerLocalTransform).position
                    
                    /**
                     We're interested in a classification that is sufficiently close to the given location––within 5 cm.
                     */
                    let distanceToFace = distance(centerWorldPosition, location)
                    if distanceToFace <= 0.05 {
                        // Get the semantic classification of the face and finish the search.
                        let classification: ARMeshClassification = anchor.geometry.classificationOf(faceWithIndex: index)
                        completionBlock(centerWorldPosition, classification)
                        return
                    }
                }
            }
            
            completionBlock(nil, .none)
        }
    }
    
    /**
     ModelEntity:
     A representation of a physical object that RealityKit renders and optionally simulates.
     
     AnchorEntity:
     
     在 RealityKit 中，AnchorEntity 和 ModelEntity 是两个核心的类，但它们的作用和用途不同，主要体现在功能性和层级关系上:
     AnchorEntity 是一种特殊的实体，用于固定到 AR 场景中的一个特定位置。它通常作为其他实体（如 ModelEntity）的父实体。
     负责将一组实体“锚定”到 AR 空间中的某个位置或跟随某些现实世界的物理特性
     特点：
     提供锚定功能，将其附加到特定的位置或跟随 ARKit 提供的锚点（如平面、图像、物体等）。
     用于建立场景中的根节点，为子实体提供一个参考框架。
     自身不具备可见性（不会直接显示），它是一个逻辑实体。
     
     锚定到世界坐标系中的特定位置
     let anchor = AnchorEntity(world: SIMD3<Float>(0, 0, -1))  // 距相机 1 米远

     
     ModelEntity 是一个可见的实体，用于在 AR 空间中渲染 3D 模型。
     表示实际的 3D 对象，负责显示、渲染以及与用户交互
     特点：
     继承自 Entity，并增加了 3D 模型的特性。
     包含 MeshResource（3D 模型的网格）和 Material（材质信息）来定义其外观。
     可以具有物理行为（HasPhysics）、碰撞体（HasCollision）等。
     可以作为子实体添加到 AnchorEntity 或其他 Entity 中。
     */
    func model(for classification: ARMeshClassification) -> ModelEntity {
        /*
        AnchorEntity
        ModelEntity
         */
        
        // Return cached model if available
        if let model = modelsForClassification[classification] {
            model.transform = .identity
            return model.clone(recursive: true)
        }
        
        // Generate 3D text for the classification
        let lineHeight: CGFloat = 0.05
        let font = MeshResource.Font.systemFont(ofSize: lineHeight)
        let textMesh = MeshResource.generateText(classification.description,
                                                 extrusionDepth: Float(lineHeight * 0.1),
                                                 font: font)
        let textMaterial = SimpleMaterial(color: classification.color, isMetallic: true)
        let model = ModelEntity(mesh: textMesh, materials: [textMaterial])
        /**
         Move text geometry to the left so that its local origin is in the center
         
         返回模型的可视边界（visual bounds），是一个包含模型在 3D 空间中边界范围的对象
         默认情况下，生成的文字模型的局部原点（local origin）通常位于左下角或其他非中心位置（这由字体的绘制规则决定）。
         
         Quartz 2D 坐标系遵循传统的数学坐标系规则，原点在左下角，y 轴向上。
         UIKit 专为 iOS 设计，考虑到用户交互的直观性，采用了左上角为原点、y 轴向下增长的布局方式，符合人们习惯的书写顺序（从左到右，从上到下）
         */
        model.position.x -= model.visualBounds(relativeTo: nil).extents.x / 2
        
        // Add model to cache
        modelsForClassification[classification] = model
        return model
    }
    
}

@available(iOS 13.4, *)
extension Visualizing_InteractingWithReconstructedSceneViewController: ARSessionDelegate {
    /*
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        print(#function)
        
    }
     */
    
    func session(_ session: ARSession, didFailWithError error: any Error) {
        guard error is ARError else { return }
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        DispatchQueue.main.async {
            // Present an alert informing about the error that has occurred.
            let alertController = UIAlertController(title: "The AR session failed.",
                                                    message: errorMessage,
                                                    preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
                self.resetDidClicked(self)
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}


@available(iOS 13.4, *)
extension Visualizing_InteractingWithReconstructedSceneViewController: ARCoachingOverlayViewDelegate {
    
    func setupCoachingOverlay() {
        coachingOverlay.session = arView.session
        coachingOverlay.delegate = self
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
    }
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        hideMeshButton.isHidden = true
        resetButton.isHidden = true
        planeDetectionButton.isHidden = true
    }

    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        hideMeshButton.isHidden = false
        resetButton.isHidden = false
        planeDetectionButton.isHidden = false
    }

    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        resetDidClicked(self)
    }
}


// MARK: - extension (Utility)

extension Scene {
    // Add an anchor and remove it from the scene after the specified number of seconds.
    func addAnchor(_ anchor: HasAnchoring, removeAfter seconds: TimeInterval) {
        /**
         public class ModelEntity : Entity, HasModel, HasPhysics
         
         let box = ModelEntity(mesh: .generateBox(size: 0.1))

         // 添加碰撞体
         box.generateCollisionShapes(recursive: true)

         // 添加物理主体并设置为动态
         box.physicsBody = PhysicsBodyComponent()
         box.physicsBody?.mode = .dynamic

         // 将模型添加到场景
         anchorEntity.addChild(box)
         arView.scene.addAnchor(anchorEntity)
         */
        guard let model = anchor.children.first as? HasPhysics else { return }
        
        
        /**
         collision: 碰撞体
         physicsBody: 物理主体
         
         碰撞体和物理主体是实现物理模拟和交互的两个关键概念。它们分别负责检测碰撞和控制物理行为。
         
         碰撞体是一个用来定义模型物理边界的形状，用于检测对象之间的碰撞和交互。
         物理主体控制模型在场景中的物理行为，例如运动、旋转、碰撞和力的作用。
         */
        // Set up model to participate in physics simulation
        if model.collision == nil {
            model.generateCollisionShapes(recursive: true)
            model.physicsBody = .init()
        }
        
        // but prevent it from being affected by simulation forces for now.
        model.physicsBody?.mode = .kinematic
        
        addAnchor(anchor)
        
        // Making the physics body dynamic at this time will let the model be affected by forces.
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { (timer) in
            model.physicsBody?.mode = .dynamic
        }
        Timer.scheduledTimer(withTimeInterval: seconds + 3, repeats: false) { (timer) in
            self.removeAnchor(anchor)
        }
    }
}

extension simd_float4x4 {
    var position: SIMD3<Float> {
        return SIMD3<Float>(columns.3.x, columns.3.y, columns.3.z)
    }
}

/**
 官方文档:
 extension ARMeshGeometry {
     func vertexIndicesOf(faceWithIndex index: Int) -> [Int] {
         let indicesPerFace = faces.indexCountPerPrimitive
         let facesPointer = faces.buffer.contents()
         var vertexIndices = [Int]()
         for offset in 0..<indicesPerFace {
             let vertexIndexAddress = facesPointer.advanced(by: (index * indicesPerFace + offset) * MemoryLayout<UInt32>.size)
             vertexIndices.append(Int(vertexIndexAddress.assumingMemoryBound(to: UInt32.self).pointee))
         }
         return vertexIndices
     }
 }
 */
@available(iOS 13.4, *)
extension ARMeshGeometry {
    
    /**
     ARMeshGeometry:
     A three-dimensional shape that represents the geometry of a mesh.
     
     
     ARGeometryElement:
     A container for index data, ###such as vertex indices of a face.###
     
     A container for index data describing how vertices connect to define a geometry.
     
     
     ARGeometrySource:
     Mesh data in a buffer-based array.
     */
    
    // MARK: - getting the vertices of a particular face
    func vertexIndicesOf(faceWithIndex faceIndex: Int) -> [UInt32] {
        assert(faces.bytesPerIndex == MemoryLayout<UInt32>.size, "Expected one UInt32 (four bytes) per vertex index")
        /**
         faces:
         An object that contains a buffer of vertex indices of the geometry's faces.
         */
        let vertexCountPerFace = faces.indexCountPerPrimitive// The number of indices for each primitive.
        let vertexIndicesPointer = faces.buffer.contents()
        var vertexIndices = [UInt32]()
        vertexIndices.reserveCapacity(vertexCountPerFace)
        for vertexOffset in 0..<vertexCountPerFace {
            let vertexIndexPointer = vertexIndicesPointer.advanced(by: (faceIndex * vertexCountPerFace + vertexOffset) * MemoryLayout<UInt32>.size)
            vertexIndices.append(vertexIndexPointer.assumingMemoryBound(to: UInt32.self).pointee)
        }
        return vertexIndices
    }
    
    func verticesOf(faceWithIndex index: Int) -> [(Float, Float, Float)] {
        let vertexIndices = vertexIndicesOf(faceWithIndex: index)
        let vertices = vertexIndices.map { vertex(at: $0) }
        return vertices
    }
    
    func vertex(at index: UInt32) -> (Float, Float, Float) {
        assert(vertices.format == MTLVertexFormat.float3, "Expected three floats (twelve bytes) per vertex.")
        
        let vertexPointer = vertices.buffer.contents().advanced(by: vertices.offset + (vertices.stride * Int(index)))
        let vertex = vertexPointer.assumingMemoryBound(to: (Float, Float, Float).self).pointee
        return vertex
    }
    
    /**
     ARMeshGeometry 中的顶点坐标是相对于网格的本地坐标系定义的。
     */
    func centerOf(faceWithIndex index: Int) -> (Float, Float, Float) {
        let vertices = verticesOf(faceWithIndex: index)
        let sum = vertices.reduce((0, 0, 0)) { ($0.0 + $1.0, $0.1 + $1.1, $0.2 + $1.2) }
        let geometricCenter = (sum.0 / 3, sum.1 / 3, sum.2 / 3)
        return geometricCenter
    }
    
    /**
     To get the mesh's classification, the sample app parses the classification's raw data and instantiates an `ARMeshClassification` object.
     For efficiency, ARKit stores classifications in a Metal buffer in `ARMeshGeometry`.
     */
    func classificationOf(faceWithIndex index: Int) -> ARMeshClassification {
        guard let classification = classification else { return .none }
        
        assert(classification.format == MTLVertexFormat.uchar,
               "Expected one unsigned char (one byte) per classification")
        
        let classificationPointer = classification.buffer.contents().advanced(by: classification.offset + (classification.stride * index))
        let classificationValue = Int(classificationPointer.assumingMemoryBound(to: CUnsignedChar.self).pointee)
        return ARMeshClassification(rawValue: classificationValue) ?? .none
    }
}

extension Transform {
    static func * (left: Transform, right: Transform) -> Transform {
        return Transform(matrix: simd_mul(left.matrix, right.matrix))
    }
}

@available(iOS 13.4, *)
extension ARMeshClassification {
    var description: String {
        switch self {
        case .ceiling: return "Ceiling"
        case .door: return "Door"
        case .floor: return "Floor"
        case .seat: return "Seat"
        case .table: return "Table"
        case .wall: return "Wall"
        case .window: return "Window"
        case .none: return "None"
        @unknown default: return "Unknown"
        }
    }
    
    var color: UIColor {
        switch self {
        case .ceiling: return .cyan
        case .door: return .brown
        case .floor: return .red
        case .seat: return .purple
        case .table: return .yellow
        case .wall: return .green
        case .window: return .blue
        case .none: return .lightGray
        @unknown default: return .gray
        }
    }
}
