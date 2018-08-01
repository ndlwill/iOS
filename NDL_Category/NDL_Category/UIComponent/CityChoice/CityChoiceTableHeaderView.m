//
//  CityChoiceTableHeaderView.m
//  DaZhongChuXing
//
//  Created by dzcx on 2018/7/26.
//  Copyright © 2018年 tony. All rights reserved.
//

#import "CityChoiceTableHeaderView.h"

@interface CityChoiceTableHeaderView ()

@property (nonatomic, strong) UIButton *locatedCityButton;
@property (nonatomic, strong) UILabel *label;

@end

@implementation CityChoiceTableHeaderView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
   if (self = [super initWithFrame:frame]) {
      _locatedCityStr = @"正在定位...";
      
      [self _setupUI];
   }
   return self;
}

#pragma mark - Private Methods
- (void)_setupUI
{
   self.locatedCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
   self.locatedCityButton.backgroundColor = UIColorFromHex(0xF7F7F7);
   self.locatedCityButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
   [self.locatedCityButton setTitleColor:UIColorFromHex(0x2C2C2C) forState:UIControlStateNormal];
   [self.locatedCityButton setTitle:self.locatedCityStr forState:UIControlStateNormal];
   [self.locatedCityButton addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
   self.locatedCityButton.enabled = NO;
   [self addSubview:self.locatedCityButton];
   self.locatedCityButton.layer.cornerRadius = 5.0;
   
   self.label = [[UILabel alloc] init];
   self.label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
   self.label.textColor = UIColorFromHex(0x9E9FA2);
   self.label.text = @"当前GPS定位";
   [self addSubview:self.label];
}

#pragma mark - Overrides
- (void)layoutSubviews
{
   [super layoutSubviews];
   
   self.locatedCityButton.frame = CGRectMake(24, 17, 91, 28);
   
   self.label.frame = CGRectMake(CGRectGetMaxX(self.locatedCityButton.frame) + 8, 0, 79, 18);
   self.label.centerY = self.locatedCityButton.centerY;
}

#pragma mark - Setter
- (void)setLocatedCityStr:(NSString *)locatedCityStr
{
   _locatedCityStr = locatedCityStr;
   
   [self.locatedCityButton setTitle:locatedCityStr forState:UIControlStateNormal];
}

#pragma mark - UIButton Actions
- (void)handleButtonClick:(UIButton *)button
{
   if (self.onLocatedCityClicked) {
      self.onLocatedCityClicked(button.titleLabel.text);
   }
}

@end
