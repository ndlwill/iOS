//
//  DashedLineView.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/29.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "DashedLineView.h"
#import "DrawUtils.h"

@implementation DashedLineView

- (void)drawRect:(CGRect)rect
{
    CGFloat lengths[] = {self.dashedLineSolidLength, self.dashedLineBlankLength};
    //   UIColorFromHex(@"#BFC0C5").CGColor
    [DrawUtils drawDashedLineInContext:UIGraphicsGetCurrentContext() lineWidth:self.lineWidth lineCap:kCGLineCapRound lineDashPattern:lengths lineStrokeColor:self.strokeColor.CGColor lineBeginPoint:CGPointZero lineEndPoint:CGPointMake(rect.size.width, 0.0)];
}

@end
