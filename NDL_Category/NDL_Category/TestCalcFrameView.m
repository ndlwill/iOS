//
//  TestCalcFrameView.m
//  NDL_Category
//
//  Created by dzcx on 2019/3/5.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestCalcFrameView.h"

@interface TestCalcFrameView ()

@property (nonatomic, strong) UIView *subTestView;

@end

@implementation TestCalcFrameView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self test1];
    }
    return self;
}

// test 子view改变H
- (void)test1
{
    self.subTestView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 120, 120)];
    self.subTestView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.subTestView];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // TestCalcFrameView layoutSubviews
//        self.subTestView.height = 150;
//    });
}

// test 父子view setNeedsLayout


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSLog(@"TestCalcFrameView layoutSubviews");
}

@end
