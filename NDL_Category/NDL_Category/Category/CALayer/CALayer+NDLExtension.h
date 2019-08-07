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
@interface CALayer (NDLExtension)

// 暂停CALayer的动画
- (void)pauseAnimation;
// 恢复CALayer的动画
- (void)resumeAnimation;

- (void)ndl_bringSubLayerToFront:(CALayer *)subLayer;

@end
