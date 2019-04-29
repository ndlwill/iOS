//
//  DBDaoFactory.h
//  NDL_Category
//
//  Created by dzcx on 2019/4/25.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBDao.h"

/*
 工厂方法模式定义一个用于创建对象的接口，让子类决定实例化哪一个类。工厂方法使一个类的实例化延迟到其子类
 在工厂方法模式中是一个子类对应一个工厂类，而这些工厂类都实现于一个抽象接口
 
 应该依赖的是一个抽象的接口或父类
 */
@interface DBDaoFactory : NSObject

- (id<DBDao>)createDao;

@end
