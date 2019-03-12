//
//  AutoCalcSizeView.h
//  NDL_Category
//
//  Created by dzcx on 2019/3/4.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 自动计算H
@interface AutoCalcSizeView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

- (void)setLabelText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
