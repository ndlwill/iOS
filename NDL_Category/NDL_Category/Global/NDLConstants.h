//
//  NDLConstants.h
//  NDL_Category
//
//  Created by dzcx on 2018/4/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

// remote gif 
// https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif

#pragma mark - 内联静态函数
// 方法交换
CG_INLINE BOOL
ReplaceMethod(Class _class, SEL _originSelector, SEL _newSelector) {
    Method oriMethod = class_getInstanceMethod(_class, _originSelector);
    Method newMethod = class_getInstanceMethod(_class, _newSelector);
    if (!newMethod) {
        // class 里不存在该方法的实现
        return NO;
    }
    BOOL isAddedMethod = class_addMethod(_class, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (isAddedMethod) {
        class_replaceMethod(_class, _newSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
    return YES;
}

#pragma mark - UIEdgeInsets

// UIKIT_STATIC_INLINE
/// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

/// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}


// 气泡框箭头方向
typedef NS_ENUM(NSInteger, BubbleFrameArrowDirection) {
    BubbleFrameArrowDirection_Top = 0,
    BubbleFrameArrowDirection_Left,
    BubbleFrameArrowDirection_Bottom,
    BubbleFrameArrowDirection_Right
};

// 优惠券背景分隔形状
typedef NS_ENUM(NSInteger, CouponBackgroundSeparateShape) {
    CouponBackgroundSeparateShape_None = 0,
    CouponBackgroundSeparateShape_SemiCircle,// 半圆
    CouponBackgroundSeparateShape_Triangle
};

// 权限类型
typedef NS_ENUM(NSInteger, AuthorityType) {
    AuthorityType_Location,
    AuthorityType_Camera,
    AuthorityType_Photo,
    AuthorityType_Contacts,
    AuthorityType_Calendar,
    AuthorityType_Reminder,// 备忘录
    AuthorityType_Microphone,// 录音
    AuthorityType_Health,
    AuthorityType_DataNetwork
};

// 分享平台
typedef NS_ENUM(NSInteger, SharePlatform) {
    SharePlatform_WechatTimeLine,
    SharePlatform_WechatSession,
    SharePlatform_QQ,
    SharePlatform_QZone,
    SharePlatform_Weibo
};

// gradient渐变方向
typedef NS_ENUM(NSInteger, GradientDirection) {
    GradientDirection_TopToBottom = 0,// topMiddle->bottomMiddle
    GradientDirection_BottomToTop,
    GradientDirection_LeftToRight,// leftMiddle->rightMiddle
    GradientDirection_RightToLeft,
    GradientDirection_LeftTopToRightBottom,
    GradientDirection_RightBottomToLeftTop,
    GradientDirection_LeftBottomToRightTop,
    GradientDirection_RightTopToLeftBottom
};

// resources
FOUNDATION_EXTERN NSString * const kRemoteGifUrlStr;

// sql
FOUNDATION_EXTERN NSString * const kTestTableName;

// =====Block=====
typedef void(^CommonNoParamNoReturnValueBlock)(void);


//
FOUNDATION_EXTERN CGFloat const kSystemBadgeViewWH;

// 大标题高度 = 60
FOUNDATION_EXTERN CGFloat const kBigTitleHeight;
// 大标题maxY = 4 + 48
FOUNDATION_EXTERN CGFloat const kBigTitleMaxY;
// 大标题middleY = 4 + 24 for自动滚动
FOUNDATION_EXTERN CGFloat const kBigTitleMiddleY;

// Tags
// 2000+
FOUNDATION_EXTERN NSInteger const kNavigationItemLeftBarButtonTag;
// 3000+
FOUNDATION_EXTERN NSInteger const kTransitionAnimationViewTag;

// 加密
FOUNDATION_EXTERN NSString * const kAES_Key;
FOUNDATION_EXTERN NSString * const kAES_IV;

// =====Navigation=====
FOUNDATION_EXTERN CGFloat const kNavBackButtonWidth;
FOUNDATION_EXTERN CGFloat const kNavBigTitleContainerViewHeight;
FOUNDATION_EXTERN CGFloat const kNavBigTitleHeight;
FOUNDATION_EXTERN CGFloat const kNavBigTitleLeadingToLeftEdge;
FOUNDATION_EXTERN CGFloat const kNavTextFieldBigTitleContainerViewHeight;
