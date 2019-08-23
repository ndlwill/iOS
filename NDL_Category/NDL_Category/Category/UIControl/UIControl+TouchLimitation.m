//
//  UIControl+TouchLimitation.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/23.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "UIControl+TouchLimitation.h"

@implementation UIControl (TouchLimitation)

- (void)setAcceptEventInterval:(CGFloat)acceptEventInterval
{
    objc_setAssociatedObject(self, @selector(acceptEventInterval), @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)acceptEventInterval
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setIgnoreEventFlag:(BOOL)ignoreEventFlag
{
    NSLog(@"setIgnoreEventFlag = %@", ignoreEventFlag ? @"YES" : @"NO");
    objc_setAssociatedObject(self, @selector(ignoreEventFlag), @(ignoreEventFlag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ignoreEventFlag
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

+ (void)load
{
    ReplaceMethod([self class], @selector(sendAction:to:forEvent:), @selector(swizzle_sendAction:to:forEvent:));
}

- (void)swizzle_sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event
{
    // action = buttonDidClicked: target = <TestTVViewController: 0x7fe860e639a0>
    NSLog(@"action = %@ target = %@", NSStringFromSelector(action), target);
    if (self.ignoreEventFlag) {
        return;
    }
    
    if (self.acceptEventInterval > 0) {
        self.ignoreEventFlag = YES;
        [self performSelector:@selector(setIgnoreEventFlag:) withObject:@(NO) afterDelay:self.acceptEventInterval];
    }
    [self swizzle_sendAction:action to:target forEvent:event];
}

@end
