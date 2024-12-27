//
//  VideoTexturedFace.swift
//  TestAR
//
//  Created by youdun on 2024/12/24.
//

import SceneKit
import ARKit

/**
 Map Camera Video onto 3D Face Geometry:
 
 For additional creative uses of face tracking, you can texture-map the live 2D video feed from the camera onto the 3D geometry that ARKit provides.
 After mapping pixels in the camera video onto the corresponding points on ARKit’s face mesh, you can modify that mesh, creating illusions such as resizing or distorting the user’s face in 3D.
 
 First, create an ARSCNFaceGeometry for the face and assign the camera image to its main material.
 ARSCNView automatically sets the scene’s background material to use the live video feed from the camera, so you can set the geometry to use the same material.
 
 To correctly align the camera image to the face, you’ll also need to modify the texture coordinates that SceneKit uses for rendering the image on the geometry.
 One easy way to perform this mapping is with a SceneKit shader modifier (see the SCNShadable protocol).
 The shader code here applies the coordinate system transformations needed to convert each vertex position in the mesh from 3D scene space to the 2D image space used by the video texture
 
 When you assign a shader code string to the geometry entry point, SceneKit configures its renderer to automatically run that code on the GPU for each vertex in the mesh. This shader code also needs to know the intended orientation for the camera image, so the sample gets that from the ARKit displayTransform(for:viewportSize:) method and passes it to the shader’s displayTransform argument:
 
 Note:
 This example’s shader modifier also applies a constant scale factor to all vertices, causing the user’s face to appear larger than life.
 Try other transformations to distort the face in other ways.
 */
class VideoTexturedFace: TexturedFace {

