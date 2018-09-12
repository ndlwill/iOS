//
//  BadgeView.h
//  NDL_Category
//
//  Created by dzcx on 2018/9/11.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BadgeViewAlignment)
{
    // 逆时针
    BadgeViewAlignment_TopRight = 0,// 右上
    BadgeViewAlignment_TopCenter,
    BadgeViewAlignment_TopLeft,
    BadgeViewAlignment_LeftCenter,
    BadgeViewAlignment_BottomLeft,
    BadgeViewAlignment_BottomCenter,
    BadgeViewAlignment_BottomRight,
    BadgeViewAlignment_RightCenter,
    BadgeViewAlignment_Center
};

// 系统badgeView(带数字)  size:(18，18)
@interface BadgeView : UIView

// text  badgeText = nil || badgeText = @"" 表示就显示为小红点
@property (nonatomic, copy) NSString *badgeText;
// alignment
@property (nonatomic, assign) BadgeViewAlignment alignment;

// =====optional=====
// badgeBgColor
@property (nonatomic, strong) UIColor *badgeBackgroundColor UI_APPEARANCE_SELECTOR;

// text: badgeTextFont & badgeTextColor
@property (nonatomic, strong) UIFont *badgeTextFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *badgeTextColor UI_APPEARANCE_SELECTOR;

// ？
// textShadow: badgeTextShadowOffset & badgeTextShadowColor
@property (nonatomic, assign) CGSize badgeTextShadowOffset UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *badgeTextShadowColor UI_APPEARANCE_SELECTOR;// default: nil

// stroke: badgeStrokeWidth & badgeStrokeColor
@property (nonatomic, assign) CGFloat badgeStrokeWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *badgeStrokeColor UI_APPEARANCE_SELECTOR;

// selfShadow: badgeShadowOffset & badgeShadowColor
@property (nonatomic, assign) CGSize badgeShadowOffset UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *badgeShadowColor UI_APPEARANCE_SELECTOR;// default: nil
@property (nonatomic, assign) CGFloat badgeShadowBlur;// default: 1.0

// =====adjustment=====
// default: 8.0
@property (nonatomic, assign) CGFloat badgeTextOffsetEdgeTotalWidthMargin;
// default:（0,0）
@property (nonatomic, assign) CGPoint badgePositionOffset;

// =====for red point with no text=====
// default: 8.0
@property (nonatomic, assign) CGFloat badgeMinWH;


- (instancetype)initWithParentView:(UIView *)parentView alignment:(BadgeViewAlignment)alignment;

@end
