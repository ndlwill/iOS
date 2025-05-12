//
//  AppDelegate.swift
//  TestAR
//
//  Created by youdun on 2023/8/11.
//

import UIKit
import ARKit

// MARK: - 矩阵
/**
 矩阵的转置:
 矩阵的转置是指将矩阵的行和列对调，形成一个新的矩阵。
 矩阵 A 的转置矩阵为 A'或A(T)
 二次转置：对矩阵做两次转置，结果是原矩阵
 加法保持性：两个矩阵相加后再转置，与先分别转置后相加的结果相同
 乘法逆序：矩阵乘法的转置是其逆序矩阵的转置之积
 对称矩阵：如果矩阵 A=A(T) 则 A 是一个对称矩阵。
 
 
 齐次坐标（Homogeneous Coordinates）:
 齐次坐标（Homogeneous Coordinates）是扩展了传统坐标系统的一种表示方法，广泛用于计算机图形学、几何变换、图像处理等领域
 它的主要特点是通过引入一个额外的维度（通常是一个额外的坐标分量）来表示坐标点，从而简化了数学变换和计算。
 在二维空间中，传统的 笛卡尔坐标 使用 (x, y) 来表示点的位置。通过齐次坐标，我们引入一个额外的维度，表示为 (x, y, w)，其中 w 是额外的分量。
 在使用笛卡尔坐标时，某些几何变换（如平移）不能通过简单的矩阵乘法表示。
 而齐次坐标通过引入额外的维度，使得平移变换也能通过矩阵乘法统一处理。这样，旋转、缩放、平移等变换都可以用同一种形式表示。
 2D 齐次坐标
 在二维空间中，齐次坐标的形式为 (x, y, w)。通过归一化，w 可以让我们轻松地恢复到传统的笛卡尔坐标。
 转换为笛卡尔坐标： (x', y') = (x/w, y/w)
 恢复为齐次坐标：笛卡尔坐标 (x, y) 可以通过给定一个 w = 1 恢复成齐次坐标 (x, y, 1)。
 3D 齐次坐标
 在三维空间中，齐次坐标的形式为 (x, y, z, w)。同样，w 控制着坐标的归一化。
 转换为笛卡尔坐标： (x', y', z') = (x/w, y/w, z/w)
 恢复为齐次坐标：笛卡尔坐标 (x, y, z) 可以通过给定一个 w = 1 恢复成齐次坐标 (x, y, z, 1)。
 */


// MARK: - Normalized Device Coordinates (NDC) 和 Normalized Viewport Coordinates
/**
 Normalized Device Coordinates (NDC) 和 Normalized Viewport Coordinates 通常是等价的概念，它们都表示一种归一化的坐标空间。

 NDC 是从 Clip space 坐标空间转换来的，通常在渲染管线的投影阶段之后。在这个空间中：
 X 和 Y 坐标 范围通常是 [-1, 1]，表示裁剪空间的水平和垂直坐标。
 Z 坐标 通常是 [0, 1]，表示深度信息，经过透视除法后的结果。

 Normalized Viewport Coordinates
 Normalized viewport coordinates 是将 NDC 转换到特定屏幕或视口的坐标系统。
 它将 NDC 中的 [-1, 1] 范围映射到屏幕的 [0, 1] 范围，表示最终的显示位置：
 X 和 Y 坐标 映射到视口的像素坐标（从 [-1, 1] 转换到 [0, 1]）。
 Z 坐标 也会被映射到相应的深度范围 [0, 1]。
 */



// MARK: - ARConfiguration
/**
 class ARConfiguration : NSObject
 The base object that contains information about how to configure an augmented reality session.
 iOS 11.0+
 */

// MARK: - ARWorldTrackingConfiguration
/**
 class ARWorldTrackingConfiguration : ARConfiguration
 A configuration that tracks the position of a device in relation to objects in the environment.
 iOS 11.0+
 
 The ARWorldTrackingConfiguration class tracks the device's movement with six degrees of freedom (6DOF):
 the three rotation axes (roll, pitch, and yaw), and three translation axes (movement in x, y, and z).

 World-tracking sessions also provide several ways for your app to recognize or interact with elements of the real-world scene visible to the camera:
 Find real-world horizontal or vertical surfaces with planeDetection. Add the surfaces to the session as ARPlaneAnchor objects.

 Recognize and track the movement of 2D images with detectionImages. Add 2D images to the scene as ARImageAnchor objects.

 Recognize 3D objects with detectionObjects. Add 3D objects to the scene as ARObjectAnchor objects.

 Find the 3D positions of real-world features that correspond to a touch point on the device's screen with ray casting.
 */

