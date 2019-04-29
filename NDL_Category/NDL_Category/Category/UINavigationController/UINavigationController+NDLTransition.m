//
//  UINavigationController+NDLTransition.m
//  NDL_Category
//
//  Created by dzcx on 2019/4/8.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "UINavigationController+NDLTransition.h"

static NSTimeInterval const kTransitionDuration = 0.8;

@implementation UINavigationController (NDLTransition)

- (void)ndl_pushViewController:(UIViewController *)viewController transitionType:(CATransitionType)transitionType transitionSubtype:(CATransitionSubtype)transitionSubtype animated:(BOOL)animated
{
    CATransition *transition = [self _transitionWithTransitionType:transitionType transitionSubtype:transitionSubtype];
    [self.view.layer addAnimation:transition forKey:@"transitionAnimation"];
    
    [self pushViewController:viewController animated:animated];
}

- (void)ndl_popViewControllerWithTransitionType:(CATransitionType)transitionType transitionSubtype:(CATransitionSubtype)transitionSubtype animated:(BOOL)animated
{
    CATransition *transition = [self _transitionWithTransitionType:transitionType transitionSubtype:transitionSubtype];
    [self.view.layer addAnimation:transition forKey:@"transitionAnimation"];
    
    [self popViewControllerAnimated:animated];
}

- (CATransition *)_transitionWithTransitionType:(CATransitionType)transitionType transitionSubtype:(CATransitionSubtype)transitionSubtype
{
    CATransition *transition = [CATransition animation];
    transition.duration = kTransitionDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = transitionType;
    transition.subtype = transitionSubtype;
    return transition;
}

@end
