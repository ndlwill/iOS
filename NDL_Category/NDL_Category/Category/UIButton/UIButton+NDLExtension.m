//
//  UIButton+NDLExtension.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/2.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "UIButton+NDLExtension.h"

@implementation UIButton (NDLExtension)

- (void)ndl_convertToRightImageButtonWithSpace:(CGFloat)space
{
    UIImage *image = self.imageView.image;
    CGFloat halfSpace = space / 2;
    NSLog(@"imageSize = %@ titleLabelSize = %@", NSStringFromCGSize(image.size), NSStringFromCGSize(self.titleLabel.size));
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width - halfSpace, 0, image.size.width + halfSpace)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.width + halfSpace, 0, -self.titleLabel.width - halfSpace)];
}

@end
