//
//  UIView+NDLExtension.h
//  NDL_Category
//
//  Created by ndl on 2017/11/8.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 UIView从Draw到Render:
 1.每一个UIView都有一个layer，每一个layer都有个content，这个content指向的是一块缓存，叫做backing store。
 2.UIView的绘制和渲染是两个过程，当UIView被绘制时，CPU执行drawRect，通过context将数据写入backing store。
 3.当backing store写完后，通过render server交给GPU去渲染，将backing store中的bitmap数据显示在屏幕上
 
 位图（Bitmap），又称栅格图（Raster graphics）或点阵图，是使用像素阵列(Pixel-array/Dot-matrix点阵)来表示的图像
 
 UIKit本身构建在CoreAnimation框架之上，CoreAnimation分成了两部分OpenGL ES和Core Graphics，OpenGL ES是直接调用底层的GPU进行渲染；Core Graphics是一个基于CPU的绘制引擎
 
 GPU屏幕渲染有以下两种方式:
 On-Screen Rendering即当前屏幕渲染，指的是GPU的渲染操作是在当前用于显示的屏幕缓冲区中进行。
 Off-Screen Rendering即离屏渲染，指的是GPU在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作
 
 离屏渲染:
 目的在于当使用圆角，阴影，遮罩的时候，图层属性的混合体被指定为在未预合成之前不能直接在屏幕中绘制，即当主屏的还没有绘制好的时候，所以就需要屏幕外渲染，最后当主屏已经绘制完成的时候，再将离屏的内容转移至主屏上
 
 在我们重写了drawRect方法，并且使用任何Core Graphics的技术进行了绘制操作，就涉及到了CPU渲染。整个渲染过程由CPU在App内 同步地 完成，渲染得到的bitmap最后再交由GPU用于显示
 */

// kvo [change objectForKey:NSKeyValueChangeNewKey];
@interface UIView (NDLExtension)

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) UIEdgeInsets extraTouchInset;
/** 在分类中声明@property, 只会生成方法的声明, 不会生成方法的实现和带有_下划线的成员变量*/
//- (CGFloat)x;
//- (void)setX:(CGFloat)x;

//判断一个控件是否真正显示在主窗口 viewDidAppear了它的window才不为空
- (BOOL)isShowInKeyWindow;

// 加载NibWithName
+ (instancetype)viewFromXib;

// UIView->带圆角的UIView
- (void)ndl_viewByRoundingCorners:(UIRectCorner)rectCorner cornerRadii:(CGSize)cornerSize;

// 返回所有可见的子视图
- (NSArray<UIView *> *)ndl_visibleSubViews;

// 获取当前视图的截屏图片
- (UIImage *)ndl_screenShot;

// 生成当前视图的快照
- (UIImage *)ndl_snapshotWithSize:(CGSize)size;

// 获取当前视图所在的控制器
- (UIViewController *)ndl_viewController;

@end
