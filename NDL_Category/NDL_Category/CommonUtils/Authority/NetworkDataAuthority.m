//
//  NetworkDataAuthority.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/19.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NetworkDataAuthority.h"
#import <CoreTelephony/CTCellularData.h>

@interface NetworkDataAuthority ()

@property (nonatomic, strong) CTCellularData *cellularData;

@end

@implementation NetworkDataAuthority

+ (instancetype)sharedInstance
{
    static NetworkDataAuthority *instance_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[NetworkDataAuthority alloc] init];
    });
    return instance_;
}

+ (void)authorizeWithCompletion:(void (^)(BOOL granted))completion
{
    if (@available(iOS 9.0, *)) {
        CTCellularData *cellularData = [[CTCellularData alloc] init];
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (state) {
                    case kCTCellularDataNotRestricted:
                    {
                        if (completion) {
                            completion(YES);
                        }
                    }
                        break;
                    case kCTCellularDataRestricted:
                    {
                        if (completion) {
                            completion(NO);
                        }
                    }
                        break;
                    case kCTCellularDataRestrictedStateUnknown:
                    {
//                        if (completion) {
//                            completion(NO);
//                        }
                    }
                        break;
                    default:
                        break;
                }
            });
        };
        [NetworkDataAuthority sharedInstance].cellularData = cellularData;
    } else {
        if (completion) {
            completion(YES);
        }
    }
}

@end
