//
//  NDLLabel.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/18.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

// frame使用sizeToFit
@interface NDLLabel : UILabel
// default: UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets padding;

@property (nonatomic, assign) BOOL longPressFlag;
// 长按时label背景色 default: [UIColor grayColor]
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;

@end
