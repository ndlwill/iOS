//
//  main22.cpp
//  TestOpenGL
//
//  Created by youdun on 2022/11/23.
//

// MARK: - 摄像机
/**
 OpenGL本身没有摄像机(Camera)的概念，但我们可以通过把场景中的所有物体往相反方向移动的方式来模拟出摄像机，产生一种我们在移动的感觉，而不是场景在移动。
 
 摄像机/观察空间(Camera/View Space)
 当我们讨论摄像机/观察空间(Camera/View Space)的时候，是在讨论以摄像机的视角作为场景原点时场景中所有的顶点坐标
 观察矩阵把所有的世界坐标变换为相对于摄像机位置与方向的观察坐标。
 要定义一个摄像机，我们需要它在世界空间中的位置、观察的方向、一个指向它右侧的向量以及一个指向它上方的向量。
 实际上创建了一个三个单位轴相互垂直的、以摄像机的位置为原点的坐标系。
 
 摄像机位置
 摄像机位置简单来说就是世界空间中一个指向摄像机位置的向量。
 把摄像机位置设置为上一节中的那个相同的位置：
 glm::vec3 cameraPos = glm::vec3(0.0f, 0.0f, 3.0f);
 不要忘记正z轴是从屏幕指向你的，如果我们希望摄像机向后移动，我们就沿着z轴的正方向移动。
 
 摄像机方向
 这里指的是摄像机指向哪个方向。
 让摄像机指向场景原点：(0, 0, 0)。
 果将两个矢量相减，我们就能得到这两个矢量的差吗？用场景原点向量减去摄像机位置向量的结果就是摄像机的指向向量。
 于我们知道摄像机指向z轴负方向，但我们希望方向向量(Direction Vector)指向摄像机的z轴正方向。如果我们交换相减的顺序，我们就会获得一个指向摄像机正z轴方向的向量：
 glm::vec3 cameraTarget = glm::vec3(0.0f, 0.0f, 0.0f);
 glm::vec3 cameraDirection = glm::normalize(cameraPos - cameraTarget);
 方向向量(Direction Vector)并不是最好的名字，因为它实际上指向从它到目标向量的相反方向
 
 右轴
 我们需要的另一个向量是一个右向量(Right Vector)，它代表摄像机空间的x轴的正方向。
 为获取右向量我们需要先使用一个小技巧：先定义一个上向量(Up Vector)。接下来把上向量和上面得到的方向向量进行叉乘
 两个向量叉乘的结果会同时垂直于两向量，因此我们会得到指向x轴正方向的那个向量
 （如果我们交换两个向量叉乘的顺序就会得到相反的指向x轴负方向的向量）：
 glm::vec3 up = glm::vec3(0.0f, 1.0f, 0.0f);
 glm::vec3 cameraRight = glm::normalize(glm::cross(up, cameraDirection));
 
 上轴
 现在我们已经有了x轴向量和z轴向量，获取一个指向摄像机的正y轴向量就相对简单了：我们把右向量和方向向量进行叉乘：
 glm::vec3 cameraUp = glm::cross(cameraDirection, cameraRight);
 
 在线性代数中这个处理叫做格拉姆—施密特正交化(Gram-Schmidt Process)。
 http://en.wikipedia.org/wiki/Gram%E2%80%93Schmidt_process
 使用这些摄像机向量我们就可以创建一个LookAt矩阵了，它在创建摄像机的时候非常有用。
 */

