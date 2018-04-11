//
//  LongPressLabel.m
//  NDL_Category
//
//  Created by ndl on 2017/12/5.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import "LongPressLabel.h"

@implementation LongPressLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addLongPressGesture];
    }
    return self;
}

- (void)addLongPressGesture
{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressed:)];
    [self addGestureRecognizer:longPressGesture];
}


- (void)didLongPressed:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            //NSLog(@"UIGestureRecognizerStateBegan");
            [self showMenuController];
            break;
        case UIGestureRecognizerStateChanged:
            //NSLog(@"UIGestureRecognizerStateChanged");
            break;
        case UIGestureRecognizerStateEnded:
            //NSLog(@"UIGestureRecognizerStateEnded");
            break;
            
        default:
            break;
    }
}

- (void)showMenuController
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController.isMenuVisible) {
        //[menuController setMenuVisible:NO animated:YES];
        return;
    } else {
        [self becomeFirstResponder];
        
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(onCopy)];
        UIMenuItem *pasteItem = [[UIMenuItem alloc] initWithTitle:@"粘贴" action:@selector(onPaste)];
        UIMenuItem *cutItem = [[UIMenuItem alloc] initWithTitle:@"剪切" action:@selector(onCut)];
        
        menuController.menuItems = @[copyItem, pasteItem, cutItem];
        menuController.arrowDirection = UIMenuControllerArrowUp;
        
        [menuController setTargetRect:self.bounds inView:self];
        
//        CGRect rect = CGRectMake(0, self.frame.size.height * 0.5, self.frame.size.width, self.frame.size.height * 0.5);
//        [menuController setTargetRect:rect inView:self];
        [menuController setMenuVisible:YES animated:YES];
    }
    
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSLog(@"canPerformAction:%@ sender:%@", NSStringFromSelector(action), sender);
    if (action == @selector(onCopy) ||
        action == @selector(onCut) ||
        (action == @selector(onPaste) && [UIPasteboard generalPasteboard].string)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)onCopy
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.text;
    NSLog(@"%@", pasteBoard.string);
}

- (void)onPaste
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSLog(@"%@", pasteBoard.string);
}

- (void)onCut
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.text;
    self.text = nil;
    NSLog(@"%@", pasteBoard.string);
}
@end
