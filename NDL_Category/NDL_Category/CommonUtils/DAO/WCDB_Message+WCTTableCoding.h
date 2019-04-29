//
//  WCDB_Message+WCTTableCoding.h
//  NDL_Category
//
//  Created by dzcx on 2019/4/24.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "WCDB_Message.h"
#import <WCDB/WCDB.h>

@interface WCDB_Message (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(messageID)
WCDB_PROPERTY(messageValue)
WCDB_PROPERTY(messageName)
WCDB_PROPERTY(createDate)

@end
