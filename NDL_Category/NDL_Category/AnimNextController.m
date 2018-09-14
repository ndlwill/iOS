//
//  AnimNextController.m
//  NDL_Category
//
//  Created by dzcx on 2018/9/10.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "AnimNextController.h"
#import "BadgeView.h"
#import "MBProgressHUD+NDLExtension.h"

#import "TagView.h"

@interface AnimNextController ()

@end

@implementation AnimNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    // tagView
    TagView *tagView = [[TagView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, 0) initialDataSource:@[@"Objective-C", @"Swift", @"C", @"C++", @"Java", @"Lua", @"Python", @"JavaScript", @"MySQL", @"Redis", @"Sqlite3"]];
//    tagView.x = 0;
//    tagView.y = 44;
//    tagView.width = self.view.width;
    tagView.tagCornerRadius = 2.0;
    tagView.multipleSelectionFlag = YES;
    
    tagView.backgroundColor = [UIColor blueColor];
    NSLog(@"======before add=====");
    [self.view addSubview:tagView];
    NSLog(@"======after add=====");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [tagView addTagArray:@[@"Objective-C", @"Swift", @"C", @"C++", @"Java"]];
        [tagView deselectAll];
    });
    
    
    // test for badgeView
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MBProgressHUD ndl_showCustomViewWithImageNamed:@"info" text:@"我是信息" toView:nil];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
