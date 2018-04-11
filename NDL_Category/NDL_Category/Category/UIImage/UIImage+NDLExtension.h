//
//  UIImage+NDLExtension.h
//  NDL_Category
//
//  Created by ndl on 2017/11/8.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NDLExtension)

// 生成圆形图片
- (UIImage *)ndl_generateRoundImage;

// 生成存色的图片
+ (UIImage *)ndl_imageWithColor:(UIColor *)color size:(CGSize)imageSize;

// 生成带透明度的图片
- (UIImage *)ndl_imageWithAlpha:(CGFloat)alpha;

// 生成带圆角的图片
- (UIImage *)ndl_imageWithCornerRadius:(CGFloat)radius;

// 生成遮罩后的图片
- (UIImage *)ndl_imageWithMaskImage:(UIImage *)maskImage;

// 生成拉伸后的图片
- (UIImage *)ndl_stretchedImage;

// 生成scale后的图片
- (UIImage *)ndl_imageWithScaleRatio:(CGFloat)ratio;

// 生成裁剪后的图片? targetSize < sourceSize
- (UIImage *)ndl_cropImageToSize:(CGSize)targetSize;

@end
