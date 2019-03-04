//
//  UserInfo.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/28.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

SINGLETON_FOR_IMPLEMENT(UserInfo)

// NSLog会走对象的description
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ : %p , %@", [self class], self, @{@"userID" : @(_userID), @"token" : _token}];
}

@end
