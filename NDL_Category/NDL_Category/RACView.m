//
//  RACView.m
//  NDL_Category
//
//  Created by dzcx on 2018/8/3.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "RACView.h"

@implementation RACView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.delegateSignal) {
        [self.delegateSignal sendNext:@""];
    }
}

- (void)buttonDidClicked:(UIButton *)button
{
    // 空实现（只定义方法）
}
@end
