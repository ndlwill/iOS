//
//  NSDate+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/6.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NDLExtension)

- (NSDateComponents *)ndl_deltaFrom:(NSDate *)fromDate;

// 是否为今年
- (BOOL)ndl_isThisYear;

// 是否为今天
- (BOOL)ndl_isToday;

// 是否为昨天
- (BOOL)ndl_isYesterday;

// yyyy-MM-dd HH:mm:ss
//- (NSDate *)ndl_currentDate;

- (NSDate *)ndl_currentDateWithFormat:(NSString *)dateFormat;

@end
