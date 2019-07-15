//
//  BaseViewController.h
//  NDL_Category
//
//  Created by ndl on 2018/2/26.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 tableView:
 // EditingStyle  不写editingStyleForRowAtIndexPath:,默认UITableViewCellEditingStyleDelete  + canEditRowAtIndexPath:需要返回YES
 */

/*
 swift:
 https://www.cnblogs.com/QianChia/default.html?page=4
 
 Swift进阶之内存模型和方法调度:
 https://blog.csdn.net/hello_hwc/article/details/53147910
 */

/*
 滴滴技术:
 https://www.jianshu.com/users/c3c893a27097/timeline
 */

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL isNetworkReachable;

@property (nonatomic, strong) UITableView *tableView;// plain
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;// setter && getter

#pragma mark - Public Methods
// 显示AppSetting AlertView
- (void)showAlertViewForAppSettingWithTitle:(NSString *)titleStr msg:(NSString *)msgStr cancel:(NSString *)cancelStr setting:(NSString *)settingStr;
// 返回按钮被点击
- (void)backButtonDidClicked;
// 取消所有网络请求
- (void)cancelAllRequests;

// 大标题滚动调整
//- (void)scrollAdjustWithScrollView:(UIScrollView *)scrollView autoFlag:(BOOL)autoFlag;
//- (void)_autoScrollAdjustmentWithScrollView:(UIScrollView *)scrollView;


// for test
- (void)_testForInherit;

@end
