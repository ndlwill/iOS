//
//  SecondViewController.m
//  NDL_Category
//
//  Created by ndl on 2017/11/18.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import "SecondViewController.h"
#import "Masonry.h"
#import "CommonUtils.h"

#import "NavigationControllerDelegate.h"
#import "PanGestureTransitionNavController.h"

#import "ThirdViewController.h"
#import "FourViewController.h"

#import "FiveViewController.h"
#import "BaseNavigationController.h"

#import "VariableCircleLayer.h"

#import "TestRACController.h"

@interface SecondViewController () <CAAnimationDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic, strong) NavigationControllerDelegate *navigationControllerDelegate;

@property (nonatomic, weak) VariableCircleLayer *variableLayer;

@end

@implementation SecondViewController

- (void)navControllerPanGesture:(UIPanGestureRecognizer *)panGesture
{
//    CGPoint translationOffset = [panGesture translationInView:self.navigationController.view];
//    CGFloat progress = fabs(translationOffset.x) / self.view.width;
//    
//    switch (panGesture.state) {
//        case UIGestureRecognizerStateBegan:
//            self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
//            if (self.viewControllers.count > 1) {
//                [self popViewControllerAnimated:YES];
//            } else {
//                
//            }
//            
//            break;
//        case UIGestureRecognizerStateChanged:
//            [self.interactiveTransition updateInteractiveTransition:progress];
//            break;
//        case UIGestureRecognizerStateEnded:
//            
//            break;
//            
//        default:
//            [self.interactiveTransition cancelInteractiveTransition];
//            self.interactiveTransition = nil;
//            break;
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(navControllerPanGesture:)];
//    [self.navigationController.view addGestureRecognizer:pan];
    
    PanGestureTransitionNavController *navVC = (PanGestureTransitionNavController *)(self.navigationController);
    navVC.pushVC = [[FourViewController alloc] init];
    
    self.navigationControllerDelegate = [[NavigationControllerDelegate alloc] init];
    self.navigationControllerDelegate.interactiveTransition = navVC.interactiveTransition;
    
    
    navVC.delegate = self.navigationControllerDelegate;
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    
    
    
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 80, 44)];
    titleView.backgroundColor = [UIColor cyanColor];

//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    //btn.backgroundColor = [UIColor redColor];
//    [btn setTitle:@"搜索" forState:UIControlStateNormal];
//    btn.layer.cornerRadius = 10;
//    btn.layer.borderColor = [UIColor blackColor].CGColor;
//    btn.layer.borderWidth = 2;
//    [titleView addSubview:btn];
//    btn.frame = titleView.bounds;
//    btn.center = titleView.center;
    
    // titleView
//    self.navigationItem.titleView = titleView;
    
//initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 80, 44)
//    UISearchBar *searchBar = [[UISearchBar alloc] init];
//    searchBar.backgroundColor = [UIColor redColor];
//   // [searchBar sizeToFit];
//    self.navigationItem.titleView = searchBar;
    
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    titleView.backgroundColor = [UIColor cyanColor];
//    self.navigationItem.titleView = titleView;
    
    /*
    {
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(80, 20, 100, 44)];
        self.searchBar = searchBar;
        
        UITextField *searchField = [searchBar valueForKey:@"_searchField"];
        searchField.backgroundColor = [UIColor redColor];
        
        searchBar.barStyle = UIBarStyleBlack;
        //    searchBar.prompt = @"中国人";
        searchBar.placeholder = @"搜索";
        searchBar.showsCancelButton = YES;
        //    searchBar.showsSearchResultsButton = YES;
        
        //[searchBar setShowsCancelButton:YES animated:YES];
        searchBar.tintColor = [UIColor yellowColor];
        searchBar.backgroundColor = [UIColor greenColor];
        searchBar.barTintColor = [UIColor cyanColor];
        //    [searchBar sizeToFit];
        
        //[searchBar setPositionAdjustment:UIOffsetMake(self.view.frame.size.width / 2, 0) forSearchBarIcon:UISearchBarIconSearch];
        // ioS 9
//        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
//        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"123"];
//        NSLog(@"sarch frame = %@", NSStringFromCGRect(searchBar.frame));
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
        
        //searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(20, 0);
        searchBar.searchTextPositionAdjustment = UIOffsetMake(30, 0);
        
        self.navigationItem.titleView = searchBar;
    }
    */
    //self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //self.title = @"Second";
    //self.view.backgroundColor = [UIColor redColor];
    
    //self.navigationController.hidesBarsOnSwipe = YES;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(64);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(80);
        make.height.equalTo(topView.mas_width).multipliedBy(1);
    }];
    
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = CGRectMake(64, 64, 200, 200);
    replicator.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:replicator];
//    
//    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:<#(CGPoint)#> radius:<#(CGFloat)#> startAngle:0 endAngle:M_PI * 2 clockwise:YES]
    
    
    CALayer *indicator = [CALayer layer];
    //indicator.transform = CATransform3DMakeScale(0, 0, 0);
    indicator.position = CGPointMake(100, 50);
    indicator.bounds = CGRectMake(0, 0, 10, 10);
    indicator.backgroundColor = [UIColor greenColor].CGColor;
    [replicator addSublayer:indicator];
    
    
    
    CGFloat durtion = 1;
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.delegate = self;
//    anim.keyPath = @"transform.scale";
//    anim.fromValue = @1;
//    anim.toValue = @0.1;

    anim.keyPath = @"opacity";
    anim.fromValue = @1;
    anim.toValue = @0.1;
    anim.repeatCount = MAXFLOAT;
    //
    anim.removedOnCompletion = NO;
    anim.duration = durtion;
    [indicator addAnimation:anim forKey:nil];
    
    
    int count = 20;
    
    // 设置子层次数
    replicator.instanceCount = count;
    
    // 设置子层动画延长时间
    replicator.instanceDelay = durtion / count;
    
    // 设置子层形变角度
    CGFloat angle = M_PI * 2 / count;
    replicator.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);

    
    [self.slider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    
    VariableCircleLayer *variableLayer = [VariableCircleLayer layer];
    variableLayer.backgroundColor = [UIColor blueColor].CGColor;
    variableLayer.frame = CGRectMake(0, self.view.height - 160, 160, 160);
    variableLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:variableLayer];
    variableLayer.progress = 0.5;
    self.variableLayer = variableLayer;
    
//    NSLog(@"variableLayer position = %@", NSStringFromCGPoint(variableLayer.position));
}

- (void)sliderValueDidChanged:(UISlider *)slider
{
    self.variableLayer.progress = slider.value;
    NSLog(@"slider value = %f", slider.value);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"second touch begin");
    
    self.searchBar.showsCancelButton = NO;
}
- (IBAction)testRACDidClicked:(id)sender {
    [self.navigationController pushViewController:[[TestRACController alloc] init] animated:YES];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"=== %@ %@", anim, [NSNumber numberWithBool:flag].stringValue);
}

- (IBAction)fiveButtonDidClicked:(id)sender {
    // embed in nav
    BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:[FiveViewController new]];
    
//    [self presentViewController:navVC animated:YES completion:nil];
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}


@end
