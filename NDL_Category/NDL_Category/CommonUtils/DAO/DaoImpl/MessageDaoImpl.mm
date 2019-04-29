//
//  MessageDaoImpl.m
//  NDL_Category
//
//  Created by dzcx on 2019/4/25.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "MessageDaoImpl.h"
#import "DatabaseConnection.h"

@interface MessageDaoImpl ()

@property (nonatomic, strong) DatabaseConnection *dbConnection;

@end

@implementation MessageDaoImpl

#pragma mark - lazy load
- (DatabaseConnection *)dbConnection
{
    if (!_dbConnection) {
        _dbConnection = [[DatabaseConnection alloc] init];
    }
    return _dbConnection;
}

#pragma mark - init
- (instancetype)init
{
    if (self = [super init]) {
        [self createTableWithModelCls:[WCDB_Message class]];// openDB + createTable
    }
    return self;
}

#pragma mark - DBDao
- (BOOL)createTableWithModelCls:(Class)cls;
{
    NSString *tableName = NSStringFromClass(cls);
    
    if ([self.dbConnection.database isTableExists:tableName]) {
        NSLog(@"表%@已存在", tableName);
        return YES;
    } else {
        // 对数据库的操作
        // 该接口使用的是IF NOT EXISTS的SQL，因此可以用重复调用。不需要在每次调用前判断表或索引是否已经存在
        BOOL result = [self.dbConnection.database createTableAndIndexesOfName:tableName withClass:cls];
        if (!result) {
            NSLog(@"创建表%@失败", tableName);
            return NO;
        } else {
            NSLog(@"创建表%@成功", tableName);
        }
        return YES;
    }
}

- (BOOL)insertModelObj:(id)obj
{
    if (![obj isMemberOfClass:[WCDB_Message class]]) {
        return NO;
    }
    // 对数据库的操作
    BOOL result = [self.dbConnection.database insertObject:obj into:NSStringFromClass([obj class])];
    if (!result) {
        NSLog(@"插入失败");
        return NO;
    } else {
        NSLog(@"插入成功");
    }

    return YES;
}

- (BOOL)insertModelObjs:(NSArray *)objs
{
    if (objs.count > 0) {
        BOOL result = [self.dbConnection.database insertObjects:objs into:NSStringFromClass([objs.firstObject class])];
        if (!result) {
            NSLog(@"批量插入失败");
            return NO;
        } else {
            NSLog(@"批量插入成功");
        }
        
        return YES;
    }
    
    NSLog(@"批量数据count = 0");
    return YES;
}

@end
