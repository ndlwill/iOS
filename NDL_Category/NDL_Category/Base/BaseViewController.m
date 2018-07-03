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

// 滚动调整
//- (void)scrollAdjustWithScrollView:(UIScrollView *)scrollView
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    self.totalOffsetY += offsetY;
//    
//    // self.totalOffsetY判断
//    if (self.totalOffsetY >= 0 && self.totalOffsetY <= kBigTitleHeight) {
//        scrollView.contentOffset = CGPointZero;
//        self.bigTitleViewTopOffsetToNavigationViewBottomCons.constant = -self.totalOffsetY;
//        [self.view layoutIfNeeded];
//    } else if (self.totalOffsetY < 0) {
//        self.totalOffsetY = 0;
//        if (self.bigTitleViewTopOffsetToNavigationViewBottomCons.constant != 0) {
//            self.bigTitleViewTopOffsetToNavigationViewBottomCons.constant = 0;
//            [self.view layoutIfNeeded];
//        }
//    } else if (self.totalOffsetY > kBigTitleHeight) {
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

@end
