//
//  ServerUrls.m
//  NDL_Category
//
//  Created by dzcx on 2018/5/16.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "ServerUrls.h"

#if DevelopmentServer
NSString * const kBaseUrl = @"https://dev.letzgo.com.cn";
#elif TestServer
NSString * const kBaseUrl = @"https://test.letzgo.com.cn";
#elif ProductionServer
NSString * const kBaseUrl = @"https://pro.letzgo.com.cn";
#endif

NSString * const kLoginUrl = @"/login";
