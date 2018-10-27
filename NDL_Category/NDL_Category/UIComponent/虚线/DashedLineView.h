//
//  DashedLineView.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/29.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE
@interface DashedLineView : UIView

// 虚线实线的长度
@property (nonatomic, assign) IBInspectable CGFloat dashedLineSolidLength;
// 虚线空白的长度
@property (nonatomic, assign) IBInspectable CGFloat dashedLineBlankLength;
// 线宽
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;
// 描边颜色
@property (nonatomic, strong) IBInspectable UIColor *strokeColor;

@end
