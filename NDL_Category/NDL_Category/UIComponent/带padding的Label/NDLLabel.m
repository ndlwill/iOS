//
//  NDLLabel.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/18.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NDLLabel.h"

@interface NDLLabel ()

@property (nonatomic, strong) UIColor *originalBackgroundColor;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation NDLLabel

#pragma mark - Life Circle
- (void)dealloc
{
    [NotificationCenter removeObserver:self];
}

#pragma mark - Setter
- (void)setPadding:(UIEdgeInsets)padding
{
    _padding = padding;
//    [self setNeedsDisplay];
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor
{
    _highlightedBackgroundColor = highlightedBackgroundColor;
    
    self.originalBackgroundColor = self.backgroundColor;
}

- (void)setLongPressFlag:(BOOL)longPressFlag
{
    _longPressFlag = longPressFlag;
    if (longPressFlag && !self.longPressGesture) {
        self.userInteractionEnabled = YES;
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        [self addGestureRecognizer:self.longPressGesture];
        
        [NotificationCenter addObserver:self selector:@selector(menuControllerWillHide:) name:UIMenuControllerWillHideMenuNotification object:nil];
        
        if (!self.highlightedBackgroundColor) {
            self.highlightedBackgroundColor = [UIColor grayColor];
        }
    } else if (!longPressFlag && self.longPressGesture) {
        [self removeGestureRecognizer:self.longPressGesture];
        self.longPressGesture = nil;
        self.userInteractionEnabled = NO;
        [NotificationCenter removeObserver:self];
    }
}

#pragma mark - Overrides
// frame    sizeToFit走1
- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize fitSize = [super sizeThatFits:CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(self.padding), size.height - UIEdgeInsetsGetVerticalValue(self.padding))];
//    CGSize fitSize = [super sizeThatFits:size];
    
    fitSize.width += UIEdgeInsetsGetHorizontalValue(self.padding);
    fitSize.height += UIEdgeInsetsGetVerticalValue(self.padding);
    
    return fitSize;
}

// auto-layout
- (CGSize)intrinsicContentSize
{
    CGFloat preferredWidth = self.preferredMaxLayoutWidth;
    if (preferredWidth <= 0) {
        preferredWidth = CGFLOAT_MAX;
    }
    CGSize size = [self sizeThatFits:CGSizeMake(preferredWidth, CGFLOAT_MAX)];
    return size;
}

// sizeToFit走2
- (void)drawTextInRect:(CGRect)rect
{
    NSLog(@"===drawTextInRect rect = %@===", NSStringFromCGRect(rect));
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.padding)];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (self.highlightedBackgroundColor) {
        self.backgroundColor = highlighted ? self.highlightedBackgroundColor : self.originalBackgroundColor;
    }
}

- (BOOL)canBecomeFirstResponder
{
    return self.longPressGesture;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ([self canBecomeFirstResponder]) {
        return action == @selector(copyString:);
    }
    return NO;
}

#pragma mark - MenuItem Actions
- (void)copyString:(id)sender
{
    if (self.longPressFlag) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if (self.text) {
            pasteboard.string = self.text;
        }
    }
}

#pragma mark - Gesture Actions
- (void)handleLongPressGesture:(UIGestureRecognizer *)gesture
{
    if (!self.longPressFlag) {
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyString:)];
        [[UIMenuController sharedMenuController] setMenuItems:@[copyMenuItem]];
        [menuController setTargetRect:self.frame inView:self.superview];
        [menuController setMenuVisible:YES animated:YES];
        
        [self setHighlighted:YES];
    } else if (gesture.state == UIGestureRecognizerStatePossible) {
        [self setHighlighted:NO];
    }
}

#pragma mark - Notification
- (void)menuControllerWillHide:(NSNotification *)notification
{
    if (!self.longPressFlag) {
        return;
    }
    
    [self setHighlighted:NO];
}

@end
