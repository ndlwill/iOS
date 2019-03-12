//
//  TestAutoLayoutView.m
//  NDL_Category
//
//  Created by dzcx on 2019/3/4.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestAutoLayoutView.h"

@interface TestAutoLayoutView ()

@property (nonatomic, strong) UIView *testView;


@end

@implementation TestAutoLayoutView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor yellowColor];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.backgroundColor = [UIColor cyanColor];
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(100);
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
        }];
        
//        self.testView = [[UIView alloc] init];
//        self.testView.backgroundColor = [UIColor blueColor];
//        [self addSubview:self.testView];
//        [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.imageView.mas_bottom).offset(10);
//            make.width.height.mas_equalTo(60);
//            make.centerX.equalTo(self);
//            make.bottom.equalTo(self).offset(-10);
//        }];
        
        self.label = [[UILabel alloc] init];
        self.label.font = [UIFont systemFontOfSize:14.0];
        self.label.backgroundColor = [UIColor greenColor];
        [self addSubview:self.label];

        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            NSLog(@"label mas");
            make.top.equalTo(self.imageView.mas_bottom).offset(10);
            make.centerX.equalTo(self);
//            make.height.mas_equalTo(30);
            make.bottom.equalTo(self).offset(0);
        }];
    }
    return self;
}

- (void)updateLabelLayout
{
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSLog(@"TestAutoLayoutView layoutSubviews labelH = %lf", self.label.height);
}


@end
