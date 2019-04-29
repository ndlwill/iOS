//
//  MessageService.h
//  NDL_Category
//
//  Created by dzcx on 2019/4/25.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WCDB_Message;

NS_ASSUME_NONNULL_BEGIN

// 业务逻辑层
@interface MessageService : NSObject

- (BOOL)insertMessage:(WCDB_Message *)message;
- (BOOL)insertMessages:(NSArray<WCDB_Message *> *)messages;

@end

NS_ASSUME_NONNULL_END
