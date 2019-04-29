//
//  BaseViewController.m
//  NDL_Category
//
//  Created by ndl on 2018/2/26.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()


@end

@implementation BaseViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
//    self.statusBarStyle = UIStatusBarStyleDefault;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    id object = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY"];// object == nil
//    NSString *objStr = [NSString stringWithFormat:@"%@", object];// objStr == (null)
}

- (void)dealloc
{
    [self cancelAllRequests];
}

#pragma mark - Lazy Load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
}

#pragma mark - Public Methods
- (void)showAlertViewForAppSettingWithTitle:(NSString *)titleStr msg:(NSString *)msgStr cancel:(NSString *)cancelStr setting:(NSString *)settingStr
{
    if (@available(iOS 8.0, *)) {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:titleStr message:msgStr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:nil];
        [vc addAction:cancelAction];
        
        UIAlertAction *settingAction = [UIAlertAction actionWithTitle:settingStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [CommonUtils openAppSettingURL];
        }];
        [vc addAction:settingAction];
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)backButtonDidClicked
{
    NSLog(@"presentingViewController = %@ navigationController = %@", self.presentingViewController, self.navigationController);
    NSLog(@"backButtonDidClicked self = %@", self);
    UINavigationController *navigationVC = self.navigationController;
    if (navigationVC && navigationVC.viewControllers.firstObject != self) {
        [navigationVC popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)cancelAllRequests
{

}

#pragma mark - Setter
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
    NSLog(@"BaseViewController method:setStatusBarStyle style = %ld self = %@", self.statusBarStyle, self);
}

#pragma mark - Overrides
// 针对presentViewController出来的vc （nav-push得去研究，push出来的vc没效果）
- (UIStatusBarStyle)preferredStatusBarStyle
{
    NSLog(@"BaseViewController method:preferredStatusBarStyle");
    return self.statusBarStyle;
}

#pragma mark - Private Methods
- (void)_testForInherit
{
    NSLog(@"Base _testForInherit");
}

// MJRefresh
/*
- (void)_loadLatestDatas
{
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    paramsDic[@"pageNumber"] = @(1);
    paramsDic[@"pageSize"] = @(kNetworkDataPageCount);
    kWeakSelf(weakSelf)
    [[VWTHttpToolManager shareManger] requestWithUrlString:@"https://dev01.letzgo.com.cn/dzcx_ck/m/enterprise/orders/query" andParams:paramsDic method:HttpRequestMehodPOST showIndicatorInView:self.view andCompletionHandler:^(NSDictionary *resBodyDic, NSError *error) {
        kStrongSelf(strongSelf, weakSelf)
        NSLog(@"resBodyDic = %@", resBodyDic);
        if (!error) {
            if ([[resBodyDic notNullObjectForKey:@"success"] isEqualToString:@"0"]) {
                NSArray *modelArray = [NSArray yy_modelArrayWithClass:[EnterpriseRouteItem class] json:[resBodyDic objectForKey:@"data"]];
                NSInteger datasCount = modelArray.count;
                strongSelf.requestPageIndex = 1;
                if (datasCount > 0) {
                    [strongSelf.dataSourceArray removeAllObjects];
                    
                    for (NSInteger i = 0; i < datasCount; i++) {
                        RouteCellViewModel *vm = [[RouteCellViewModel alloc] initWithEnterpriseRouteItem:modelArray[i]];
                        [strongSelf.dataSourceArray addObject:vm];
                    }
                    if (strongSelf.tableView.mj_footer.hidden == YES) {
                        strongSelf.tableView.mj_footer.hidden = NO;
                    }
                    if (datasCount < kNetworkDataPageCount) {
                        strongSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                    } else if (datasCount == kNetworkDataPageCount) {
                        if (strongSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                            [strongSelf.tableView.mj_footer resetNoMoreData];
                        }
                    }
                    [strongSelf.tableView reloadData];
                } else {
                    // footer隐藏 上拉不走_loadMoreDatas
                    if (strongSelf.tableView.mj_footer.hidden == NO) {
                        strongSelf.tableView.mj_footer.hidden = YES;
                    }
                }
            } else {
                [Common tipAlert:[resBodyDic objectForKey:@"msg"]];
            }
            
            if ([strongSelf.tableView.mj_header isRefreshing]) {
                [strongSelf.tableView.mj_header endRefreshing];
            }
        } else {
            if ([strongSelf.tableView.mj_header isRefreshing]) {
                [strongSelf.tableView.mj_header endRefreshing];
            }
            [Common tipAlert:error.localizedDescription];
        }
    }];
}

- (void)_loadMoreDatas
{
    NSInteger page = self.requestPageIndex + 1;
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    paramsDic[@"pageNumber"] = @(page);
    paramsDic[@"pageSize"] = @(kNetworkDataPageCount);
    kWeakSelf(weakSelf)
    [[VWTHttpToolManager shareManger] requestWithUrlString:@"https://dev01.letzgo.com.cn/dzcx_ck/m/enterprise/orders/query" andParams:paramsDic method:HttpRequestMehodPOST showIndicatorInView:self.view andCompletionHandler:^(NSDictionary *resBodyDic, NSError *error) {
        kStrongSelf(strongSelf, weakSelf)
        NSLog(@"resBodyDic = %@", resBodyDic);
        if (!error) {
            if ([[resBodyDic notNullObjectForKey:@"success"] isEqualToString:@"0"]) {
                NSArray *modelArray = [NSArray yy_modelArrayWithClass:[EnterpriseRouteItem class] json:[resBodyDic objectForKey:@"data"]];
                NSInteger datasCount = modelArray.count;
                strongSelf.requestPageIndex = page;
                if (datasCount > 0) {
                    for (NSInteger i = 0; i < datasCount; i++) {
                        RouteCellViewModel *vm = [[RouteCellViewModel alloc] initWithEnterpriseRouteItem:modelArray[i]];
                        [strongSelf.dataSourceArray addObject:vm];
                    }
                    if (datasCount < kNetworkDataPageCount) {
                        strongSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                    } else if (datasCount == kNetworkDataPageCount) {
                        if (strongSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                            [strongSelf.tableView.mj_footer resetNoMoreData];
                        }
                    }
                    
                    [strongSelf.tableView reloadData];
                } else {
                    strongSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                    if (strongSelf.dataSourceArray.count == 0) {
                        if (strongSelf.tableView.mj_footer.hidden == NO) {
                            strongSelf.tableView.mj_footer.hidden = YES;
                        }
                    }
                }
            } else {
                [Common tipAlert:[resBodyDic objectForKey:@"msg"]];
            }
            
            if ([strongSelf.tableView.mj_footer isRefreshing]) {
                [strongSelf.tableView.mj_footer endRefreshing];
            }
        } else {
            if ([strongSelf.tableView.mj_footer isRefreshing]) {
                [strongSelf.tableView.mj_footer endRefreshing];
            }
            
            [Common tipAlert:error.localizedDescription];
        }
    }];
}
*/

// 屏幕旋转
/*
 // 屏幕旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
 */


// BigTitle
// 滚动调整
//- (void)scrollAdjustWithScrollView:(UIScrollView *)scrollView autoFlag:(BOOL)autoFlag
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    self.totalOffsetY += offsetY;
//    NSLog(@"offsetY = %lf self.totalOffsetY = %lf", offsetY, self.totalOffsetY);
//
//    // self.totalOffsetY判断
//    if (self.totalOffsetY >= 0 && self.totalOffsetY < kBigTitleHeight) {
//        scrollView.contentOffset = CGPointZero;
//        self.bigTitleViewTopOffsetToNavigationViewBottomCons.constant = -self.totalOffsetY;
//        if (autoFlag) {
//            [UIView animateWithDuration:0.5 animations:^{
//                [self.view layoutIfNeeded];
//            }];
//        } else {
//            [self.view layoutIfNeeded];
//        }
//    } else if (self.totalOffsetY < 0) {
//        self.totalOffsetY = 0;
//        if (self.bigTitleViewTopOffsetToNavigationViewBottomCons.constant != 0) {
//            self.bigTitleViewTopOffsetToNavigationViewBottomCons.constant = 0;
//            [self.view layoutIfNeeded];
//        }
//    } else if (self.totalOffsetY >= kBigTitleHeight) {
//        self.totalOffsetY = kBigTitleHeight;
//        if (self.bigTitleViewTopOffsetToNavigationViewBottomCons.constant != -kBigTitleHeight) {
//            self.bigTitleViewTopOffsetToNavigationViewBottomCons.constant = -kBigTitleHeight;
//            [self.view layoutIfNeeded];
//        }
//    }
//
//    // 显示隐藏 titleLabel
//    if (self.totalOffsetY >= 0 && self.totalOffsetY < kBigTitleMaxY) {
//        if (!self.navigationTitleLabel.hidden) {
//            self.navigationTitleLabel.hidden = YES;
//        }
//    } else if (self.totalOffsetY >= kBigTitleMaxY && self.totalOffsetY <= kBigTitleHeight) {
//        if (self.navigationTitleLabel.hidden) {
//            self.navigationTitleLabel.hidden = NO;
//        }
//    }
//}

// 自动调整
//- (void)_autoScrollAdjustmentWithScrollView:(UIScrollView *)scrollView
//{
//    if (self.totalOffsetY > 0.0 && self.totalOffsetY <= 20.0) {
//        self.totalOffsetY = 0.0;
//        [self _scrollAdjustWithScrollView:scrollView autoFlag:YES];
//    } else if (self.totalOffsetY > 20.0 && self.totalOffsetY <= 60.0) {
//        self.totalOffsetY = 60;
//        [self _scrollAdjustWithScrollView:scrollView autoFlag:YES];
//    }
//}

@end
