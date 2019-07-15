//
//  HighlightGradientProgressView.h
//  NDL_Category
//
//  Created by dzcx on 2019/6/12.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 高光渐变进度条
@interface HighlightGradientProgressView : UIView

- (instancetype)initWithFrame:(CGRect)frame gradientColors:(NSArray *)gradientColors;

@end

NS_ASSUME_NONNULL_END
