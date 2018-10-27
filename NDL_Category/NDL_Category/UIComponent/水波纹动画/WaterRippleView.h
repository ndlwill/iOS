//
//  WaterRippleView.h
//  NDL_Category
//
//  Created by dzcx on 2018/9/7.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterRippleView : UIView

// default: black
@property (nonatomic, strong) UIColor *rippleStrokeColor;
// default: 1.0
@property (nonatomic, assign) CGFloat rippleLineWidth;
// default: 2.0
@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, assign) CGFloat originWH;

// 宽高一致
- (instancetype)initWithFrame:(CGRect)frame originWH:(CGFloat)originWH;

@end
