//
//  ImageLoadingView.h
//  NDL_Category
//
//  Created by dzcx on 2018/11/23.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageLoadingView : UIView

// 0-1
@property (nonatomic, assign) CGFloat progress;

+ (instancetype)showInView:(UIView *)parentView;

@end

NS_ASSUME_NONNULL_END
