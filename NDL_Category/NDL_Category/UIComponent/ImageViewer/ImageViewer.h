//
//  ImageViewer.h
//  NDL_Category
//
//  Created by dzcx on 2018/11/19.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 仿今日头条
@interface ImageViewer : UIView

// 如果是来自九宫格，需要9张图片的引用(九宫格最多9个图片)
// 在图片自己的坐标系，把图片相对于自己的rect转化为世界坐标系rect
@property (nonatomic, copy) NSArray<NSString *> *thumbnailImageUrls;// 缩略图地址(用于来自九宫格)
@property (nonatomic, copy) NSArray<UIView *> *thumbnailReferenceViews;// 缩略图参考视图
@property (nonatomic, copy) NSArray<NSString *> *originalImageUrls;// 原图地址

// 配合originalImageUrls 这个类型的不需要显示缩略图视图和加载视图
@property (nonatomic, weak) UIView *originalReferenceView;// 原图参考视图 (用于来自非九宫格)

// =====common=====
@property (nonatomic, assign) NSUInteger curIndex;// 当前展示图片的下标

// 设置完属性，再调方法
- (void)show;

// =================================


@end

NS_ASSUME_NONNULL_END
