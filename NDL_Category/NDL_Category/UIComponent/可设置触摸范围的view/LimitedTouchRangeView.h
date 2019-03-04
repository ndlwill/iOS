//
//  LimitedTouchRangeView.h
//  NDL_Category
//
//  Created by dzcx on 2018/12/28.
//  Copyright © 2018 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LimitedTouchRangeView : UIView

// 默认view的大小 (相对于self的坐标系)
@property (nonatomic, assign) CGRect touchRangeRect;

@end

NS_ASSUME_NONNULL_END
