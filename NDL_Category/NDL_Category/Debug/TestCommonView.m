//
//  TestCommonView.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/29.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestCommonView.h"

@implementation TestCommonView

- (instancetype)initWithFrame:(CGRect)frame
{
    NSLog(@"TestCommonView initWithFrame");
    if (self = [super initWithFrame:frame]) {
        [self _setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"TestCommonView initWithCoder");
    if (self = [super initWithCoder:aDecoder]) {
        [self _setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"TestCommonView awakeFromNib");
    [super awakeFromNib];
    
}

#pragma mark - Private Methods
- (void)_setupUI
{
    
}

@end
