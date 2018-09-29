//
//  SQLiteManager.h
//  NDL_Category
//
//  Created by dzcx on 2018/9/27.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface SQLiteManager : NSObject

SINGLETON_FOR_HEADER(SQLiteManager)

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

// 单个db
- (void)openDB:(NSString *)dataBaseName;

// ========================================
// 插入单条数据
// eg: "INSERT INTO t_test (testID, testText) VALUES (?, ?);"
- (void)insertWithSQL:(NSString *)insertSQL valueArray:(NSArray *)valueArray;

// 批量用事务

@end

NS_ASSUME_NONNULL_END
