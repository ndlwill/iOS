//
//  AnimNextController.m
//  NDL_Category
//
//  Created by dzcx on 2018/9/10.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "AnimNextController.h"
#import "BadgeView.h"

@interface AnimNextController ()

@end

@implementation AnimNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60, 300, 120, 120)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    
    [BadgeView appearance].badgeBackgroundColor = [UIColor redColor];
    BadgeView *badgeView = [[BadgeView alloc] initWithParentView:view alignment:BadgeViewAlignment_TopRight];
    badgeView.badgeStrokeWidth = 2.0;
    badgeView.badgeStrokeColor = [UIColor whiteColor];
    badgeView.badgeMinWH = 12;
//    badgeView.badgeText = @"6";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
