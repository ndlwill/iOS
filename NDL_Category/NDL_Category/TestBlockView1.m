//
//  TestBlockView1.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/2.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestBlockView1.h"

@implementation TestBlockView1

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor greenColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"按钮" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        [self addSubview:btn];
    }
    return self;
}

- (void)btnClicked
{
    if (self.block) {
        self.block();
    }
}

- (void)dealloc
{
    NSLog(@"TestBlockView1 dealloc");
}

@end
