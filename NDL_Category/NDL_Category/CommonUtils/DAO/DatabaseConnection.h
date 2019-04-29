//
//  DatabaseConnection.h
//  NDL_Category
//
//  Created by dzcx on 2019/4/25.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>
NS_ASSUME_NONNULL_BEGIN

/*
 WCDB:
 https://github.com/Tencent/wcdb/wiki
 多线程高并发：WCDB支持多线程读与读、读与写并发执行，写与写串行执行
 
 线程安全与并发:
 对于WCDB，WCTDatabase、WCTTable和WCTTransaction的所有SQL操作接口都是线程安全，并且自动管理并发的
 WCDB的连接池会根据数据库访问所在的线程、是否处于事务、并发状态等，自动分发合适的SQLite连接进行操作，并在完成后回收以供下一次再利用。
 因此，开发者既不需要使用一个新的类来完成多线程任务，也不需要过多关注线程安全的问题。
 //thread-1 read
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
 NSArray *messages = [wcdb getAllObjectsOfClass:Message.class fromTable:@"message"];
 //...
 });
 //thread-2 write
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
 [wcdb insertObjects:messages into:@"message"];
 });
 
 关闭数据库:
 关闭数据库通常有两种场景：
 数据库使用结束，回收对象。
 数据库进行某些操作，需要临时关闭数据库。如移动、复制数据库文件。
 回收对象:
 对于这种情况，开发者无需手动操作。WCDB会自动管理这个过程。对于某一路径的数据库，WCDB会在所有对其的引用释放时，自动关闭数据库，并回收资源。
 
 对于iOS平台，当内存不足时，WCDB会自动关闭空闲的SQLite连接，以节省内存。开发者也可以手动调用[db purgeFreeHandles]对清理单个数据库的空闲SQLite连接。或调用[WCTDatabase PurgeFreeHandlesInAllDatabases]清理所有数据库的空闲SQLite连接。
 
 手动关闭数据库:
 无论是WCDB的多线程管理，还是FMDB的FMDatabasePool，都存在多线程关闭数据库的问题。
 即，当一个线程希望关闭数据库时，另一个线程还在继续执行操作。
 而某些特殊的操作需要确保数据库完全关闭，例如移动、重命名、删除数据库等文件层面的操作。
 例如，若在A线程进行插入操作的执行过程中，B线程尝试复制数据库，则复制后的新数据库很可能是一个损坏的数据库。
 因此，WCDB提供了close:接口确保完全关闭数据库，并阻塞其他线程的访问。
 
 [wcdb close:^(){
 //do something on this closed database
 }];
 */
// WINQ（WCDB Integrated Query，音'wink'）
// 数据库本身是存储在磁盘上。访问和修改数据库，即对磁盘进行读写，即I/O操作


/*
 索引:是一种数据结构
 B-Tree 是最常用的用于索引的数据结构。因为它们是时间复杂度低， 查找、删除、插入操作都可以可以在对数时间内完成
 另外一个重要原因存储在B-Tree中的数据是有序的。
 
 索引存储了指向表中某一行的指针
 
 如果表中某列在查询过程中使用的非常频繁，那就在该列上创建索引。
 */
@interface DatabaseConnection : NSObject

// 句柄是物体的描述结构体
/*
 WCDB对于涉及批量操作的接口，都有内置的事务。如createTableAndIndexesOfName:withClass:和insertObjects:into:等，这类接口通常不止执行一条SQL，因此WCDB会自动嵌入事务，以提高性能
 */
@property (nonatomic, strong, readonly) WCTDatabase *database;

@end

NS_ASSUME_NONNULL_END
