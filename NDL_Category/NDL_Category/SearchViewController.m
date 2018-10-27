
//
//  SearchViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/9/19.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"

#import <SafariServices/SafariServices.h>

static NSInteger count = 0;

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>// ios 9.0

@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UISearchController *searchVC;// ios 8.0
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;// ios 6.0 自带indicatorView

@property (nonatomic, assign, getter=isLoadingData) BOOL loadingData;

@property (nonatomic, assign) BOOL moreFlag;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        // Do Nothing
    } else {
        NSLog(@"setAutomaticallyAdjustsScrollViewInsets");
        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
            [self setAutomaticallyAdjustsScrollViewInsets:NO];
        }
    }
    
    self.title = @"TestSearch";
    
    /*
     [Search] The topViewController (<SearchViewController: 0x101c5bc30>) of the navigation controller containing the presented search controller (<UISearchController: 0x1020ba000>) must have definesPresentationContext set to YES.
     */
    self.definesPresentationContext = YES;
    
    // UI
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
        self.navigationItem.searchController = self.searchVC;
        self.navigationItem.hidesSearchBarWhenScrolling = YES;
    } else {
        self.tableView.tableHeaderView = self.searchVC.searchBar;
    }
}

- (void)didEndRefreshing
{
    {
        self.loadingData = NO;

        // 头部
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        // 底部
        if ([self.indicatorView isAnimating]) {
            [self.indicatorView stopAnimating];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // h = 60
    NSLog(@"viewDidAppear self.refreshControl.frame = %@", NSStringFromCGRect(self.refreshControl.frame));
}

#pragma mark - lazy load
- (UISearchController *)searchVC
{
    if (!_searchVC) {
        SearchResultViewController *resultVC = [[SearchResultViewController alloc] init];
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:resultVC];
        _searchVC.searchBar.placeholder = @"搜索";
        _searchVC.searchResultsUpdater = resultVC;
    }
    return _searchVC;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        NSLog(@"_indicatorView size = %@", NSStringFromCGSize(_indicatorView.frame.size));
//        [_indicatorView startAnimating];
    }
    return _indicatorView;
}

- (UIView *)tableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 49)];
        _tableFooterView.backgroundColor = [UIColor cyanColor];
        [_tableFooterView addSubview:self.indicatorView];
        self.indicatorView.center = _tableFooterView.center;
    }
    return _tableFooterView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
        _tableView.rowHeight = 80;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
        _tableView.tableFooterView = [[UIView alloc] init];
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.backgroundColor = [UIColor yellowColor];
        [self.refreshControl addTarget:self action:@selector(loadLatestData:) forControlEvents:UIControlEventValueChanged];
        _tableView.refreshControl = self.refreshControl;// 不设置 就是iOS系统设置的拉动效果
    }
    return _tableView;
}

#pragma mark - UIControl Actions
- (void)loadLatestData:(UIRefreshControl *)pSender
{
    // 228.0 (64, 60, 104(52, 52))
    NSLog(@"loadLatestData navBarH = %lf", self.navigationController.navigationBar.height);
    
    count++;
    if (count == 1) {
        self.moreFlag = YES;
        if (self.tableView.tableFooterView != self.tableFooterView) {
            self.tableView.tableFooterView = self.tableFooterView;
        }
    } else {
        self.moreFlag = NO;
        [self.tableView setTableFooterView:[UIView new]];
    }
    

    // 加载
    if (self.isLoadingData) {
        return;
    }
    self.loadingData = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
        [self didEndRefreshing];
    });
}

#pragma mark - UIViewControllerPreviewingDelegate
// 3D Touch 预览模式
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
    // ios 9.0
    SFSafariViewController *sfViewController = [[SFSafariViewController alloc] initWithURL:url];
    if (@available(iOS 11.0, *)) {
        sfViewController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
        sfViewController.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
    }
    
    return sfViewController;
}

// 3D Touch 继续按压进入
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self presentViewController:viewControllerToCommit animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
    // ios 9.0
    SFSafariViewController *sfViewController = [[SFSafariViewController alloc] initWithURL:url];
    if (@available(iOS 11.0, *)) {
        sfViewController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
        sfViewController.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
    }
    [self presentViewController:sfViewController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20 * MIN(count, 3);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor ndl_randomColor];
    }
    
    // 为 Cell 添加 3D Touch 支持
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 向上 contentOffsetY > 0
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if (contentOffsetY < 0) {
        return;
    }
    
    CGFloat contentHeight = scrollView.contentSize.height;
    NSLog(@"contentOffsetY = %lf contentHeight = %lf", contentOffsetY, contentHeight);
    
    // 上拉到最后个元素时的高度deltaHeight = contentHeight
    CGFloat deltaHeight = contentOffsetY + self.tableView.height ;
    // 上拉加载更多
    if (contentHeight > 0 && (deltaHeight + 10) >= contentHeight) {
        NSLog(@"===load more===");
        [self.indicatorView startAnimating];
        // 省略。。。
    }
}

@end
