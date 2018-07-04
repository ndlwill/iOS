//
//  TestTextFieldViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/3.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestTextFieldViewController.h"
#import "BigTitleNavigationView.h"

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
