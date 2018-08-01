//
//  CityChoiceSectionHeaderView.m
//  DaZhongChuXing
//
//  Created by dzcx on 2018/7/27.
//  Copyright © 2018年 tony. All rights reserved.
//

#import "CityChoiceSectionHeaderView.h"

@interface CityChoiceSectionHeaderView ()

@property (nonatomic, strong) UILabel *indexLabel;

@end

@implementation CityChoiceSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
   if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
      [self _setupUI];
   }
   return self;
}

#pragma mark - Private Methods
- (void)_setupUI
{
   UIView *backgroundView = [[UIView alloc] init];
   backgroundView.backgroundColor = [UIColor whiteColor];
   self.backgroundView = backgroundView;
   
   // 水平垂直居中
   self.indexLabel = [[UILabel alloc] init];
   self.indexLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
   self.indexLabel.textColor = [UIColorFromHex(0x2C2C2C) colorWithAlphaComponent:0.6];
   [self addSubview:self.indexLabel];
}

#pragma mark - Overrides
- (void)layoutSubviews
{
   [super layoutSubviews];
   
   self.indexLabel.x = 24;
   self.indexLabel.centerY = self.height / 2.0;
   self.indexLabel.width = self.width - 2 * 24;
   self.indexLabel.height = 18;
}

#pragma mark - Setter
- (void)setIndexStr:(NSString *)indexStr
{
   _indexStr = indexStr;
   
   self.indexLabel.text = indexStr;
}

@end
