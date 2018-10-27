//
//  TabView.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/5.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TabView.h"

@interface TabView ()

@property (nonatomic, assign) NSUInteger curIndex;
@property (nonatomic, assign) CGFloat tabItemWidth;

@property (nonatomic, strong) UIView *maskView;

//@property (nonatomic, strong) NSMutableArray *backSubViews;
//@property (nonatomic, strong) NSMutableArray *frontSubViews;

@end

@implementation TabView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame tabTitleArray:(NSArray<NSString *> *)tabTitleArray tabTitleFont:(UIFont *)tabTitleFont
{
    if (self = [super initWithFrame:frame]) {
        [self _initialConfiguration];
        [self _setupUIWithTabTitles:tabTitleArray tabTitleFont:tabTitleFont];
    }
    return self;
}

#pragma mark - Overrides
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, _borderWidth);
//    CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
//    CGContextAddEllipseInRect(context, self.bounds);
//    CGContextStrokePath(context);
//}

#pragma mark - Private Methods
- (void)_initialConfiguration
{
    _backViewColor = [UIColor redColor];
    _frontViewColor = [UIColor whiteColor];
    _cornerRadius = self.height / 2.0;
    _borderColor = [UIColor lightGrayColor];
    _borderWidth = 1.0;
    
    _curIndex = 0;
}

- (void)_setupUIWithTabTitles:(NSArray *)tabTitleArray tabTitleFont:(UIFont *)tabTitleFont
{
    self.layer.cornerRadius = _cornerRadius;
    self.layer.masksToBounds = YES;
    
    // 这边设置 在self.bounds 外面绘制
    self.layer.borderWidth = _borderWidth;
    self.layer.borderColor = _borderColor.CGColor;
    
    _tabItemWidth = self.width / tabTitleArray.count;
    
    // backContainerView
    UIView *backContainerView = [[UIView alloc] initWithFrame:self.bounds];
    backContainerView.backgroundColor = _backViewColor;
    [self addSubview:backContainerView];
    
    for (NSInteger i = 0; i < tabTitleArray.count; i++) {
        UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * _tabItemWidth, 0, _tabItemWidth, backContainerView.height)];
        backLabel.textColor = _frontViewColor;
        backLabel.font = tabTitleFont;
        backLabel.textAlignment = NSTextAlignmentCenter;
        backLabel.text = tabTitleArray[i];
        [backContainerView addSubview:backLabel];
    }
    
    // frontContainerView
    UIView *frontContainerView = [[UIView alloc] initWithFrame:self.bounds];
    frontContainerView.backgroundColor = _frontViewColor;
    [self addSubview:frontContainerView];
    
    for (NSInteger i = 0; i < tabTitleArray.count; i++) {
        UILabel *frontTitle = [[UILabel alloc] initWithFrame:CGRectMake(i * _tabItemWidth, 0, _tabItemWidth, frontContainerView.height)];
        frontTitle.textColor = _backViewColor;
        frontTitle.font = tabTitleFont;
        frontTitle.textAlignment = NSTextAlignmentCenter;
        frontTitle.text = tabTitleArray[i];
        [frontContainerView addSubview:frontTitle];
    }
    
    // maskView
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(_curIndex * _tabItemWidth, 0, _tabItemWidth, frontContainerView.height)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.layer.cornerRadius = _cornerRadius;
    frontContainerView.maskView = self.maskView;
    
    // buttons
    for (NSInteger i = 0; i < tabTitleArray.count; i++) {
        
    }
}



@end
