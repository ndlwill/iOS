//
//  SXTAttributedImage.h
//  01-CoreText绘制文字
//
//  Created by YanZhang on 15/4/10.
//  Copyright © 2015年 YanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

/**
 显示的类型，包括UIImage, UIImageView(gif), 网络获取图片
 */
typedef NS_ENUM(NSInteger, SXTImageTppe){
    SXTImagePNGTppe = 0, // -> 包含JPG本地图片
    SXTImageGIFTppe,     // -> GIF图片
    SXTImageURLType      // -> 网络图片
};

@interface ZYAttributedImage : NSObject

/**
 * 图片名字
 */
@property (nonatomic, copy) NSString *imageName;

/**
 * 图片大小
 */
@property (nonatomic, assign) CGSize imageSize;

/**
 * 图片的位置
 */
@property (nonatomic, assign) NSInteger position;

/**
 * 图片类型
 */
@property (nonatomic, assign) SXTImageTppe imageType;

/**
 * 占位图片属性字符的字体fontRef
 * ->此处为方便计算Ascent和Descent
 */
@property (nonatomic, assign) CTFontRef fontRef;

/**
 * 图片与文字的上下左右的间距
 */
@property (nonatomic, assign) UIEdgeInsets imageInsets;

@end
