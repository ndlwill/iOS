//
//  NSDate+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/6.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NSLocale类是将与国家和语言相关的信息进行简单的组合，包括货币、语言、国家等的信息
 公历（Gregorian calendar）
 */
@interface NSDate (NDLExtension)

- (NSDateComponents *)ndl_deltaFrom:(NSDate *)fromDate;

// 是否为今年
- (BOOL)ndl_isThisYear;

// 是否为今天
- (BOOL)ndl_isToday;

// 是否为昨天
- (BOOL)ndl_isYesterday;

// yyyy-MM-dd HH:mm:ss
+ (NSDate *)ndl_currentDate;

+ (NSDate *)ndl_currentDateWithFormat:(NSString *)dateFormat;

// ###parse internet date###
// date string -> date
+ (NSDate *)ndl_dateFromRFC3339String:(NSString *)dateString;
+ (NSDate *)ndl_dateFromRFC822String:(NSString *)dateString;

@end
