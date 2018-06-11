//
//  AlipayPaymentAnimationView.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/8.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlipayPaymentAnimationView : UIView

+ (AlipayPaymentAnimationView *)showInView:(UIView *)superView;

- (void)resumeAnimation;
- (void)pauseAnimation;
//- (void)stopAnimation;

@end