// MARK: - ARAnchor
/**
 class ARAnchor : NSObject
 An object that specifies the position and orientation of an item in the physical environment.
 iOS 11.0+
 
 To track the static positions and orientations of real or virtual objects relative to the camera,
 create anchor objects and use the add(anchor:) method to add them to your AR session.

 Tip:
 Adding an anchor to the session helps ARKit to optimize world-tracking accuracy in the area around that anchor,
 so that virtual objects appear to stay in place relative to the real world.
 If a virtual object moves, remove the corresponding anchor from the old position and add one at the new position.
 
 Some ARKit features automatically add special anchors to a session.
 World-tracking sessions can add ARPlaneAnchor, ARObjectAnchor, and ARImageAnchor objects if you enable the corresponding features;
 face-tracking sessions add ARFaceAnchor objects.
 
 
 Ensure that your anchor classes behave correctly when ARKit updates frames or saves and loads anchors in an ARWorldMap:
 Anchor subclasses must fullfill the requirements of the ARAnchorCopying protocol. ARKit calls init(anchor:) (on a background thread) to copy instances of your anchor class from each ARFrame to the next. Your implementation of this initializer should copy the values of any custom properties your subclass adds.

 Anchor subclasses must also adopt the NSSecureCoding protocol. Override encode(with:) and init(coder:) to save and restore the values your subclass' custom properties when ARKit saves and loads them in a world map.
 
 Anchors are considered equal based on their identifier property.

 Only anchors that do not adopt ARTrackable are included when you save a world map.
 */

// MARK: - ARPlaneAnchor
/**
 class ARPlaneAnchor : ARAnchor
 An anchor for a 2D planar surface that ARKit detects in the physical environment.
 iOS 11.0+
 
 When you enable planeDetection in a world tracking session, ARKit notifies your app of all the surfaces it observes using the device's back camera.
 ARKit calls your delegate's session(_:didAdd:) with an ARPlaneAnchor for each unique surface.
 Each plane anchor provides details about the surface, like its real-world position and shape.
 
 The width and length of a plane (the planeExtent) span the xz-plane of an ARPlaneAnchor instance's local coordinate system.
 The y-axis of the plane anchor is the plane’s normal vector.
 
 
 ARKit offers two ways to track the area of an estimated plane.
 A plane anchor’s geometry describes a convex polygon tightly enclosing all points that ARKit currently estimates to be part of the same plane (easily visualized using ARSCNPlaneGeometry).
 ARKit also provides a simpler estimate in a plane anchor’s extent and center, which together describe a rectangular boundary (easily visualized using SCNPlane).
 */


// MARK: - ARFrame
/**
 class ARFrame : NSObject
 A video image captured as part of a session with position-tracking information.
 iOS 11.0+
 
 A running session continuously captures video frames from the device's camera while ARKit analyzes the captures to determine the user's position in the world.
 ARKit can provide this information to you in the form of an ARFrame in two ways:
 Occasionally, by accessing an ARSession object's currentFrame
 Constantly, as a stream of frames through the session(_:didUpdate:) callback
 
 To automatically receive all frames as ARKit captures them, make one of your objects the delegate of your app's ARSession.

 Each frame can contain additional data, for example, EXIF (exifData), or data based on any particular frameSemantics that you enable.
 */


// MARK: - Vision
/**
 https://www.kodeco.com/32611432-vision-framework-tutorial-for-ios-contour-detection
 
 https://www.jianshu.com/p/cb7177c3e77c
 */

