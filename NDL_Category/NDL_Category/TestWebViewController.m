//
//  TestWebViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/28.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestWebViewController.h"
#import "TestBlockView1.h"
#import "TestBlockView2.h"
#import "RightImageButton.h"

@interface TestWebViewController ()

@property (nonatomic, strong) TestBlockView1 *view1;

@property (nonatomic, strong) TestBlockView2 *view2;

@property (nonatomic, weak) UIButton *btn;

@property (nonatomic, strong) RightImageButton *riBtn;

@end

@implementation TestWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"TestWebViewController viewDidLoad");
    self.view.backgroundColor = [UIColor grayColor];
    
//    self.navigationController.navigationBar.alpha = 1;
    
    UISegmentedControl *segmentedCtl = [[UISegmentedControl alloc] initWithItems:@[@"我们", @"傻逼"]];
    segmentedCtl.width = 100;
    segmentedCtl.height = 40;
    segmentedCtl.tintColor = [UIColor greenColor];
    segmentedCtl.backgroundColor = [UIColor redColor];
    self.navigationItem.titleView = segmentedCtl;
    
//    self.navigationController.navigationBar.translucent = YES;
    
    // =====test rightImageButton=====
    /*
    self.riBtn = [RightImageButton buttonWithType:UIButtonTypeCustom];
    [self.riBtn setTitle:@"上海" forState:UIControlStateNormal];
    [self.riBtn setImage:[UIImage imageNamed:@"common_close_20x20"] forState:UIControlStateNormal];
    [self.view addSubview:self.riBtn];
    // frame 比 autoLayout效率高 少调用===TestWebViewController viewDidLayoutSubviews===等一系列
    // frame
//    [self.riBtn sizeToFit];
    // autoLayout
    [self.riBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);// 约束包裹
    }];
    */
    
    // =====test button=====
    /*
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"common_close_20x20"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    // frame 必须写sizeToFit
//    [btn sizeToFit];
//    btn.width += 8;
    // autoLayout 不需要设置宽高，包裹
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view);
        make.width.mas_equalTo(70);// 62 + space  sizeToFit:width = 61
    }];
    self.btn = btn;
    [btn ndl_convertToRightImageButtonWithSpace:8.0];
    */
    
    
    
    // dealloc顺序 self->TestBlockView2->TestBlockView1
    // =====test block=====
    /*
    self.view1 = [[TestBlockView1 alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.view1];
    WeakSelf(weakSelf)
    self.view1.block = ^{
        StrongSelf(strongSelf, weakSelf)
        strongSelf.view.backgroundColor = [UIColor cyanColor];
        
        __weak typeof(strongSelf) wSelf = strongSelf;
        strongSelf.view2 = [[TestBlockView2 alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
        strongSelf.view2.backgroundColor = [UIColor yellowColor];
        strongSelf.view2.block = ^{
            __strong typeof(wSelf) sSelf = wSelf;
            sSelf.view.backgroundColor = [UIColor purpleColor];
        };
        [strongSelf.view addSubview:strongSelf.view2];
    };
    */

    
//    [self _testForInherit];// for test
    
//    [self setStatusBarStyle:UIStatusBarStyleLightContent];// 执行superClass的setter
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // frame
//    [self.riBtn setTitle:@"我们是他们的伤害" forState:UIControlStateNormal];
//    [self.riBtn sizeToFit];
    
    // autoLayout
//    [self.riBtn setTitle:@"我们是他们的伤害" forState:UIControlStateNormal];
}

- (void)dealloc
{
    NSLog(@"===TestWebViewController dealloc===");
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    NSLog(@"===TestWebViewController viewDidLayoutSubviews===");
//    [self.btn ndl_convertToRightImageButtonWithSpace:8.0];
    
//    NSLog(@"viewDidLayoutSubviews riBtnFrame = %@", NSStringFromCGRect(self.riBtn.frame));
    //autoLayout viewDidLayoutSubviews self.riBtn能到了真正的frame
    
    // 调整titlwImageSpace 有bug button不在self.view的center了
//    self.riBtn.width += 8.0;// 调用===RightImageButton layoutSubviews===使得===RightImageButton layoutSubviews===的width加了8
    
    // 针对autoLayout约束 解决button不在self.view的center了
    [self.riBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.riBtn.width + 8.0);
    }];
    // 针对frame 通过sizeToFit + center解决
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // {{0, 64}, {375, 603}}  translucent = 0
    // {{0, 0}, {375, 667}}   translucent = 1
    NSLog(@"viewDidAppear self.view.frame = %@", NSStringFromCGRect(self.view.frame));
}

#pragma mark - Overrides
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    NSLog(@"TestWebViewController method:preferredStatusBarStyle");
//    return self.statusBarStyle;
//}

//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}



//- (void)_testForInherit
//{
//    [super _testForInherit];// Base _testForInherit
//    NSLog(@"TestWebViewController _testForInherit");
//}


@end
