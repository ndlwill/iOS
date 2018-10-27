//
//  LocationAuthority.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/15.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "LocationAuthority.h"

@interface LocationAuthority () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) void (^completion)(BOOL granted);

@end

@implementation LocationAuthority

+ (instancetype)sharedInstance
{
    static LocationAuthority *instance_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[LocationAuthority alloc] init];
    });
    return instance_;
}

+ (BOOL)isServicesEnabled
{
    return [CLLocationManager locationServicesEnabled];
}

+ (BOOL)authorized
{
    CLAuthorizationStatus status = [self authorizationStatus];
    return ((status == kCLAuthorizationStatusAuthorizedAlways) || (status == kCLAuthorizationStatusAuthorizedWhenInUse));
}

+ (CLAuthorizationStatus)authorizationStatus
{
    return [CLLocationManager authorizationStatus];
}

+ (void)authorizeWithCompletion:(void (^)(BOOL granted))completion
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            if (completion) {
                completion(YES);
            }
        }
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        {
            if (completion) {
                completion(NO);
            }
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            if (![self isServicesEnabled]) {
                if (completion) {
                    completion(NO);
                }
                return;
            }
            
            [[LocationAuthority sharedInstance] requestAccessWithCompletion:completion];
        }
            break;
        default:
            break;
    }
}

- (void)requestAccessWithCompletion:(void (^)(BOOL granted))completion
{
    self.completion = completion;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
    BOOL hasWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
    
    if (hasAlwaysKey) {
        [self.locationManager requestAlwaysAuthorization];
    } else if (hasWhenInUseKey) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            if (self.completion) {
                self.completion(YES);
            }
            self.completion = nil;
        }
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        {
            if (self.completion) {
                self.completion(NO);
            }
            self.completion = nil;
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
//            if (self.completion) {
//                self.completion(NO);
//            }
//            self.completion = nil;
        }
            break;
        default:
            break;
    }
}

@end
