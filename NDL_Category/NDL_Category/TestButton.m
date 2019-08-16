//
//  TestButton.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/8.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestButton.h"

@implementation TestButton

@dynamic testName;

+ (void)initialize
{
    NSLog(@"TestButton initialize");
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    NSLog(@"TestButton drawRect");
}

- (NSString *)testName
{
    return @"234";
}

- (void)setTestName:(NSString *)testName
{
    
}

@end
