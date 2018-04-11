//
//  NDLFloatLayoutView.h
//  NDL_Category
//
//  Created by ndl on 2018/1/30.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDLFloatLayoutView : UIView

// 内边距(content-edge的距离) 默认为 UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets padding;

// item的外边距 默认为 UIEdgeInsetsZero  (eg:item-space = 12 设置12 ／ 2 = 6)
@property (nonatomic, assign) UIEdgeInsets itemMargins;

@end
