//
//  TestMaskView.m
//  NDL_Category
//
//  Created by dzcx on 2019/1/4.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestMaskView.h"

@implementation TestMaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 80, 120, 120)];
        backgroundImageView.image = [UIImage imageNamed:@"tieba_background"];// 蓝色
        [self addSubview:backgroundImageView];
        
        // back needMaskView
        UIImageView *needMaskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 80, 120, 120)];
        needMaskImageView.image = [UIImage imageNamed:@"tieba_front"];
        [self addSubview:needMaskImageView];

//        // maskView
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 120)];
        lineView.backgroundColor = [UIColor blackColor];
        needMaskImageView.maskView = lineView;
        
        [UIView animateWithDuration:5.0 animations:^{
            lineView.x = 120;
        }];

    }
    return self;
}



@end
