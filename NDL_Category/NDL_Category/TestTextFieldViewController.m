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

@interface TestTextFieldViewController () <UITextFieldDelegate>

@property (nonatomic, strong) BigTitleNavigationView *navView;

@end

@implementation TestTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    TabView *tabView = [[TabView alloc] initWithFrame:CGRectMake(0, 0, 210, 40) tabTitleArray:@[@"问吧", @"话题", @"关注"] tabTitleFont:[UIFont systemFontOfSize:17.0]];
    [self.view addSubview:tabView];
    tabView.center = self.view.center;
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
