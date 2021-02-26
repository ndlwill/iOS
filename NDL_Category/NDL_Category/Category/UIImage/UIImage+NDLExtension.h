//
//  UIImage+NDLExtension.h
//  NDL_Category
//
//  Created by ndl on 2017/11/8.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

// WebP是由google推出来的一种图片格式,这种格式的主要优势在于高效率,高压缩率,能够加快图片加载速度
// http://www.uisdc.com/image-format-webp-introduction
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
// 压缩到宽为width的图片
- (UIImage *)ndl_compressToWidth:(CGFloat)width;
// 压缩到多少字节大小的图片
- (void)ndl_compressToDataLength:(NSInteger)length withBlock:(void (^)(NSData *data))block;
// 生成高清二维码
+ (UIImage *)ndl_createNonInterpolatedUIImageFormCIImage:(CIImage *)ciImage whValue:(CGFloat)whValue;

// 高斯模糊图片 （brush stroke 笔触）
- (UIImage *)ndl_blurImage:(UIImage *)image withBlurValue:(CGFloat)blur;

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;


@end
