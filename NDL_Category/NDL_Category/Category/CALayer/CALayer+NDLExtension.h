//
//  CALayer+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/18.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

/*
 Model Tree ：也就是我们通常所说的layer。
 Presentation Tree：呈现出来的layer，也就是我们做动画时你看到的那个layer，可以通过layer.presentationLayer获得。
 Render Tree ：私有，无法访问。主要是对Presentation Tree数据进行渲染，并且不会阻塞线程
 
 fillMode -> 决定当前对象在非动画时间段的行为
 
 对于非根图层，设置它的可动画属性是有隐式动画的，那么我们需要关闭图层的隐式动画，我们就需要用到动画事务CATransaction
 
 CATransition: 转场动画是一种显示样式向另一种显示样式过渡的效果
 
 属性动画可以做动画的属性：
 opacity 透明度
 backgroundColor 背景颜色
 cornerRadius 圆角
 borderWidth 边框宽度
 contents 内容
 shadowColor 阴影颜色
 shadowOffset 阴影偏移量
 shadowOpacity 阴影透明度
 shadowRadius 阴影圆角
 ...
 rotation 旋转
 transform.rotation.x
 transform.rotation.y
 transform.rotation.z
 ...
 scale 缩放
 transform.scale.x
 transform.scale.y
 transform.scale.z
 ...
 translation 平移
 transform.translation.x
 transform.translation.y
 transform.translation.z
 ...
 position 位置
 position.x
 position.y
 ...
 bounds
 bounds.size
 bounds.size.width
 bounds.size.height
 bounds.origin
 bounds.origin.x
 bounds.origin.y
 ...
 ...
 以及CALayer子类对应的各个属性（比如CAShapeLayer的path）
 */

/*
 Animation:
 https://github.com/yixiangboy/IOSAnimationDemo
 */

/*
 CALayerDelegate:
 是一个绘制图层内容的代理方法,不应该将UIView对象设置为显示层的委托对象，这是因为UIView对象已经是隐式层的代理对象
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
 */
@interface CALayer (NDLExtension)

// 暂停CALayer的动画
- (void)pauseAnimation;
// 恢复CALayer的动画
- (void)resumeAnimation;

- (void)ndl_bringSubLayerToFront:(CALayer *)subLayer;

@end

/*
 GPU 渲染机制：CPU 计算好显示内容提交到 GPU，GPU 渲染完成后将渲染结果放入帧缓冲区，随后视频控制器会按照 信号逐行读取帧缓冲区的数据，经过可能的数模转换传递给显示器显示
 1）On-Screen Rendering，意为当前屏幕渲染，指的是 GPU 的渲染操作是在当前用于显示的屏幕缓冲区中进行。
 2）Off-Screen Rendering，意为离屏渲染，指的是 GPU 在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作。
 
 CPU 渲染。如果我们重写了 drawRect 方法，并且使用任何 Core Graphics 的技术进行了绘制操作，就涉及到了 CPU 渲染。整个渲染过程由 CPU 在 App 内同步地 完成，渲染得到的 bitmap 最后再交由 GPU 用于显示
 Core Graphics 通常是线程安全的，所以可以进行异步绘制，显示的时候再放回主线程
 
 CPU 或者 GPU 没有完成内容提交，则那一帧就会被丢弃，等待下一次机会再显示，而这时显示屏会保留之前的内容不变。这就是界面卡顿的原因
 
 离屏渲染消耗性能的原因:
 1.需要创建新的缓冲区
 2.离屏渲染的整个过程，需要多次切换上下文环境，先是从当前屏幕（On-Screen）切换到离屏（Off-Screen）；等到离屏渲染结束以后，将离屏缓冲区的渲染结果显示到屏幕上，又需要将上下文环境从离屏切换到当前屏幕
 
 光栅化概念：将图转化为一个个栅格组成的图象。光栅化特点：每个元素对应帧缓冲区中的一像素
 
 触发离屏渲染:
 圆角 （maskToBounds并用才会触发）
 图层蒙版(遮罩)
 阴影
 光栅化
 
 shouldRasterize = YES 会使视图渲染内容被缓存起来，下次绘制的时候可以直接显示缓存，当然要在视图内容不改变的情况下
 */
