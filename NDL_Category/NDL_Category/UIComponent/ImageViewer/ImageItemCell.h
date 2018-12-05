//
//  ImageItemCell.h
//  NDL_Category
//
//  Created by dzcx on 2018/11/19.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const ImageItemCellID = @"ImageItemCellID";

// 设计:imageView的宽等于cell的宽 (imageView的高变化)
@interface ImageItemCell : UICollectionViewCell

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL firstSelectionFlag;
// YES和NO作不同动画
@property (nonatomic, assign) BOOL firstSelectionImageExistFlag;

@property (nonatomic, copy) NSString *thumbnailImagePath;
@property (nonatomic, copy) NSString *originalImagePath;

// 原图图片还没加载完，dismiss ImageViewer
@property (nonatomic, copy) CommonNoParamNoReturnValueBlock noImageDismissBlock;
// 有图片 将要dismiss
@property (nonatomic, copy) CommonNoParamNoReturnValueBlock hasImageWillDismissBlock;
// 执行dismiss操作
@property (nonatomic, copy) CommonNoParamNoReturnValueBlock executeDismissBlock;
// 手势没有达到dismiss恢复完成后的block
@property (nonatomic, copy) CommonNoParamNoReturnValueBlock imageViewRestoreFinishedBlock;

// thumbnailImage相对于self的rect
@property (nonatomic, assign) CGRect thumbnailImageRect;

- (void)executeInitialAnimation;
- (void)saveImage;

@end

NS_ASSUME_NONNULL_END
