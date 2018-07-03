//
//  CommonButton.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/3.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "CommonButton.h"

@interface CommonButton ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CommonButton

#pragma mark - init
- (instancetype)initWithTitle:(NSString *)titleStr image:(UIImage *)image titleImageSpace:(CGFloat)space
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor yellowColor];
        
        
    }
    return self;
}

#pragma mark - Setter


@end
