//
//  main8.cpp
//  TestOpenGL
//
//  Created by youdun on 2022/11/11.
//

// MARK: - 自己的着色器类
/**
 编写、编译、管理着色器是件麻烦事。
 
 #ifndef SHADER_H
 #define SHADER_H

 #include <glad/glad.h>; // 包含glad来获取所有的必须OpenGL头文件

 #include <string>
 #include <fstream>
 #include <sstream>
 #include <iostream>


 class Shader
 {
 public:
     // 程序ID
     unsigned int ID;

     // 构造器读取并构建着色器
     Shader(const char* vertexPath, const char* fragmentPath);
     // 使用/激活程序
     void use();
     // uniform工具函数
     void setBool(const std::string &name, bool value) const;
     void setInt(const std::string &name, int value) const;
     void setFloat(const std::string &name, float value) const;
 };

 #endif
 
 头文件顶部使用了几个预处理指令(Preprocessor Directives)
 这些预处理指令会告知你的编译器只在它没被包含过的情况下才包含和编译这个头文件，即使多个文件都包含了这个着色器头文件。它是用来防止链接冲突的。
 
 从文件读取:
 Shader(const char* vertexPath, const char* fragmentPath)
 {
     // 1. 从文件路径中获取顶点/片段着色器
     std::string vertexCode;
     std::string fragmentCode;
     std::ifstream vShaderFile;
     std::ifstream fShaderFile;
     // 保证ifstream对象可以抛出异常：
     vShaderFile.exceptions (std::ifstream::failbit | std::ifstream::badbit);
     fShaderFile.exceptions (std::ifstream::failbit | std::ifstream::badbit);
     try
     {
         // 打开文件
         vShaderFile.open(vertexPath);
         fShaderFile.open(fragmentPath);
         std::stringstream vShaderStream, fShaderStream;
         // 读取文件的缓冲内容到数据流中
         vShaderStream << vShaderFile.rdbuf();
         fShaderStream << fShaderFile.rdbuf();
         // 关闭文件处理器
         vShaderFile.close();
         fShaderFile.close();
         // 转换数据流到string
         vertexCode   = vShaderStream.str();
         fragmentCode = fShaderStream.str();
     }
     catch(std::ifstream::failure e)
     {
         std::cout << "ERROR::SHADER::FILE_NOT_SUCCESFULLY_READ" << std::endl;
     }
     const char* vShaderCode = vertexCode.c_str();
     const char* fShaderCode = fragmentCode.c_str();
     [...]
 
 下一步，我们需要编译和链接着色器。注意，我们也将检查编译/链接是否失败，如果失败则打印编译时错误，调试的时候这些错误输出会及其重要（你总会需要这些错误日志的）：
 
 // 2. 编译着色器
 unsigned int vertex, fragment;
 int success;
 char infoLog[512];

 // 顶点着色器
 vertex = glCreateShader(GL_VERTEX_SHADER);
 glShaderSource(vertex, 1, &vShaderCode, NULL);
 glCompileShader(vertex);
 // 打印编译错误（如果有的话）
 glGetShaderiv(vertex, GL_COMPILE_STATUS, &success);
 if(!success)
 {
     glGetShaderInfoLog(vertex, 512, NULL, infoLog);
     std::cout << "ERROR::SHADER::VERTEX::COMPILATION_FAILED\n" << infoLog << std::endl;
 };

 // 片段着色器也类似
 [...]

 // 着色器程序
 ID = glCreateProgram();
 glAttachShader(ID, vertex);
 glAttachShader(ID, fragment);
 glLinkProgram(ID);
 // 打印连接错误（如果有的话）
 glGetProgramiv(ID, GL_LINK_STATUS, &success);
 if(!success)
 {
     glGetProgramInfoLog(ID, 512, NULL, infoLog);
     std::cout << "ERROR::SHADER::PROGRAM::LINKING_FAILED\n" << infoLog << std::endl;
 }

 // 删除着色器，它们已经链接到我们的程序中了，已经不再需要了
 glDeleteShader(vertex);
 glDeleteShader(fragment);
 
 use函数非常简单：
 void use()
 {
     glUseProgram(ID);
 }
 
 uniform的setter函数也很类似：
 void setBool(const std::string &name, bool value) const
 {
     glUniform1i(glGetUniformLocation(ID, name.c_str()), (int)value);
 }
 void setInt(const std::string &name, int value) const
 {
     glUniform1i(glGetUniformLocation(ID, name.c_str()), value);
 }
 void setFloat(const std::string &name, float value) const
 {
     glUniform1f(glGetUniformLocation(ID, name.c_str()), value);
 }
 
 现在我们就写完了一个完整的着色器类。使用这个着色器类很简单；只要创建一个着色器对象，从那一点开始我们就可以开始使用了：

 Shader ourShader("path/to/shaders/shader.vs", "path/to/shaders/shader.fs");
 ...
 while(...)
 {
     ourShader.use();
     ourShader.setFloat("someUniform", 1.0f);
     DrawStuff();
 }
 
 我们把顶点和片段着色器储存为两个叫做shader.vs和shader.fs的文件
 */

#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <iostream>

#include "shaders/Shader.h"

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

    // build and compile our shader program
    // ------------------------------------
    Shader ourShader("/Users/youdun-ndl/Desktop/iOS/OpenGL/LearnOpenGL_CN/TestOpenGL/TestOpenGL/shaders/8.shader.vs", "/Users/youdun-ndl/Desktop/iOS/OpenGL/LearnOpenGL_CN/TestOpenGL/TestOpenGL/shaders/8.shader.fs"); // you can name your shader files however you like

    // set up vertex data (and buffer(s)) and configure vertex attributes
    // ------------------------------------------------------------------
    float vertices[] = {
        // positions         // colors
         0.5f, -0.5f, 0.0f,  1.0f, 0.0f, 0.0f,  // bottom right
        -0.5f, -0.5f, 0.0f,  0.0f, 1.0f, 0.0f,  // bottom left
         0.0f,  0.5f, 0.0f,  0.0f, 0.0f, 1.0f   // top
    };

    unsigned int VBO, VAO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    // bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
    glBindVertexArray(VAO);

    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    // position attribute
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    // color attribute
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);

    // You can unbind the VAO afterwards so other VAO calls won't accidentally modify this VAO, but this rarely happens. Modifying other
    // VAOs requires a call to glBindVertexArray anyways so we generally don't unbind VAOs (nor VBOs) when it's not directly necessary.
    // glBindVertexArray(0);


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
        glClear(GL_COLOR_BUFFER_BIT);

        // render the triangle
        ourShader.use();
        glBindVertexArray(VAO);
        glDrawArrays(GL_TRIANGLES, 0, 3);

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
