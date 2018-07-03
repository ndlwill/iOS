//
//  HttpHeader.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/28.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "HttpHeader.h"
#import "OpenUDID.h"

@implementation HttpHeader

- (instancetype)init
{
    if (self = [super init]) {
        _userID = [UserInfo sharedUserInfo].userID;
        _imei = [OpenUDID value];
        _osType = 2;
        _appVersion = App_Bundle_Version;
        _channel = @"AppStore";
        _mobileModel = CurrentDevice.machineModel;
        _mobileModelName = CurrentDevice.machineModelName;
        _token = [UserInfo sharedUserInfo].token;
    }
    return self;
}

@end
