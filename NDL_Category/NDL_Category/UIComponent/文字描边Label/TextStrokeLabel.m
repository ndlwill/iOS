//
//  TextStrokeLabel.m
//  NDL_Category
//
//  Created by dzcx on 2018/5/30.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TextStrokeLabel.h"

@implementation TextStrokeLabel

- (void)drawTextInRect:(CGRect)rect
{
    NSLog(@"===drawTextInRect===");
    if (self.textStrokeWidth > 0) {
        UIColor *originTextColor = self.textColor;
        CGSize originShadowOffset = self.shadowOffset;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, self.textStrokeWidth);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        
        // 画描边
        CGContextSetTextDrawingMode(context, kCGTextStroke);
        self.textColor = self.textStrokeColor;
        [super drawTextInRect:rect];
        // 画文字
        CGContextSetTextDrawingMode(context, kCGTextFill);
        self.textColor = originTextColor;
        self.shadowOffset = CGSizeZero;
        [super drawTextInRect:rect];
        
        self.shadowOffset = originShadowOffset;
    } else {
        [super drawTextInRect:rect];
    }
}

@end
