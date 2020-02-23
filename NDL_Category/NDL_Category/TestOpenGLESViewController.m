//
//  TestOpenGLESViewController.m
//  NDL_Category
//
//  Created by ndl on 2020/2/22.
//  Copyright © 2020 ndl. All rights reserved.
//

// MARK: ==OpenGLES==
/**
 MARK: ==EGL (Embedded Graphics Library )==
 OpenGL ES 命令需要渲染上下文和绘制表面才能完成图形图像的绘制.
 渲染上下文: 存储相关OpenGL ES 状态.
 绘制表面: 是⽤于绘制图元的表⾯,它指定渲染所需要的缓存区类型,例如颜色缓存 区,深度缓冲区和模板缓存区
 
 OpenGL ES API 并没有提供如何创建渲染上下文或者上下文如何连接到原生窗⼝系 统
 EGL 是Khronos 渲染API(如OpenGL ES) 和原生窗⼝系统之间的接⼝
 唯⼀支持 OpenGL ES 却不⽀持EGL 的平台是iOS. Apple 提供⾃己的EGL API的iOS实现,称为EAGL
 
 因为每个窗⼝系统都有不同的定义,所以EGL提供基本的不透明类型—EGLDisplay,
 这 个类型封装了所有系统相关性,⽤于和原生窗⼝系统接⼝
 
 EGL的主要功能如下:
1. 和本地窗口系统(native windowing system)通讯;
2. 查询可⽤的配置;
3. 创建OpenGL ES可用的“绘图表面”(drawing surface);
4. 同步不同类别的API之间的渲染，⽐如在OpenGL ES和OpenVG之间同步，或者在
OpenGL和本地窗口的绘图命令之间;
5. 管理“渲染资源”，比如纹理映射(rendering map)
 
 OpenGL ES是基于C的API
 作为C API，它与Objective-C Cocoa Touch应⽤程序⽆缝集成。OpenGL ES规范没有定义窗口层
 相反，托管操作系统必须提供函数来创建一个接受命令的OpenGL ES 渲染上下⽂和⼀个帧缓冲区,其中写入任何绘图命令的结果
 在iOS上使⽤OpenGL ES需要使⽤iOS类来设置和呈现绘图表面，并使⽤平台中立的API来呈现其内容
 
 MARK: ==GLKit ==
 GLKView 提供绘制场所(View)
 GLKViewController(扩展于标准的UIKit 设计模式. 用于绘制视图内容的管理与呈现.)
 苹果弃⽤OpenGL ES ,但iOS开发者可以继续使用
 
 MARK: ==GLKit 纹理加载==
 ==GLKTextureInfo 创建OpenGL 纹理信息==
name : OpenGL 上下⽂中纹理名称
target : 纹理绑定的⽬标
height : 加载的纹理高度
width : 加载纹理的宽度
textureOrigin : 加载纹理中的原点位置
alphaState: 加载纹理中alpha分量状态
containsMipmaps: 布尔值,加载的纹理是否包含mip贴图
 
 ==GLTextureLoader 简化从各种资源文件中加载纹理==
 - initWithSharegroup: 初始化一个新的纹理加载到对象中
- initWithShareContext: 初始化⼀个新的纹理加载对象
 
 从⽂件中加载处理:
+ textureWithContentsOfFile:options:errer: 从⽂件加载2D纹理图像并从数据中
创建新的纹理
- textureWithContentsOfFile:options:queue:completionHandler: 从⽂件中异步
加载2D纹理图像,并根据数据创建新纹理
 
 从URL加载纹理:
- textureWithContentsOfURL:options:error: 从URL 加载2D纹理图像并从数据创
建新纹理
- textureWithContentsOfURL:options:queue:completionHandler: 从URL异步
加载2D纹理图像,并根据数据创建新纹理
 
从内存中表示创建纹理:
+ textureWithContentsOfData:options:errer: 从内存空间加载2D纹理图像,并根
据数据创建新纹理
- textureWithContentsOfData:options:queue:completionHandler:从内存空间
异步加载2D纹理图像,并从数据中创建新纹理
 
 从CGImages创建纹理:
- textureWithCGImage:options:error: 从Quartz图像 加载2D纹理图像并从数据创
建新纹理
- textureWithCGImage:options:queue:completionHandler: 从Quartz图像异步
加载2D纹理图像,并根据数据创建新纹理
 
从URL加载多维创建纹理:
+ cabeMapWithContentsOfURL:options:errer: 从单个URL加载⽴方体贴图纹理
图像,并根据数据创建新纹理
- cabeMapWithContentsOfURL:options:queue:completionHandler:从单个
URL异步加载⽴方体贴图纹理图像,并根据数据创建新纹理
 
 从文件加载多维数据创建纹理:
+ cubeMapWithContentsOfFile:options:errer: 从单个⽂件加载⽴方体贴图纹理
对象,并从数据中创建新纹理
- cubeMapWithContentsOfFile:options:queue:completionHandler:从单个⽂件
异步加载⽴方体贴图纹理对象,并从数据中创建新纹理
+ cubeMapWithContentsOfFiles:options:errer: 从一系列文件中加载⽴方体贴图
纹理图像,并从数据总创建新纹理
- cubeMapWithContentsOfFiles:options:options:queue:completionHandler:
 从⼀系列文件异步加载⽴方体贴图纹理图像,并从数据中创建新纹理
 
 ==GLKView==
 初始化视图:
 - initWithFrame:context: 初始化新视图
 
 代理:
 delegate 视图的代理
 
配置帧缓存区对象:
drawableColorFormat 颜⾊色渲染缓存区格式
drawableDepthFormat 深度渲染缓存区格式
drawableStencilFormat 模板渲染缓存区的格式
drawableMultisample 多重采样缓存区的格式
 
帧缓存区属性:
drawableHeight 底层缓存区对象的⾼度(以像素为单位)
drawableWidth 底层缓存区对象的宽度(以像素为单位)
 
 绘制视图的内容:
context 绘制视图内容时使⽤的OpenGL ES 上下文
- bindDrawable 将底层FrameBuffer 对象绑定到OpenGL ES
enableSetNeedsDisplay 布尔值,指定视图是否响应使得视图内容无效的消息
- display 立即重绘视图内容
snapshot 绘制视图内容并将其作为新图像对象返回
 
删除视图FrameBuffer对象:
- deleteDrawable 删除与视图关联的可绘制对象
 
 GLKViewDelegate ⽤于GLKView 对象回调⽅法:
 - glkView:drawInRect: 绘制视图内容 (必须实现代理)
 
 ==GLKViewController 管理OpenGL ES 渲染循环的视图控制器==
 更新:
 - (void) update 更新视图内容
 - (void) glkViewControllerUpdate:
 
 配置帧速率:
 preferredFramesPerSecond 视图控制器调⽤视图以及更新视图内容的速率
framesPerSencond 视图控制器调⽤视图以及更新其内容的实际速率
 
 配置GLKViewController 代理:
 delegate 视图控制器的代理
 
 控制帧更新:
paused 布尔值,渲染循环是否已暂停
pausedOnWillResignActive 布尔值,当前程序重新激活动状态时视图控制器是
否⾃动暂停渲染循环
resumeOnDidBecomeActive 布尔值,当前程序变为活动状态时视图控制是否⾃动
恢复呈现循环
 
 获取有关View 更新信息:
frameDisplayed 视图控制器自创建以来发送的帧更新数
timeSinceFirstResume ⾃视图控制器第一次恢复发送更新事件以来经过的时间量
timeSinceLastResume ⾃上次视图控制器恢复发送更新事件以来更新的时间量
timeSinceLastUpdate ⾃上次视图控制器调用委托⽅法以及经过的时间量
glkViewControllerUpdate:
 timeSinceLastDraw ⾃上次视图控制器调用视图display 方法以来经过的时间量
 
 ==GLKViewControllerDelegate 渲染循环回调方法==
 处理理更新事件:
 - glkViewControllerUpdate: 在显示每个帧之前调⽤
 
 暂停/恢复通知:
 - glkViewController:willPause: 在渲染循环暂停或恢复之前调⽤
 
 ==GLKBaseEffect 一种简单光照/着色系统,用于基于着⾊器OpenGL 渲染==
 命名Effect:
 label 给Effect(效果)命名
 
 配置模型视图转换:
 transform 绑定效果时应用于顶点数据的模型视图,投影和纹理变换
 
 配置光照效果:
lightingType ⽤于计算每个⽚段的光照策略,GLKLightingType
GLKLightingType:
 GLKLightingTypePerVertex 表示在三⻆形中每个顶点执⾏光照计算,然后在三⻆形进行插值
GLKLightingTypePerPixel 表示光照计算的输入在三⻆形内插入,并且在每个片段执⾏光照计算
 
 配置光照:
lightModelTwoSided 布尔值,表示为基元的两侧计算光照
material 计算渲染图元光照使用的材质属性
lightModelAmbientColor 环境颜⾊,应用效果渲染的所有图元.
 light0 场景中第⼀个光照属性
 light1 场景中第⼆个光照属性
 light2 场景中第三个光照属性
 
 配置纹理:
 texture2d0 第⼀个纹理属性
 texture2d1 第⼆个纹理属性
textureOrder 纹理应⽤于渲染图元的顺序
 
配置雾化:
 fog 应用于场景的雾属性
 
 配置颜⾊信息:
colorMaterialEnable 布尔值,表示计算光照与材质交互时是否使⽤颜色顶点属性
useConstantColor 布尔值,指示是否使⽤常量颜⾊
constantColor 不提供每个顶点颜色数据时使⽤常量颜⾊(黑色)
 
 准备绘制效果:
 - prepareToDraw 准备渲染效果
 
 
 
 
 */

