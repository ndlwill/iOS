//
//  main21.cpp
//  TestOpenGL
//
//  Created by youdun on 2022/11/23.
//

// 使用模型矩阵只让是3倍数的箱子旋转（以及第1个箱子），而让剩下的箱子保持静止
/**
 glBindVertexArray(VAO);
 for(unsigned int i = 0; i < 10; i++)
 {
     // calculate the model matrix for each object and pass it to shader before drawing
     glm::mat4 model = glm::mat4(1.0f);
     model = glm::translate(model, cubePositions[i]);
     float angle = 20.0f * i;
     if(i % 3 == 0)  // every 3rd iteration (including the first) we set the angle using GLFW's time function.
         angle = glfwGetTime() * 25.0f;
     model = glm::rotate(model, glm::radians(angle), glm::vec3(1.0f, 0.3f, 0.5f));
     ourShader.setMat4("model", model);
     
     glDrawArrays(GL_TRIANGLES, 0, 36);
 }
 */
