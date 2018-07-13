//
//  UIView+NDLTapGesture.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/10.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "UIView+NDLTapGesture.h"

@implementation UIView (NDLTapGesture)

//- (void)ndl_addTapGestureWithHandler:(CommonNoParamNoReturnValueBlock)handler
//{
//    self.userInteractionEnabled = YES;
//
//    UITapGestureRecognizer *tap = [UITapGestureRecognizer ndl_gestureRecognizerWithActionBlock:^(UIGestureRecognizer *gesture) {
//        if (handler) {
//            handler();
//        }
//    }];
//    [self addGestureRecognizer:tap];
//}

- (void)ndl_addTapGestureWithHandler:(CommonNoParamNoReturnValueBlock)handler
{
    self.userInteractionEnabled = YES;
    
    [self associateTapGestureActionBlock:handler];// 关联tap手势action block
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTapped)];
    [self addGestureRecognizer:tap];
}

- (void)associateTapGestureActionBlock:(CommonNoParamNoReturnValueBlock)handler
{
    if (handler) {
        objc_setAssociatedObject(self, _cmd, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

#pragma mark - Gesture
- (void)viewDidTapped
{
    CommonNoParamNoReturnValueBlock block = objc_getAssociatedObject(self, @selector(associateTapGestureActionBlock:));
    
    if (block) {
        block();
    }
}

@end
