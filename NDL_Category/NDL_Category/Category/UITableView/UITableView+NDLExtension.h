//
//  UITableView+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/12.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 reloadDate并不会等待tableview更新结束后才返回，而是立即返回
 
 // 判断reloadData加载数据已经结束
 [self.tableView reloadData];
 [self.tableView layoutIfNeeded];//###
 self.tableView.contentOffset = CGPointZero;
 */
@interface UITableView (NDLExtension)

@end
