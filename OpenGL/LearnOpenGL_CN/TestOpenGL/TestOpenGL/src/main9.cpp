//
//  main9.cpp
//  TestOpenGL
//
//  Created by youdun on 2022/11/11.
//

// MARK: - 修改顶点着色器让三角形上下颠倒
/**
 #version 330 core
 layout (location = 0) in vec3 aPos;
 layout (location = 1) in vec3 aColor;

 out vec3 ourColor;

 void main()
 {
     gl_Position = vec4(aPos.x, -aPos.y, aPos.z, 1.0); // just add a - to the y position
     ourColor = aColor;
 }
 */

// MARK: - 使用uniform定义一个水平偏移量，在顶点着色器中使用这个偏移量把三角形移动到屏幕右侧
/**
 // In your CPP file:
 // ======================
 float offset = 0.5f;
 ourShader.setFloat("xOffset", offset);

 // In your vertex shader:
 // ======================
 #version 330 core
 layout (location = 0) in vec3 aPos;
 layout (location = 1) in vec3 aColor;

 out vec3 ourColor;

 uniform float xOffset;

 void main()
 {
     gl_Position = vec4(aPos.x + xOffset, aPos.y, aPos.z, 1.0); // add the xOffset to the x position of the vertex position
     ourColor = aColor;
 }
 */

// MARK: - 使用out关键字把顶点位置输出到片段着色器，并将片段的颜色设置为与顶点位置相等（来看看连顶点位置值都在三角形中被插值的结果）。
/**
 // Vertex shader:
 // ==============
 #version 330 core
 layout (location = 0) in vec3 aPos;
 layout (location = 1) in vec3 aColor;

 // out vec3 ourColor;
 out vec3 ourPosition;

 void main()
 {
     gl_Position = vec4(aPos, 1.0);
     // ourColor = aColor;
     ourPosition = aPos;
 }

 // Fragment shader:
 // ================
 #version 330 core
 out vec4 FragColor;
 // in vec3 ourColor;
 in vec3 ourPosition;

 void main()
 {
     FragColor = vec4(ourPosition, 1.0);    // note how the position value is linearly interpolated to get all the different colors
 }
 */
