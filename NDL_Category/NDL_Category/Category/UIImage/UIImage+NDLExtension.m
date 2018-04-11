//
//  UIImage+NDLExtension.m
//  NDL_Category
//
//  Created by ndl on 2017/11/8.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import "UIImage+NDLExtension.h"

@implementation UIImage (NDLExtension)

- (UIImage *)ndl_generateRoundImage
{
    // 这个是透明的 NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    // 获得上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(context, rect);
    
    // 裁减
    CGContextClip(context);
    
    // 将原始图片画到圆上
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)ndl_imageWithColor:(UIColor *)color size:(CGSize)imageSize
{
    CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, imageRect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)ndl_imageWithAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    [self drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:alpha];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)ndl_imageWithCornerRadius:(CGFloat)radius
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //clip
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, radius);
    CGContextAddLineToPoint(context, 0.0f, self.size.height - radius);
    CGContextAddArc(context, radius, self.size.height - radius, radius, M_PI, M_PI / 2.0f, 1);// angle = 180->90 1逆时针
    CGContextAddLineToPoint(context, self.size.width - radius, self.size.height);
    CGContextAddArc(context, self.size.width - radius, self.size.height - radius, radius, M_PI / 2.0f, 0.0f, 1);
    CGContextAddLineToPoint(context, self.size.width, radius);
    CGContextAddArc(context, self.size.width - radius, radius, radius, 0.0f, -M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, radius, 0.0f);
    CGContextAddArc(context, radius, radius, radius, -M_PI / 2.0f, M_PI, 1);
    CGContextClip(context);
    
    [self drawAtPoint:CGPointZero];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)ndl_imageWithMaskImage:(UIImage *)maskImage
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), maskImage.CGImage);
    [self drawAtPoint:CGPointZero];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)ndl_stretchedImage
{
    UIImage *stretchedImage = nil;
    
    CGFloat top_bottom = self.size.height / 2;
    CGFloat left_right = self.size.width / 2;
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(top_bottom, left_right, top_bottom, left_right);
    UIImageResizingMode resizeMode = UIImageResizingModeStretch;
    
    stretchedImage = [self resizableImageWithCapInsets:capInsets resizingMode:resizeMode];
    return stretchedImage;
}

- (UIImage *)ndl_imageWithScaleRatio:(CGFloat)ratio
{
    if (ratio == 1.0) {
        return self;
    }
    
    CGFloat scaledWdith = self.size.width * ratio;
    CGFloat scaledHeight = self.size.height * ratio;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(scaledWdith, scaledHeight), NO, 0.0f);
    // eg:ratio = 2.0
    [self drawInRect:CGRectMake(0.0f, 0.0f, scaledWdith, scaledHeight)];// drawInRect image全部显示在这个rect
//    [self drawAtPoint:CGPointZero];// drawAtPoint 画板大小 = （scaledWdith，scaledHeight） image还是原来大小绘制在画板
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *)ndl_cropImageToSize:(CGSize)targetSize
{
    if (self == nil) {
        return nil;
    }
    UIImage *newImage = nil;
    
    CGSize sourceImageSize = self.size;
    CGFloat sourceWidth = sourceImageSize.width;
    CGFloat sourceHeight = sourceImageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat croppedWidth = targetWidth;
    CGFloat croppedHeight = targetHeight;
    
    CGFloat scaleRatio = 0;
    
    CGPoint originPoint = CGPointZero;
    
    if (!CGSizeEqualToSize(sourceImageSize, targetSize)) {
        CGFloat widthRatio = targetWidth / sourceWidth;
        CGFloat heightRatio = targetHeight / sourceHeight;
        
        if (widthRatio > heightRatio) {
            scaleRatio = widthRatio;
        } else {
            scaleRatio = heightRatio;
        }
        
        croppedWidth = sourceWidth * scaleRatio;
        croppedHeight = sourceHeight * scaleRatio;
        
        // center image
        if (widthRatio > heightRatio) {
            originPoint.y = (targetHeight - croppedHeight) * 0.5;
        } else if (widthRatio < heightRatio) {
            originPoint.x = (targetWidth - croppedWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:CGRectMake(originPoint.x, originPoint.y, croppedWidth, croppedHeight)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
