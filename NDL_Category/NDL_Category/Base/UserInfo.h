//
//  UserInfo.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/28.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

SINGLETON_FOR_HEADER(UserInfo)

@property (nonatomic, assign) long long userID;// 用户ID

@property (nonatomic, copy) NSString *token;// 用户登录后分配的登录Token

@end
