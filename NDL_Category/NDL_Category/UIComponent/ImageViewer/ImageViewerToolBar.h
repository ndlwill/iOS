//
//  ImageViewerToolBar.h
//  NDL_Category
//
//  Created by dzcx on 2018/11/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 当前图片显示的index && 保存
@interface ImageViewerToolBar : UIView

@property (nonatomic, strong, readonly) UILabel *indexLabel;

@property (nonatomic, copy) CommonNoParamNoReturnValueBlock saveBlock;

- (void)showWithAnimationDuration:(CGFloat)duration;
- (void)hideWithAnimationDuration:(CGFloat)duration;

@end

NS_ASSUME_NONNULL_END
