//
//  LocalNotificationUtils.h
//  NDL_Category
//
//  Created by dzcx on 2018/11/6.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalNotificationUtils : NSObject

// 显示本地通知
+ (void)presentLocalNotificationWithContent:(NSString *)contentStr soundNamed:(NSString *)soundNamed;

@end

NS_ASSUME_NONNULL_END
