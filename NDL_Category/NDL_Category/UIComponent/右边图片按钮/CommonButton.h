//
//  CommonButton.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/3.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonButton : UIControl

- (instancetype)initWithTitle:(NSString *)titleStr image:(UIImage *)image titleImageSpace:(CGFloat)space;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) UIImage *image;

@end
