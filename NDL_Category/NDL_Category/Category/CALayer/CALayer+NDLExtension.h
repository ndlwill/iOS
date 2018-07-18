//
//  CALayer+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/18.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (NDLExtension)

// 暂停CALayer的动画
- (void)pauseAnimation;
// 恢复CALayer的动画
- (void)resumeAnimation;

@end
