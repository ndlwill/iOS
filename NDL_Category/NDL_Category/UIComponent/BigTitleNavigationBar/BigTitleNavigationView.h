//
//  BigTitleNavigationView.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/29.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackBlock)(void);
@interface BigTitleNavigationView : UIView

// navigationBar背景颜色 default:white
@property (nonatomic, strong) IBInspectable UIColor *navBarBackgroundColor;

// bigTitleStr
@property (nonatomic, copy) IBInspectable NSString *bigTitleStr;

@property (nonatomic, copy) BackBlock backBlock;

@end
