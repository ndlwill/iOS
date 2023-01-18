//
//  main31.cpp
//  TestOpenGL
//
//  Created by youdun on 2022/11/29.
//

// 目前，我们的光源是静止的，你可以尝试使用sin或cos函数让光源在场景中来回移动。
/**
 int main()
 {
     [...]
     // render loop
     while(!glfwWindowShouldClose(window))
     {
         // per-frame time logic
         float currentFrame = glfwGetTime();
         deltaTime = currentFrame - lastFrame;
         lastFrame = currentFrame;

         // input
         processInput(window);

         // clear the colorbuffer
         glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
         glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

         // change the light's position values over time (can be done anywhere in the render loop actually, but try to do it at least before using the light source positions)
         lightPos.x = 1.0f + sin(glfwGetTime()) * 2.0f;
         lightPos.y = sin(glfwGetTime() / 2.0f) * 1.0f;
         
         // set uniforms, draw objects
         [...]
         
         // glfw: swap buffers and poll IO events
         glfwSwapBuffers(window);
         glfwPollEvents();
     }
 }

 */
