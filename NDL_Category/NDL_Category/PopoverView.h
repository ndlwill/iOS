//
//  PopoverView.h
//  NDL_Category
//
//  Created by dzcx on 2018/3/14.
//  Copyright © 2018年 ndl. All rights reserved.
//

#define kRectCorner 12

#define kBigCircleRadius 14
#define kSmallCircleRadius 6

#import <UIKit/UIKit.h>

@interface PopoverView : UIView

@property (nonatomic, assign, readonly) BOOL isAnimating;

// pointX相对于PopoverView的width
- (instancetype)initWithFrame:(CGRect)frame superViewRightPointX:(CGFloat)pointX titles:(NSArray *)titles subTitles:(NSArray *)subTitles images:(NSArray *)images;

- (void)startAnimation;

@end
