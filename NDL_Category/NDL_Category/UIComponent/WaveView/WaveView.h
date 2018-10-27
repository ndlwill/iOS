//
//  WaveView.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveView : UIView
// 0.0-1.0
@property (nonatomic, assign) CGFloat progress;
// 默认3.0 适用于多个waveLayer
@property (nonatomic, assign) CGFloat waveSpacing;

- (instancetype)initWithFrame:(CGRect)frame waveColors:(NSArray<UIColor *> *)waveColors;

//- (void)startAnimation;

@end
