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
 
 OpenGL /OpenGL ES/ Metal 在任何项⽬中解决问题的本质 就是利利用GPU芯⽚来高效渲染图形图像
 
 MARK: ==OpenGL 上下文(context)
 1.在应⽤程序调⽤任何OpenGL的指令之前，需要安排首先创建一个OpenGL的 上下⽂。这个上下文是⼀个⾮常庞⼤的状态机，保存了OpenGL中的各种状 态，这也是OpenGL指令执行的基础
 2.OpenGL的函数不管在哪个语言中，都是类似C语言一样的⾯面向过程的函 数，本质上都是对OpenGL上下⽂这个庞⼤的状态机中的某个状态或者对象 进⾏操作，当然你得首先把这个对象设置为当前对象。因此，通过对 OpenGL指令的封装，是可以将OpenGL的相关调⽤封装成为一个⾯面向对象的 图形API的
 3.由于OpenGL上下文是一个巨大的状态机，切换上下⽂往会产⽣生较大的开 销，但是不同的绘制模块，可能需要使⽤完全独立的状态管理。因此，可 以在应⽤程序中分别创建多个不同的上下文，在不同线程中使⽤不同的上 下文，上下文之间共享纹理、缓冲区等资源。这样的方案，会⽐反复切换 上下文，或者⼤量修改渲染状态，更加合理高效的
 */

#include "GLShaderManager.h"
#include "GLTools.h"

//#include <glut/glut.h>
#include <GLUT/GLUT.h>

int main(int argc, char* argv[])
{
    
    // 初始化GLUT库
    glutInit(&argc, argv);
    return 0;
}
