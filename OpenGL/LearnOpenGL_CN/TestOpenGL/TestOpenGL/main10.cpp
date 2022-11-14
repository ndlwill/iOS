//
//  main10.cpp
//  TestOpenGL
//
//  Created by youdun on 2022/11/11.
//

// MARK: - SOIL
/**
 SOIL是简易OpenGL图像库(Simple OpenGL Image Library)的缩写，它支持大多数流行的图像格式
 http://www.lonesock.net/soil.html
 
 要使用SOIL加载图片，我们需要使用它的SOIL_load_image函数：
 int width, height;
 unsigned char* image = SOIL_load_image("container.jpg", &width, &height, 0, SOIL_LOAD_RGB);
 */

// MARK: - 纹理
/**
 如果想让图形看起来更真实，我们就必须有足够多的顶点，从而指定足够多的颜色。这将会产生很多额外开销，因为每个模型都会需求更多的顶点，每个顶点又需求一个颜色属性。
 程序员更喜欢使用纹理(Texture)。
 纹理是一个2D图片（甚至也有1D和3D的纹理），它可以用来添加物体的细节；你可以想象纹理是一张绘有砖块的纸，无缝折叠贴合到你的3D的房子上，这样你的房子看起来就像有砖墙外表了。
 因为我们可以在一张图片上插入非常多的细节，这样就可以让物体非常精细而不用指定额外的顶点。
 
 除了图像以外，纹理也可以被用来储存大量的数据，这些数据可以发送到着色器上
 
 为了能够把纹理映射(Map)到三角形上，我们需要指定三角形的每个顶点各自对应纹理的哪个部分。这样每个顶点就会关联着一个纹理坐标(Texture Coordinate)，用来标明该从纹理图像的哪个部分采样（译注：采集片段颜色）。
 之后在图形的其它片段上进行片段插值(Fragment Interpolation)。
 */
