//
//  main.cpp
//  TestOpenGL
//
//  Created by ndl on 2019/12/10.
//  Copyright © 2019 ndl. All rights reserved.
//

// MARK: OpenGL编程指南 && OpenGL超级宝典
/**
 OpenGL (Open Graphics Library:)是⼀个跨编程语言、跨平台的编程图形程序接口
 
 OpenGL ES (OpenGL for Embedded Systems):是 OpenGL 三维图形 API 的⼦集，针对手机、 PDA和游戏主机等嵌入式设备而设计，去除了许多不必要和性能较低的API接⼝
 
 Metal: Apple为游戏开发者推出了新的平台技术 Metal，该技术能够为 3D 图 像提⾼ 10 倍的渲染性能.
 Metal 是Apple为了解决3D渲染⽽推出的框架
 
 OpenGL /OpenGL ES/ Metal 在任何项⽬中解决问题的本质 就是利用GPU芯⽚来高效渲染图形图像
 
 MARK: ==OpenGL 上下文(context)
 1.在应⽤程序调⽤任何OpenGL的指令之前，需要安排首先创建一个OpenGL的 上下⽂。这个上下文是⼀个⾮常庞⼤的状态机，保存了OpenGL中的各种状 态，这也是OpenGL指令执行的基础
 2.OpenGL的函数不管在哪个语言中，都是类似C语言一样的⾯面向过程的函 数，本质上都是对OpenGL上下⽂这个庞⼤的状态机中的某个状态或者对象 进⾏操作，当然你得首先把这个对象设置为当前对象。因此，通过对 OpenGL指令的封装，是可以将OpenGL的相关调⽤封装成为一个⾯面向对象的 图形API的
 3.由于OpenGL上下文是一个巨大的状态机，切换上下⽂往会产⽣生较大的开 销，但是不同的绘制模块，可能需要使⽤完全独立的状态管理。因此，可 以在应⽤程序中分别创建多个不同的上下文，在不同线程中使⽤不同的上 下文，上下文之间共享纹理、缓冲区等资源。这样的方案，会⽐反复切换 上下文，或者⼤量修改渲染状态，更加合理高效的
 
 MARK: ==OpenGL 状态机
 状态机描述了一个对象在其生命周期内所经历的各种状态，状态间的 转变，发⽣转变的动因，条件及转变中所执行的活动
 
 OpenGL可以记录⾃己的状态(如当前所使用的颜色、是否开启了混合 功能等)
 
 OpenGL可以接收输入(当调⽤OpenGL函数的时候，实际上可以看成 OpenGL在接收我们的输入)，如我们调⽤glColor3f，则OpenGL接收到 这个输入后会修改⾃己的“当前颜色”这个状态
 
 OpenGL可以进入停⽌状态，不再接收输入。在程序退出前，OpenGL总 会先停⽌工作的
 
 MARK: ==渲染
 将图形/图像数据转换成3D空间图像操作叫做渲染(Rendering)
 
 MARK: ==顶点数组(VertexArray)和顶点缓冲区(VertexBuffer)
 画图⼀般是先画好图像的⻣架，然后再往⻣架⾥面填充颜⾊，这对于 OpenGL也是一样的
 顶点数据就是要画的图像的⻣骨架
 OpenGL中的图像都是由图元组成。在OpenGLES中，有3种类型的图 元:点、线、三角形
 顶点数据之前是存储在内存当中的，被称为顶点数组
 ⽽ 性能更高的做法是，提前分配一块显存，将顶点数据预先传入到显存当 中。这部分的显存，就被称为顶点缓冲区
 数据可以直接 存储在数组中或者将其缓存到GPU内存中
 
 MARK: ==管线
 在OpenGL 下渲染图形,就会有经历⼀个一个节点.而这样的操作可以理解管 线.⼤家可以想象成流⽔线.每个任务类似流水线般执行.任务之间有先后顺序. 之所以称之为管线是因为显卡在处理数据的时候是按照 ⼀个固定的顺序来的，⽽且严格按照这个顺序。就像⽔从⼀根管⼦的一端流到 另一端，这个顺序是不能打破的
 
 MARK: ==固定管线/存储着⾊器
 在早期的OpenGL 版本,它封装了很多种着色器程序块内置的一段包含了光 照、坐标变换、裁剪等诸多功能的固定shader程序来完成,来帮助开发者 来完成图形的渲染. ⽽开发者只需要传入相应的参数,就能快速完成图形的 渲染. 类似于iOS开发会封装很多API,⽽我们只需要调⽤,就可以实现功能.不 需要关注底层实现原理
 
 MARK: ==着⾊器程序Shader
 将固定渲染管线架构变为了可编程渲染管线
 因此，OpenGL在实 际调⽤绘制函数之前，还需要指定⼀个由shader编译成的着⾊器程序
 常见的着⾊器主要有顶点着⾊器(VertexShader)，片段着⾊器 (FragmentShader)/像素着⾊器(PixelShader)，⼏何着⾊器 (GeometryShader)，曲⾯细分着⾊器(TessellationShader)
 片段着⾊色器和像素着⾊器只是在OpenGL和DX中的不同叫法而已
 直到 OpenGLES 3.0，依然只支持了顶点着⾊器和⽚段着⾊器这两个最基础的着⾊器
 
 OpenGL在处理shader时，和其他编译器一样。通过编译、链接等步骤，⽣ 成了着⾊器程序(glProgram)，着⾊器程序同时包含了顶点着⾊器和⽚片段 着⾊器的运算逻辑
 
 在OpenGL进行绘制的时候，⾸先由顶点着⾊器对传⼊的顶点数据进行运算。再通过图元装配，将顶点转换为图元。然后进⾏光 栅化，将图元这种⽮量图形，转换为栅格化数据。最后，将栅格化数据传 ⼊片段着⾊器中进行运算。⽚段着⾊器会对栅格化数据中的每⼀个像素进 ⾏运算，并决定像素的颜⾊
 
 MARK: ==顶点着⾊器VertexShader
 ⽤来处理图形每个顶点变换(旋转/平移/投影等)
 
 顶点着⾊器是OpenGL中⽤于计算顶点属性的程序。顶点着⾊器是逐顶点运 算的程序，也就是说每个顶点数据都会执行⼀次顶点着⾊器，当然这是并 ⾏的，并且顶点着⾊器运算过程中⽆法访问其他顶点的数据
 
 ⼀般来说典型的需要计算的顶点属性主要包括顶点坐标变换、逐顶点光照 运算等。顶点坐标由⾃身坐标系转换到归一化坐标系的运算，就是在这 ⾥发生的
 
 MARK: ==片元着⾊器程序FragmentShader
 用来处理图形中每个像素点颜⾊计算和填充
 片段着⾊器是OpenGL中⽤于计算片段(像素)颜⾊的程序。⽚段着⾊器是 逐像素运算的程序，也就是说每个像素都会执行一次片段着⾊器，当然也 是并行的
 
 MARK: ==GLSL(OpenGL Shading Language)
 OpenGL着⾊色语⾔言(OpenGL Shading Language)是⽤用来在OpenGL中着⾊编程 的语⾔
 也即开发⼈员写的短⼩的⾃定义程序，他们是在图形卡的GPU (Graphic Processor Unit图形处理理单元)上执行的，代替了固定的渲染管 线的⼀部分，使渲染管线中不同层次具有可编程性
 
 ⽐如:视图转换、投 影转换等。GLSL(GL Shading Language)的着⾊器代码分成2个部分: Vertex Shader(顶点着⾊器)和Fragment(⽚断着⾊器)
 
 MARK: == 光栅化Rasterization
 是把顶点数据转换为片元的过程，具有将图转化为⼀个栅格组成的图象 的作用，特点是每个元素对应帧缓冲区中的一像素
 
 光栅化其实是⼀种将⼏何图元变为二维图像的过程。该过程包含了两部分 的⼯作。
 第一部分工作:决定窗⼝坐标中的哪些整型栅格区域被基本图元 占用
 第⼆部分⼯作:分配一个颜色值和⼀个深度值到各个区域。光栅化 过程产⽣的是⽚片元
 
 把物体的数学描述以及与物体相关的颜⾊信息转换为屏幕上用于对应位置 的像素及⽤于填充像素的颜⾊，这个过程称为光栅化，这是一个将模拟信 号转化为离散信号的过程
 
 MARK: ==纹理
 纹理可以理解为图片. ⼤家在渲染图形时需要在其编码填充图⽚,为了使得 场景更加逼真.而这⾥使⽤的图⽚,就是常说的纹理.但是在OpenGL,我们更加 习惯叫纹理,⽽不是图⽚
 
 MARK: ==混合(Blending)
 在测试阶段之后，如果像素依然没有被剔除，那么像素的颜色将会和帧缓 冲区中颜色附着上的颜色进行混合，混合的算法可以通过OpenGL的函数进 行指定
 但是OpenGL提供的混合算法是有限的，如果需要更加复杂的混合 算法，⼀般可以通过像素着⾊器进行实现，当然性能会比原⽣的混合算法 差一些
 
 MARK: ==变换矩阵(Transformation)
 例如图形想发生平移,缩放,旋转变换.就需要使⽤变换矩阵
 
 MARK: ==投影矩阵Projection
 ⽤于将3D坐标转换为二维屏幕坐标,实际线条也将在二维坐标下进行绘制
 
 MARK: ==交换缓冲区(SwapBuffer)
 渲染缓冲区一般映射的是系统的资源⽐如窗口。如果将图像直接渲染到窗口对应的渲染缓冲区，则可以 将图像显示到屏幕上
 
 值得注意的是，如果每个窗⼝只有⼀个缓冲区，那么在绘制过程中屏幕进⾏了刷新，窗⼝可能显 示出不完整的图像
 为了解决这个问题，常规的OpenGL程序⾄至少都会有两个缓冲区。显示在屏幕上的称为屏幕缓冲区，没有 显示的称为离屏缓冲区。在一个缓冲区渲染完成之后，通过将屏幕缓冲区和离屏缓冲区交换，实现图像 在屏幕上的显示
 
 由于显示器的刷新一般是逐⾏进行的，因此为了防止交换缓冲区的时候屏幕上下区域的图像分属于两个 不同的帧，因此交换⼀般会等待显示器刷新完成的信号，在显示器两次刷新的间隔中进行交换，这个信 号就被称为垂直同步信号，这个技术被称为垂直同步
 
 使⽤了双缓冲区和垂直同步技术之后，由于总是要等待缓冲区交换之后再进行下⼀帧的渲染，使得帧率 无法完全达到硬件允许的最⾼水平。为了解决这个问题，引⼊了三缓冲区技术，在等待垂直同步时，来 回交替渲染两个离屏的缓冲区，⽽垂直同步发⽣时，屏幕缓冲区和最近渲染完成的离屏缓冲区交换，实 现充分利利用硬件性能的⽬的
 
 MARK: ==2D笛卡尔坐标系
 MARK: ==3D笛卡尔坐标系
 
 MARK: ==OpenGL 投影方式
 透视投影 Perspective projection(P) Far clip plane > Near clip plane
 正投影 Orthographic projection(O) Far clip plane == Near clip plane
 
 MARK: ==坐标系
 OpenGL 摄像机坐标系
 OpenGL 坐标系(世界坐标系, 惯性坐标系,物体坐标系)
 
 MARK: ==剪切:剪切视⼝之外的 绘制
 
 MARK: ==YYImage解压图⽚
 CGImageRef YYCGImageCreateDecodedCopy(CGImageRef imageRef, BOOL decodeForDisplay) { ...
 if (decodeForDisplay) { // decode with redraw (may lose some precision)
 CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
 BOOL hasAlpha = NO;
 if (alphaInfo == kCGImageAlphaPremultipliedLast ||
 alphaInfo == kCGImageAlphaPremultipliedFirst || alphaInfo == kCGImageAlphaLast ||
 alphaInfo == kCGImageAlphaFirst) {
 hasAlpha = YES;
 }
 // BGRA8888 (premultiplied) or BGRX8888
 // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
 CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
 bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
 CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, YYCGColorSpaceGetDeviceRGB(), bitmapInfo); if (!context) return NULL;
 CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode CGImageRef newImage = CGBitmapContextCreateImage(context); CFRelease(context);
 return newImage; } else {}
 
 MARK: ==attribute属性
 可传递到顶点着色器，不能直接传递到片元着色器，通过glsl代码间接传递
 修饰不断改变的
 传
 颜色数据
 顶点数据
 纹理坐标
 光照法线
 
 MARK: ===uniform
 它是一个通道（通道：传递数据的一种方式）
 可直接传递到片元/顶点着色器
 修饰比较统一的
 旋转：每一个顶点*旋转矩阵
 传
 旋转矩阵
 
 MARK: ==存储着⾊器
 存储着⾊器种类:
 参数1:单元着色器GLT_ATTRIBUTE_VERTEX, 参数2:颜色
 使用场景：绘制默认OpenGL坐标系（-1，1）下的图形，图形所有片段都会以一种颜色填充
 
 参数1:平面着色器GLT_SHADER_FLAT，参数2:允许变化的4*4矩阵（mvp），参数3:颜色
 使用场景：在绘制图形时，可以应用变换（模型/投影变化）
 
 参数1:上色着色器GLT_SHADER_SHADED，参数2:允许变化的4*4矩阵
 使用场景：在绘制图形时，可以应用变换（模型/投影变化） 颜色将会平滑的插入到顶点之间称为平滑颜色
 
 参数1:默认光源着色器GLT_SHADER_DEFAULT_LIGHT，参数2:模型（mv）4*4矩阵，参数3:投影（p）4*4矩阵，参数4:颜色
 使用场景：在绘制图形时，可以应用变换（模型/投影变化） 这种着色器会使绘制的图形产生阴影和光照的效果
 
 参数1:点光源着色器GLT_SHADER_POINT_LIGHT_DIEF，参数2:模型（mv）4*4矩阵，参数3:投影（p）4*4矩阵，参数4:点光源的位置， 参数5:漫反射颜色值
 使用场景：在绘制图形时，可以应用变换（模型/投影变化） 这种着色器会使绘制的图形产生阴影和光照的效果。他与默认光源着色器类似。区别是光源位置可能是特定的
 
 参数1:纹理替换矩阵着色器GLT_SHADER_TEXTURE_REPLACE，参数2:mvp4*4矩阵，参数3:纹理单元
 使用场景：在绘制图形时，可以应用变换（模型/投影变化） 这种着色器通过给定的模型视图投影矩阵。使用纹理单元来进行颜色填充。其中每个像素点的颜色从纹理中获取
 
 参数1:纹理调整着色器GLT_SHADER_TEXTURE_MODULATE，参数2:mvp4*4矩阵，参数3:颜色值，参数4:纹理单元
 使用场景：在绘制图形时，可以应用变换（模型/投影变化） 这种着色器通过给定的模型视图投影矩阵。着色器将一个基本颜色乘以一个取自纹理单元nTextureUnit的纹理。将颜色和纹理进行颜色混合后才填充到片段中
 
 参数1:纹理光源着色器GLT_SHADER_TEXTURE_POINT_LIGHT_DIEF，参数2:模型4*4矩阵，参数3:投影4*4矩阵，参数4:点光源位置，参数5:颜色值，参数6:纹理单元
 使用场景：在绘制图形时，可以应用变换（模型/投影变化） 这种着色器通过给定的模型视图投影矩阵。着色器将一个纹理y通过漫反射照明计算进行调整（相乘）
 
 顶点着⾊器,⽚元着⾊器,细分着⾊器 属于可编程管线下的着⾊器
 
 MARK: ==7种基本图元
 GL_POINTS
 每个顶点在屏幕上都是单独点
 GL_LINES
 每⼀对顶点定义⼀个线段
 GL_LINE_STRIP
 一个从第⼀个顶点依次经过每一个后续顶点⽽绘制的线条
 GL_LINE_LOOP
 和GL_LINE_STRIP相同,但是最后一个顶点和第⼀个顶点连接起来了.
 GL_TRIANGLES
 每3个顶点定义一个新的三⻆形
 GL_TRIANGLE_STRIP
 共⽤一个条带(strip)上的顶点的一组三角形
 GL_TRIANGLE_FAN
 以⼀个圆点为中心呈扇形排列,共⽤相邻顶点的一组三角形
 
 // 在client
 glPointSize(4.0);// 设置点的大小
 glLineWidth(2.5f)// 设置线宽
 // 在server设置点的大小
 着色器内置变量：gl_PointSize
 gl_PointSize = 5.0;
 
 在绘制第一个三⻆形时，线条是按照从V0-V1，再到V2。最后再回到V0的⼀个闭合三角形。 这个是沿着顶点顺时针⽅向。这种 顺序与⽅向结合来指定顶点的⽅式称为环绕
 在默认情况下,OpenGL 认为具有逆时针方向环绕的多边形为正 ⾯
 glFrontFace(GL_CW);
 GL_CW:告诉OpenGL 顺时针环绕的多边形为正⾯
 GL_CCW:告诉OpenGL 逆时针环绕的多边形为正⾯
 
 MARK: --三⻆形带
 1. ⽤用前3个顶点指定第1个三⻆形之后，对于接下来的每⼀个三角形，只需 要再指定1个顶点。需要绘制⼤量的三角形时，采⽤这种方法可以节省⼤量 的程序代码和数据存储空间
 2.提供运算性能和节省带宽。更少的顶点意味着数据从内存传输到图形卡 的速度更快，并且顶点着⾊器需要处理的次数也更少了。
 
 MARK: --渲染过程中可能产生的问题，以及渲染技巧
 在绘制3D场景的时候,我们需要决定哪些部分是对观察者 可见的,或者哪些部分是对观察者不可见的.对于不可见的 部分,应该及早丢弃.例如在一个不透明的墙壁后,就不应该 渲染.这种情况叫做”隐藏⾯消除”(Hidden surface elimination)
 
 解决⽅案: 正背面剔除(Face Culling)
 OpenGL 可以做到检查所有正⾯朝向观察者的面,并渲染它们.从⽽丢弃背面朝向的面. 这样可以 节约片元着色器的性能.
 通过分析顶点数据的顺序
 正面: 按照逆时针顶点连接顺序的三⻆形面
 背面: 按照顺时针顶点连接顺序的三⻆形面
 正面和背⾯是有三⻆形的顶点定义顺序和观察者⽅向共同决定的.随着观察者的⻆度⽅向的改变,正面背⾯也 会跟着改变
 
 MARK: --深度
 深度其实就是该像素点在3D世界中距离摄像机的距离,Z值
 深度缓存区,就是一块内存区域,专⻔存储着每个像素点(绘制在屏幕上的)深度值.深度值(Z值)越⼤, 则离摄像机就越远
 在不使用深度测试的时候,如果我们先绘制一个距离⽐较近的物理,再绘制距离较远的物理,则距离 远的位图因为后绘制,会把距离近的物体覆盖掉. 有了深度缓冲区后,绘制物体的顺序就不那么􏰁重要的. 实际上,只要存在深度缓冲区,OpenGL 都会把像素的深度值写入到缓冲区中. 除非调用 glDepthMask(GL_FALSE).来禁止写入
  
 解决方法: Z-buffer方法(深度缓冲区Depth-buffer)
 深度测试：
 深度缓冲区(DepthBuffer)和颜⾊缓存区(ColorBuffer)是对应的.颜色缓存区存储像素的颜⾊信 息,而深度缓冲区存储像素的深度信息. 在决定是否绘制⼀个物体表⾯时, ⾸先要将表面对应的像 素的深度值与当前深度缓冲区中的值进行比较. 如果⼤于深度缓冲区中的值,则丢弃这部分.否则 利用这个像素对应的深度值和颜色值.分别更新深度缓冲区和颜色缓存区. 这个过程称为”深度测试”
 
 void glDepthMask(GLBool value);
 value : GL_TURE 开启深度缓冲区写入; GL_FALSE 关闭深度缓冲区写⼊
 
 使⽤正⾯/背⾯剔除法和深度测试法来解决渲染效率问题
 
 MARK: --ZFighting 闪烁问题
 对于深度相差非常小的情况下.OpenGL 就可能出现不能正确判断两者的深度值,会导致深度测试的结果不可预测.
 
 启用 Polygon Offset ⽅式解决
 让深度值之间产⽣间隔.如果2个图形之间有间隔,是不是意味着就不会产⽣干涉.可以理 解为在执⾏深度测试前将⽴方体的深度值做⼀些细微的增加.于是就能将􏰁叠的2个图形深度值之 前有所区分.
 
 通过glPolygonOffset 来指定.glPolygonOffset 需要2个参数: factor , units
 每个Fragment 的深度值都会增加如下所示的偏移量:
 Offset = ( m * factor ) + ( r * units);
 只需要将-1.0 和 -1 这样简单赋值给glPolygonOffset 基本可以满⾜需求
 
 1.启⽤Polygon Offset ⽅式 glEnable(GL_POLYGON_OFFSET_FILL)
 2.指定偏移量void glPolygonOffset(Glfloat factor,Glfloat units);
 3.关闭Polygon Offset glDisable(GL_POLYGON_OFFSET_FILL)
 
 ZFighting闪烁问题预防:
 1.不要将两个物体靠的太近，避免渲染时三⻆形叠在一起
 2.尽可能将近裁剪⾯设置得离观察者远一些.尽可能让近裁剪面远一些的话，会使整个裁剪范围内的精确度变⾼⼀些.但是这种⽅式会使 离观察者较近的物体被裁减掉，因此需要调试好裁剪面参数
 3.使⽤更高位数的深度缓冲区，通常使用的深度缓冲区是24位的，现在有一些硬件使⽤32位的缓冲 区，使精确度得到提⾼
 
 MARK: --裁剪
 在OpenGL 中提⾼渲染的⼀种方式.只刷新屏幕上发生变化的部分.OpenGL 允许将要进行渲染的窗口只 去指定一个裁剪框
 基本原理:用于渲染时限制绘制区域，通过此技术可以再屏幕(帧缓冲)指定一个矩形区域。启用剪裁 测试之后，不在此矩形区域内的片元被丢弃，只有在此矩形区域内的片元才有可能进入帧缓冲。因此实 际达到的效果就是在屏幕上开辟了一个⼩窗口，可以再其中进行指定内容的绘制
 
 //1 开启裁剪测试 glEnable(GL_SCISSOR_TEST);
 //2.关闭裁剪测试 glDisable(GL_SCISSOR_TEST);
 //3.指定裁剪窗口
 void glScissor(Glint x,Glint y,GLSize width,GLSize height);
 x,y:指定裁剪框左下角位置; width , height:指定裁剪尺⼨
 
 MARK: --窗⼝,视⼝,裁剪区域
 窗⼝: 就是显示界⾯
 视⼝: 就是窗口中用来显示图形的一块矩形区域，它可以和窗⼝等大，也可以比窗口⼤或者小。只有绘
 制在视口区域中的图形才能被显示，如果图形有一部分超出了视口区域，那么那⼀部分是看不到的。
 通过glViewport()函数设置
 裁剪区域(平行投影):就是视⼝矩形区域的最⼩最大x坐标(left,right)和最小最大y坐标 (bottom,top)，而不是窗⼝的最小最大x坐标和y坐标。通过glOrtho()函数设置，这个函数还需指定最近 最远z坐标，形成一个⽴体的裁剪区域
 
 MARK: --混合
 OpenGL 渲染时会把颜⾊值存在颜色缓存区中，每个⽚段的深度值也是放在深度缓冲区。当深度 缓冲区被关闭时，新的颜⾊将简单的覆盖原来颜色缓存区存在的颜⾊值，当深度缓冲区再次打开时，新 的颜⾊片段只是当它们比原来的值更接近邻近的裁剪平⾯才会替换原来的颜⾊⽚段
 glEnable(GL_BlEND)
 
 ⽬标颜色:已经存储在颜色缓存区的颜色值
 源颜⾊:作为当前渲染命令结果进⼊颜⾊缓存区的颜色值
 当混合功能被启动时，源颜色和⽬标颜⾊的组合方式是混合⽅程式控制的
 
 Cf = (Cs * S) + (Cd * D)
 Cf :最终计算参数的颜色 Cs : 源颜⾊
 Cd :⽬标颜色 S:源混合因子 D:⽬标混合因⼦
 
 设置混合因子，需要用到glBlendFun函数
 glBlendFunc(GLenum S,GLenum D);
 S:源混合因⼦
 D:⽬标混合因⼦
 
 表中R、G、B、A 分别代表 红、绿、蓝、alpha。 表中下标S、D，分别代表源、目标
 表中C 代表常量颜⾊(默认⿊色)
 
 eg:glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
 如果颜色缓存区已经有一种颜⾊红色(1.0f,0.0f,0.0f,0.0f),这个目标颜⾊Cd，如果在这上面用一
 种alpha为0.6的蓝色(0.0f,0.0f,1.0f,0.6f)
 Cd (⽬标颜色) = (1.0f,0.0f,0.0f,0.0f); Cs (源颜色) = (0.0f,0.0f,1.0f,0.6f); S = 源alpha值 = 0.6f
 D = 1 - 源alpha值= 1-0.6f = 0.4f
 ⽅程式Cf = (Cs * S) + (Cd * D)
 等价于 = (Blue * 0.6f) + (Red * 0.4f)
 
 最终颜色是以原先的红色(⽬标颜色)与 后来的蓝色(源颜色)进⾏组合。源颜色的alpha值 越高，添加的蓝色颜色成分越⾼，⽬标颜⾊所保留的成分就会越少
 混合函数经常⽤于实现在其他⼀些不透明的物体前面绘制一个透明物体的效果
 
 默认混合⽅程式:
 Cf = (Cs*S)+(Cd*D)
 可以从5个不同的方程式中进行选择
 选择混合⽅程式的函数:
 glbBlendEquation(GLenum mode);
 
 除了能使用glBlendFunc 来设置混合因子，还可以有更灵活的选择。
 void glBlendFuncSeparate(GLenum strRGB,GLenum dstRGB ,GLenum strAlpha,GLenum dstAlpha);
 strRGB: 源颜色的混合因⼦ dstRGB: 目标颜⾊的混合因⼦ strAlpha: 源颜色的Alpha因⼦ dstAlpha: ⽬标颜⾊的Alpha因⼦
 
 glBlendFunc 指定 源和⽬标 RGBA值的混合函数;但是glBlendFuncSeparate函数则允许为RGB 和 Alpha 成分单独指定混合函数
 在混合因子表中GL_CONSTANT_COLOR,GL_ONE_MINUS_CONSTANT_COLOR,GL_CONSTANT_ALPHA,GL _ONE_MINUS_CONSTANT值允许混合⽅程式中引入一个常量混合颜⾊
 
 常量混合颜色，默认初始化为⿊色(0.0f,0.0f,0.0f,0.0f)，但是还是可以修改这个常量混合颜色。
 void glBlendColor(GLclampf red ,GLclampf green ,GLclampf blue ,GLclampf alpha );
 
 MARK: --矩阵/向量
 3个值(x、y、z)组合起来表示2个重要的值，⽅向和数量
 
 四维向量(x,y,z,w)
 在典型情况下，w 坐标设为1.0。x,y,z值通过除以w，来进行缩放
 
 单位矩阵: (1,0,0,0,1,0,0,0,1)
 
 点乘:返回的是-1，1之间的值,即标量。它代表这个2个向量的余弦值
 float m3dDotProduct3(const M3DVector3f u,const
 M3DVector3f v)
 返回2个向量之间的弧度值
 float m3dGetAngleBetweenVector3(const M3DVector3f
 u,const M3DVector3f v)
 叉乘: ##它不满足交换律##，是有顺序的
 叉乘运算结果返回一个新的向量，这个新的向量与原来的2个向量垂直
 void m3dCrossProduct3(M3DVector3f result,const M3DVector3f
 u ,const M3DVector3f v)
 
 转置矩阵:将行矩阵A的换成同序列列得到的矩阵，叫做A的转换矩阵。计为AT
 矩阵转置，其实就是行列互换
 
 将⼀个向量乘以⼀个单位矩阵得到的结果还是原来的矩阵
 
 仿射变换:
 //Rotate 函数angle参数是传递的度数，而不是弧度
 void MatrixStack::Rotate(GLfloat angle,GLfloat x,GLfloat y,GLfloat z);
 void MatrixStack::Translate(GLfloat x,GLfloat y,GLfloat z);
 void MatrixStack::Scale(GLfloat x,GLfloat y,GLfloat z);
 
 使⽤矩阵堆栈:
 //类型
 GLMatrixStack::GLMatrixStack(int iStackDepth = 64);
 //在堆栈顶部载⼊一个单元矩阵
 void GLMatrixStack::LoadIdentity(void);
 //在堆栈顶部载⼊任何矩阵 //参数:4*4矩阵
 void GLMatrixStack::LoadMatrix(const M3DMatrix44f m);
 //矩阵乘以矩阵堆栈顶部矩阵，相乘结果存储到堆栈的顶部
 void GLMatrixStack::MultMatrix(const M3DMatrix44f);
 
 //获取矩阵堆栈顶部的值 GetMatrix 函数 //为了适应GLShaderMananger的使用，或者获取顶部矩阵的副本
 const M3DMatrix44f & GLMatrixStack::GetMatrix(void);
 void GLMatrixStack::GetMatrix(M3DMatrix44f mMatrix);
 
 压栈.出栈
 //将当前矩阵压入堆栈(栈顶矩阵copy 一份到栈顶)
 void GLMatrixStack::PushMatrix(void);
 //将M3DMatrix44f 矩阵对象压⼊当前矩阵堆栈
 void PushMatrix(const M3DMatrix44f mMatrix);
 //将GLFame 对象压入矩阵对象
 void PushMatrix(GLFame &frame);
 //出栈(出栈指的是移除顶部的矩阵对象)
 void GLMatrixStack::PopMatrix(void);
 
 使⽤照相机(摄像机) 和 ⻆色帧 进行移动
 class GLFrame {
 protected:
 M3DVector3f vOrigin; // Where am I?
 M3DVector3f vForward; // Where am I going?
 M3DVector3f vUp; // Which way is up?
 }
 
 GLFrame
 //将堆栈的顶部压⼊任何矩阵
 void GLMatrixStack::LoadMatrix(GLFrame &frame);
 //矩阵乘以矩阵堆栈顶部的矩阵。相乘结果存储在堆栈的顶部
 void GLMatrixStack::MultMatrix(GLFrame &frame);
 //将当前的矩阵压栈
 void GLMatrixStack::PushMatrix(GLFrame &frame);
 
 照相机管理:
 //GLFrame函数，这个函数⽤来检索条件适合的照相矩阵
 void GetCameraMatrix(M3DMatrix44f m,bool bRotationOnly = flase);
 
 MARK: ==Metal不支持模拟器，OpenGLES支持模拟器（用cpu模拟gpu计算，真机效果好）
 
 MARK: ==纹理
 图像存储空间 = 图像⾼度 * 图像宽度 * 每个像素的字节数
 tga纹理文件，一个字节一个字节排列
 OpenGL纹理文件需要.tga文件
 
 OpenGLES可以使用压缩文件
 .png/jpeg 是压缩文件，需要在屏幕上显示的时候需要解压缩，由cpu来执行
 
 //改变像素存储方式
 void glPixelStorei(GLenum pname,GLint param);
 //恢复像素存储⽅式
 void glPixelStoref(GLenum pname,GLfloat param);
 //参数1:GL_UNPACK_ALIGNMENT 指定OpenGL 如何从数据缓存区中解包图像 数据
 //参数2:表示参数GL_UNPACK_ALIGNMENT 设置的值
 //GL_UNPACK_ALIGNMENT 指内存中每个像素⾏起点的排列请求，允许设置为1 (byte排列)、2(排列为偶数byte的行)、4(字word排列)、8(⾏从双字节 边界开始)
 
 MARK: ==使用纹理的步骤==
 1.##读取文件:##
 从颜⾊缓存区内容作为像素图直接读取
 //参数1:x,矩形左下角的窗口坐标
 //参数2:y,矩形左下角的窗⼝坐标
 //参数3:width,矩形的宽，以像素为单位 //参数4:height,矩形的⾼，以像素为单位
 //参数5:format,OpenGL 的像素格式 参数6:type,解释参数pixels指向的数据，告诉OpenGL 使⽤缓存区中的什么 数据类型来存储颜⾊分量，像素数据的数据类型 //参数7:pixels,指向图形数据的指针
 void glReadPixels(GLint x,GLint y,GLSizei width,GLSizei
 height, GLenum format, GLenum type,const void * pixels)
 
 glReadBuffer(mode);—> 指定读取的缓存
 glWriteBuffer(mode);—> 指定写⼊的缓存
 
 从TGA⽂件中读取像素图
 GLbyte *gltReadTGABits(const char *szFileName, GLint *iWidth, GLint *iHeight, GLint
 *iComponents, GLenum *eFormat);
 参数1: 纹理文件名称
 参数2: 文件宽度地址
 参数3:⽂件⾼度地址
 参数4:文件组件地址
 参数5:⽂件格式地址
 返回值:pBits,指向图像数据的指针
 
 2.##载入纹理##
 void glTexImage1D(GLenum target,GLint level,GLint
      internalformat,GLsizei width,GLint border,GLenum
      format,GLenum type,void *data);
 
 void glTexImage2D(GLenum target,GLint level,GLint
      internalformat,GLsizei width,GLsizei height,GLint
      border,GLenum format,GLenum type,void * data);
 
 void glTexImage3D(GLenum target,GLint level,GLint internalformat,GLSizei width,GLsizei height,GLsizei depth,GLint border,GLenum format,GLenum type,void *data)
 
 target:`GL_TEXTURE_1D`、`GL_TEXTURE_2D`、`GL_TEXTURE_3D`。
 Level:指定所加载的mip贴图层次。一般我们都把这个参数设置为0。
 internalformat:每个纹理单元中存储多少颜⾊成分。
 width、height、depth参数:指加载纹理的宽度、⾼度、深度。
 这些值必须是 2的整数次方。(这是因为OpenGL 旧版本上的遗留下的一个要求。当然现在已经可以支持不是 2的整数次⽅。但是开发者们还是习惯使用以2的整数次⽅去设置这些参数。)
 border参数:允许为纹理贴图指定一个边界宽度。
 format、type、data参数:与glDrawPixels 函数的参数相同
 
 更新纹理
 void glTexSubImage1D(GLenum target,GLint level,GLint xOffset,GLsizei width,GLenum
     format,GLenum type,const GLvoid *data);
 void glTexSubImage2D(GLenum target,GLint level,GLint xOffset,GLint yOffset,GLsizei
     width,GLsizei height,GLenum format,GLenum type,const GLvoid *data);
 void glTexSubImage3D(GLenum target,GLint level,GLint xOffset,GLint yOffset,GLint
     zOffset,GLsizei width,GLsizei height,GLsizei depth,Glenum type,const GLvoid * data)
 
 插⼊替换纹理
 void glCopyTexSubImage1D(GLenum target,GLint level,GLint xoffset,GLint x,GLint y,GLsize
 width);
 void glCopyTexSubImage2D(GLenum target,GLint level,GLint xoffset,GLint yOffset,GLint x,
      y,GLsizei width,GLsizei height);
 void glCopyTexSubImage3D(GLenum target,GLint level,GLint xoffset,GLint yOffset,GLint
      zOffset,GLint x,GLint y,GLsizei width,GLsizei height);
 
 使⽤颜⾊缓存区加载数据,形成新的纹理使用
 void glCopyTexImage1D(GLenum target,GLint level,GLenum
   internalformt,GLint x,GLint y,GLsizei width,GLint border);
 void glCopyTexImage2D(GLenum target,GLint level,GLenum
   internalformt,GLint x,GLint y,GLsizei width,GLsizei
   height,GLint border)
 
 x,y 在颜色缓存区中指定了开始读取纹理数据的位置; 缓存区里的数据，是源缓存区通过glReadBuffer设置的。
 
 3.##纹理对象:##
 //使⽤函数分配纹理对象
 //指定纹理对象的数量 和 指针(指针指向一个无符号整形数组，由纹理对象标识符填充)。
 void glGenTextures(GLsizei n,GLuint * textTures);
 
 //绑定纹理状态 //参数target:GL_TEXTURE_1D、GL_TEXTURE_2D、GL_TEXTURE_3D
 //参数texture:需要绑定的纹理对象
 void glBindTexture(GLenum target,GLunit texture);
 
 //删除绑定纹理对象
 //纹理对象 以及 纹理对象指针(指针指向一个无符号整形数组，由纹理对象标识符填充)。
 void glDeleteTextures(GLsizei n,GLuint *textures); /
 
 /测试纹理对象是否有效
 //如果texture是一个已经分配空间的纹理对象，那么这个函数会返回GL_TRUE,否则会返回GL_FALSE。
 GLboolean glIsTexture(GLuint texture);
 
 MARK: ==设置纹理的相关参数==
 glTexParameterf(GLenum target,GLenum pname,GLFloat param);
 glTexParameteri(GLenum target,GLenum pname,GLint param);
 glTexParameterfv(GLenum target,GLenum pname,GLFloat *param);
 glTexParameteriv(GLenum target,GLenum pname,GLint *param);
 参数1:target,指定这些参数将要应用在那个纹理模式上，⽐比如GL_TEXTURE_1D、GL_TEXTURE_2D、GL_TEXTURE_3D。 参数2:pname,指定需要设置那个纹理参数
 参数3:param,设定特定的纹理参数的值
 
 (1)过滤⽅式
 邻近过滤(GL_NEAREST)
 线性过滤(GL_LINEAR)
  
 glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST) 纹理缩小时,使用邻近过滤
 glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR) 纹理放大时,使⽤线性过滤
 
 glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST); glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
 glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR); glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
 
 (2)设置环绕⽅式
 GL_REPEaT
 GL_MIRRORED_REPEAT
 GL_CLAMP_TO_EDGE
 GL_CLAMP_TO_BORDER
 
 参数1:GL_TEXTURE_1D、GL_TEXTURE_2D、GL_TEXTURE_3D 参数2:GL_TEXTURE_WRAP_S、GL_TEXTURE_T、GL_TEXTURE_R,针对s,t,r坐标 参数3:GL_REPEAT、GL_CLAMP、GL_CLAMP_TO_EDGE、GL_CLAMP_TO_BORDER
 GL_REPEAT:OpenGL 在纹理坐标超过1.0的⽅向上对纹理进⾏重复;
 GL_CLAMP:所需的纹理单元取⾃纹理边界或TEXTURE_BORDER_COLOR. GL_CLAMP_TO_EDGE环绕模式强制对范围之外的纹理坐标沿着合法的纹理单元的最后⼀行或者最后一
 列来进⾏采样。
 GL_CLAMP_TO_BORDER:在纹理坐标在0.0到1.0范围之外的只使⽤边界纹理单元。边界纹理单元是
 作为围绕基本图像的额外的⾏和列，并与基本纹理图像⼀起加载的。
 
 x,y,z,w
 对应
 s,t,r,q
 
 glTextParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAR_S,GL_CLAMP_TO_EDGE); glTextParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAR_T,GL_CLAMP_TO_EDGE);
 
 MARK: ==纹理坐标==
 默认左下角（0，0）右上角（1，1）
 
 MARK: ==Mip 贴图(多层渐远纹理Mipmap)==
 是一种纹理技巧。可以提高渲染性能同时可以改善场景的显示质量
 解决高分辨率纹理浪费内存的问题
 
 mip纹理是由一系列的纹理图像组成，每个图像大小是在每个轴的方向上都缩小一半或者是原来图像像素的总数的四分之一。
 mip贴图每个图像大小都依次减半，直到最后一个图像大小是1*1的纹理单元为止
 
 只有minFilter 等于以下四种模式，才可以生成Mip贴图
 GL_NEAREST_MIPMAP_NEAREST具有非常好的性能，并且闪烁现象非常弱
 GL_LINEAR_MIPMAP_NEAREST常常用于对游戏进行加速，它使用了高质量的线性过滤器
 
 GL_LINEAR_MIPMAP_LINEAR 和GL_NEAREST_MIPMAP_LINEAR 过滤器在Mip层之间执行了一些额外的插值，以消除他们之间的过滤痕迹。
 GL_LINEAR_MIPMAP_LINEAR 三线性Mip贴图。纹理过滤的黄金准则，具有最高的精度。
 
 if(minFilter == GL_LINEAR_MIPMAP_LINEAR ||
    minFilter == GL_LINEAR_MIPMAP_NEAREST ||
    minFilter == GL_NEAREST_MIPMAP_LINEAR ||
    minFilter == GL_NEAREST_MIPMAP_NEAREST)
 //纹理生成所有的Mip层
 //参数：GL_TEXTURE_1D、GL_TEXTURE_2D、GL_TEXTURE_3D
 glGenerateMipmap(GL_TEXTURE_2D);
 
 MARK: ==压缩纹理==
 判断压缩 与 选择压缩⽅式
 GLint comFlag;
 //判断纹理是否被成功压缩
 glGetTexLevelParameteriv(GL_TEXTURE_2D,0,GL_TEXTURE_COMPRESSED,&comFlag);
 
 //根据选择的压缩纹理格式，选择最快、最优、⾃⾏选择的算法⽅式选择压缩格式。
 glHint(GL_TEXTURE_COMPRESSION_HINT,GL_FASTEST);
 glHint(GL_TEXTURE_COMPRESSION_HINT,GL_NICEST);
 glHint(GL_TEXTURE_COMPRESSION_HINT,GL_DONT_CARE);
 
 加载压缩纹理
 void glCompressedTexImage1D(GLenum target,GLint level,GLenum internalFormat,GLsizei
  width,GLint border,GLsizei imageSize,void *data);
 void glCompressedTexImage2D(GLenum target,GLint level,GLenum internalFormat,GLsizei
  width,GLint heigth,GLint border,GLsizei imageSize,void *data);
 void glCompressedTexImage3D(GLenum target,GLint level,GLenum internalFormat,GLsizei
  width,GLsizei heigth,GLsizei depth,GLint border,GLsizei imageSize,void *data);
 
 target:`GL_TEXTURE_1D`、`GL_TEXTURE_2D`、`GL_TEXTURE_3D`。
 Level:指定所加载的mip贴图层次。一般我们都把这个参数设置为0。
 internalformat:每个纹理单元中存储多少颜⾊成分。 width、height、depth参数:指加载纹理的宽度、高度、深度。==注意==这些值必须是2的整数次方。
 border参数:允许为纹理贴图指定⼀个边界宽度。
 format、type、data参数:与glDrawPixels 函数对应的参数相同
 
 MARK: ==3D数学
 列向量
 横向量
 4D向量:x y z w
 
 负向量:
 -[x,y] = [-x, -y]
 
 向量⼤⼩计算公式:
 ||V|| = 根号(v1^2 + v2^2)

 标量与向量的乘法:
 K[a1, a2, a3] = [a1, a2, a3] K = [Ka1, Ka2, Ka3]
 
 标准化向量:V是向量
 Vnorm = V / ||V|| V!=0
 零向量是不能被标准的，数学上是不允许的，因为将导致除0.几何上也没有意义。因为零向量没有⽅向
 
 [a1, a2, a3] + [b1, b2, b3] = [a1+b1, a2+b2, a3+b3]
 
 距离公式:
 (a, b) = ||d|| = 根号(dx^2+dy^2+dz^2)
 */

