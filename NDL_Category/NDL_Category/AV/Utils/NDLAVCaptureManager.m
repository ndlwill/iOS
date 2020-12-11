//
//  NDLAVCaptureManager.m
//  NDL_Category
//
//  Created by youdone-ndl on 2020/11/25.
//  Copyright © 2020 ndl. All rights reserved.
//

#import "NDLAVCaptureManager.h"

@implementation NDLAVCaptureManager

+ (instancetype)shared {
    static NDLAVCaptureManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NDLAVCaptureManager alloc] init];
    });
    return manager;
}

@end
