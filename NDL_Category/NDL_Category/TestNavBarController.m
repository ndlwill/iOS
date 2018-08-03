//
//  TestNavBarController.m
//  NDL_Category
//
//  Created by dzcx on 2018/8/3.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestNavBarController.h"

@interface TestNavBarController ()

@property (nonatomic, weak) UIView *firstView;

@end

@implementation TestNavBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.firstView = self.navigationController.navigationBar.subviews.firstObject;
    
    self.title = @"TestNavBar";
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];// 默认显示
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.firstView.alpha = 0;
//}




@end
