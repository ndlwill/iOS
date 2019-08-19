//
//  InvisibleWatermark.m
//  NDL_Category
//
//  Created by dzcx on 2019/6/13.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "InvisibleWatermark.h"

@implementation InvisibleWatermark

// White    255 255 255    #FFFFFF
// Black    0 0 0    #000000
+ (UIImage *)addWatermarkToImage:(UIImage *)originImage text:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:32.0];
    NSDictionary *attributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.01]};

    UIImage *newImage = [originImage copy];
    CGFloat textX = 0.0;
    CGFloat textY = 0.0;
    NSUInteger colIndex = 0;
    NSUInteger rowIndex = 0;
    CGSize textSize = [text sizeWithAttributes:attributes];
    
    NSMutableArray<NSString *> *points = [NSMutableArray array];
    
    // textY < originImage.size.height
    while (YES) {
        textY = (textSize.height * 2) * rowIndex;
        if (textY >= originImage.size.height) {
            break;
        }
        while (YES) {
            @autoreleasepool {
                textX = (textSize.width * 2) * colIndex;
                if (textX >= originImage.size.width) {
                    break;
                }
                CGPoint point = CGPointMake(textX, textY);
                [points addObject:NSStringFromCGPoint(point)];
            }
            colIndex++;
        }
        
        textX = 0.0;
        colIndex = 0;
        rowIndex++;
    }
    NSLog(@"points.count = %lu", points.count);
    return [self addWatermarkToImage:newImage text:text textPoints:[points copy] textAttributes:attributes];
}

+ (void)addWatermarkToImage:(UIImage *)originImage text:(NSString *)text completion:(void (^)(UIImage *))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        StartTime
        UIImage *newImage = [self addWatermarkToImage:originImage text:text];
        EndTime
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(newImage);
            }
        });
    });
}

+ (UIImage *)addWatermarkToImage:(UIImage *)image text:(NSString *)text textPoints:(NSArray<NSString *> *)textPoints textAttributes:(NSDictionary *)textAttributes
{
    UIGraphicsBeginImageContext(image.size);
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    [image drawInRect:CGRectMake(0, 0, imageWidth, imageHeight)];
    
    for (NSInteger i = 0; i < textPoints.count; i++) {
        CGPoint textPoint = CGPointFromString(textPoints[i]);
        
        [text drawAtPoint:textPoint withAttributes:textAttributes];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/*
 
 在小端模式中，低位字节放在低地址，高位字节放在高地址；在大端模式中，低位字节放在高地址，高位字节放在低地址
 unsigned int value = 0x12345678
 内存地址    小端模式存放内容    大端模式存放内容
 0x4000    0x78    0x12
 0x4001    0x56    0x34
 0x4002    0x34    0x56
 0x4003    0x12    0x78
 
 kCGImageAlphaPremultipliedLast >>>> R G B A
 kCGImageAlphaPremultipliedFirst >>>> A R G B
 
 typedef struct CGImage *CGImageRef;
 CGImageRef 和 struct CGImage * 是完全等价的。这个结构用来创建像素位图，可以通过操作存储的像素位来编辑图片
 */
// RGB与16进制色互转
// https://tool.css-js.com/rgba.html
// 0x7C2219FF -> 124, 34, 25, 255(rgba)
+ (UIImage *)colorBumWatermarkImage:(UIImage *)watermarkImage
{
    // raw pixels(原始像素) of the image
    UInt32 *inputPixels;
    
    CGImageRef inputCGImage = [watermarkImage CGImage];
    size_t imageWidth = CGImageGetWidth(inputCGImage);
    size_t imageHeight = CGImageGetHeight(inputCGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bitsPerComponent = 8;
    
    // 每行字节数
    NSUInteger bytesPerRow = bytesPerPixel * imageWidth;
    // 开辟内存区域,指向首像素地址
    inputPixels = (UInt32 *)calloc(imageWidth * imageHeight, sizeof(UInt32));
    // 创建像素层
    CGContextRef context = CGBitmapContextCreate(inputPixels, imageWidth, imageHeight,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);// kCGBitmapByteOrder32Little kCGBitmapByteOrder32Big kCGImageAlphaPremultipliedFirst kCGImageAlphaPremultipliedLast
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), inputCGImage);
    
    // 像素处理
    for (int j = 0; j < imageHeight; j++) {
        for (int i = 0; i < imageWidth; i++) {
            @autoreleasepool {
                UInt32 *currentPixel = inputPixels + (j * imageWidth) + i;
                UInt32 currentPixelValue = *currentPixel;
                // 124, 34, 25, 255(rgba) 0x7C2219FF 2082609663 自己已验证
                // kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big 4279837308->ff19227c abgr
                // kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Little 2082609663->7c2219ff rgba###
                // kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little 4286325273->ff7c2219 argb
                // kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Big 421690623->19227cff bgra
                NSLog(@"currentPixelValue = %u", (unsigned int)currentPixelValue);
                UInt32 currentR, currentG, currentB, currentA;

                // rgba
                currentR = (currentPixelValue & 0x000000FF);
                currentG = (currentPixelValue & 0x0000FF00) >> 8;
                currentB = (currentPixelValue & 0x00FF0000) >> 16;
                currentA = (currentPixelValue & 0xFF000000) >> 24;

                
                UInt32 newR, newG, newB;
                newR = [self blendingCalculation:currentR];
                newG = [self blendingCalculation:currentG];
                newB = [self blendingCalculation:currentB];

                *currentPixel = (newR  | newG << 8 | newB << 16 | currentA << 24);
            }
        }
    }
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newCGImage];
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    free(inputPixels);
    
    return newImage;
}

+ (int)blendingCalculation:(int)originValue
{
    // 结果色 = 基色 —（基色反相 × 混合色反相）/ 混合色
    int resultValue = 0;
    int mixValue = 1;
    
    if (mixValue == 0) {
        resultValue = 0;
    } else {
        resultValue = originValue - (255 - originValue) * (255 - mixValue) / mixValue;
    }
    
    if (resultValue < 0) {
        resultValue = 0;
    }
    
    return resultValue;
}

@end
