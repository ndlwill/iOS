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

// 以groups方式添加文件，文件参与编译 ，图标为黄色
// 以folder方式添加文件，文件将被作为资源文件，不参与编译，图标为蓝色

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

// 在2x倍数下（0.5pt 对应 1px），在3x倍数下（0.333pt 对应 1px）
/**
 *  某些地方可能会将 CGFLOAT_MIN 作为一个数值参与计算（但其实 CGFLOAT_MIN 更应该被视为一个标志位而不是数值），可能导致一些精度问题，所以提供这个方法快速将 CGFLOAT_MIN 转换为 0
 */
CG_INLINE CGFloat
convertFloatMin2Zero(CGFloat floatValue) {
    return floatValue == CGFLOAT_MIN ? 0 : floatValue;
}

// 基于指定的倍数，对传进来的 floatValue 进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准。
CG_INLINE CGFloat
flatSpecificScale(CGFloat floatValue, CGFloat scale) {
    floatValue = convertFloatMin2Zero(floatValue);
    scale = scale == 0 ? ScreenScale : scale;
    CGFloat flattedValue = ceil(floatValue * scale) / scale;
    return flattedValue;
}

// 基于当前设备的屏幕倍数，对传进来的 floatValue 进行像素取整。
// 在 Core Graphic 绘图里使用时，要注意当前画布的倍数是否和设备屏幕倍数一致，若不一致，不可使用 flat() 函数，而应该用 flatSpecificScale
CG_INLINE CGFloat
flat(CGFloat floatValue) {
    return flatSpecificScale(floatValue, 0);
}

#pragma mark - CGFloat
/// 用于居中运算
CG_INLINE CGFloat
CGFloatGetCenter(CGFloat parent, CGFloat child) {
    return flat((parent - child) / 2.0);
}


// 气泡框箭头方向
typedef NS_ENUM(NSInteger, BubbleFrameArrowDirection) {
    BubbleFrameArrowDirection_Top = 0,
    BubbleFrameArrowDirection_Left,
    BubbleFrameArrowDirection_Bottom,
    BubbleFrameArrowDirection_Right
};

// 气泡框直角位置
typedef NS_ENUM(NSInteger, BubbleFrameRightAnglePosition) {
    BubbleFrameRightAnglePosition_LB = 0,// 左下
    BubbleFrameRightAnglePosition_LT,// 左上
    BubbleFrameRightAnglePosition_RT,// 右上
    BubbleFrameRightAnglePosition_RB// 右下
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

// scrollView 拖拽方向
typedef NS_ENUM(NSInteger, ScrollViewDragDirection) {
    ScrollViewDragDirection_None = 0,// 没有拖拽
    ScrollViewDragDirection_Left,
    ScrollViewDragDirection_Right,
    ScrollViewDragDirection_Up,
    ScrollViewDragDirection_Down
};

// resources
FOUNDATION_EXTERN NSString * const kRemoteGifUrlStr;

// sql
FOUNDATION_EXTERN NSString * const kTestTableName;
FOUNDATION_EXTERN NSString * const kMessageTableName;

// =====Block=====
typedef void(^CommonNoParamNoReturnValueBlock)(void);


//
FOUNDATION_EXTERN CGFloat const kSystemBadgeViewWH;


// scrollView
/*
 setContentOffset: animated:
 只会调用scrollViewDidScroll
 
 animated:
 YES 调用多次scrollViewDidScroll
 NO 调用1次scrollViewDidScroll
 
 scrollView.contentOffset 设置的值与原来的一样，不调用scrollViewDidScroll
 */

// 大标题fontSize = 28(相当于bundle包裹大小) (BigTitleHeight = 40, BigTitleWrapperViewHeight = 60, (40 - 28) / 2 = 6表示字体到上下边界的距离)
FOUNDATION_EXTERN CGFloat const kBigTitleWrapperViewHeight;
FOUNDATION_EXTERN CGFloat const kBigTitleFontSize;
FOUNDATION_EXTERN CGFloat const kBigTitleBundleMargin;
FOUNDATION_EXTERN CGFloat const kBigTitleLimitY;


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
