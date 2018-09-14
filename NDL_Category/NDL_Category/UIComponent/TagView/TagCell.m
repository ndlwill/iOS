//
//  TagCell.m
//  NDL_Category
//
//  Created by dzcx on 2018/9/13.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TagCell.h"

@implementation TagCell

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _setupUI];
    }
    return self;
}

#pragma mark - private methods
- (void)_setupUI
{
    _tagLabel = [[UILabel alloc] init];
    // for test
    _tagLabel.backgroundColor = [UIColor redColor];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_tagLabel];
}

#pragma mark - setter
- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    _contentInsets = contentInsets;
    
    [self setNeedsLayout];
}

#pragma mark - overrides
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect selfbounds = self.contentView.bounds;
    self.tagLabel.width = selfbounds.size.width - self.contentInsets.left - self.contentInsets.right;
    self.tagLabel.height = selfbounds.size.height - self.contentInsets.top - self.contentInsets.bottom;
    self.tagLabel.center = self.contentView.center;
}

@end
