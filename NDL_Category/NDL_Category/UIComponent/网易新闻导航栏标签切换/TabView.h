//
//  TabView.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/5.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabView : UIView

- (instancetype)initWithFrame:(CGRect)frame tabTitleArray:(NSArray<NSString *> *)tabTitleArray tabTitleFont:(UIFont *)tabTitleFont;

// default: lightgray 
@property (nonatomic, strong) UIColor *borderColor;
// default: 1.0
@property (nonatomic, assign) CGFloat borderWidth;

// default: red
@property (nonatomic, strong) UIColor *backViewColor;
// default: white
@property (nonatomic, strong) UIColor *frontViewColor;
// default: height / 2.0
@property (nonatomic, assign) CGFloat cornerRadius;

// tabTitleColor containerView背景颜色交换
//@property (nonatomic, strong) UIColor *backTabTitleColor;
//@property (nonatomic, strong) UIColor *frontTabTitleColor;

@end
