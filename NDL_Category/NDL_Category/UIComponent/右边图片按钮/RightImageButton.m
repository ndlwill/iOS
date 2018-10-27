//
//  RightImageButton.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/3.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "RightImageButton.h"

@implementation RightImageButton

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"===RightImageButton initWithFrame===");
        [self _initialConfigure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        NSLog(@"===RightImageButton initWithCoder===");
        [self _initialConfigure];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"===RightImageButton awakeFromNib===");
}

#pragma mark - Private Methods
- (void)_initialConfigure
{
    self.backgroundColor = [UIColor yellowColor];
//    self.titleImageSpace = 0.0;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark - Setter


#pragma mark - Overrides
// setTitle会 先走===TestWebViewController viewDidLayoutSubviews===再走===RightImageButton layoutSubviews===
// 改变self.frame会走这个
// frame 或者 约束 都会走这个
- (void)layoutSubviews
{
    // 不能在layoutSubviews中改变frame 死循环会一直调layoutSubviews
    [super layoutSubviews];
    NSLog(@"===RightImageButton layoutSubviews self.frame:%@ title:%@ image:%@===", NSStringFromCGRect(self.bounds), self.titleLabel.text, self.imageView.image);// 这边肯定拿到真正的frame
    // common(normal)Button
    NSString *text = self.titleLabel.text;
    if ([text isEqualToString:@""] || text == nil || self.imageView.image == nil) {
        NSLog(@"#####return#####");
        return;
    }
    
    // rightImage
    // 调整文字
    self.titleLabel.x = 0;
//    self.titleLabel.centerY = self.height / 2.0;
    // 调整图片
    CGFloat imageW = self.imageView.image.size.width;
    self.imageView.x = self.width - imageW;
//    self.imageView.centerY = self.height / 2.0;
}

@end
