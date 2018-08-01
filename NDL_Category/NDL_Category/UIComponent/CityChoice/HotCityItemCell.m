//
//  HotCityItemCell.m
//  DaZhongChuXing
//
//  Created by dzcx on 2018/7/27.
//  Copyright © 2018年 tony. All rights reserved.
//

#import "HotCityItemCell.h"

@interface HotCityItemCell ()

@property (nonatomic, strong) UILabel *hotCityLabel;

@end

@implementation HotCityItemCell

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.hotCityLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.hotCityLabel.backgroundColor = UIColorFromHex(0xF7F7F7);
        self.hotCityLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.hotCityLabel.textColor = UIColorFromHex(0x2C2C2C);
        self.hotCityLabel.textAlignment = NSTextAlignmentCenter;
        self.hotCityLabel.layer.cornerRadius = 5.0;
        self.hotCityLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:self.hotCityLabel];
    }
    return self;
}

#pragma mark - Setter
- (void)setHotCityNameStr:(NSString *)hotCityNameStr
{
   _hotCityNameStr = hotCityNameStr;
   self.hotCityLabel.text = hotCityNameStr;
}

@end
