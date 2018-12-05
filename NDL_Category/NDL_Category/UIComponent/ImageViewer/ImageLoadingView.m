//
//  ImageLoadingView.m
//  NDL_Category
//
//  Created by dzcx on 2018/11/23.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "ImageLoadingView.h"

static CGFloat const selfWH = 80.0;

@interface ImageLoadingView ()

@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation ImageLoadingView

#pragma mark - class methods
+ (instancetype)showInView:(UIView *)parentView
{
    if (!parentView) {
        parentView = KeyWindow;
    }
    
    ImageLoadingView *loadingView = [[ImageLoadingView alloc] initWithFrame:CGRectMake(0, 0, selfWH, selfWH)];
    loadingView.center = CGPointMake(parentView.width / 2.0, parentView.height / 2.0);
    [parentView addSubview:loadingView];
    
    return loadingView;
}

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
    CGFloat labelWH = selfWH / 2.0;
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWH, labelWH)];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.textColor = [UIColor whiteColor];
    self.progressLabel.font = [UIFont systemFontOfSize:16.0];
    self.progressLabel.center = CGPointMake(labelWH, labelWH);
    self.progressLabel.text = @"0%";
    [self addSubview:self.progressLabel];
    
    CGFloat lineWidth = 3.0;
    CGFloat radius = labelWH - lineWidth / 2.0;
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:self.progressLabel.center radius:radius startAngle:-M_PI_2 endAngle:(3.0 / 2 * M_PI) clockwise:YES];
    
    // bgLayer
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.frame = self.bounds;
    bgLayer.fillColor = [UIColor clearColor].CGColor;
    bgLayer.strokeColor = [UIColor colorWithRed:50.0 / 255.0f green:50.0 / 255.0f blue:50.0 / 255.0f alpha:1].CGColor;
    bgLayer.lineWidth = lineWidth;
    bgLayer.path = arcPath.CGPath;
    bgLayer.strokeEnd = 1.0;
    [self.layer addSublayer:bgLayer];
    
    // progressLayer
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.frame = self.bounds;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.progressLayer.lineWidth = lineWidth;
    self.progressLayer.path = arcPath.CGPath;
    self.progressLayer.strokeEnd = 0;
    [self.layer addSublayer:self.progressLayer];
}

#pragma mark - setter
- (void)setProgress:(CGFloat)progress
{
    // 0-1
    _progress = MAX(progress, 0);
    _progress = MIN(_progress, 1);
    
    self.progressLabel.text = [NSString stringWithFormat:@"%.0lf%%", _progress * 100];
    self.progressLayer.strokeEnd = _progress;
}

@end
