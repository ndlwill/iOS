//
//  BluetoothAuthority.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/19.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothAuthority : NSObject

+ (BOOL)authorized;

+ (CBPeripheralManagerAuthorizationStatus)authorizationStatus;

+ (void)authorizeWithCompletion:(void (^)(BOOL granted))completion;

@end
