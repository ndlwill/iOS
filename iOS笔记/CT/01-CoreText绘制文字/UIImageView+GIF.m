//
//  UIImageView+GIF.m
//  01-CoreText绘制文字
//
//  Created by YanZhang on 15/4/10.
//  Copyright © 2015年 YanZhang. All rights reserved.//

#import "UIImageView+GIF.h"
#import <ImageIO/ImageIO.h>

@implementation NSString (imageType)

/**
 * 判断图片类型
 */
+ (SXTImageTppe)contentTypeForImageName:(NSString *)imageName
{
    // 加载gif文件数据
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    
    // 获取gif二进制数据
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    
    uint8_t c;
    [gifData getBytes:&c length:1];
    // 根据16进制图片的头部，判断图片是什么类型
    switch (c) {
        case 0x47:
            return SXTImageGIFTppe;
            break;
            
        default:
            return SXTImagePNGTppe;
            break;
    }
}

@end

@implementation UIImageView (GIF)

/**
 * 加载指定GIF图片并创建UIImageView
 */
+ (UIImageView *)imageViewWithGIFName:(NSString *)imageName
                                frame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    
    // 加载gif文件数据
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];

    // 获取gif二进制数据
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    
    // GIF动画图片数组
    NSMutableArray *frames = nil;
    // 图像源引用
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    // 动画时长
    CGFloat animationTime = 0.f;
    
    if (src) {
        // 获取gif图片的帧数
        size_t count = CGImageSourceGetCount(src);
        // 实例化图片数组
        frames = [NSMutableArray arrayWithCapacity:count];
        
        for (size_t i = 0; i < count; i++) {
            // 获取指定帧图像
            CGImageRef image = CGImageSourceCreateImageAtIndex(src, i, NULL);
            
            // 获取GIF动画时长
            NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, i, NULL);
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            
            if (image) {
                [frames addObject:[UIImage imageWithCGImage:image]];
                CGImageRelease(image);
            }
        }
        
        CFRelease(src);
    }
    
    [imageView setImage:[frames objectAtIndex:0]];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setAnimationImages:frames];
    [imageView setAnimationDuration:animationTime];
    [imageView startAnimating];
    
    return imageView;
}

@end
