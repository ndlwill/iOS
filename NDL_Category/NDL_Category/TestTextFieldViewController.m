//
//  TestTextFieldViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/3.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestTextFieldViewController.h"
#import "BigTitleNavigationView.h"
#import "TabView.h"

#import "GradientView.h"

@interface TestTextFieldViewController () <UITextFieldDelegate>

@property (nonatomic, strong) BigTitleNavigationView *navView;

@end

@implementation TestTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor cyanColor];
    
    self.navView = [[BigTitleNavigationView alloc] initWithFrame:CGRectMake(0, 100, NDLScreenW, 114)];
    self.navView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.navView];
    
    self.navView.navBarBackgroundColor = [UIColor redColor];
//    UILabel *placeholderLabel = [self.navView.textField valueForKeyPath:@"_placeholderLabel"];//null
//    NSLog(@"placeholderLabel = %@", placeholderLabel);
    
    self.navView.placeHolderStr = @"目的地";
    UILabel *placeholderLabel = [self.navView.textField valueForKeyPath:@"_placeholderLabel"];
//    placeholderLabel.backgroundColor = [UIColor blueColor];
    
    self.navView.textField.text = @"我们是广军";
    self.navView.textField.delegate = self;
    [self.navView.textField becomeFirstResponder];
    
    
//    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 500, 100, 60)];
//    backLabel.backgroundColor = [UIColor yellowColor];
//    backLabel.textAlignment = NSTextAlignmentCenter;
//    backLabel.textColor = [UIColor greenColor];
//    backLabel.text = @"今日头条";
//    [self.view addSubview:backLabel];
//
//    UILabel *frontLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 500, 100, 60)];
//    frontLabel.backgroundColor = [UIColor cyanColor];
//    frontLabel.textAlignment = NSTextAlignmentCenter;
//    frontLabel.textColor = [UIColor redColor];
//    frontLabel.text = @"今日头条";
//    [self.view addSubview:frontLabel];
//
//    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 60, 60)];
//    maskView.layer.cornerRadius = 30;
//    maskView.backgroundColor = [UIColor blueColor];
//    frontLabel.maskView = maskView;
    
    // tabView
//    TabView *tabView = [[TabView alloc] initWithFrame:CGRectMake(0, 0, 210, 40) tabTitleArray:@[@"问吧", @"话题", @"关注"] tabTitleFont:[UIFont systemFontOfSize:17.0]];
//    [self.view addSubview:tabView];
//    tabView.center = self.view.center;
    
    GradientView *gradientView = [[GradientView alloc] initWithFrame:CGRectMake(20, 400, 100, 60) colors:@[[UIColor redColor], [[UIColor redColor] colorWithAlphaComponent:0.0]] gradientDirection:GradientDirection_LeftToRight];// [[UIColor redColor] colorWithAlphaComponent:0.0]
//    gradientView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gradientView];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"should = %@", textField.beginningOfDocument);
//    [self.navView.textField selectAllText];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"did = %@", textField.beginningOfDocument);
    [self.navView.textField selectAllText];
}


@end
