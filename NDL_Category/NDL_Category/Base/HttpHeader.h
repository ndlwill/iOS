//
//  HttpHeader.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/28.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

// UDID的全名为 Unique Device Identifier :设备唯一标识符 UDID是一个40位十六进制序列 UDID是只和iOS设备有关的
// 被苹果禁用了 将UUID保存在keychain里面，每次调用先检查钥匙串里面有没有，有则使用，没有则写进去，保证其唯一性
@interface HttpHeader : NSObject

@property (nonatomic, assign) long long userID;// 用户ID
@property (nonatomic, copy) NSString *imei;// 设备号 唯一
@property (nonatomic, assign) NSUInteger osType;// 0-未知,1-安卓,2-iOS
@property (nonatomic, copy) NSString *appVersion;// 当前APP版本
@property (nonatomic, copy) NSString *channel;// 渠道 @"AppStore"

// [UIDevice currentDevice].model: e.g. @"iPhone"

@property (nonatomic, copy) NSString *mobileModel;// eg:x86_64 与下面的相对应
@property (nonatomic, copy) NSString *mobileModelName;// eg:Simulator x64

@property (nonatomic, copy) NSString *token;// 用户登录后分配的登录Token

@end
