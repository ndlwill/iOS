//
//  UINavigationController+NDLTransition.h
//  NDL_Category
//
//  Created by dzcx on 2019/4/8.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (NDLTransition)

/*
 CATransitionType:
 kCATransitionFade    // 淡化
 kCATransitionMoveIn  // 覆盖
 kCATransitionPush    // push
 kCATransitionReveal  // 揭开
 
 @"cube"        // 3D立方
 @"suckEffect"  // 吮吸
 @"oglFlip"     // 翻转
 @"rippleEffect"// 波纹
 @"pageCurl"    // 翻页
 @"pageUnCurl"  // 反翻页
 @"cameraIrisHollowOpen"   // 开镜头
 @"cameraIrisHollowClose"  // 关镜头
 */
- (void)ndl_pushViewController:(UIViewController *)viewController transitionType:(CATransitionType)transitionType transitionSubtype:(CATransitionSubtype)transitionSubtype animated:(BOOL)animated;

- (void)ndl_popViewControllerWithTransitionType:(CATransitionType)transitionType transitionSubtype:(CATransitionSubtype)transitionSubtype animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
