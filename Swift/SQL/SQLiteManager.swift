//
//  SQLiteManager.swift
//  02-SQLite的使用(Swift)
//
//  Created by apple on 15/11/29.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit

class SQLiteManager: NSObject {
    
    // 定义单例的属性,使用let定义的属性本身就是线程安全
    static let instance : SQLiteManager = SQLiteManager()
    
    // 对外提供一个接口,返回单例实例
    class func shareInstance() -> SQLiteManager {
        return instance
    }
    
    // MARK:- 创建数据库和表的方法
    var db : COpaquePointer = nil
    
    func openDB() -> Bool {
        // 1.获取数据库存放的路径
        var filePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first;
        filePath = (filePath! as NSString).stringByAppendingPathComponent("my.sqlite")
        let cFilePath = (filePath?.cStringUsingEncoding(NSUTF8StringEncoding))!
        
        print(filePath)
        
        // 2.打开数据库
        if sqlite3_open(cFilePath, &db) != SQLITE_OK {
            print("打开数据库失败");
            return false
        }
        
        // 3.创建表
        return createTable()
    }
    
    func createTable() -> Bool {
        // 1.封装创建表的SQL语句
        let createTableSQL = "CREATE TABLE IF NOT EXISTS 't_student' ('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'name' TEXT,'age' INTEGER);"
        
        // 2.执行SQL语句
        return execSQL(createTableSQL)
    }
    
    func execSQL(sql : String) -> Bool {
        // 1.将语句转成c语言字符串
        let cSQL = (sql.cStringUsingEncoding(NSUTF8StringEncoding))!
        
        return sqlite3_exec(db, cSQL, nil, nil, nil) == SQLITE_OK
    }
    
    // MARK:- 查询语句
    func querySQL(querySQL : String) -> [[String : AnyObject]]? {
        // 0.游标对象
        var stmt : COpaquePointer = nil
        
        // 1.将查询语句转成C语言的字符串
        let cQuerySQL = (querySQL.cStringUsingEncoding(NSUTF8StringEncoding))!
        
        // 2.准备工作
        if sqlite3_prepare_v2(db, cQuerySQL, -1, &stmt, nil) != SQLITE_OK {
            print("没有准备成功")
            return nil
        }
        
        // 3.查询数据
        var tempArray = [[String : AnyObject]]()
        let count = sqlite3_column_count(stmt)
        while sqlite3_step(stmt) == SQLITE_ROW {
            var dict = [String : AnyObject]()
            for i in 0..<count {
                // 1.取出key
                let cValue = UnsafePointer<Int8>(sqlite3_column_text(stmt, i))
                let value = String(CString: cValue, encoding: NSUTF8StringEncoding)!
                
                // 2.取出值
                let cKey = sqlite3_column_name(stmt, i)
                let key = String(CString: cKey, encoding: NSUTF8StringEncoding)!
                
                // 3.将键值对添加到字典中
                dict[key] = value
            }
            
            tempArray.append(dict)
        }
        
        return tempArray
    }
    
    // MARK:- 事务的封装
    func beginTransaction() {
        execSQL("BEGIN TRANSACTION;")
    }
    
    func rollBackTransaction() {
        execSQL("ROLLBACK TRANSACTION;")
    }
    
    func commitTransaction() {
        execSQL("COMMIT TRANSACTION;")
    }
}
