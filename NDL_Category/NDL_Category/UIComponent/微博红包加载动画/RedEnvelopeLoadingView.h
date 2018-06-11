//
//  RedEnvelopeLoadingView.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/7.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

//
typedef NS_ENUM(NSInteger, RedEnvelopeLoadingDirection) {
    RedEnvelopeLoadingDirection_Left = 0,// 以左边的dot为参照
    RedEnvelopeLoadingDirection_Right
};


// 平移动画 x += direction * speed;//  direction = 1或者-1 speed = 2
@interface RedEnvelopeLoadingView : UIView

//@property (nonatomic, assign) CGFloat rotateRadius;// 旋转半径

// 默认RedEnvelopeLoadingDirection_Left
@property (nonatomic, assign) RedEnvelopeLoadingDirection moveDirection;

- (instancetype)initWithFrame:(CGRect)frame dotsSpace:(CGFloat)spaceValue;

- (void)startAnimation;

@end
