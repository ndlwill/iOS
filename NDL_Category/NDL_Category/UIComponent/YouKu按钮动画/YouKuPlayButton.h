//
//  YouKuPlayButton.h
//  NDL_Category
//
//  Created by dzcx on 2018/8/28.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YouKuButtonState) {
    YouKuButtonState_Pause = 0,
    YouKuButtonState_Play
};

// 默认暂停
@interface YouKuPlayButton : UIButton

@property (nonatomic, assign) YouKuButtonState buttonState;

- (instancetype)initWithFrame:(CGRect)frame state:(YouKuButtonState)buttonState;

@end
