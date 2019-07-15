//
//  UIImage+NDLExtension.m
//  NDL_Category
//
//  Created by ndl on 2017/11/8.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import "UIImage+NDLExtension.h"
// 使用vImage实现高斯模糊,vImage属于Accelerate.Framework
// 原理是：将原来的图片惊醒模糊处理返回渲染后的一整张图片，比较消耗CPU
#import <Accelerate/Accelerate.h>

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

- (UIImage *)ndl_compressToWidth:(CGFloat)width
{
    if (width <= 0 || [self isKindOfClass:[NSNull class]] || self == nil) {
        return nil;
    }
    CGSize newSize = CGSizeMake(width, width * (self.size.height / self.size.width));
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)ndl_compressToDataLength:(NSInteger)length withBlock:(void (^)(NSData *data))block
{
    if (length <= 0 || [self isKindOfClass:[NSNull class]] || self == nil) {
        block(nil);
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *newImage = [self copy];
        CGFloat scaleRatio = 0.9;
        NSData *jpegData = UIImageJPEGRepresentation(newImage, scaleRatio);
        
        while (jpegData.length > length) {
            newImage = [self ndl_compressToWidth:newImage.size.width * scaleRatio];
            NSData *newData = UIImageJPEGRepresentation(newImage, 0.0);
            if (newData.length < length) {
                CGFloat scale = 1.0;
                newData = UIImageJPEGRepresentation(newImage, scale);
                while (newData.length > length) {
                    scale -= 0.1;
                    newData = UIImageJPEGRepresentation(newImage, scale);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(newData);
                });
                return ;
            }
        }
        block(jpegData);
    });
}

+ (UIImage *)ndl_createNonInterpolatedUIImageFormCIImage:(CIImage *)ciImage whValue:(CGFloat)whValue
{
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(whValue / CGRectGetWidth(extent), whValue / CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/*
 void 被翻译为"无类型"，相应的void * 为"无类型指针"
 
 C语言中void 常常用于：对函数返回类型的限定和对函数参数限定
 void fun(int a);
 int fun(void);
 
 C语言中void * 为 “不确定类型指针”
 1.void *可以接受任何类型的赋值:
 void *a = NULL；
 int *b = NULL；
 a  =  b；//a是void * 型指针，任何类型的指针都可以直接赋值给它，无需进行强制类型转换
 2.void *可以赋值给任何类型的变量 但是需要进行强制转换
 int * a = NULL ；
 void * b ；
 a  =  （int *）b
 void* 类型接受了int * 的赋值后 这个void * 不能转化为其他类型，必须转换为int *类型
 
 */
/**
 * 使用vImage实现模糊效果
 */
- (UIImage *)ndl_blurImage:(UIImage *)image withBlurValue:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.0f) blur = 0.5f;
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    // 图像处理
    CGImageRef img = image.CGImage;
    
    // 输入缓存 输出缓存
    vImage_Buffer inBuffer,outBuffer;
    
    vImage_Error error;
    
    // 像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //create vImage_Buffer with data from CGImageRef
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    // 模糊算法使用的函数是：vImageBoxConvolve_ARGB8888
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) NSLog(@"error from convolution %ld", error);

    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));// (CGBitmapInfo)kCGImageAlphaNoneSkipLast
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage * outImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    // 释放句柄
    CGImageRelease(imageRef);
    
    return outImage;
}

@end
