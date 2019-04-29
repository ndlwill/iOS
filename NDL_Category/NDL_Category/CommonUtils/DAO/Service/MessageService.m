//
//  MessageService.m
//  NDL_Category
//
//  Created by dzcx on 2019/4/25.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "MessageService.h"
#import "MessageDaoFactory.h"

@interface MessageService ()

@property (nonatomic, strong) MessageDaoImpl *messageDao;

@end

@implementation MessageService

- (instancetype)init
{
    if (self = [super init]) {
        _messageDao = [[[MessageDaoFactory alloc] init] createDao];
    }
    return self;
}

#pragma mark - public methods
- (BOOL)insertMessage:(WCDB_Message *)message
{
    return [_messageDao insertModelObj:message];
}

- (BOOL)insertMessages:(NSArray<WCDB_Message *> *)messages
{
    return [_messageDao insertModelObjs:messages];
}

@end
