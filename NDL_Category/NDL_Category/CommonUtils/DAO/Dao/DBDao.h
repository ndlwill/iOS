//
//  DBDao.h
//  NDL_Category
//
//  Created by dzcx on 2019/4/25.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/*
 DAO（Date Access Object）模型就是写一个类，把访问数据库的代码封装起来，DAO在数据库与业务逻辑（Service）之间
 
 DAO模型需要先提供一个DAO接口
 
 然后再提供一个DAO接口的实现类
 
 再编写一个DAO工厂，Service通过工厂来获取DAO实现
 */

// DAO接口中定义了所有的用户操作（增、删、改、查...）
@protocol DBDao <NSObject>

- (BOOL)createTableWithModelCls:(Class)cls;

- (BOOL)insertModelObj:(id)obj;
- (BOOL)insertModelObjs:(NSArray *)objs;

@end

NS_ASSUME_NONNULL_END
