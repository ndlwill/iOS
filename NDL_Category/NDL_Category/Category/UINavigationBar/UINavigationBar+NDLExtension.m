//
//  UINavigationBar+NDLExtension.m
//  NDL_Category
//
//  Created by dzcx on 2019/4/8.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "UINavigationBar+NDLExtension.h"

@implementation UINavigationBar (NDLExtension)

- (UIView *)ndl_backgroundView
{
    // _backgroundView  [[self subviews] firstObject]
    UIView *backgroundView = nil;
    if (@available(iOS 10.0, *)) {
        // _UIBarBackground.UIVisualEffectView H = 64
        backgroundView = [self valueForKeyPath:@"_backgroundView._backgroundEffectView"];
    } else {
        backgroundView = [self valueForKey:@"_backgroundView"];
    }
    NSLog(@"firstObject = %@ _backgroundView = %@ _backgroundEffectView = %@", self.subviews.firstObject, [self valueForKeyPath:@"_backgroundView"], backgroundView);
    return backgroundView;
}

- (CGFloat)ndl_backgroundOpacity
{
    return [[self valueForKey:@"__backgroundOpacity"] doubleValue];
}

@end
