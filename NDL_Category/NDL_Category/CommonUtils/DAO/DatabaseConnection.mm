//
//  DatabaseConnection.m
//  NDL_Category
//
//  Created by dzcx on 2019/4/25.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "DatabaseConnection.h"

static int const NDLDatebaseSqliteTag = 88;

@implementation DatabaseConnection

@synthesize database = _database;
#pragma mark - lazy load && getter
- (WCTDatabase *)database
{
    if (!_database) {
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *dbPath = [docPath stringByAppendingPathComponent:@"NDL_Datebase.sqlite"];
        NSLog(@"dbPath = %@", dbPath);
        
        // 该接口使用的是IF NOT EXISTS的SQL，因此可以用重复调用
        _database = [[WCTDatabase alloc] initWithPath:dbPath];
        _database.tag = NDLDatebaseSqliteTag;
        
        // Note that WCTCore objects with same path share this tag, even they are not the same object
        // 相同path的不同WCTDatabase，不同WCTDatabase的tag相同
        NSLog(@"_database = %p _database.tag = %d", _database, _database.tag);
    }
    return _database;
}

#pragma mark - init
- (instancetype)init
{
    if (self = [super init]) {
        [self _createDatabaseHandle];
    }
    return self;
}

// WCDB会在第一次访问数据库时，自动打开数据库，不需要开发者主动操作。
// canOpen接口可用于测试数据库能否正常打开，isOpened接口可用于测试数据库是否已打开
#pragma mark - private methods
- (void)_createDatabaseHandle
{
    if (![self.database isOpened]) {
        NSLog(@"数据库未打开");
        
        if ([self.database canOpen]) {// 这个方法会打开数据库
            NSLog(@"测试:数据库能正常打开");
        } else {
            NSLog(@"测试:数据库不能正常打开");
        }
    } else {
        NSLog(@"数据库已打开");
    }
}

// 关闭数据库 Closing A Database Connection 数据库使用完毕后需要关闭

@end
