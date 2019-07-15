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

// RGB与16进制色互转
// https://tool.css-js.com/rgba.html
// ff1493 -> 255,20,147
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
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), inputCGImage);
    
    // 像素处理
    for (int j = 0; j < imageHeight; j++) {
        for (int i = 0; i < imageWidth; i++) {
            @autoreleasepool {
                UInt32 *currentPixel = inputPixels + (j * imageWidth) + i;
                UInt32 currentPixelValue = *currentPixel;
                UInt32 currentR, currentG, currentB, currentA;

                currentR = (currentPixelValue & 0x000000FF);
                currentG = (currentPixelValue & 0x0000FF00) >> 8;
                currentB = (currentPixelValue & 0x00FF0000) >> 16;
                currentA = (currentPixelValue & 0xFF000000) >> 24;
//                currentR = (currentPixelValue & 0xFF000000) >> 24;
//                currentG = (currentPixelValue & 0x00FF0000) >> 16;
//                currentB = (currentPixelValue & 0x0000FF00) >> 8;
//                currentA = (currentPixelValue & 0x000000FF);

                
                UInt32 newR, newG, newB;
                newR = [self blendingCalculation:currentR];
                newG = [self blendingCalculation:currentG];
                newB = [self blendingCalculation:currentB];

                *currentPixel = (newR  | newG << 8 | newB << 16 | currentA << 24);
//                *currentPixel = (newR << 24 | newG << 16 | newB << 8 | currentA);
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
