//
//  UIGestureRecognizer+NDLBlock.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/14.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "UIGestureRecognizer+NDLBlock.h"

@implementation UIGestureRecognizer (NDLBlock)

+ (instancetype)ndl_gestureRecognizerWithActionBlock:(void(^)(UIGestureRecognizer *gesture))block
{
    return [[self alloc] initWithActionBlock:block];
}

- (instancetype)initWithActionBlock:(void(^)(UIGestureRecognizer *))block
{
    self = [self init];
    [self associateActionBlock:block];
    // Target-Action: Control objects do not (and should not) retain their targets
    // UIGestureRecognizer 是不会对 target 强引用
    [self addTarget:self action:@selector(gestureDidTriggered)];
    
    return self;
}

- (void)associateActionBlock:(GestureActionBlock)block
{
    if (block) {
        objc_setAssociatedObject(self, _cmd, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)gestureDidTriggered
{
    GestureActionBlock block = objc_getAssociatedObject(self, @selector(associateActionBlock:));
    if (block) {
        block(self);
    }
}




@end
