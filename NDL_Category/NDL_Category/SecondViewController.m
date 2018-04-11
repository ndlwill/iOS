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

@interface SecondViewController () <CAAnimationDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    //[self.navigationController setNavigationBarHidden:YES animated:NO];

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
    
    self.navigationItem.titleView = titleView;
    
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
    
    
    
    
    [UIApplication sharedApplication].windows;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    self.searchBar.showsCancelButton = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"=== %@ %@", anim, [NSNumber numberWithBool:flag].stringValue);
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