#include "GLShaderManager.h"
#include "GLTools.h"

//#include <glut/glut.h>
#include <GLUT/GLUT.h>

// 着色管理器
GLShaderManager shaderManager;
// 批次容器
GLBatch triangleBatch;

/*
 在窗口大小改变时，接收新的宽度&高度。
 */
void changeSize(int w, int h)
{
    printf("===========changeSize\n");
    /*
      x,y 参数代表窗口中视图的左下角坐标，而宽度、高度是像素为表示，通常x,y 都是为0
     */
    glViewport(0, 0, w, h);
}

void renderScene(void)
{
    printf("===========renderScene\n");
    // 清除一个或者一组特定的缓存区
    /*
    缓冲区是一块存在图像信息的储存空间，红色、绿色、蓝色和alpha分量通常一起作为颜色缓存区或像素缓存区引用。
    OpenGL 中不止一种缓冲区（颜色缓存区、深度缓存区和模板缓存区）
    清除缓存区对数值进行预置
    参数：指定将要清除的缓存
    GL_COLOR_BUFFER_BIT :指示当前激活的用来进行颜色写入缓冲区
    GL_DEPTH_BUFFER_BIT :指示深度缓存区
    GL_STENCIL_BUFFER_BIT:指示模板缓冲区
    */
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
    
    // 设置一组浮点数来表示红色
    GLfloat vRed[] = {1.0, 0.0, 0.0, 1.0f};
    
    // 传递到存储着色器，即GLT_SHADER_IDENTITY着色器，这个着色器只是使用指定颜色以默认笛卡尔坐标在屏幕上渲染几何图形
    shaderManager.UseStockShader(GLT_SHADER_IDENTITY, vRed);
    
    // 提交着色器
    triangleBatch.Draw();
    /**
     在开始设置openGL 窗口的时候，我们指定要一个双缓冲区的渲染环境。
     这就意味着将在后台缓冲区进行渲染，渲染结束后交换给前台。
     这种方式可以防止观察者看到可能伴随着动画帧与动画帧之间的闪烁的渲染过程。缓冲区交换平台将以平台特定的方式进行。
     */
    glutSwapBuffers();
}

