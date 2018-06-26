//
//  BaseViewController.h
//  NDL_Category
//
//  Created by ndl on 2018/2/26.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL isNetworkReachable;

@property (nonatomic, strong) UITableView *tableView;// plain
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

// 显示AppSetting AlertView
- (void)showAlertViewForAppSettingWithTitle:(NSString *)titleStr msg:(NSString *)msgStr cancel:(NSString *)cancelStr setting:(NSString *)settingStr;

// 取消所有网络请求
- (void)cancelAllRequests;

// 大标题滚动调整
//- (void)scrollAdjustWithScrollView:(UIScrollView *)scrollView;

@end
