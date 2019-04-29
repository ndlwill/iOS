//
//  UIGestureRecognizer+NDLBlock.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/14.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureActionBlock)(UIGestureRecognizer *gesture);

/*
 KVC:
 canPanVertically
 */
@interface UIGestureRecognizer (NDLBlock)

+ (instancetype)ndl_gestureRecognizerWithActionBlock:(void(^)(UIGestureRecognizer *gesture))block;

@end