// MARK: - Look At
/**
 使用矩阵的好处之一是如果你使用3个相互垂直（或非线性）的轴定义了一个坐标空间，你可以用这3个轴外加一个平移向量来创建一个矩阵,并且你可以用这个矩阵乘以任何向量来将其变换到那个坐标空间。
 这正是LookAt矩阵所做的，现在我们有了3个相互垂直的轴和一个定义摄像机空间的位置坐标，我们可以创建我们自己的LookAt矩阵了：
            Rx  Ry  Rz   0            1   0   0   -Px
            Ux  Uy  Uz   0            0   1   0   -Py
LookAt =                                     *
            Dx  Dy   Dz   0           0   0   1   -Pz
            0   0       0   1             0   0   0   1
 其中R是右向量，U是上向量，D是方向向量P是摄像机位置向量。
 注意，位置向量是相反的，因为我们最终希望把世界平移到与我们自身移动的相反方向。
 把这个LookAt矩阵作为观察矩阵可以很高效地把所有世界坐标变换到刚刚定义的观察空间。
 LookAt矩阵就像它的名字表达的那样：它会创建一个看着(Look at)给定目标的观察矩阵。
 
 GLM已经提供了这些支持。我们要做的只是定义一个摄像机位置，一个目标位置和一个表示世界空间中的上向量的向量（我们计算右向量使用的那个上向量）。
 接着GLM就会创建一个LookAt矩阵，我们可以把它当作我们的观察矩阵：
 glm::mat4 view;
 view = glm::lookAt(glm::vec3(0.0f, 0.0f, 3.0f),
            glm::vec3(0.0f, 0.0f, 0.0f),
            glm::vec3(0.0f, 1.0f, 0.0f));
 glm::LookAt函数需要一个位置、目标和上向量。它会创建一个和在上一节使用的一样的观察矩阵。
 
 把我们的摄像机在场景中旋转。我们会将摄像机的注视点保持在(0, 0, 0)。
 我们需要用到一点三角学的知识来在每一帧创建一个x和z坐标，它会代表圆上的一点，我们将会使用它作为摄像机的位置。
 通过重新计算x和y坐标，我们会遍历圆上的所有点，这样摄像机就会绕着场景旋转了。我们预先定义这个圆的半径radius，在每次渲染迭代中使用GLFW的glfwGetTime函数重新创建观察矩阵，来扩大这个圆。
 float radius = 10.0f;
 float camX = sin(glfwGetTime()) * radius;
 float camZ = cos(glfwGetTime()) * radius;
 glm::mat4 view;
 view = glm::lookAt(glm::vec3(camX, 0.0, camZ), glm::vec3(0.0, 0.0, 0.0), glm::vec3(0.0, 1.0, 0.0));
 摄像机现在会随着时间流逝围绕场景转动了
 
 自由移动
 我们自己移动摄像机会更有趣！首先我们必须设置一个摄像机系统，所以在我们的程序前面定义一些摄像机变量很有用：

 glm::vec3 cameraPos   = glm::vec3(0.0f, 0.0f,  3.0f);
 glm::vec3 cameraFront = glm::vec3(0.0f, 0.0f, -1.0f);
 glm::vec3 cameraUp    = glm::vec3(0.0f, 1.0f,  0.0f);
 我们首先将摄像机位置设置为之前定义的cameraPos。方向是当前的位置加上我们刚刚定义的方向向量。
 这样能保证无论我们怎么移动，摄像机都会注视着目标方向。
 添加几个需要检查的按键命令：

 void processInput(GLFWwindow *window)
 {
     ...
     float cameraSpeed = 0.05f; // adjust accordingly
     if (glfwGetKey(window, GLFW_KEY_W) == GLFW_PRESS)
         cameraPos += cameraSpeed * cameraFront;
     if (glfwGetKey(window, GLFW_KEY_S) == GLFW_PRESS)
         cameraPos -= cameraSpeed * cameraFront;
     if (glfwGetKey(window, GLFW_KEY_A) == GLFW_PRESS)
         cameraPos -= glm::normalize(glm::cross(cameraFront, cameraUp)) * cameraSpeed;
     if (glfwGetKey(window, GLFW_KEY_D) == GLFW_PRESS)
         cameraPos += glm::normalize(glm::cross(cameraFront, cameraUp)) * cameraSpeed;
 }
 
 当我们按下WASD键的任意一个，摄像机的位置都会相应更新。如果我们希望向前或向后移动，我们就把位置向量加上或减去方向向量。如果我们希望向左右移动，我们使用叉乘来创建一个右向量(Right Vector)，并沿着它相应移动就可以了。这样就创建了使用摄像机时熟悉的横移(Strafe)效果。
 
 注意，我们对右向量进行了标准化。如果我们没对这个向量进行标准化，最后的叉乘结果会根据cameraFront变量返回大小不同的向量。
 如果我们不对向量进行标准化，我们就得根据摄像机的朝向不同加速或减速移动了，但如果进行了标准化移动就是匀速的。
 
 移动速度
 目前我们的移动速度是个常量。理论上没什么问题，但是实际情况下根据处理器的能力不同，有些人可能会比其他人每秒绘制更多帧，也就是以更高的频率调用processInput函数。
 结果就是，根据配置的不同，有些人可能移动很快，而有些人会移动很慢。当你发布你的程序的时候，你必须确保它在所有硬件上移动速度都一样。
 
 图形程序和游戏通常会跟踪一个时间差(Deltatime)变量，它储存了渲染上一帧所用的时间。我们把所有速度都去乘以deltaTime值。
 如果我们的deltaTime很大，就意味着上一帧的渲染花费了更多时间，所以这一帧的速度需要变得更高来平衡渲染所花去的时间。
 使用这种方法时，无论你的电脑快还是慢，摄像机的速度都会相应平衡，这样每个用户的体验就都一样了。
 
 我们跟踪两个全局变量来计算出deltaTime值：

 float deltaTime = 0.0f; // 当前帧与上一帧的时间差
 float lastFrame = 0.0f; // 上一帧的时间
 在每一帧中我们计算出新的deltaTime以备后用。

 float currentFrame = glfwGetTime();
 deltaTime = currentFrame - lastFrame;
 lastFrame = currentFrame;
 
 现在我们有了deltaTime，在计算速度的时候可以将其考虑进去了：

 void processInput(GLFWwindow *window)
 {
   float cameraSpeed = 2.5f * deltaTime;
   ...
 }
 
 视角移动
 为了能够改变视角，我们需要根据鼠标的输入改变cameraFront向量
 欧拉角
 欧拉角(Euler Angle)是可以表示3D空间中任何旋转的3个值
 一共有3种欧拉角：俯仰角(Pitch)、偏航角(Yaw)和滚转角(Roll)
 俯仰角是描述我们如何往上或往下看的角
 偏航角表示我们往左和往右看的程度
 滚转角代表我们如何翻滚摄像机，通常在太空飞船的摄像机中使用
 每个欧拉角都有一个值来表示，把三个角结合起来我们就能够计算3D空间中任何的旋转向量了。
 
 对于我们的摄像机系统来说，我们只关心俯仰角和偏航角，所以我们不会讨论滚转角。
 给定一个俯仰角和偏航角，我们可以把它们转换为一个代表新的方向向量的3D向量。俯仰角和偏航角转换为方向向量的处理需要一些三角学知识
 
 如果我们想象自己在xz平面上，看向y轴
 对于一个给定俯仰角的y值等于sin θ
 direction.y = sin(glm::radians(pitch)); // 注意我们先把角度转为弧度
 direction.x = cos(glm::radians(pitch));
 direction.z = cos(glm::radians(pitch));
 偏航角
 x分量取决于cos(yaw)的值，z值同样取决于偏航角的正弦值
 把这个加到前面的值中，会得到基于俯仰角和偏航角的方向向量：
 direction.x = cos(glm::radians(pitch)) * cos(glm::radians(yaw)); // 译注：direction代表摄像机的前轴(Front)，这个前轴是和第一幅图片的第二个摄像机的方向向量是相反的
 direction.y = sin(glm::radians(pitch));
 direction.z = cos(glm::radians(pitch)) * sin(glm::radians(yaw));
 这样我们就有了一个可以把俯仰角和偏航角转化为用来自由旋转视角的摄像机的3维方向向量了。
 
 鼠标输入
 偏航角和俯仰角是通过鼠标（或手柄）移动获得的，水平的移动影响偏航角，竖直的移动影响俯仰角。
 它的原理就是，储存上一帧鼠标的位置，在当前帧中我们当前计算鼠标位置与上一帧的位置相差多少。如果水平/竖直差别越大那么俯仰角或偏航角就改变越大，也就是摄像机需要移动更多的距离。
 首先我们要告诉GLFW，它应该隐藏光标，并捕捉(Capture)它。
 glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);
 在调用这个函数之后，无论我们怎么去移动鼠标，光标都不会显示了，它也不会离开窗口。对于FPS摄像机系统来说非常完美。
 为了计算俯仰角和偏航角，我们需要让GLFW监听鼠标移动事件。（和键盘输入相似）我们会用一个回调函数来完成，函数的原型如下：
 void mouse_callback(GLFWwindow* window, double xpos, double ypos);
 这里的xpos和ypos代表当前鼠标的位置。当我们用GLFW注册了回调函数之后，鼠标一移动mouse_callback函数就会被调用：
 glfwSetCursorPosCallback(window, mouse_callback);
 在处理FPS风格摄像机的鼠标输入的时候，我们必须在最终获取方向向量之前做下面这几步：
 计算鼠标距上一帧的偏移量。
 把偏移量添加到摄像机的俯仰角和偏航角中。
 对偏航角和俯仰角进行最大和最小值的限制。
 计算方向向量。
 第一步是计算鼠标自上一帧的偏移量。我们必须先在程序中储存上一帧的鼠标位置，我们把它的初始值设置为屏幕的中心（屏幕的尺寸是800x600）：
 float lastX = 400, lastY = 300;
 然后在鼠标的回调函数中我们计算当前帧和上一帧鼠标位置的偏移量：
 float xoffset = xpos - lastX;
 float yoffset = lastY - ypos; // 注意这里是相反的，因为y坐标是从底部往顶部依次增大的
 lastX = xpos;
 lastY = ypos;

 float sensitivity = 0.05f;
 xoffset *= sensitivity;
 yoffset *= sensitivity;
 注意我们把偏移量乘以了sensitivity（灵敏度）值。如果我们忽略这个值，鼠标移动就会太大了.找到适合自己的灵敏度值。
 接下来我们把偏移量加到全局变量pitch和yaw上：
 yaw   += xoffset;
 pitch += yoffset;
 第三步，我们需要给摄像机添加一些限制，这样摄像机就不会发生奇怪的移动了（这样也会避免一些奇怪的问题）。对于俯仰角，要让用户不能看向高于89度的地方（在90度时视角会发生逆转，所以我们把89度作为极限），同样也不允许小于-89度。这样能够保证用户只能看到天空或脚下，但是不能超越这个限制。我们可以在值超过限制的时候将其改为极限值来实现：

 if(pitch > 89.0f)
   pitch =  89.0f;
 if(pitch < -89.0f)
   pitch = -89.0f;
 注意我们没有给偏航角设置限制，这是因为我们不希望限制用户的水平旋转。当然，给偏航角设置限制也很容易
 第四也是最后一步，就是通过俯仰角和偏航角来计算以得到真正的方向向量：
 glm::vec3 front;
 front.x = cos(glm::radians(pitch)) * cos(glm::radians(yaw));
 front.y = sin(glm::radians(pitch));
 front.z = cos(glm::radians(pitch)) * sin(glm::radians(yaw));
 cameraFront = glm::normalize(front);
 计算出来的方向向量就会包含根据鼠标移动计算出来的所有旋转了。
 你会发现在窗口第一次获取焦点的时候摄像机会突然跳一下。这个问题产生的原因是，在你的鼠标移动进窗口的那一刻，鼠标回调函数就会被调用，这时候的xpos和ypos会等于鼠标刚刚进入屏幕的那个位置。这通常是一个距离屏幕中心很远的地方，因而产生一个很大的偏移量，所以就会跳了。
 我们可以简单的使用一个bool变量检验我们是否是第一次获取鼠标输入，如果是，那么我们先把鼠标的初始位置更新为xpos和ypos值，这样就能解决这个问题；接下来的鼠标移动就会使用刚进入的鼠标位置坐标来计算偏移量了：
 if(firstMouse) // 这个bool变量初始时是设定为true的
 {
     lastX = xpos;
     lastY = ypos;
     firstMouse = false;
 }
 最后的代码应该是这样的：
 void mouse_callback(GLFWwindow* window, double xpos, double ypos)
 {
     if(firstMouse)
     {
         lastX = xpos;
         lastY = ypos;
         firstMouse = false;
     }

     float xoffset = xpos - lastX;
     float yoffset = lastY - ypos;
     lastX = xpos;
     lastY = ypos;

     float sensitivity = 0.05;
     xoffset *= sensitivity;
     yoffset *= sensitivity;

     yaw   += xoffset;
     pitch += yoffset;

     if(pitch > 89.0f)
         pitch = 89.0f;
     if(pitch < -89.0f)
         pitch = -89.0f;

     glm::vec3 front;
     front.x = cos(glm::radians(yaw)) * cos(glm::radians(pitch));
     front.y = sin(glm::radians(pitch));
     front.z = sin(glm::radians(yaw)) * cos(glm::radians(pitch));
     cameraFront = glm::normalize(front);
 }
 
 缩放
 作为我们摄像机系统的一个附加内容，我们还会来实现一个缩放(Zoom)接口。
 视野(Field of View)或fov定义了我们可以看到场景中多大的范围。
 当视野变小时，场景投影出来的空间就会减小，产生放大(Zoom In)了的感觉。
 我们会使用鼠标的滚轮来放大。
 鼠标滚轮的回调函数：

 void scroll_callback(GLFWwindow* window, double xoffset, double yoffset)
 {
   if(fov >= 1.0f && fov <= 45.0f)
     fov -= yoffset;
   if(fov <= 1.0f)
     fov = 1.0f;
   if(fov >= 45.0f)
     fov = 45.0f;
 }
 当滚动鼠标滚轮的时候，yoffset值代表我们竖直滚动的大小。当scroll_callback函数被调用后，我们改变全局变量fov变量的内容。因为45.0f是默认的视野值，我们将会把缩放级别(Zoom Level)限制在1.0f到45.0f。
 我们现在在每一帧都必须把透视投影矩阵上传到GPU，但现在使用fov变量作为它的视野：
 projection = glm::perspective(glm::radians(fov), 800.0f / 600.0f, 0.1f, 100.0f);
 注册鼠标滚轮的回调函数：
 glfwSetScrollCallback(window, scroll_callback);
 
 使用欧拉角的摄像机系统并不完美。根据你的视角限制或者是配置，你仍然可能引入万向节死锁问题。最好的摄像机系统是使用四元数(Quaternions)的
 四元数摄像机的实现
 https://github.com/cybercser/OpenGL_3_3_Tutorial_Translation/blob/master/Tutorial%2017%20Rotations.md
 
 摄像机类
 摄像机系统是一个FPS风格的摄像机
 但是在创建不同的摄像机系统，比如飞行模拟摄像机，时就要当心。每个摄像机系统都有自己的优点和不足，所以确保对它们进行了详细研究。比如，这个FPS摄像机不允许俯仰角大于90度，而且我们使用了一个固定的上向量(0, 1, 0)，这在需要考虑滚转角的时候就不能用了。
 #ifndef CAMERA_H
 #define CAMERA_H

 #include <glad/glad.h>
 #include <glm/glm.hpp>
 #include <glm/gtc/matrix_transform.hpp>

 #include <vector>

 // Defines several possible options for camera movement. Used as abstraction to stay away from window-system specific input methods
 enum Camera_Movement {
     FORWARD,
     BACKWARD,
     LEFT,
     RIGHT
 };

 // Default camera values
 const float YAW         = -90.0f;
 const float PITCH       =  0.0f;
 const float SPEED       =  2.5f;
 const float SENSITIVITY =  0.1f;
 const float ZOOM        =  45.0f;


 // An abstract camera class that processes input and calculates the corresponding Euler Angles, Vectors and Matrices for use in OpenGL
 class Camera
 {
 public:
     // camera Attributes
     glm::vec3 Position;
     glm::vec3 Front;
     glm::vec3 Up;
     glm::vec3 Right;
     glm::vec3 WorldUp;
     // euler Angles
     float Yaw;
     float Pitch;
     // camera options
     float MovementSpeed;
     float MouseSensitivity;
     float Zoom;

     // constructor with vectors
     Camera(glm::vec3 position = glm::vec3(0.0f, 0.0f, 0.0f), glm::vec3 up = glm::vec3(0.0f, 1.0f, 0.0f), float yaw = YAW, float pitch = PITCH) : Front(glm::vec3(0.0f, 0.0f, -1.0f)), MovementSpeed(SPEED), MouseSensitivity(SENSITIVITY), Zoom(ZOOM)
     {
         Position = position;
         WorldUp = up;
         Yaw = yaw;
         Pitch = pitch;
         updateCameraVectors();
     }
     // constructor with scalar values
     Camera(float posX, float posY, float posZ, float upX, float upY, float upZ, float yaw, float pitch) : Front(glm::vec3(0.0f, 0.0f, -1.0f)), MovementSpeed(SPEED), MouseSensitivity(SENSITIVITY), Zoom(ZOOM)
     {
         Position = glm::vec3(posX, posY, posZ);
         WorldUp = glm::vec3(upX, upY, upZ);
         Yaw = yaw;
         Pitch = pitch;
         updateCameraVectors();
     }

     // returns the view matrix calculated using Euler Angles and the LookAt Matrix
     glm::mat4 GetViewMatrix()
     {
         return glm::lookAt(Position, Position + Front, Up);
     }

     // processes input received from any keyboard-like input system. Accepts input parameter in the form of camera defined ENUM (to abstract it from windowing systems)
     void ProcessKeyboard(Camera_Movement direction, float deltaTime)
     {
         float velocity = MovementSpeed * deltaTime;
         if (direction == FORWARD)
             Position += Front * velocity;
         if (direction == BACKWARD)
             Position -= Front * velocity;
         if (direction == LEFT)
             Position -= Right * velocity;
         if (direction == RIGHT)
             Position += Right * velocity;
     }

     // processes input received from a mouse input system. Expects the offset value in both the x and y direction.
     void ProcessMouseMovement(float xoffset, float yoffset, GLboolean constrainPitch = true)
     {
         xoffset *= MouseSensitivity;
         yoffset *= MouseSensitivity;

         Yaw   += xoffset;
         Pitch += yoffset;

         // make sure that when pitch is out of bounds, screen doesn't get flipped
         if (constrainPitch)
         {
             if (Pitch > 89.0f)
                 Pitch = 89.0f;
             if (Pitch < -89.0f)
                 Pitch = -89.0f;
         }

         // update Front, Right and Up Vectors using the updated Euler angles
         updateCameraVectors();
     }

     // processes input received from a mouse scroll-wheel event. Only requires input on the vertical wheel-axis
     void ProcessMouseScroll(float yoffset)
     {
         Zoom -= (float)yoffset;
         if (Zoom < 1.0f)
             Zoom = 1.0f;
         if (Zoom > 45.0f)
             Zoom = 45.0f;
     }

 private:
     // calculates the front vector from the Camera's (updated) Euler Angles
     void updateCameraVectors()
     {
         // calculate the new Front vector
         glm::vec3 front;
         front.x = cos(glm::radians(Yaw)) * cos(glm::radians(Pitch));
         front.y = sin(glm::radians(Pitch));
         front.z = sin(glm::radians(Yaw)) * cos(glm::radians(Pitch));
         Front = glm::normalize(front);
         // also re-calculate the Right and Up vector
         Right = glm::normalize(glm::cross(Front, WorldUp));  // normalize the vectors, because their length gets closer to 0 the more you look up or down which results in slower movement.
         Up    = glm::normalize(glm::cross(Right, Front));
     }
 };
 #endif
 */

