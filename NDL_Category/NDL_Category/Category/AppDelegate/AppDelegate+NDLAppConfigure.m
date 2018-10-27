//
//  AppDelegate+NDLAppConfigure.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/22.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "AppDelegate+NDLAppConfigure.h"

@implementation AppDelegate (NDLAppConfigure)

- (void)configJPushSDK
{
    
}

- (void)configShareSDK
{
    
}

- (void)configNetwork
{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = kBaseUrl;
}

@end
