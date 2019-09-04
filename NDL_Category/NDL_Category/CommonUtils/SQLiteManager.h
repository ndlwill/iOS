//
//  SQLiteManager.h
//  NDL_Category
//
//  Created by dzcx on 2018/9/27.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

/*
 MARK:FMDB写入大量数据的处理方法
 用事务
 在数据库操作中，所谓事务是用户定义的一个数据库操作序列,这些操作要么全做要么全不做
 
 在关系数据库中,一个事务可以是一条SQL语句、一组SQL语句
 
 事务的开始与结束可以由用户显式控制
 BEGIN TRANSACTION
 COMMIT TRANSACTION
 ROLLBACK TRANSACTION
 
 数据库以文件的形式存在磁盘中，每次访问时都要打开一次文件，如果对数据库进行大量的操作，就很慢。当用事物的形式提交，开始事务后，进行的大量操作语句都保存在内存中，当提交时才全部写入数据库，此时，数据库文件也只用打开一次。如果操作错误，还可以回滚事务
 
 FMDatabase * _dataBase = [[FMDatabase alloc]initWithPath:dbString];
 [_dataBase beginTransaction];//开启一个事务
 BOOL isRollBack = NO;
 @try {
 for(CityModel * model in modelArr){
 BOOL res = [_dataBase executeUpdate:@“SQL语句及其参数”];
 if(!res){
 //数据存储失败
 }
 }
 } @catch (NSException *exception) {
 isRollBack = YES;
 [_dataBase rollback];//回滚事务
 } @finally {
 if(!isRollBack){
 [_dataBase commit];//重新提交事务
 }
 }
 [_dataBase close];
 */

// SQLCipher加密
// https://blog.csdn.net/weixin_39339407/article/details/81699267

/*
 MARK:加密
 数据里加密有两种方法：
 1.对数据库内容加密，存的时候加密，用得时候解密。
 2.直接对数据库文件加密 ###
 
 pod 'FMDB/SQLCipher'
 */

/*
 https://www.jianshu.com/p/6cfc38a6d2c0
 MARK:使用FMDBMigrationManager 进行数据库迁移
 FMDBMigrationManager 是与FMDB结合使用的一个第三方，可以记录数据库版本号并对数据库进行数据库升级等操作
 
 将数据库与我们的FMDBMigrationManager关联起来
 创建版本号表，这个表会保存在我们的数据库中，进行数据库版本号的记录
 添加升级文件:文件名的格式是固定的 (数字)_(描述性语言).sql,前面的数字就是所谓的版本号，官方建议使用时间戳，也可以使用1，2，3，4，5……升级，保持单调递增即可
 CREATE TABLE User(name TEXT,age integer)
 文件内写入要对数据库做的操作
 将文件拖入工程
 FMDBMigrationManager 将会根据创建时给入的NSBundle自行寻找sql文件，对比版本号进行操作
 发现新增了一个User表，再加入一个新增数据库字段的文件（工程中常用的升级操作就是增加数据库字段)
 ALTER TABLE USER ADD email text
 重启项目运行升级代码，查看数据库
 
 第二种方法进行升级，使用自定义类的形式。第一种方法，每次升级都要建立一个文件
 定义一个新的类：Migration
 遵循FMDBMigrating协议
 */

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