#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <stb_image/stb_image.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include <utils/shader_m.h>

#include <iostream>

void framebuffer_size_callback(GLFWwindow* window, int width, int height);
void processInput(GLFWwindow *window);

// settings
const unsigned int SCR_WIDTH = 800;
const unsigned int SCR_HEIGHT = 600;

int main()
{
    // glfw: initialize and configure
    // ------------------------------
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

#ifdef __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif

    // glfw window creation
    // --------------------
    GLFWwindow* window = glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, "TestOpenGL", NULL, NULL);
    if (window == NULL)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

    // glad: load all OpenGL function pointers
    // ---------------------------------------
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }

    // configure global opengl state
    // -----------------------------
    glEnable(GL_DEPTH_TEST);

    // build and compile our shader zprogram
    // ------------------------------------
    Shader ourShader("/Users/youdun-ndl/Desktop/iOS/OpenGL/LearnOpenGL_CN/TestOpenGL/TestOpenGL/shaders/18.shader.vs", "/Users/youdun-ndl/Desktop/iOS/OpenGL/LearnOpenGL_CN/TestOpenGL/TestOpenGL/shaders/18.shader.fs");

    // set up vertex data (and buffer(s)) and configure vertex attributes
    // ------------------------------------------------------------------
    float vertices[] = {
        -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,
         0.5f, -0.5f, -0.5f,  1.0f, 0.0f,
         0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
         0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,

        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
         0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
         0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
         0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
        -0.5f,  0.5f,  0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,

        -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,

         0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
         0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
         0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
         0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
         0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
         0.5f,  0.5f,  0.5f,  1.0f, 0.0f,

        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
         0.5f, -0.5f, -0.5f,  1.0f, 1.0f,
         0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
         0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,

        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
         0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
         0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
         0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f,  0.5f,  0.5f,  0.0f, 0.0f,
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f
    };
    // world space positions of our cubes
    glm::vec3 cubePositions[] = {
        glm::vec3( 0.0f,  0.0f,  0.0f),
        glm::vec3( 2.0f,  5.0f, -15.0f),
        glm::vec3(-1.5f, -2.2f, -2.5f),
        glm::vec3(-3.8f, -2.0f, -12.3f),
        glm::vec3 (2.4f, -0.4f, -3.5f),
        glm::vec3(-1.7f,  3.0f, -7.5f),
        glm::vec3( 1.3f, -2.0f, -2.5f),
        glm::vec3( 1.5f,  2.0f, -2.5f),
        glm::vec3( 1.5f,  0.2f, -1.5f),
        glm::vec3(-1.3f,  1.0f, -1.5f)
    };
    unsigned int VBO, VAO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);

    glBindVertexArray(VAO);

    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    // position attribute
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    // texture coord attribute
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);


    // load and create a texture
    // -------------------------
    unsigned int texture1, texture2;
    // texture 1
    // ---------
    glGenTextures(1, &texture1);
    glBindTexture(GL_TEXTURE_2D, texture1);
    // set the texture wrapping parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    // set texture filtering parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // load image, create texture and generate mipmaps
    int width, height, nrChannels;
    stbi_set_flip_vertically_on_load(true); // tell stb_image.h to flip loaded texture's on the y-axis.
    unsigned char *data = stbi_load("/Users/youdun-ndl/Desktop/iOS/OpenGL/LearnOpenGL_CN/TestOpenGL/TestOpenGL/resources/textures/container.jpg", &width, &height, &nrChannels, 0);
    if (data)
    {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, data);
        glGenerateMipmap(GL_TEXTURE_2D);
    }
    else
    {
        std::cout << "Failed to load texture" << std::endl;
    }
    stbi_image_free(data);
    // texture 2
    // ---------
    glGenTextures(1, &texture2);
    glBindTexture(GL_TEXTURE_2D, texture2);
    // set the texture wrapping parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    // set texture filtering parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // load image, create texture and generate mipmaps
    data = stbi_load("/Users/youdun-ndl/Desktop/iOS/OpenGL/LearnOpenGL_CN/TestOpenGL/TestOpenGL/resources/textures/awesomeface.png", &width, &height, &nrChannels, 0);
    if (data)
    {
        // note that the awesomeface.png has transparency and thus an alpha channel, so make sure to tell OpenGL the data type is of GL_RGBA
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
        glGenerateMipmap(GL_TEXTURE_2D);
    }
    else
    {
        std::cout << "Failed to load texture" << std::endl;
    }
    stbi_image_free(data);

    // tell opengl for each sampler to which texture unit it belongs to (only has to be done once)
    // -------------------------------------------------------------------------------------------
    ourShader.use();
    ourShader.setInt("texture1", 0);
    ourShader.setInt("texture2", 1);

    // pass projection matrix to shader (as projection matrix rarely changes there's no need to do this per frame)
    // -----------------------------------------------------------------------------------------------------------
    glm::mat4 projection = glm::perspective(glm::radians(45.0f), (float)SCR_WIDTH / (float)SCR_HEIGHT, 0.1f, 100.0f);
    ourShader.setMat4("projection", projection);


    // render loop
    // -----------
    while (!glfwWindowShouldClose(window))
    {
        // input
        // -----
        processInput(window);

        // render
        // ------
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        // bind textures on corresponding texture units
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, texture1);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, texture2);

        // activate shader
        ourShader.use();

        // camera/view transformation
        glm::mat4 view = glm::mat4(1.0f); // make sure to initialize matrix to identity matrix first
        float radius = 10.0f;
        float camX = static_cast<float>(sin(glfwGetTime()) * radius);
        float camZ = static_cast<float>(cos(glfwGetTime()) * radius);
        view = glm::lookAt(glm::vec3(camX, 0.0f, camZ), glm::vec3(0.0f, 0.0f, 0.0f), glm::vec3(0.0f, 1.0f, 0.0f));
        ourShader.setMat4("view", view);

        // render boxes
        glBindVertexArray(VAO);
        for (unsigned int i = 0; i < 10; i++)
        {
            // calculate the model matrix for each object and pass it to shader before drawing
            glm::mat4 model = glm::mat4(1.0f);
            model = glm::translate(model, cubePositions[i]);
            float angle = 20.0f * i;
            model = glm::rotate(model, glm::radians(angle), glm::vec3(1.0f, 0.3f, 0.5f));
            ourShader.setMat4("model", model);

            glDrawArrays(GL_TRIANGLES, 0, 36);
        }

        // glfw: swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
        // -------------------------------------------------------------------------------
        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    // optional: de-allocate all resources once they've outlived their purpose:
    // ------------------------------------------------------------------------
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);

    // glfw: terminate, clearing all previously allocated GLFW resources.
    // ------------------------------------------------------------------
    glfwTerminate();
    return 0;
}

// process all input: query GLFW whether relevant keys are pressed/released this frame and react accordingly
// ---------------------------------------------------------------------------------------------------------
void processInput(GLFWwindow *window)
{
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
        glfwSetWindowShouldClose(window, true);
}

// glfw: whenever the window size changed (by OS or user resize) this callback function executes
// ---------------------------------------------------------------------------------------------
void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
    // make sure the viewport matches the new window dimensions; note that width and
    // height will be significantly larger than specified on retina displays.
    glViewport(0, 0, width, height);
}
