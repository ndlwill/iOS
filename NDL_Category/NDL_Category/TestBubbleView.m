//
//  TestBubbleView.m
//  NDL_Category
//
//  Created by dzcx on 2019/2/21.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestBubbleView.h"
#import "DrawUtils.h"
#import "UIView+NDLTapGesture.h"


@implementation TestBubbleView

- (void)drawRect:(CGRect)rect
{
    [DrawUtils drawRightAngleBubbleFrameInContext:UIGraphicsGetCurrentContext() inRect:rect lineWidth:2.0 lineStrokeColor:[UIColor redColor].CGColor fillColor:[UIColor greenColor].CGColor cornerRadius:3.0 rightAnglePosition:BubbleFrameRightAnglePosition_LB];
}

@end
