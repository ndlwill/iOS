//
//  UIButton+NDLBlock.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/19.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "UIButton+NDLBlock.h"

@implementation UIButton (NDLBlock)

- (void)addActionBlock:(void (^)(UIButton *pSender))block
{
    [self associateActionBlock:block];// 关联block
    [self addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)associateActionBlock:(void (^)(UIButton *pSender))block
{
    if (block) {
        objc_setAssociatedObject(self, _cmd, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

#pragma mark - UIButton Actions
- (void)buttonDidClicked:(UIButton *)pSender
{
    void (^block)(UIButton *pSender) = objc_getAssociatedObject(self, @selector(associateActionBlock:));
    
    if (block) {
        block(pSender);
    }
}

@end
