//
//  TestLifeCircleController.m
//  NDL_Category
//
//  Created by dzcx on 2019/3/4.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestLifeCircleController.h"
#import "AutoCalcSizeView.h"

#import "TestCalcFrameView.h"

@interface TestLifeCircleController ()

@property (nonatomic, strong) AutoCalcSizeView *autoCalcSizeView;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *topSubView;

@property (nonatomic, strong) UIView *contentView;// for company project

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) TestCalcFrameView *calcFrameView;

@end

@implementation TestLifeCircleController

/*
 viewDidLoad: for testCalcFrame && testCompanyProject
 
 TestLifeCircleController viewWillLayoutSubviews#####
 AutoCalcSizeView layoutSubviews#####
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // ===============start===============
//    [self testCalcFrame];
    // ===============end===============
    
    
//    [self testCompanyProject];
    
    
    
    
    self.calcFrameView = [[TestCalcFrameView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.calcFrameView];
}

- (void)testCompanyProject
{
    self.contentView = [[UIView alloc] init];// H 未知
    self.contentView.width = 100;
    self.contentView.height = 80;
    self.contentView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.contentView];
    
    self.autoCalcSizeView = [[AutoCalcSizeView alloc] init];// red  // H 布局完自动计算
    self.autoCalcSizeView.width = 100;
    [self.contentView addSubview:self.autoCalcSizeView];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bottomView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"testCompanyProject after 3.0");
        self.autoCalcSizeView.label.text = @"ndlwill";
        /*
         self.view.subview(是self.content) .subview setNeedsLayout
         
         只调AutoCalcSizeView layoutSubviews#####
         */
//        [self.autoCalcSizeView setNeedsLayout];
        // 先打印log height还是80没有改变 再 AutoCalcSizeView layoutSubviews#####
//        NSLog(@"after 3.0 -> after setNeedsLayout autoCalcSizeViewH = %lf", self.autoCalcSizeView.height);
        
        
        //        [self.autoCalcSizeView setNeedsLayout];
        //        [self.view setNeedsLayout];// 两个setNeedsLayout log顺序不一样
        
        /*
         setNeedsLayout
         标记为需要重新布局，异步调用layoutIfNeeded刷新布局，不立即刷新，在下一轮runloop结束前刷新，对于这一轮runloop之内的所有布局和UI上的更新只会刷新一次，layoutSubviews一定会被调用。
         
         layoutIfNeeded
         如果有需要刷新的标记，立即调用layoutSubviews进行布局（如果没有标记，不会调用layoutSubviews）
         */
//        [self.autoCalcSizeView setNeedsLayout];// 标记下个运行循环layout
//        [self.autoCalcSizeView layoutIfNeeded];// 有标记的 立即layout
//        // 先AutoCalcSizeView layoutSubviews##### 再log打印 height改变了等于107
//        NSLog(@"after 3.0 -> after setNeedsLayout autoCalcSizeViewH = %lf", self.autoCalcSizeView.height);
        
        [self.autoCalcSizeView setNeedsLayout];// 标记下个运行循环layout
        [self.autoCalcSizeView layoutIfNeeded];// 有标记的 立即layout
        // 先AutoCalcSizeView layoutSubviews##### 再log打印 height改变了等于107
        NSLog(@"after 3.0 -> after setNeedsLayout autoCalcSizeViewH = %lf", self.autoCalcSizeView.height);
        // self.view.subview(self.content)改变H 会调TestLifeCircleController viewWillLayoutSubviews#####
        self.contentView.height = self.autoCalcSizeView.height;
        
        // 什么都不会调用
//        [self.contentView setNeedsLayout];
    });
}

- (void)testCompanyProjectViewWillLayoutSubviews
{
    NSLog(@"testCompanyProjectViewWillLayoutSubviews autoCalcSizeViewH = %lf", self.autoCalcSizeView.height);
    
    self.contentView.y = 100;
    
    self.bottomView.y = CGRectGetMaxY(self.contentView.frame) + 10;
    self.bottomView.size = CGSizeMake(80, 80);
}

// AutoCalcSizeView
- (void)testCalcFrame
{
    self.autoCalcSizeView = [[AutoCalcSizeView alloc] init];
    self.autoCalcSizeView.width = 100;
    [self.view addSubview:self.autoCalcSizeView];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bottomView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"TestLifeCircleController after 5.0");
        
        // test-0-0
        self.autoCalcSizeView.label.text = @"ndlwill";
        /*
         AutoCalcSizeView layoutSubviews#####
         TestLifeCircleController viewWillLayoutSubviews#####
         */
        [self.autoCalcSizeView setNeedsLayout];// self.autoCalcSizeView H 改变了
        // test-0-1
        //        /*
        //         AutoCalcSizeView layoutSubviews#####
        //         TestLifeCircleController viewWillLayoutSubviews#####
        //         */
        //        [self.autoCalcSizeView setLabelText:@"ndlwill"];
        
        // test-1
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            NSLog(@"5.0->3.0");
        //
        //            self.autoCalcSizeView.label.text = @"";
        //
        //            /*
        //             AutoCalcSizeView layoutSubviews#####
        //             TestLifeCircleController viewWillLayoutSubviews#####
        //             */
        //            [self.autoCalcSizeView setNeedsLayout];
        //        });
        
        // test-2
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            NSLog(@"TestLifeCircleController after 5.0->2.0");
        //
        //            self.topView = [[UIView alloc] init];
        //            self.topView.backgroundColor = [UIColor greenColor];
        //
        //            /*
        //             self.view addSubview
        //
        //             TestLifeCircleController viewWillLayoutSubviews#####
        //             */
        //            [self.view addSubview:self.topView];
        //
        //
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                NSLog(@"TestLifeCircleController after 5.0->2.0->3.0");
        //
        //                self.topSubView = [[UIView alloc] init];
        //                self.topSubView.backgroundColor = [UIColor grayColor];
        //                /*
        //                 self.view.subView addSubview
        //                 不会调TestLifeCircleController viewWillLayoutSubviews#####
        //                 */
        //                [self.topView addSubview:self.topSubView];
        //            });
        //        });
        
        // test-3
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"TestLifeCircleController after 5.0->4.0");
            
            /*
             改变self.view.subView的宽高
             
             TestLifeCircleController viewWillLayoutSubviews#####
             AutoCalcSizeView layoutSubviews#####
             */
            self.autoCalcSizeView.width = 200;
        });
    });
}

- (void)testCalcFrameViewWillLayoutSubviews
{
    if (self.topView) {
        self.topView.frame = CGRectMake(0, 80, 120, 40);
        
        self.autoCalcSizeView.y = CGRectGetMaxY(self.topView.frame) + 10.0;
    } else {
        self.autoCalcSizeView.y = 300;// viewDidLoad进来的时候 autoCalcSizeView.h = 0
    }
    
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.autoCalcSizeView.frame) + 11, 100, 100);
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"TestLifeCircleController viewWillLayoutSubviews#####");
    [super viewWillLayoutSubviews];
    
//    [self testCalcFrameViewWillLayoutSubviews];
    
//    [self testCompanyProjectViewWillLayoutSubviews];
}

@end
