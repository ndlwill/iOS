//
//  HealthAuthority.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/15.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "HealthAuthority.h"
#import <HealthKit/HealthKit.h>

@implementation HealthAuthority

+ (BOOL)authorized
{
    return ([self authorizationStatus] == HKAuthorizationStatusSharingAuthorized);
}

+ (BOOL)isHealthDataAvailable
{
    if (@available(iOS 8.0, *)) {
        return [HKHealthStore isHealthDataAvailable];
    }
    
    return NO;
}

+ (NSInteger)authorizationStatus
{
    if (@available(iOS 8.0, *)) {
        if (![HKHealthStore isHealthDataAvailable]) {
            return HKAuthorizationStatusSharingDenied;
        }
        
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        HKObjectType *objectType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
        HKAuthorizationStatus status = [healthStore authorizationStatusForType:objectType];
        return status;
    }
    
    return 3;// 不支持
}

+ (void)authorizeWithCompletion:(void (^)(BOOL granted))completion
{
    HKHealthStore *healthStore = [[HKHealthStore alloc] init];
    HKObjectType *objectType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKAuthorizationStatus status = [healthStore authorizationStatusForType:objectType];
    
    switch (status) {
        case HKAuthorizationStatusSharingAuthorized:
        {
            if (completion) {
                completion(YES);
            }
        }
            break;
        case HKAuthorizationStatusSharingDenied:
        {
            if (completion) {
                completion(NO);
            }
        }
            break;
        case HKAuthorizationStatusNotDetermined:
        {
            // 从Health Stroe中读取的所有的类型：个人特征（血液类型、性别、出生日期）、数据采样信息（身体质量、身高）以及锻炼与健身的信息。
            NSSet<HKObjectType *> *readTypes = [[NSSet alloc] initWithArray:@[[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth], [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBloodType], [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex], [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass], [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight], [HKObjectType workoutType]]];
            
            // 向Health Stroe写入的信息的所有类型（锻炼与健身的信息、BMI、能量消耗、运动距离）
            NSSet<HKSampleType *> *writeTypes = [[NSSet alloc] initWithArray:@[[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex], [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned], [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning], [HKObjectType workoutType]]];
            
            [healthStore requestAuthorizationToShareTypes:writeTypes readTypes:readTypes completion:^(BOOL success, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(success);
                    }
                });
            }];
        }
            break;
        default:
            break;
    }
}

@end
