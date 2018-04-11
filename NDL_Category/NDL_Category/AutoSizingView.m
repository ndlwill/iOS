//
//  AutoSizingView.m
//  NDL_Category
//
//  Created by ndl on 2018/2/2.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "AutoSizingView.h"
#import "Masonry.h"

@implementation AutoSizingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        
        //
        UIView *childView = [[UIView alloc] initWithFrame:self.bounds];
        // 大小随着父控件变化而变化
        childView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        childView.backgroundColor = [UIColor greenColor];
        [self addSubview:childView];
        
//        UIView *childView = [[UIView alloc] init];
//        childView.backgroundColor = [UIColor greenColor];
//                [self addSubview:childView];
//        [childView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
    }
    return self;
}

@end
