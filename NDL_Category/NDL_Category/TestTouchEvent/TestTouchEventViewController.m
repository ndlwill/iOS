//
//  TestTouchEventViewController.m
//  NDL_Category
//
//  Created by youdone-ndl on 2020/8/7.
//  Copyright © 2020 ndl. All rights reserved.
//

#import "TestTouchEventViewController.h"
#import "TestEventView.h"

/**
 UIWindow:
 - (void)sendEvent:(UIEvent *)event;                    // called by UIApplication to dispatch events to views inside the window
 */

@interface TestTouchEventViewController ()

@end

@implementation TestTouchEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    TestEventView *eventView = [[TestEventView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    eventView.backgroundColor = [UIColor redColor];
    [self.view addSubview:eventView];
}

// 1.eventView.userInteractionEnabled = NO; 点击TestEventView，TestEventView不响应，self 响应
// 2.TestEventView写[super touchesBegan:touches withEvent:event]; 先打印===TestTouchEventViewController touchesBegan===，再打印TestEventView touchesBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"===TestTouchEventViewController touchesBegan===");
}

@end
