//
//  TranNextViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/12/18.
//  Copyright © 2018 ndl. All rights reserved.
//

#import "TranNextViewController.h"

@interface TranNextViewController () <UITextFieldDelegate>

@property (nonatomic, weak) UIView *topView;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *childView1;
@property (nonatomic, strong) UIView *childView2;
@end

@implementation TranNextViewController


- (void)viewDidLoad {
    NSLog(@"TranNextViewController viewDidLoad");
    [super viewDidLoad];
    self.title = @"TranNext";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(20, TopExtendedLayoutH, self.view.width - 40, 60)];
    topView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:topView];
    topView.layer.cornerRadius = 10.0;
    self.topView = topView;
    
    self.textField = [[UITextField alloc] init];
    self.textField.placeholder = @"select address";
    self.textField.delegate = self;
//    self.textField.backgroundColor = [UIColor whiteColor];
    [topView addSubview:self.textField];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), self.view.width, self.view.height - CGRectGetMaxY(topView.frame))];
    self.bottomView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.bottomView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.bottomView.width - 40, 60)];
    self.titleLabel.text = @"TranNextViewController viewDidAppear";
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [self.bottomView addSubview:self.titleLabel];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), self.view.width, self.view.height - CGRectGetMaxY(topView.frame))];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
//    self.scrollView.userInteractionEnabled = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    self.childView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    self.childView1.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:self.childView1];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 50, 80, 40);
    btn.backgroundColor = [UIColor cyanColor];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.childView1 addSubview:btn];
    
    self.childView2 = [[UIView alloc] initWithFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
    self.childView2.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.childView2];
    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * 2, self.scrollView.height);
}

- (void)btnClicked
{
    NSLog(@"btnClicked");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"TranNextViewController viewDidAppear");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"subView = %@", self.scrollView.subviews);
        [self.scrollView setContentOffset:CGPointMake(self.view.width, 0) animated:YES];
    });
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"viewWillLayoutSubviews");
    [super viewWillLayoutSubviews];
    
    self.textField.frame = CGRectMake(10, 10, self.topView.width - 20, self.topView.height - 20);
}


@end
