//
//  TestNavBarAlphaViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/11/8.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestNavBarAlphaViewController.h"
#import "UIViewController+NavigationBarExtension.h"
#import "TestAlphaNextViewController.h"

#import "UINavigationBar+NDLExtension.h"

// protocol: UIViewControllerInteractiveTransitioning
@interface TestNavBarAlphaViewController () <UINavigationControllerDelegate>

@end

@implementation TestNavBarAlphaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    // imageView
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = CGRectMake(0, 0, NDLScreenW, NDLScreenH - 70);
    [self.view addSubview:imageView];
    
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    // 设置虚化度
    effectView.alpha = 1.0;// 0.3（值越小，blur低，可见性高）, 0.0(相当于没设置)
    effectView.frame = CGRectMake(0, 70, NDLScreenW, 300);
    [imageView addSubview:effectView];
    // top
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NDLScreenW, 64)];
    topView.backgroundColor = [UIColor whiteColor];//
    [self.view addSubview:topView];
    // label
//    UILabel *textLabel = [[UILabel alloc] init];
//    textLabel.textColor = [UIColor blackColor];
//    textLabel.text = @"TestNavBar";
//    [topView addSubview:textLabel];
//    [textLabel sizeToFit];
//    textLabel.center = CGPointMake(topView.width / 2.0, topView.height / 2.0);
    // bottom
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), NDLScreenW, 70)];
    bottomView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bottomView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // barTintColor设置的不是_UIBarBackground，在默认颜色的层级基础上面多个_UIVisualEffectSubview（颜色设置在这个上面）
    // 不设置这个 有默认颜色 ，也就是_UIBarBackground层级上面多个UIVisualEffectView，UIVisualEffectView层级上面_UIVisualEffectBackdropView，_UIVisualEffectSubview（颜色设置在这个上面）

    
    // _UIBarBackground  层级上面多个UIIMageView
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage ndl_imageWithColor:[UIColor cyanColor] size:CGSizeMake(1.0, 1.0)] forBarMetrics:UIBarMetricsDefault];// 设置了 isTranslucent = 0(NO），（NO的情况下，UI会向下位移64）
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"isTranslucent = %ld", [[NSNumber numberWithBool:self.navigationController.navigationBar.isTranslucent] integerValue]);
    
    [self.navigationController.navigationBar ndl_backgroundView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[TestAlphaNextViewController new] animated:YES];
}

@end
