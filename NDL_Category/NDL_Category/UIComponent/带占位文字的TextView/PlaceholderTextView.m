//
//  PlaceholderTextView.m
//  NDL_Category
//
//  Created by dzcx on 2018/3/13.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "PlaceholderTextView.h"
#import "UIView+NDLExtension.h"

@interface PlaceholderTextView ()

/** 占位文字label */
@property (nonatomic, weak) UILabel *placeholderLabel;//label的文字默认垂直居中

@end

@implementation PlaceholderTextView

#pragma mark - Lazy Load
- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        // 添加一个用来显示占位文字的label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.backgroundColor = [UIColor redColor];// for test
        placeholderLabel.textAlignment = NSTextAlignmentCenter;
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.x = 5;
        
        // for PlaceholderAlignment_Top
        // x=4 y=7
//        placeholderLabel.x = 5;
//        placeholderLabel.y = 8;
        
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 垂直方向上永远有弹簧效果
        self.alwaysBounceVertical = YES;
        
        // 默认的占位文字颜色
        self.placeholderColor = [UIColor grayColor];
        
        // 默认字体
        self.font = [UIFont systemFontOfSize:15];
        
        // 监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_placeholderAlignment == PlaceholderAlignment_Top) {
        [self.placeholderLabel sizeToFit];
        self.placeholderLabel.y = 8;
    } else if (_placeholderAlignment == PlaceholderAlignment_Center) {
//        self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
//        // 多行需先设置width 再sizeToFit
//        [self.placeholderLabel sizeToFit];//sizeToFit 不设置宽度，只计算一行的宽高
//        self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
        
        NSLog(@"size = %@", NSStringFromCGRect(self.placeholderLabel.frame));
        
        self.placeholderLabel.centerY = self.height / 2;
    }
    
    
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification
/**
 * 监听文字改变
 */
- (void)textDidChange
{
    // 只要有文字, 就隐藏占位文字label
    self.placeholderLabel.hidden = self.hasText;
}


#pragma mark - Setter
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    
    [self setNeedsLayout];//在恰当的时候调  layoutSubviews
}

- (void)setPlaceholderAlignment:(PlaceholderAlignment)placeholderAlignment
{
    _placeholderAlignment = placeholderAlignment;
    
    [self setNeedsLayout];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];

    self.placeholderLabel.font = font;

    //[self updatePlaceholderLabelSize];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

#pragma mark - Private Methods
//- (void)updatePlaceholderLabelSize
//{
//    CGSize maxSize = CGSizeMake(self.width - 2 * self.placeholderLabel.x, MAXFLOAT);
//    self.placeholderLabel.size = [self.placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
////    if (_placeholderAlignment == PlaceholderAlignment_Top) {
////
////    } else if (_placeholderAlignment == PlaceholderAlignment_Center) {
////
////    }
//}

@end
