//
//  GestureNextViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/4/10.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "GestureNextViewController.h"

#import "GestureNNViewController.h"

@interface GestureNextViewController ()

@end

@implementation GestureNextViewController

// 0
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"返回" forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor cyanColor];
//    button.bounds = CGRectMake(0, 0, 60, 44);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    NSLog(@"GestureNextViewController viewDidLoad");
}
// 2
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSLog(@"GestureNextViewController viewWillAppear vc.count = %ld", self.navigationController.viewControllers.count);
    
    // 会跳转
//    [self.navigationController pushViewController:[GestureNNViewController new] animated:YES];
}
// 4
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"GestureNextViewController viewDidAppear vc.count = %ld", self.navigationController.viewControllers.count);
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController popViewControllerAnimated:YES];
//        NSLog(@"popViewControllerAnimated vc.count = %ld", self.navigationController.viewControllers.count);
//    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"GestureNextViewController viewWillDisappear vc.count = %ld", self.navigationController.viewControllers.count);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSLog(@"GestureNextViewController viewDidDisappear vc.count = %ld", self.navigationController.viewControllers.count);
}

@end
