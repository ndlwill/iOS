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

/*
 NSDateFormatter:
 a: PM
 
 星期几:
 EEE: Sun
 EEEE: Sunday
 星期一 Mon Monday
 星期二 Tue Tuesday
 星期三 Wed Wednesday
 星期四 Thu Thursday
 星期五 Fri Friday
 星期六 Sat Saturday
 星期天 Sun Sunday

 月:
 M: 将月份显示为不带前导零的数字
 MM: 将月份显示为带前导零的数字
 MMM: 将月份显示为缩写形式（例如 Jan）
 MMMM: 将月份显示为完整月份名（例如 January）
 一月 Jan January
 二月 Feb February
 三月 Mar March
 四月 Apr April
 五月 May May
 六月 Jun June
 七月 Jul July
 八月 Aug August
 九月 Sep September
 十月 Oct October
 十一月 Nov November
 十二月 Dec December
 
 日:
 d: 将日显示为不带前导零的数字
 dd: 将日显示为带前导零的数字
 
 小时: 13点
 h 使用 12 小时制将小时显示为不带前导零的数字（例如 1:15:15）
 hh 使用 12 小时制将小时显示为带前导零的数字（例如 01:15:15）
 H 使用 24 小时制将小时显示为不带前导零的数字（例如 13:15:15）
 HH 使用 24 小时制将小时显示为带前导零的数字（例如 13:15:15）
 
 分钟:
 m 将分钟显示为不带前导零的数字（例如 12:1:15）
 mm 将分钟显示为带前导零的数字（例如 12:01:15）
 
 秒:
 s 将秒显示为不带前导零的数字（例如 12:15:5）
 ss 将秒显示为带前导零的数字（例如 12:15:05）
 
 时区:
 z GMT+8
 zzzz China Standard Time
 Z +0800
 
 上午还是下午
 a: AM || PM
 */

// UTC比GMT来得更加精准
// LT=UTC+时区差 (LT - 本地时间)
// 东区是加相应的时区差，西区是减时区差。如北京是东八区   北京时间=UTC+8=GMT+8
// 格林尼治标准时间 GMT
// 通用协调时 UTC,它其实是个更精确的GMT.
// NSDate存储的是世界标准时(UTC)
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
