//
//  CircleTransitionAnimator.h
//  DaZhongChuXing
//
//  Created by dzcx on 2018/9/5.
//  Copyright © 2018年 tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning, CAAnimationDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) BOOL isPresentFlag;
@property (nonatomic, assign) CGPoint originCenterPoint;

@end
