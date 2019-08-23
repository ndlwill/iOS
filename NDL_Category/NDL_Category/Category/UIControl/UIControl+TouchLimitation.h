//
//  UIControl+TouchLimitation.h
//  NDL_Category
//
//  Created by dzcx on 2019/8/23.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (TouchLimitation)

@property (nonatomic, assign) CGFloat acceptEventInterval;
@property (nonatomic, assign) BOOL ignoreEventFlag;

@end

NS_ASSUME_NONNULL_END
