//
//  BounceView.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/23.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

// 
// https://www.desmos.com/calculator
@interface BounceView : UIView

// contentFrame.width = frame.width - 2 * bounceSpacing
- (instancetype)initWithFrame:(CGRect)frame bounceSpacing:(CGFloat)bounceSpacing;

@end
