//
//  UIImageView+GIF.h
//  01-CoreText绘制文字
//
//  Created by YanZhang on 15/4/10.
//  Copyright © 2015年 YanZhang. All rights reserved.//

#import <UIKit/UIKit.h>
#import "ZYAttributedImage.h"

@interface NSString (imageType)

/**
 * 判断图片类型
 */
+ (SXTImageTppe)contentTypeForImageName:(NSString *)imageName;

@end

@interface UIImageView (GIF)

/**
 * 加载指定GIF图片并创建UIImageView
 * ->imageName一定要加上.gif
 */
+ (UIImageView *)imageViewWithGIFName:(NSString *)imageName
                                frame:(CGRect)frame;

@end
