//
//  WCDB_Message.mm
//  NDL_Category
//
//  Created by dzcx on 2019/4/24.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "WCDB_Message+WCTTableCoding.h"
#import "WCDB_Message.h"
#import <WCDB/WCDB.h>

@implementation WCDB_Message

// 用于在类文件中定义绑定到数据库表的类
WCDB_IMPLEMENTATION(WCDB_Message)
// 用于在类文件中定义绑定到数据库表的字段
WCDB_SYNTHESIZE(WCDB_Message, messageID)
WCDB_SYNTHESIZE(WCDB_Message, messageValue)
// 默认使用属性名作为数据库表的字段名。对于属性名与字段名不同的情况，可以使用WCDB_SYNTHESIZE_COLUMN(className, propertyName, columnName)进行映射。
WCDB_SYNTHESIZE_COLUMN(WCDB_Message, messageName, "c_messageName")
WCDB_SYNTHESIZE_DEFAULT(WCDB_Message, createDate, WCTDefaultTypeCurrentDate) //设置一个默认值

WCDB_PRIMARY_AUTO_INCREMENT(WCDB_Message, messageID)

WCDB_NOT_NULL(WCDB_Message, messageName)

- (BOOL)isAutoIncrement
{
    return YES;
}

@end
