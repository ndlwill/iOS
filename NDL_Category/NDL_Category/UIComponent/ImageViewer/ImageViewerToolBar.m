//
//  ImageViewerToolBar.m
//  NDL_Category
//
//  Created by dzcx on 2018/11/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "ImageViewerToolBar.h"

@interface ImageViewerToolBar ()

@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation ImageViewerToolBar

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
    CGFloat edgeSpace = 5.0;
    CGFloat itemWidth = 50.0;
    CGFloat itemHeight = 28.0;
    
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _indexLabel.layer.cornerRadius = 5.0;
    _indexLabel.layer.masksToBounds = YES;
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.font = UISystemFontMake(16.0);
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_indexLabel];
    _indexLabel.x = edgeSpace;
    _indexLabel.width = itemWidth;
    _indexLabel.height = itemHeight;
    _indexLabel.centerY = self.height / 2.0;
    
//    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _saveBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//    _saveBtn.layer.cornerRadius = 5.0;
//    _saveBtn.layer.masksToBounds = YES;
//    _saveBtn.titleLabel.font = UISystemFontMake(16.0);
//    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
//    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_saveBtn addTarget:self action:@selector(saveButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_saveBtn];
//    _saveBtn.x = self.width - edgeSpace - itemWidth;
//    _saveBtn.width = itemWidth;
//    _saveBtn.height = itemHeight;
//    _saveBtn.centerY = self.height / 2.0;
    
    self.alpha = 0.0;
}

#pragma mark - uicontrol actions
- (void)saveButtonDidClicked:(UIButton *)button
{
    if (self.saveBlock) {
        self.saveBlock();
    }
}

#pragma mark - public methods
- (void)showWithAnimationDuration:(CGFloat)duration
{
    if (duration <= 0) {
        self.alpha = 1.0;
    } else if (duration > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.alpha = 1.0;
        }];
    }
}

- (void)hideWithAnimationDuration:(CGFloat)duration
{
    if (duration <= 0) {
        self.alpha = 0.0;
    } else if (duration > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.alpha = 0.0;
        }];
    }
}

@end
