//
//  InvisibleWatermark.h
//  NDL_Category
//
//  Created by dzcx on 2019/6/13.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface InvisibleWatermark : NSObject
// 添加水印
+ (UIImage *)addWatermarkToImage:(UIImage *)originImage text:(NSString *)text;
+ (void)addWatermarkToImage:(UIImage *)originImage text:(NSString *)text completion:(void (^)(UIImage *))completion;

// 颜色加深
+ (UIImage *)colorBumWatermarkImage:(UIImage *)watermarkImage;


@end

NS_ASSUME_NONNULL_END
