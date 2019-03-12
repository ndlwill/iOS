//
//  TestAutoLayoutView.h
//  NDL_Category
//
//  Created by dzcx on 2019/3/4.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestAutoLayoutView : UIView

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImageView *imageView;

- (void)updateLabelLayout;

@end

NS_ASSUME_NONNULL_END
