//
//  BigTitleBaseViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/3/22.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "BigTitleBaseViewController.h"
#import "WidgetManager.h"

@interface BigTitleBaseViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation BigTitleBaseViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initializeConfiguration];
    [self _setupUI];
}

#pragma mark - private methods
- (void)_initializeConfiguration
{
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
}

- (void)_setupUI
{
    NSLog(@"BigTitleBaseViewController _setupUI");
    UIView *navigationView = [[UIView alloc] init];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(StatusBarH);
        make.height.mas_equalTo(NavigationBarH);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"common_navBack_18x18"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(navigationView);
        make.width.mas_equalTo(48.0);
    }];
    
    UILabel *titleLabel = [WidgetManager labelWithFrame:CGRectZero font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] textColor:UIColorFromHex(0x2C2C2C) textAlignment:NSTextAlignmentCenter text:self.titleStr];
    titleLabel.hidden = YES;
    [navigationView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(navigationView);
    }];
    
    [self setupMainViewWithBigTitleStr:self.titleStr referToNavigationView:navigationView];
    //  不注释:写死的主内容是scrollView
    //  注释:如果主内容是tableView，写个空方法 让子类重写 动态的让别人告诉我 主内容是什么
//    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.delegate = self;
//    if (iPhoneX) {
//        scrollView.contentInset = UIEdgeInsetsMake(0, 0, AdditionaliPhoneXBottomSafeH, 0);
//        scrollView.scrollIndicatorInsets = scrollView.contentInset;
//    }
//    [self.view addSubview:scrollView];
//    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.top.equalTo(navigationView.mas_bottom);
//    }];
//
//    UIView *contentView = [[UIView alloc] init];
//    [scrollView addSubview:contentView];
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(scrollView);
//        make.width.equalTo(scrollView);
//    }];
//
//    UIView *bigTitleWrapperView = [[UIView alloc] init];
//    [contentView addSubview:bigTitleWrapperView];
//    [bigTitleWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(contentView);
//        make.height.mas_equalTo(kBigTitleWrapperViewHeight);
//    }];
//
//    UILabel *bigTitleLabel = [WidgetManager labelWithFrame:CGRectZero font:[UIFont fontWithName:@"PingFangSC-Semibold" size:kBigTitleFontSize] textColor:UIColorFromHex(0x2C2C2C) textAlignment:NSTextAlignmentLeft text:self.titleStr];
//    [bigTitleWrapperView addSubview:bigTitleLabel];
//    [bigTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bigTitleWrapperView);
//        make.left.equalTo(bigTitleWrapperView).offset(20.0);
//        make.right.equalTo(bigTitleWrapperView).offset(-20.0);
//        make.height.mas_equalTo(40.0);
//    }];
//
//    _mainView = [[UIView alloc] init];
//    [contentView addSubview:_mainView];
//    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bigTitleWrapperView.mas_bottom);
//        make.left.right.bottom.equalTo(contentView);
//    }];
}

- (void)setupMainViewWithBigTitleStr:(NSString *)bigTitleStr referToNavigationView:(UIView *)navigationView
{
    
}

// 6.0 等价于 kBigTitleBundleMargin
- (void)_scrollAdjustmentWithScrollView:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if (contentOffsetY >= (kBigTitleFontSize + 6.0)) {
        if (self.titleLabel.hidden) {
            self.titleLabel.hidden = NO;
        }
    } else {
        if (!self.titleLabel.hidden) {
            self.titleLabel.hidden = YES;
        }
    }
}

- (void)_autoScrollAdjustmentWithScrollView:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if ((contentOffsetY > 0) && (contentOffsetY <= (6.0 + (kBigTitleFontSize / 2.0)))) {
        if (scrollView.contentSize.height - scrollView.height > (6.0 + (kBigTitleFontSize / 2.0))) {
            [scrollView setContentOffset:CGPointZero animated:YES];
        }
    } else if ((contentOffsetY > (6.0 + (kBigTitleFontSize / 2.0))) && (contentOffsetY < kBigTitleWrapperViewHeight)) {
        if (scrollView.contentSize.height - scrollView.height >= kBigTitleWrapperViewHeight) {
            [scrollView setContentOffset:CGPointMake(0, kBigTitleWrapperViewHeight) animated:YES];
        }
    }
}

#pragma mark - uicontrol actions
- (void)backButtonDidClicked:(UIButton *)pSender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
// 滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll scrollView.contentOffset.y = %lf", scrollView.contentOffset.y);
    [self _scrollAdjustmentWithScrollView:scrollView];
}

// 滚动惯性，将要减速   scrollViewDidEndDragging: willDecelerate:YES
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
{
    NSLog(@"scrollViewWillBeginDecelerating");
}

// 结束惯性滚动  willDecelerate:YES-final
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    [self _autoScrollAdjustmentWithScrollView:scrollView];
}

// 1.将要开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging scrollView.contentOffset.y = %lf", scrollView.contentOffset.y);
}

// 结束拖拽  willDecelerate:NO-final
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging decelerate = %ld scrollView.contentOffset.y = %lf", [NSNumber numberWithBool:decelerate].integerValue, scrollView.contentOffset.y);
    
    if (!decelerate) {
        [self _autoScrollAdjustmentWithScrollView:scrollView];
    }
}

@end
