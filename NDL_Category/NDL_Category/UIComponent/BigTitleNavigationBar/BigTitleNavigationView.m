//
//  BigTitleNavigationView.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/29.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "BigTitleNavigationView.h"

@interface BigTitleNavigationView ()

@property (nonatomic, strong) UIView *navBarView;
@property (nonatomic, strong) UILabel *bigTitleLabel;

@end

@implementation BigTitleNavigationView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self _setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // IBInspectable设置了 这边有值
    NSLog(@"awakeFromNib navBarBackgroundColor = %@", self.navBarBackgroundColor);
}

#pragma mark - Private Methods
- (void)_setupUI
{
    // IBInspectable设置了 这边为null
    NSLog(@"_setupUI navBarBackgroundColor = %@", self.navBarBackgroundColor);
    
    // navBarView
    self.navBarView = [[UIView alloc] init];
    //   self.navBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.navBarView];
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(TopExtendedLayoutH);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"common_navBack_18x18"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBarView).offset(StatusBarH);
        make.left.equalTo(self.navBarView);
        make.width.mas_equalTo(kNavBackButtonWidth);
        make.height.mas_equalTo(NavigationBarH);
    }];
    
    // bigTitleContainerView
    UIView *bigTitleContainerView = [[UIView alloc] init];
    [self addSubview:bigTitleContainerView];
    [bigTitleContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBarView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kNavBigTitleContainerViewHeight);
    }];
    
    self.bigTitleLabel = [[UILabel alloc] init];
    self.bigTitleLabel.textColor = BigTitleTextColor;
    self.bigTitleLabel.font = BigTitleFont;
    self.bigTitleLabel.textAlignment = NSTextAlignmentLeft;
    [bigTitleContainerView addSubview:self.bigTitleLabel];
    [self.bigTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bigTitleContainerView.mas_top);
        make.left.equalTo(bigTitleContainerView).offset(kNavBigTitleLeadingToLeftEdge);
        make.right.equalTo(bigTitleContainerView).offset(-kNavBigTitleLeadingToLeftEdge);
        make.height.mas_equalTo(kNavBigTitleHeight);
    }];
    
    // lineView
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromHex(0xE1E1E1);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - UIButton Actions
- (void)backButtonDidClicked
{
    if (self.backBlock) {
        self.backBlock();
    }
}

#pragma mark - Setter
- (void)setNavBarBackgroundColor:(UIColor *)navBarBackgroundColor
{
    _navBarBackgroundColor = navBarBackgroundColor;
    self.navBarView.backgroundColor = navBarBackgroundColor;
}

- (void)setBigTitleStr:(NSString *)bigTitleStr
{
    _bigTitleStr = [bigTitleStr copy];
    self.bigTitleLabel.text = bigTitleStr;
}

@end
