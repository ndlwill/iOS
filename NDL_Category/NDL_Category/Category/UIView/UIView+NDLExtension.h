//
//  UIView+NDLExtension.h
//  NDL_Category
//
//  Created by ndl on 2017/11/8.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 UIScrollView在滚动过程当中，其实是在修改原点坐标。当手指触摸后, scroll view会暂时拦截触摸事件,使用一个计时器。假如在计时器到点后没有发生手指移动事件，那么 scroll view 发送 tracking events 到被点击的 subview。假如在计时器到点前发生了移动事件，那么 scroll view 取消 tracking 自己发生滚动
 
 UIScrollView对于touch事件的接收处理原理：
 UIScrollView应该是重载了hitTest 方法，并总会返回itself 。所以所有的touch 事件都会进入到它自己里面去了。内部的touch事件检测到这个事件是不是和自己相关的，或者处理或者除递给内部的view
 为了检测touch是处理还是传递，UIScrollView当touch发生时会生成一个timer。
 
 如果150ms内touch未产生移动，它就把这个事件传递给内部view
 如果150ms内touch产生移动，开始scrolling，不会传递给内部的view。（例如, 当你touch一个table时候，直接scrolling，你touch的那行永远不会highlight。）
 如果150ms内touch未产生移动并且UIScrollView开始传递内部的view事件，但是移动的话，且canCancelContentTouches = YES，UIScrollView会调用touchesCancelled方法，cancel掉内部view的事件响应,并开始scrolling。（例如, 当你touch一个table， 停止了一会，然后开始scrolling，那一行就首先被highlight，但是随后就不在高亮了）
 */

/*
 mas_makeConstraints执行流程:
 1.创建约束制造者MASConstraintMaker,绑定控件,生成了一个保存所有约束的数组
 2.执行mas_makeConstraints传入的block
 3.让约束制造者安装约束
 *   1.清空之前的所有约束
 *   2.遍历约束数组,一个一个安装
 */

/*
 MARK:UIView从Draw到Render:
 1.每一个UIView都有一个layer，每一个layer都有个content，这个content指向的是一块缓存，叫做backing store。
 2.UIView的绘制和渲染是两个过程，当UIView被绘制时，CPU执行drawRect，通过context将数据写入backing store。
 3.当backing store写完后，通过render server交给GPU去渲染，将backing store中的bitmap数据显示在屏幕上
 
 位图（Bitmap），又称栅格图（Raster graphics）或点阵图，是使用像素阵列(Pixel-array/Dot-matrix点阵)来表示的图像
 
 UIKit本身构建在CoreAnimation框架之上，CoreAnimation分成了两部分OpenGL ES和Core Graphics，OpenGL ES是直接调用底层的GPU进行渲染；Core Graphics是一个基于CPU的绘制引擎
 
 GPU屏幕渲染有以下两种方式:
 On-Screen Rendering即当前屏幕渲染，指的是GPU的渲染操作是在当前用于显示的屏幕缓冲区中进行。
 Off-Screen Rendering即离屏渲染，指的是GPU在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作
 
 离屏渲染:
 离屏渲染：指GPU（图形处理器）在当前屏幕缓冲区外新开辟一个渲染缓冲区进行工作。这会给我们带来额外的性能损耗
 会触发缓冲区的频繁合并和上下文的的频繁切换，会出现卡顿、掉帧现象
 目的在于当使用圆角，阴影，遮罩的时候，图层属性的混合体被指定为在未预合成之前不能直接在屏幕中绘制，即当主屏的还没有绘制好的时候，所以就需要屏幕外渲染，最后当主屏已经绘制完成的时候，再将离屏的内容转移至主屏上
 
 在我们重写了drawRect方法，并且使用任何Core Graphics的技术进行了绘制操作，就涉及到了CPU渲染。整个渲染过程由CPU在App内 同步地 完成，渲染得到的bitmap最后再交由GPU用于显示
 
 不会离屏渲染:
 UIView设置圆角不会产生离屏渲染
 设置阴影后，设置CALayer的 shadowPath
 label:如果不设置背景，不用masksToBounds。有背景，设置label.layer.backgroundColor，不用masksToBounds（masksToBounds会触发离屏渲染）
 iOS 9.0 之后UIImageView里png图片设置圆角不会触发离屏渲染了，但是给imageView添加背景色后再加圆角会有离屏渲染
 UIButton 设置图片:对图片设置圆角，不要对button设置圆角 button.imageView?.layer.cornerRadius = 5
 有图片的UIButton、UIIMageView，用drawInRect绘制UIImage圆角
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

/*
 ##AsyncDisplayKit##
 UI 线程中一旦出现繁重的任务就会导致界面卡顿，这类任务通常分为3类：排版，绘制，UI对象操作。
 排版通常包括计算视图大小、计算文本高度、重新计算子式图的排版等操作。 绘制一般有文本绘制 (例如 CoreText)、图片绘制 (例如预先解压)、元素绘制 (Quartz)等操作。 UI对象操作通常包括 UIView/CALayer 等 UI 对象的创建、设置属性和销毁。
 其中前两类操作可以通过各种方法扔到后台线程执行，而最后一类操作只能在主线程完成，并且有时后面的操作需要依赖前面操作的结果 （例如TextView创建时可能需要提前计算出文本的大小）。ASDK 所做的，就是尽量将能放入后台的任务放入后台，不能的则尽量推迟 (例如视图的创建、属性的调整)。
 为此，ASDK 创建了一个名为 ASDisplayNode 的对象，并在内部封装了 UIView/CALayer，它具有和 UIView/CALayer 相似的属性，例如 frame、backgroundColor等。所有这些属性都可以在后台线程更改，开发者可以只通过 Node 来操作其内部的 UIView/CALayer，这样就可以将排版和绘制放入了后台线程。但是无论怎么操作，这些属性总需要在某个时刻同步到主线程的 UIView/CALayer 去。
 ASDK 仿照 QuartzCore/UIKit 框架的模式，实现了一套类似的界面更新的机制：即在主线程的 RunLoop 中添加一个 Observer，监听了 kCFRunLoopBeforeWaiting 和 kCFRunLoopExit 事件，在收到回调时，遍历所有之前放入队列的待处理的任务，然后一一执行
 */

/*
 App 的启动:
 
 加载 MachO 的依赖库（这些依赖库也是 MachO 格式的文件）:
 dyld 从可执行 MachO 文件的依赖开始, 递归加载所有依赖的动态库。 动态库包括：iOS 中用到的所有系统动态库：加载 OC runtime 方法的 libobjc，系统级别的 libSystem（例如 libdispatch(GCD) 和 libsystem_blocks(Block)）
 
 Fix-ups（地址修正），包括 rebasing 和 binding:
 
 执行各模块初始化器:
 */
