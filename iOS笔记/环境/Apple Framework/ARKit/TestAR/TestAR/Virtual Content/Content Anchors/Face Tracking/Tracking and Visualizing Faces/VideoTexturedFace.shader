
/*
 SceneKit shader (geometry) modifier for texture mapping ARKit camera video onto the face.
 
 这段 Shader 代码的主要目的是进行坐标变换，确保摄像头图像的纹理正确地映射到 ARKit 捕捉到的面部几何体上。
*/


/*
#pragma arguments
用于声明着色器中接受的参数（或变量）的预处理指令。这些参数可以在实际运行时通过代码传递给着色器，以便在渲染过程中使用。
*/
#pragma arguments
float4x4 displayTransform; // from ARFrame.displayTransform(for:viewportSize:)

// Transform the vertex to the camera coordinate system.
float4 vertexCamera = scn_node.modelViewTransform * _geometry.position;

// Camera projection and perspective divide to get normalized viewport coordinates (clip space).
float4 vertexClipSpace = scn_frame.projectionTransform * vertexCamera;
vertexClipSpace /= vertexClipSpace.w;

// XY in clip space is [-1,1]x[-1,1], so adjust to UV texture coordinates: [0,1]x[0,1].
// U 和 V 通常是 [0,1] 范围内的值，用于映射纹理图像。UV坐标的原点通常是在左下角
float4 vertexImageSpace = float4(vertexClipSpace.xy * 0.5 + 0.5, 0.0, 1.0);
// Image coordinates are Y-flipped (upper-left origin).
/*
假设：在标准坐标系中，原点 (0, 0) 通常位于左上角，Y坐标增加方向是向下的。
对于一个标准图像的坐标系，图像的右下角通常对应 (1, 1)，左上角对应 (0, 0)。
进行 Y-flipped：
当我们进行 Y-flipped 处理时，原点通常会保持在 左下角，Y坐标的值 会反转。
这样，原始坐标系中的 (1, 1) 点会变成 (1, 0)，而原始的 (0, 0) 点则会变为 (0, 1)。
*/
vertexImageSpace.y = 1.0 - vertexImageSpace.y;

// Apply ARKit's display transform (device orientation * front-facing camera flip).
float4 transformedVertex = displayTransform * vertexImageSpace;

// kSCNTexcoordCount 在默认情况下，它通常为 1，但有时候可以有多个纹理坐标集。
// Output as texture coordinates for use in later rendering stages.
_geometry.texcoords[0] = transformedVertex.xy;

/**
 * MARK: Post-process special effects
 */
// Make head appear big. (You could also apply other geometry modifications here.)
_geometry.position.xyz *= 1.5;
