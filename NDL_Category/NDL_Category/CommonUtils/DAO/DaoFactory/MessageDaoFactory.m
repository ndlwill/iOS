//
//  MessageDaoFactory.m
//  NDL_Category
//
//  Created by dzcx on 2019/4/25.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "MessageDaoFactory.h"

@implementation MessageDaoFactory

#pragma mark - overrides
- (id<DBDao>)createDao
{
    return [[MessageDaoImpl alloc] init];
}

@end
