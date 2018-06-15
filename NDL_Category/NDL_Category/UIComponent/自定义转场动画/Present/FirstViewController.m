//
//  FirstViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "FirstViewController.h"
#import "NextViewController.h"

#import "DrawerTransitionAnimator.h"

@interface FirstViewController ()

@property (nonatomic, strong) DrawerTransitionAnimator *drawerTransitionAnimator;

@end

@implementation FirstViewController

- (DrawerTransitionAnimator *)drawerTransitionAnimator
{
    if (!_drawerTransitionAnimator) {
        _drawerTransitionAnimator = [[DrawerTransitionAnimator alloc] init];
    }
    return _drawerTransitionAnimator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"ViewController" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button sizeToFit];
    button.center = self.view.center;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"===self.view.superView = %@", self.view.superview);// 被其他vc present出来的控制器的view的superView是UITransitionView
    NSLog(@"===self.view.superView.superView = %@", self.view.superview.superview);// UIWindow
}

- (void)backToViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{
    NSLog(@"===FirstViewController Dealloc===");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"FirstViewController touchesBegan");
//    [super touchesBegan:touches withEvent:event];
    
    NextViewController *vc = [[NextViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.drawerTransitionAnimator;
    [self presentViewController:vc animated:YES completion:nil];
}



@end
