//
//  AutoCalcSizeView.m
//  NDL_Category
//
//  Created by dzcx on 2019/3/4.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "AutoCalcSizeView.h"

@implementation AutoCalcSizeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.backgroundColor = [UIColor cyanColor];
        [self addSubview:self.imageView];
        
        self.label = [[UILabel alloc] init];
        self.label.font = [UIFont systemFontOfSize:14];
        self.label.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews
{
    NSLog(@"AutoCalcSizeView layoutSubviews#####");
    [super layoutSubviews];
    
    self.imageView.size = CGSizeMake(60, 60);
    self.imageView.y = 10;
    self.imageView.centerX = self.width / 2.0;
    
    [self.label sizeToFit];
    if (CGSizeEqualToSize(self.label.size, CGSizeZero)) {
        self.height = 80;
    } else {
        self.label.y = CGRectGetMaxY(self.imageView.frame) + 10;
        self.label.centerX = self.width / 2.0;
        
        self.height = CGRectGetMaxY(self.label.frame) + 10;
    }
}

- (void)setLabelText:(NSString *)text
{
    self.label.text = text;
    
    [self setNeedsLayout];
}

@end
