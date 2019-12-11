//
//  NDLDevice.m
//  NDL_Category
//
//  Created by ndl on 2019/11/17.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "NDLDevice.h"

@implementation NDLDevice

// 对应1.不重写或者重写setter方法，都会调用kvo的回调
- (void)setDeviceName:(NSString *)deviceName
{
    // 1.
    _deviceName = [deviceName copy];
    // 2.这样会多回调一次
//    [self willChangeValueForKey:@"deviceName"];
//    _deviceName = [deviceName copy];
//    [self didChangeValueForKey:@"deviceName"];
}

@end
