//
//  DrawRectView.m
//  NDL_Category
//
//  Created by ndl on 2019/11/2.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "DrawRectView.h"

@implementation DrawRectView

- (void)drawRect:(CGRect)rect {
    NSLog(@"DrawRectView: %@", [NSThread currentThread]);// main
    
}


@end
