//
//  RequestViewModel.h
//  NDL_Category
//
//  Created by dzcx on 2018/8/8.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestViewModel : NSObject <UITableViewDataSource>

/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;



@property (nonatomic, strong, readonly) RACCommand *reuqesCommand;// for tableView
//模型数组
@property (nonatomic, strong, readonly) NSArray *models;
// 控制器中的view
@property (nonatomic, weak) UITableView *tableView;

@end
