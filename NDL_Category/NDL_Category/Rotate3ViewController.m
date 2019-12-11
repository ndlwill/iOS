//
//  Rotate3ViewController.m
//  NDL_Category
//
//  Created by ndl on 2019/11/17.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "Rotate3ViewController.h"

@interface Rotate3ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIView *testView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation Rotate3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.01];
    self.view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    self.testView = view;
    // MARK: 我的理解是约束会在viewWillLayoutSubviews计算frame viewDidLayoutSubviews里面得到某个视图真正的frame
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 80));
    }];
    view.frame = CGRectMake(100, 100, 50, 50);
    // frame = {{100, 100}, {50, 50}}
    NSLog(@"viewDidLoad frame = %@", NSStringFromCGRect(self.testView.frame));
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"###numberOfRowsInSection###");
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"===cellForRowAtIndexPath===");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"===%ld===", indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath");
    return 44.0;
}

- (void)viewWillLayoutSubviews
{
    // frame = {{100, 100}, {50, 50}}
    NSLog(@"before frame = %@", NSStringFromCGRect(self.testView.frame));
    [super viewWillLayoutSubviews];
    // frame = {{100, 100}, {50, 50}}
    NSLog(@"after frame = %@", NSStringFromCGRect(self.testView.frame));
    
}

// MARK: 这边才能拿到各个视图真正的frame
- (void)viewDidLayoutSubviews
{
    // frame = {{137.5, 273.5}, {100, 80}}
    NSLog(@"before did frame = %@", NSStringFromCGRect(self.testView.frame));
    [super viewDidLayoutSubviews];
    // frame = {{137.5, 273.5}, {100, 80}}
    NSLog(@"after did frame = %@", NSStringFromCGRect(self.testView.frame));
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

@end
