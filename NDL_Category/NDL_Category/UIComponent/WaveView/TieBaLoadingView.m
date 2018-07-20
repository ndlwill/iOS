//
//  TieBaLoadingView.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TieBaLoadingView.h"
#import "WaveView.h"

@interface TieBaLoadingView ()

@property (nonatomic, strong) UIImageView *needMaskImageView;
@property (nonatomic, strong) UIImageView *needMaskFrontImageView;

@property (nonatomic, strong) WaveView *maskView;
@property (nonatomic, strong) WaveView *frontMaskView;

@end

@implementation TieBaLoadingView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _setupUI];
    }
    return self;
}

#pragma mark - Private Methods
- (void)_setupUI
{
    self.layer.cornerRadius = self.width / 2.0;
    self.layer.masksToBounds = YES;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.image = [UIImage imageNamed:@"tieba_background"];
    [self addSubview:backgroundImageView];
    
    // back needMaskView
    self.needMaskImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.needMaskImageView.image = [UIImage imageNamed:@"tieba_front"];
//    self.needMaskImageView.backgroundColor = [UIColor colorWithRed:51/255.0f green:170/255.0f blue:255/255.0f alpha:1];
    [self addSubview:self.needMaskImageView];
    // maskView
    self.maskView = [[WaveView alloc] initWithFrame:self.bounds waveColors:@[[UIColor blackColor]]];
    self.maskView.progress = 0.4;
    self.needMaskImageView.maskView = self.maskView;
    
    // 为了配合下面的frontMaskView的waveSpacing 露出这个颜色
    UIView *overlayView = [[UIView alloc] initWithFrame:self.needMaskImageView.bounds];
    overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.needMaskImageView addSubview:overlayView];
    
    // front needMaskView
    self.needMaskFrontImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.needMaskFrontImageView.image = [UIImage imageNamed:@"tieba_front"];
    self.needMaskFrontImageView.backgroundColor = [UIColor colorWithRed:51/255.0f green:170/255.0f blue:255/255.0f alpha:1];// 因为图片除了字 背景都是透明的
    [self addSubview:self.needMaskFrontImageView];
    // maskView 这个需要waveSpacing
    self.frontMaskView = [[WaveView alloc] initWithFrame:self.bounds waveColors:@[[UIColor blackColor]]];
    self.frontMaskView.progress = 0.4;
    self.needMaskFrontImageView.maskView = self.frontMaskView;
}

#pragma mark - Setter
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    self.maskView.progress = progress;
    self.frontMaskView.progress = progress;
}

@end
