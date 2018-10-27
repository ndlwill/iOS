//
//  GradientView.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/18.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientView : UIView

// colors: UIColor数组  单个颜色渐变eg:红色@[[UIColor redColor], [[UIColor redColor] colorWithAlphaComponent:0.0]]
// 默认: gradientDirection top->bottom
// The default values are [.5,0] and [.5,1]
- (instancetype)initWithFrame:(CGRect)frame colors:(NSArray *)colors gradientDirection:(GradientDirection)gradientDirection;

@end
