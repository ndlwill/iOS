//
//  TestLifeCircleAutoLayoutViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/3/4.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestLifeCircleAutoLayoutViewController.h"

#import "TestAutoLayoutView.h"

@interface TestLifeCircleAutoLayoutViewController ()

@property (nonatomic, strong) TestAutoLayoutView *testAutoLayoutView;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation TestLifeCircleAutoLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.testAutoLayoutView = [[TestAutoLayoutView alloc] init];
    [self.view addSubview:self.testAutoLayoutView];
    [self.testAutoLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view);
    }];
    
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.testAutoLayoutView.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.width.height.mas_equalTo(100);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"TestLifeCircleAutoLayoutViewController after 3.0");
        
        if (true) {
            
            [self.testAutoLayoutView updateLabelLayout];
            /*
             
             TestLifeCircleAutoLayoutViewController viewWillLayoutSubviews#####
             TestAutoLayoutView layoutSubviews labelH = 17.000000
             */
            self.testAutoLayoutView.label.text = @"ndlwill";
        }
    });
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"TestLifeCircleAutoLayoutViewController viewWillLayoutSubviews#####");
    [super viewWillLayoutSubviews];
    
    
}


@end
