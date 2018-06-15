//
//  UIView+NDLExtension.h
//  NDL_Category
//
//  Created by ndl on 2017/11/8.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

// kvo [change objectForKey:NSKeyValueChangeNewKey];
@interface UIView (NDLExtension)

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

// ?
- (void)ndl_addTapGestureWithHandler:(void (^)())handler;

@end
