//
//  ThirdViewController.m
//  NDL_Category
//
//  Created by ndl on 2017/11/18.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import "ThirdViewController.h"
#import "ViewController.h"
#import "SecondViewController.h"
#import "UIViewController+NDLExtension.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "Masonry.h"


@interface ThirdViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *greenView;

@property (nonatomic, strong) UIView *blueView;

@property (nonatomic, strong) UIView *middleView;

@end

@implementation ThirdViewController

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.bounces = YES;
        _scrollView.backgroundColor = [UIColor lightGrayColor];
    }
    return _scrollView;
}

- (UIView *)greenView
{
    if (!_greenView) {
        _greenView = [[UIView alloc] init];
        _greenView.backgroundColor = [UIColor greenColor];
    }
    return _greenView;
}

- (UIView *)blueView
{
    if (!_blueView) {
        _blueView = [[UIView alloc] init];
        _blueView.backgroundColor = [UIColor blueColor];
    }
    return _blueView;
}

- (UIView *)middleView
{
    if (!_middleView) {
        _middleView = [[UIView alloc] init];
        _middleView.backgroundColor = [UIColor cyanColor];
    }
    return _middleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.title = @"Third";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
    //self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.scrollView.bounds.size.height * 2);
    
    //self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 1000);
    
    [self.scrollView addSubview:self.greenView];
    self.scrollView.backgroundColor = [UIColor cyanColor];
    [self.greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView);
        make.right.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView.bounds.size.width);
        make.height.mas_equalTo(900);
    }];
    
    //self.blueView.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, 100);
    //[self.scrollView addSubview:self.blueView];
    
    
    //self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.scrollView.bounds.size.height * 2);
    //self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 1000);
//    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(self.blueView.frame) + 50);
    
    
    
    
    NSDate *nowDate = [NSDate date];
    NSDate *testDate = [NSDate dateWithTimeIntervalSinceNow:30];
    
    NSLog(@"now = %@ testDate = %@", nowDate, testDate);
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor redColor];
//    [button setTitle:@"返回" forState:UIControlStateNormal];
//
//    //button.size = CGSizeMake(70, 30);
//
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    
//            [button sizeToFit];
//    // 让按钮的内容往左边偏移10  内边距
//    //button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);//tlbr
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    //禁止导航栏的滑动返回
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}


- (ALAssetsGroupEnumerationResultsBlock)getGroupEnumerBlock
{
    ALAssetsGroupEnumerationResultsBlock groupEnumerBlock = ^(ALAsset *result,NSUInteger index,BOOL *stop){
        
    };
    
    return groupEnumerBlock;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    
    
}

- (void)back
{
        //[self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self ndl_popToViewController:[SecondViewController class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
