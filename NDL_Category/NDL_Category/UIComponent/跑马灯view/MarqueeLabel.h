//
//  MarqueeLabel.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/18.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

// right->left
@interface MarqueeLabel : UILabel
// default: 0.5  10表示1帧10pt
@property (nonatomic, assign) CGFloat speed;
// default: 2.5
@property (nonatomic, assign) NSTimeInterval stayDurationWhenMoveToEdge;
// default: 40pt
@property (nonatomic, assign) CGFloat textSpacing;

// default: YES 是否显示边缘渐变
@property (nonatomic, assign) BOOL showEdgeFadeFlag;
// default: 20
@property (nonatomic, assign) CGFloat edgeFadeWidth;
// 渐变颜色
@property (nonatomic, strong) UIColor *edgeFadeStartColor;

// 文字是否以leftFade的后面为开始点 default: YES
@property (nonatomic, assign) BOOL showTextAtFadeTailFlag;

@end