// MARK: - extent
/**
 "extent" 是指代物体在局部空间中的包围盒或边界框。
 它表示了物体在三维空间中的最小和最大范围，通常用于优化渲染和碰撞检测等操作。

 Extent 包含了物体的最小和最大坐标，这些坐标分别表示物体在三维空间中的最左下后角和最右上前角。
 通过计算 extent，你可以大致确定物体所占用的空间区域，从而帮助优化场景渲染和其他计算操作的性能。
 */

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - https://developer.apple.com/documentation/arkit
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
                """)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


// MARK: - SceneKit
/**
 https://developer.apple.com/documentation/scenekit/scenekit_3d_data_types
 
 Important:
 In macOS 10.13, iOS 11, tvOS 11, and watchOS 4 (or later), use data types provided by the system SIMD library (such as float3 and float4x4) and the corresponding SceneKit methods (such as simdPosition and simdTransform) instead.
 These types provide faster performance, offer more concise C, C++, and Swift syntax (such as + and * operators instead of functions), and interoperate better with other technologies (such as Model I/O, GameplayKit, and the Metal Shading Language).
 */

// MARK: - SCNNode
/**
 class SCNNode : NSObject
 A structural element of a scene graph, representing a position and transform in a 3D coordinate space, to which you can attach geometry, lights, cameras, or other displayable content.
 iOS 8.0+
 
 An SCNNode object by itself has no visible content when the scene containing it is rendered—it represents only a coordinate space transform (position, orientation, and scale) relative to its parent node.
 To construct a scene, you use a hierarchy of nodes to create its structure, then add lights, cameras, and geometry to nodes to create visible content.
 
 
 ==========Nodes Determine the Structure of a Scene:
 You may create a node hierarchy programmatically using SceneKit, load one from a file created using 3D authoring tools, or combine the two approaches.
 SceneKit provides many utilities for organizing and searching the scene graph—for details, see the methods in Managing the Node Hierarchy and Searching the Node Hierarchy.
 
 The rootNode object in a scene defines the coordinate system of the world rendered by SceneKit.
 Each child node you add to this root node creates its own coordinate system, which is in turn inherited by its own children.
 You determine the transformation between coordinate systems using the node’s position, rotation, and scale properties properties (or directly using its transform property).
 
 

 var rootNode: SCNNode { get }
 All scene content—nodes, geometries and their materials, lights, cameras, and related objects—is organized in a node hierarchy with a single common root node.

 Some scene files created using external tools may describe node hierarchies containing multiple root nodes.
 When SceneKit imports such files, their separate root nodes will be made children of a new, unique root node.

 Each child node’s coordinate system is defined relative to the transformation of its parent node.
 You should not modify the transform property of the root node.
 
 
 
 var position: SCNVector3 { get set }
 The translation applied to the node. Animatable.
 iOS 8.0+
 The node’s position locates it within the coordinate system of its parent, as modified by the node’s pivot property.
 The default position is the zero vector, indicating that the node is placed at the origin of the parent node’s coordinate system.
 
 
 
 var rotation: SCNVector4 { get set }
 The node’s orientation, expressed as a rotation angle about an axis. Animatable.
 iOS 8.0+
 The four-component rotation vector specifies the direction of the rotation axis in the first three components and the angle of rotation (in radians) in the fourth.
 The default rotation is the zero vector, specifying no rotation.
 Rotation is applied relative to the node’s pivot property.
 The rotation, eulerAngles, and orientation properties all affect the rotational aspect of the node’s transform property.
 Any change to one of these properties is reflected in the others.
 
 
 
 var scale: SCNVector3 { get set }
 The scale factor applied to the node. Animatable.
 iOS 8.0+
 Each component of the scale vector multiplies the corresponding dimension of the node’s geometry.
 The default scale is 1.0 in all three dimensions.
 For example, applying a scale of (2.0, 0.5, 2.0) to a node containing a cube geometry reduces its height and increases its width and depth.
 Scaling is applied relative to the node’s pivot property.
 
 
 
 var transform: SCNMatrix4 { get set }
 The transform applied to the node relative to its parent. Animatable.
 iOS 8.0+
 The transformation is the combination of the node’s rotation, position, and scale properties.
 The default transformation is SCNMatrix4Identity.
 
 When you set the value of this property, the node’s rotation, orientation, eulerAngles, position, and scale properties automatically change to match the new transform, and vice versa.
 SceneKit can perform this conversion only if the transform you provide is a combination of rotation, translation, and scale operations.
 If you set the value of this property to a skew transformation or to a nonaffine transformation, the values of these properties become undefined.
 Setting a new value for any of these properties causes SceneKit to compute a new transformation, discarding any skew or nonaffine operations in the original transformation.


 
 var pivot: SCNMatrix4 { get set }
 The pivot point for the node’s position, rotation, and scale. Animatable.
 iOS 8.0+
 A node’s pivot is the transformation between its coordinate space and that used by its position, rotation, and scale properties.
 The default pivot is SCNMatrix4Identity, specifying that the node’s position locates the origin of its coordinate system, its rotation is about an axis through its center, and its scale is also relative to that center point.
 
 Changing the pivot transform alters these behaviors in many useful ways. You can:
 Offset the node’s contents relative to its position.
 For example, by setting the pivot to a translation transform you can position a node containing a sphere geometry relative to where the sphere would rest on a floor instead of relative to its center.
 
 Move the node’s axis of rotation.
 For example, with a translation transform you can cause a node to revolve around a faraway point instead of rotating around its center, and with a rotation transform you can tilt the axis of rotation.
 
 Adjust the center point and direction for scaling the node.
 For example, with a translation transform you can cause a node to grow or shrink relative to a corner instead of to its center.
 
 
 
 ==========A Node’s Attachments Define Visual Content and Behavior:
 The node hierarchy determines the spatial and logical structure of a scene, but not its visible contents.
 You add 2D and 3D objects to a scene by attaching SCNGeometry objects to nodes.
 (Geometries, in turn, have attached SCNMaterial objects that determine their appearance.)To shade the geometries in a scene with light and shadow effects, add nodes with attached SCNLight objects.
 To control the viewpoint from which the scene appears when rendered, add nodes with attached SCNCamera objects.
 
 To add physics-based behaviors and special effects to SceneKit content, use other types of node attachments.
 For example, an SCNPhysicsBody object defines a node’s characteristics for physics simulation, and an SCNPhysicsField object applies forces to physics bodies in an area around the node.
 An SCNParticleSystem object attached to a node renders particle effects such as fire, rain, or falling leaves in the space defined by a node.
 
 To improve performance, SceneKit can share attachments between multiple nodes.
 For example, in a racing game that includes many identical cars, the scene graph would contain many nodes—one to position and animate each car—but all car nodes would reference the same geometry object.
 */

// MARK: - 几何
// MARK: - SCNGeometry
/**
 class SCNGeometry : NSObject
 A three-dimensional shape (also called a model or mesh) that can be displayed in a scene, with attached materials that define its appearance.
 iOS 8.0+
 
 In SceneKit, geometries attached to SCNNode objects form the visible elements of a scene, and SCNMaterial objects attached to a geometry determine its appearance.
 
 Working with Geometry Objects
 You control a geometry’s appearance in a scene with nodes and materials.
 A geometry object provides only the form of a visible object rendered by SceneKit.
 You specify color and texture for a geometry’s surface, control how it responds to light, and add special effects by attaching materials (for details, see the methods in Managing a Geometry’s Materials).
 You position and orient a geometry in a scene by attaching it to an SCNNode object.
 Multiple nodes can reference the same geometry object, allowing it to appear at different positions in a scene.
 */

// MARK: - SCNGeometryElement
/**
 class SCNGeometryElement : NSObject
 A container for index data describing how vertices connect to define a three-dimensional object, or geometry.
 iOS 8.0+
 
 When SceneKit renders a geometry, each geometry element corresponds to a drawing command sent to the GPU.
 Because different rendering states require separate drawing commands, you can define a geometry using multiple geometry elements.
 For example, the teapot geometry shown below has four geometry elements, so you can assign up to four SCNMaterial objects in order to render each element with a different appearance.
 But because each drawing command incurs a CPU time overhead when rendering, minimizing the number of elements in a custom geometry can improve rendering performance.
 */


// MARK: - SCNGeometrySource
/**
 class SCNGeometrySource : NSObject
 A container for vertex data forming part of the definition for a three-dimensional object, or geometry.
 iOS 8.0+
 
 You use geometry sources together with SCNGeometryElement objects to define custom SCNGeometry objects or to inspect the data that composes an existing geometry.
 
 ///
 You create a custom geometry using a three-step process:
 Create one or more SCNGeometrySource objects containing vertex data.
 Each geometry source defines an attribute, or semantic, of the vertices it describes.
 You must provide at least one geometry source, using the vertex semantic, to create a custom geometry; typically you also provide geometry sources for surface normals and texture coordinates.

 Create at least one SCNGeometryElement object, containing an array of indices identifying vertices in the geometry sources and describing the drawing primitive that SceneKit uses to connect the vertices when rendering the geometry.

 Create an SCNGeometry instance from the geometry sources and geometry elements.
 ///

 Interleaving Vertex Data:
 you can achieve better rendering performance for custom geometries by interleaving the vertex data for multiple semantics in the same array.
 
 typedef struct {
     float x, y, z;    // position
     float nx, ny, nz; // normal
     float s, t;       // texture coordinates
 } MyVertex;
  
 MyVertex vertices[VERTEX_COUNT] = { /* ... vertex data ... */ };
 NSData *data = [NSData dataWithBytes:vertices length:sizeof(vertices)];
 SCNGeometrySource *vertexSource, *normalSource, *tcoordSource;
  
 vertexSource = [SCNGeometrySource geometrySourceWithData:data
                                                 semantic:SCNGeometrySourceSemanticVertex
                                              vectorCount:VERTEX_COUNT
                                          floatComponents:YES
                                      componentsPerVector:3 // x, y, z
                                        bytesPerComponent:sizeof(float)
                                               dataOffset:offsetof(MyVertex, x)
                                               dataStride:sizeof(MyVertex)];
  
 normalSource = [SCNGeometrySource geometrySourceWithData:data
                                                 semantic:SCNGeometrySourceSemanticNormal
                                              vectorCount:VERTEX_COUNT
                                          floatComponents:YES
                                      componentsPerVector:3 // nx, ny, nz
                                        bytesPerComponent:sizeof(float)
                                               dataOffset:offsetof(MyVertex, nx)
                                               dataStride:sizeof(MyVertex)];
  
 tcoordSource = [SCNGeometrySource geometrySourceWithData:data
                                                 semantic:SCNGeometrySourceSemanticTexcoord
                                              vectorCount:VERTEX_COUNT
                                          floatComponents:YES
                                      componentsPerVector:2 // s, t
                                        bytesPerComponent:sizeof(float)
                                               dataOffset:offsetof(MyVertex, s)
                                               dataStride:sizeof(MyVertex)];
 */


// MARK: - 材质
// MARK: - SCNMaterial
/**
 class SCNMaterial : NSObject
 A set of shading attributes that define the appearance of a geometry's surface when rendered.
 iOS 8.0+
 
 When you create a material, you define a collection of visual attributes and their options, which you can then reuse for multiple geometries in a scene.
 
 A material has several visual properties, each of which defines a different part of SceneKit’s lighting and shading process.
 Each visual property is an instance of the SCNMaterialProperty class that provides a solid color, texture, or other 2D content for that aspect of SceneKit’s rendering.
 The material’s lightingModel property then determines the formula SceneKit uses to combine the visual properties with the lights in the scene to produce the final color for each pixel in the rendered scene.
 For more details on the rendering process, see SCNMaterial.LightingModel.

 You attach one or more materials to an instance of the SCNGeometry class using its firstMaterial or materials property.
 Multiple geometries can reference the same material. In this case, changing the attributes of the material changes the appearance of every geometry that uses it.
 
 
 var lightingModel: SCNMaterial.LightingModel { get set }
 The lighting formula that SceneKit uses to render the material.
 SceneKit provides several different lighting models, each of which combines information from a material’s visual properties with the lights and other contents of a scene.
 For details on how each lighting model affects rendering, see Lighting Models.
 For details on the contribution from each visual property, see Visual Properties for Special Effects.
 */

// MARK: - SCNMaterialProperty
/**
 class SCNMaterialProperty : NSObject
 A container for the color or texture of one of a material’s visual properties.
 iOS 8.0+
 
 A material has several visual properties that together determine its appearance under lighting and shading.
 SceneKit renders each pixel in the scene by combining the information from material properties with the locations, intensities, and colors of lights.
 
 A material property’s contents can be either a color, which provides a uniform effect across the surface of a material, or a texture, which SceneKit maps across the surface of a material using texture coordinates provided by the geometry object the material is attached to.
 A texture, in turn, can come from any of several sources, such as an image object, a URL to an image file, a specially formatted image or set of images for use as a cube map, or even animated content provided by Core Animation, SpriteKit, or AVFoundation—for the full set of options, see the contents property.

 Note:
 Typically, you associate texture images with materials when creating 3D assets with third-party authoring tools, and the scene files containing those assets reference external image files.
 For best results when shipping assets in your app bundle, place scene files in a folder with the .scnassets extension, and place image files referenced as textures from those scenes in an Asset Catalog.

 Xcode then optimizes the scene and texture resources for best performance on each target device, and prepares your texture resources for delivery features such as App Thinning and On-Demand Resources.
 
 SceneKit uses the material property’s contents object in different ways for each visual property of a material. For example:
 When you provide a color for the diffuse property, it determines the material’s base color—geometries using the material appear shaded in gradations of this color when illuminated by white light.
 If you instead provide an image, SceneKit maps the image across the geometry’s surface instead of shading with a uniform base color.
 
 When you provide a color for the specular property, it affects the color of light reflected directly toward the viewer from the surface of a geometry using the material.
 If you instead provide a grayscale image, it determines the tendency of the material to reflect light directly toward the viewer—lighter pixels in the image make those areas of the material appear more shiny, and darker pixels make the material appear more matte.
 
 The normal property specifies the orientation of a surface at each point.
 Materials are uniformly smooth by default, so specifying a color for this property has no useful effect.
 Instead, you can specify an image for this property that describes the contours of the surface.
 SceneKit uses this image (called a normal map) in lighting, creating the illusion of a complex, bumpy surface without increasing the complexity of the geometry.
 
 
 SceneKit also uses SCNMaterialProperty objects elsewhere:
 To provide content to be rendered behind a scene, in the background property of an SCNScene object,

 To affect the color and shape of illumination from a light source, in the gobo property of an SCNLight object.

 To bind texture samplers to custom GLSL shader source code snippets, in classes conforming to the SCNShadable protocol.
 */

// MARK: - SCNMaterial.LightingModel
/**
 struct LightingModel
 Constants specifying the lighting and shading algorithm to use for rendering a material.
 iOS 10.0+
 */

/**
 粗糙的物体表面向各个方向等强度地反射光，这种等同地向各个方向散射的现象称为光的漫反射(diffuse reflection)。
 产生光的漫反射现象的物体表面称为理想漫反射体，也称为朗伯(Lambert)反射体。
 
 环境光来自各个方向，因此会同等地增强所有几何图形的亮度。
 */

// MARK: - SCNTechnique
/**
 class SCNTechnique : NSObject
 A specification for augmenting or postprocessing SceneKit's rendering of a scene using additional drawing passes with custom Metal or OpenGL shaders.
 iOS 8.0+
 
 For example, custom symbols defined in the technique with a type of vec3, with a type of float3 in the shader, use a SCNVector3 value when bound.
 Reference the table on the SCNShadable page of the documentation to identify corresponding types between GLSL, Metal, and Swift.
 
 Examples of multipass rendering techniques include:
 1. Postprocessing rendered pixels. To create effects such as color grading and displacement mapping, define techniques that use as input the color buffer rendered by SceneKit and process that buffer with a fragment shader.

 2. Deferred shading. To create effects such as motion blur and screen-space ambient occlusion (SSAO), define techniques that capture information about the scene into an intermediary buffer during the main rendering pass and then perform additional drawing passes using that buffer to create the final output image.
 
 To create an SCNTechnique object, you supply a technique definition that specifies the input and output image buffers, shader programs, shader input variables, and rendering options for each drawing pass in the technique.
 Defining a technique does not require Metal or OpenGL client code, but you should be familiar with the terminology and conventions of GPU rendering.
 To use a technique, assign it to the technique property of a view (or other SceneKit renderer object) or a camera.
 
 Defining a Technique:
 https://developer.apple.com/documentation/scenekit/scntechnique
 */



// MARK: - SCNShadable
/**
 https://developer.apple.com/documentation/scenekit/scnshadable
 */

// MARK: - Multipass rendering techniques
/**
 "Multipass rendering techniques"（多通道渲染技术）指的是在图形渲染中使用多个渲染通道（pass）来完成最终图像的生成。
 这种技术通常用于实现复杂的视觉效果。每个渲染通道可以处理图像的一部分，最终将这些部分组合起来形成最终的输出。
 
 主要特点:
 分阶段处理：在多通道渲染中，渲染过程被分为多个阶段，每个阶段负责处理场景的一部分（如光照、阴影、纹理、特效等）。
 中间结果存储：每个通道的输出通常存储在帧缓冲区中，以便后续通道可以使用这些结果。
 效果丰富：通过这种方法，可以实现更复杂的效果，比如反射、折射、阴影、后处理特效等，单通道渲染可能难以实现。
 
 例子:
 光照通道：先计算光源对场景的影响。
 阴影通道：单独计算阴影，然后将其合成到主图像中。
 后处理通道：在最后的输出上应用特效，如模糊、色彩校正等。
 */

// OpenGLES
// https://fangshufeng.github.io/opengl-es-ios-book/chapter4/section4.1.html