    override func renderer(_ renderer: any SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let sceneView = renderer as? ARSCNView,
              let frame: ARFrame = sceneView.session.currentFrame,
              anchor is ARFaceAnchor
        else { return nil }
        
#if targetEnvironment(simulator)
        #error("ARKit is not supported in iOS Simulator. Connect a physical iOS device and select it as your Xcode run destination, or select Generic iOS Device as a build-only destination.")
#else
        if let device = sceneView.device {
            // Show video texture as the diffuse material and disable lighting.
            // MARK: - ARSCNFaceGeometry
            /**
             ARSCNFaceGeometry:
             
             This class is a subclass of SCNGeometry that wraps the mesh data provided by the ARFaceGeometry class.
             You can use ARSCNFaceGeometry to quickly and easily visualize face topology and facial expressions provided by ARKit in a SceneKit view.
             
             Important
             ARSCNFaceGeometry is available only in SceneKit views or renderers that use Metal.
             This class is not supported for OpenGL-based SceneKit rendering.
             
             Face mesh topology is constant for the lifetime of an ARSCNFaceGeometry object.
             That is, the geometry's single SCNGeometryElement object always describes the same arrangement of vertices, and the texcoord geometry source always maps the same vertices to the same texture coordinates.
             在ARKit中，每个人脸的基础网格拓扑是相同的，无论面部表情如何变化。
             这意味着网格的顶点数量、三角形面片的数量和它们之间的连接方式不会因为表情改变而发生变化。
             
             一个 ARSCNFaceGeometry 对象内部有一个 SCNGeometryElement，它定义了顶点之间如何组成三角形。
             即使面部表情变化，顶点的具体位置可能会更新（即坐标改变），但这些顶点的连接关系（即哪几个顶点组成一个三角形）始终保持不变。
             texcoord 的映射是固定的：
             texcoord 是纹理坐标，用于将纹理映射到几何表面。
             每个顶点都与纹理上的某个点对应，这种对应关系在对象的生命周期中不会改变。这确保了当面部几何变化时，纹理仍能正确贴合到几何体上。
             
             When you modify the geometry with the update(from:) method, only the contents of the vertex geometry source change, indicating the difference in vertex positions as ARKit adapts the mesh to the shape and expression of the user's face.
             */
            if let faceGeometry = ARSCNFaceGeometry(device: device, fillMesh: true),
               let material: SCNMaterial = faceGeometry.firstMaterial {
                /**
                 var background: SCNMaterialProperty
                 
                 A background to be rendered before the rest of the scene.
                 
                 If the material property’s contents object is nil, SceneKit does not draw any background before drawing the rest of the scene. (If the scene is presented in an SCNView instance, the view’s background color is visible behind the contents of the scene.)
                 
                 If you specify a cube map texture for the material property (see the discussion of the contents property), SceneKit renders the background as a skybox.
                 */
                material.diffuse.contents = sceneView.scene.background.contents
                /**
                 .constant:
                 
                 Uniform shading that incorporates ambient lighting only.
                 This shading model calculates the color of a point on a surface with the following formula:
                 color = ambient * al + diffuse
                 The ambient and diffuse terms refer to the material’s properties. 
                 The al term is the sum of all ambient lights in the scene (a color).
                 */
                material.lightingModel = .constant
                
                /**
                 
                 */
                guard let shaderUrl = Bundle.main.url(forResource: "VideoTexturedFace", withExtension: "shader"),
                      let modifier = try? String(contentsOf: shaderUrl) 
                else { fatalError("Can't load shader modifier from bundle.") }
                /**
                 Shader modifiers can be used to tweak SceneKit rendering by adding custom code at the following entry points:
                     1. vertex   (SCNShaderModifierEntryPointGeometry)
                     2. surface  (SCNShaderModifierEntryPointSurface)
                     3. lighting (SCNShaderModifierEntryPointLightingModel)
                     4. fragment (SCNShaderModifierEntryPointFragment)
                 
                 shader的执行时机：
                 赋值时：立即将着色器代码绑定到 faceGeometry 的渲染管线配置。
                 运行时：在渲染过程的 geometry 阶段，SceneKit 会自动调用你的 shader modifier 代码来处理顶点数据等。
                 */
                faceGeometry.shaderModifiers = [.geometry: modifier]
                
                /**
                 Pass view-appropriate image transform to the shader modifier so that the mapped video lines up correctly with the background video.
                 */
                // MARK: - displayTransform
                /**
                 Returns an affine transform for converting between normalized image coordinates and a coordinate space appropriate for rendering the camera image onscreen.
                 
                 viewportSize:
                 The size, in points, of the view intended for rendering the camera image.
                 
                 Return Value:
                 A transform matrix that converts from normalized image coordinates in the captured image to normalized image coordinates that account for the specified parameters.
                 
                 Normalized image coordinates range from (0,0) in the upper left corner of the image to (1,1) in the lower right corner.
                 
                 This method creates an affine transform representing the rotation and aspect-fit crop operations necessary to adapt the camera image to the specified orientation and to the aspect ratio of the specified viewport. 
                 
                 The affine transform does not scale to the viewport's pixel size.
                 The capturedImage pixel buffer is the original image captured by the device camera, and thus not adjusted for device orientation or view aspect ratio.
                 
                 该方法返回一个仿射变换（CGAffineTransform），
                 用于将摄像头捕获的归一化图像坐标（normalized image coordinates）转换到适合在屏幕上渲染的归一化图像坐标。
                 
                 
                 let orientation = UIApplication.shared.statusBarOrientation
                 let viewportSize = sceneView.bounds.size

                 // 获取仿射变换矩阵
                 let transform = frame.displayTransform(for: orientation, viewportSize: viewportSize)

                 // 使用仿射变换矩阵转换坐标
                 let normalizedPoint = CGPoint(x: 0.5, y: 0.5) // 中心点的归一化坐标
                 let transformedPoint = normalizedPoint.applying(transform)

                 // transformedPoint 是经过旋转和裁剪后的坐标
                 print("Transformed Point: \(transformedPoint)")
                 
                 如果你想获取点在屏幕上的实际像素位置，可以将 transformedPoint 转换到视图像素坐标：
                 let pixelX = transformedPoint.x * viewportSize.width
                 let pixelY = transformedPoint.y * viewportSize.height

                 */
                let affineTransform = frame.displayTransform(for: .portrait, viewportSize: sceneView.bounds.size)
                let transform = SCNMatrix4(affineTransform)
                /**
                 SCNMatrix4Invert:
                 求一个 4x4 矩阵的逆矩阵
                 如果一个矩阵把物体从 A 变换到 B，逆矩阵可以把物体从 B 再变回 A。
                 在渲染过程中，逆矩阵也常用于将点从世界空间变换回局部空间。
                 
                 A⋅A−1=I
                 其中 I 是单位矩阵（Identity Matrix），那么A−1就是A 的逆矩阵。
                 
                 原始的 transform 矩阵是 摄像头图像 -> 屏幕坐标 的变换。
                 SCNMatrix4Invert(transform) 是其逆变换，意味着 屏幕坐标 -> 摄像头图像坐标 的变换。
                 */
                faceGeometry.setValue(SCNMatrix4Invert(transform), forKey: "displayTransform")
                
                contentNode = SCNNode(geometry: faceGeometry)
            }
        }
#endif
        
        return contentNode
    }
}
