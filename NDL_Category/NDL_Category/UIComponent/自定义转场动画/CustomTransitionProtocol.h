//
//  CustomTransitionProtocol.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

// 需要实现自定义转场的vc去遵守
@protocol CustomTransitionProtocol <NSObject>

@required
// 返回动画器
//- (id<UIViewControllerAnimatedTransitioning>)transitionAnimator;

// 返回动画器的class
//- (Class)transitionAnimatorClass;


//@optional

@end
