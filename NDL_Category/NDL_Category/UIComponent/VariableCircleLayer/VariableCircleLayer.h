//
//  VariableCircleLayer.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/24.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

// https://github.com/KittenYang/A-GUIDE-TO-iOS-ANIMATION
@interface VariableCircleLayer : CALayer

// 默认0.5 0-1
@property (nonatomic, assign) CGFloat progress;

// 默认50
@property (nonatomic, assign) CGFloat circleRadius;

@end
