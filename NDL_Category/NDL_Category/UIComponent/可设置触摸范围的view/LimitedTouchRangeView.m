//
//  LimitedTouchRangeView.m
//  NDL_Category
//
//  Created by dzcx on 2018/12/28.
//  Copyright © 2018 ndl. All rights reserved.
//

#import "LimitedTouchRangeView.h"

@implementation LimitedTouchRangeView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.touchRangeRect = self.bounds;
    }
    return self;
}

#pragma mark - setter
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.touchRangeRect = self.bounds;
}

#pragma mark - overrides
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.touchRangeRect, point)) {
        return [super pointInside:point withEvent:event];
    } else {
        return NO;
    }
}

@end
