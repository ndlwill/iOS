//
//  SQLiteManager.m
//  NDL_Category
//
//  Created by dzcx on 2018/9/27.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "SQLiteManager.h"

@implementation SQLiteManager

SINGLETON_FOR_IMPLEMENT(SQLiteManager)

- (void)openDB:(NSString *)dataBaseName
{
    NSString *dbPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dbFilePath = [dbPath stringByAppendingPathComponent:dataBaseName];
    NSLog(@"dataBaseFilePath = %@", dbFilePath);
    
    self.dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbFilePath];
    
    [self createTable];
}

- (void)createTable
{
    NSString *createTableSQL = @"CREATE TABLE IF NOT EXISTS t_test ('testID' INTEGER NOT NULL PRIMARY KEY, 'testText' TEXT, 'createTime' TEXT DEFAULT (datetime('now', 'localtime')));";

    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        // [db executeUpdate:createTableSQL withArgumentsInArray:nil]
        if ([db executeUpdate:createTableSQL]) {
            NSLog(@"创建表成功");
        }
    }];
}

- (void)insertWithSQL:(NSString *)insertSQL valueArray:(NSArray *)valueArray
{
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db executeUpdate:insertSQL withArgumentsInArray:valueArray]) {
            NSLog(@"插入成功");
        }
    }];
}


@end
