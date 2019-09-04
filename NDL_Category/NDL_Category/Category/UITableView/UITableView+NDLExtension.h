//
//  UITableView+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 MARK:优化
 滑动卡顿: 每帧16.7毫秒没法完成图片的渲染
 后台下载数据，切换到主线程不影响滑动: 让数据在defaultMode显示
 */

/*
 reloadDate并不会等待tableview更新结束后才返回，而是立即返回
 
 // 判断reloadData加载数据已经结束
 [self.tableView reloadData];
 [self.tableView layoutIfNeeded];//###
 self.tableView.contentOffset = CGPointZero;
 */
@interface UITableView (NDLExtension)

@end
