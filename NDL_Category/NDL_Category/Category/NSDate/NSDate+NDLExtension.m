//
//  NSDate+NDLExtension.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/6.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NSDate+NDLExtension.h"

@implementation NSDate (NDLExtension)

- (NSDateComponents *)ndl_deltaFrom:(NSDate *)fromDate
{
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:fromDate toDate:self options:0];
}

- (BOOL)ndl_isThisYear
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];// iOS8.0
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];// 需要判断的NSDate
    
    return nowYear == selfYear;
}

- (BOOL)ndl_isToday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    
    return [nowString isEqualToString:selfString];
}

- (BOOL)ndl_isYesterday
{
    // 2014-12-31 23:59:59 -> 2014-12-31
    // 2015-01-01 00:00:01 -> 2015-01-01
    
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}

// 返回值为NSDate  等价于[NSDate date]
- (NSDate *)ndl_currentDate
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
}

- (NSDate *)ndl_currentDateWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = dateFormat;
    return [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
}

@end