void setupRenderData()
{
    // 设置清屏颜色（背景颜色）
    glClearColor(0.98f, 0.40f, 0.7f, 1);
    
    // 没有着色器，在OpenGL 核心框架中是无法进行任何渲染的。初始化一个渲染管理器。
    // 我们会采用固管线渲染，后面会学着用OpenGL着色语言来写着色器
    shaderManager.InitializeStockShaders();
    
    // 顶点数据
    // 在OpenGL中，三角形是一种基本的3D图元绘图原素。
    GLfloat vVerts[] = {
        -0.5f, 0.0f, 0.0f,
        0.5f, 0.0f, 0.0f,
        0.0f, 0.5f, 0.0f
    };
    
    triangleBatch.Begin(GL_TRIANGLES, 3);
    triangleBatch.CopyVertexData3f(vVerts);
    triangleBatch.End();
}

// MARK: 绘制三角形
int main(int argc, char* argv[])
{
    // argc = 3
    /**
     argv_0 = /Users/ndl/Library/Developer/Xcode/DerivedData/TestOpenGL-cbfwisdnuqjtgyexftvqmkktzbmj/Build/Products/Debug/TestOpenGL.app/Contents/MacOS/TestOpenGL
     argv_1 = -NSDocumentRevisionsDebugMode
     argv_2 = YES
     */
    printf("argc = %d argv_0 = %s\n argv_1 = %s\n argv_2 = %s\n", argc, argv[0], argv[1], argv[2]);
    
    // GLUT代表OpenGL应用工具包，英文全称为OpenGL Utility Toolkit
    // 初始化GLUT库
    glutInit(&argc, argv);
    /**
     GLUT_DOUBLE、GLUT_RGBA、GLUT_DEPTH、GLUT_STENCIL分别指
     双缓冲窗口、RGBA颜色模式、深度测试、模板缓冲区
     
     --GLUT_DOUBLE`：双缓存窗口，是指绘图命令实际上是离屏缓存区执行的，然后迅速转换成窗口视图，这种方式，经常用来生成动画效果；
     --GLUT_DEPTH`：标志将一个深度缓存区分配为显示的一部分，因此我们能够执行深度测试；
     --GLUT_STENCIL`：确保我们也会有一个可用的模板缓存区。
     */
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH | GLUT_STENCIL);
    // GLUT窗口大小、窗口标题
    glutInitWindowSize(800, 600);
    glutCreateWindow("Triangle");
    
    /*
    GLUT 内部运行一个本地消息循环，拦截适当的消息。然后调用我们不同时间注册的回调函数。我们一共注册2个回调函数：
    1）为窗口改变大小而设置的一个回调函数
    2）包含OpenGL 渲染的回调函数
    */
    // 注册重塑函数
    /*
     当屏幕⼤小发生变化/或者第一次创建窗口时,会调用该函数调整窗⼝⼤小/视⼝大小
     */
    glutReshapeFunc(changeSize);
    // 注册显示函数
    /**
     当屏幕发⽣变化/或者开发者主动渲染会调⽤此函数,用来实现数据->渲染过程
     */
    glutDisplayFunc(renderScene);
    
    /*
     初始化一个GLEW库,确保OpenGL API对程序完全可用。
     在试图做任何渲染之前，要检查确定驱动程序的初始化过程中没有任何问题
     */
    GLenum status = glewInit();
    if (GLEW_OK != status) {
        printf("GLEW Error:%s\n", glewGetErrorString(status));
        return 1;
    }
    
    // 设置你需要渲染的图形的相关顶点数据/颜⾊数据等数据装备工作
    setupRenderData();
    printf("===========11\n");
    
    glutMainLoop();
    
    printf("===========00\n");
    
    return 0;
}
