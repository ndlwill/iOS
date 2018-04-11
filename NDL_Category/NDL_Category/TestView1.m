//
//  TestView1.m
//  NDL_Category
//
//  Created by ndl on 2017/11/27.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import "TestView1.h"

@implementation TestView1

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    NSLog(@"MyTestView1");
}

@end
