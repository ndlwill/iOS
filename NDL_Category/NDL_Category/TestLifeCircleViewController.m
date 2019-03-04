//
//  TestLifeCircleViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/1/21.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestLifeCircleViewController.h"

#import "TestLifeCircleView.h"

@interface TestLifeCircleViewController ()

@property (nonatomic, strong) TestLifeCircleView *lifeCircleView;

@end

@implementation TestLifeCircleViewController

- (TestLifeCircleView *)lifeCircleView
{
    if (!_lifeCircleView) {
        _lifeCircleView = [[TestLifeCircleView alloc] initWithFrame:CGRectMake(20, 100, 100, 100)];
        _lifeCircleView.backgroundColor = [UIColor greenColor];
    }
    return _lifeCircleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view addSubview:self.lifeCircleView];// TestLifeCircleViewController viewWillLayoutSubviews & viewDidLayoutSubviews + lifeCircleView layoutSubviews
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // vc.view
//    self.view.height = 600;// TestLifeCircleViewController viewWillLayoutSubviews & viewDidLayoutSubviews
    
    // subView
//    self.lifeCircleView.width = 120;// lifeCircleView layoutSubviews
//    self.lifeCircleView.y = 150;// 不调lifeCircleView layoutSubviews
    
    [self.lifeCircleView removeFromSuperview];// TestLifeCircleViewController viewWillLayoutSubviews & viewDidLayoutSubviews
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    NSLog(@"TestLifeCircleViewController viewWillLayoutSubviews");
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    NSLog(@"TestLifeCircleViewController viewDidLayoutSubviews");
}

@end
