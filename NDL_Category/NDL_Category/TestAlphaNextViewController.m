//
//  TestAlphaNextViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/11/8.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestAlphaNextViewController.h"
#import "UIViewController+NavigationBarExtension.h"
#import "TestAlphaNextNextViewController.h"

@interface TestAlphaNextViewController ()

@property (nonatomic, weak) UILabel *label;

@end

@implementation TestAlphaNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"NextViewController";
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, NDLScreenW, 30)];
    label.backgroundColor = [UIColor redColor];
    label.text = @"[[UILabel alloc] initWithFrame:CGRectMake(0, 100, NDLScreenW, 30)][[UILabel alloc] initWithFrame:CGRectMake(0, 100, NDLScreenW, 30)]";
    [self.view addSubview:label];
    self.label = label;
    
    UISlider *slider = [[UISlider alloc] init];
    slider.width = 300;
    slider.center = self.view.center;
    slider.backgroundColor = [UIColor redColor];
    [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome"]];
    imageView.backgroundColor = [UIColor cyanColor];
    // 等比例缩放
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.contentMode = UIViewContentModeScaleAspectFill;// ##居中显示的##
    imageView.size = CGSizeMake(80, 80);
    [self.view addSubview:imageView];
    imageView.centerX = self.view.centerX;
    imageView.y = 500;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navItemTintColor = [UIColor redColor];
    self.navBarTintColor = [UIColor greenColor];
    self.navBarAlpha = 0.8;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"isTranslucent = %ld", [[NSNumber numberWithBool:self.navigationController.navigationBar.isTranslucent] integerValue]);
}

- (void)sliderChanged:(UISlider *)slider
{
    // test color
    self.label.backgroundColor = [UIColor ndl_interpolationColorWithFromColor:[UIColor redColor] toColor:[UIColor greenColor] percentComplete:slider.value];
    
    // test alpha
//    self.label.alpha = slider.value;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[TestAlphaNextNextViewController new] animated:YES];
}

@end