#import "TestOpenGLESViewController.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface TestOpenGLESViewController ()
{
    EAGLContext *context;
}

@end

@implementation TestOpenGLESViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self helloOpenGLES];
}

// MARK: ==hello opengles==
- (void)helloOpenGLES {
    //1.初始化上下文&设置当前上下文
    /*
     EAGLContext 是苹果iOS平台下实现OpenGLES 渲染层.
     kEAGLRenderingAPIOpenGLES1 = 1, 固定管线
     kEAGLRenderingAPIOpenGLES2 = 2,
     kEAGLRenderingAPIOpenGLES3 = 3,
     */
    context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    //判断context是否创建成功
    if (!context) {
        NSLog(@"Create ES context Failed");
    }
    //设置当前上下文
    [EAGLContext setCurrentContext:context];
    
    //2.获取GLKView & 设置context
    GLKView *view =(GLKView *) self.view;
    view.context = context;
    
    //3.设置背景颜色
    glClearColor(1, 0, 0, 1.0);
}

#pragma mark -- GLKViewDelegate
//绘制视图的内容
/*
 GLKView对象使其OpenGL ES上下文成为当前上下文，并将其framebuffer绑定为OpenGL ES呈现命令的目标。然后，委托方法应该绘制视图的内容。
*/
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
}


@end
