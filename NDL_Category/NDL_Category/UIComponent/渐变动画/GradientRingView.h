//
//  GradientRingView.h
//  NDL_Category
//
//  Created by dzcx on 2019/6/12.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// CAGradientLayer只能实现线性渐变的效果，而CoreGraphics的绘制能绘制更多的渐变效果
@interface GradientRingView : UIView

- (instancetype)initWithFrame:(CGRect)frame ringWidth:(CGFloat)ringWidth ringColors:(NSArray *)ringColors;

@end

NS_ASSUME_NONNULL_END
