//
//  TestRotateViewController.m
//  NDL_Category
//
//  Created by ndl on 2019/11/17.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestRotateViewController.h"
#import "Rotate1ViewController.h"
#import "Rotate2ViewController.h"
#import "Rotate3ViewController.h"

@interface TestRotateViewController ()

@end

@implementation TestRotateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"rotate1" forState:UIControlStateNormal];
    [button1 setTarget:self action:@selector(button1Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    button1.frame = CGRectMake(100, 100, 60, 40);
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"rotate2" forState:UIControlStateNormal];
    [button2 setTarget:self action:@selector(button2Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    button2.frame = CGRectMake(100, 200, 60, 40);
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.backgroundColor = [UIColor redColor];
    [button3 setTitle:@"rotate3" forState:UIControlStateNormal];
    [button3 setTarget:self action:@selector(button3Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    button3.frame = CGRectMake(100, 300, 60, 40);
    
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)button1Clicked
{
    [self.navigationController pushViewController:[Rotate1ViewController new] animated:YES];
}

- (void)button2Clicked
{
    [self.navigationController pushViewController:[Rotate2ViewController new] animated:YES];
}

- (void)button3Clicked
{
    // MARK: 模态视图
    Rotate3ViewController *vc = [Rotate3ViewController new];
//    vc.modalPresentationStyle = UIModalPresentationFullScreen;// 0
//    vc.modalPresentationStyle = UIModalPresentationCustom;
//    NSLog(@"modalPresentationStyle = %ld", vc.modalPresentationStyle);// 默认:1
//    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;// over:覆盖 用于弹出透明背景的全屏控制器(ios13前的present的默认效果)
//    NSLog(@"after modalPresentationStyle = %ld", vc.modalPresentationStyle);// 5
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeLeft;
//}

@end
