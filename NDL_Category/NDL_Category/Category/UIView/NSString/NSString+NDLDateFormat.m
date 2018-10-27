//
//  NSString+NDLDateFormat.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/6.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NSString+NDLDateFormat.h"

@implementation NSString (NDLDateFormat)

- (instancetype)ndl_stringFromSeparateString:(NSString *)str
{
    NSArray *dateArray = [self componentsSeparatedByString:str];
    return [NSString stringWithFormat:@"%@年%@月%@日", dateArray[0], dateArray[1], dateArray[2]];
}

- (NSDate *)ndl_dateWithFormatter:(NSString *)fmtStr
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = fmtStr;
    return [fmt dateFromString:self];
}

- (instancetype)ndl_convertToCNDateString
{
    NSArray<NSString *> *tempArray = [self componentsSeparatedByString:@" "];
    NSString *firstStr = [tempArray.firstObject ndl_stringFromSeparateString:@"-"];
    NSString *lastStr = [@" " stringByAppendingString:tempArray.lastObject];
    return [firstStr stringByAppendingString:lastStr];
}

// curTimeInterval > timeInterval
+ (instancetype)ndl_convertToTimeStatusFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSTimeInterval curTimeInterval = [[NSDate date] timeIntervalSince1970];
//    NSTimeInterval createTimeInterval = timeInterval;
    NSTimeInterval deltaTimeInterval = curTimeInterval - timeInterval;
    
    if (deltaTimeInterval < 60.0) {
        return @"刚刚";
    }
    
    NSUInteger minutes = deltaTimeInterval / 60.0;
    if (minutes < 60) {
        return [NSString stringWithFormat:@"%ld分钟前", minutes];
    }
    
    NSUInteger hours = deltaTimeInterval / 3600;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前", hours];
    }
    
    NSUInteger days = deltaTimeInterval / 3600 / 24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前", days];
    }
    
    NSUInteger months = deltaTimeInterval / 3600 / 24 / 30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前", months];
    }
    
    NSUInteger years = deltaTimeInterval / 3600 / 24 / 30 / 12;
    return [NSString stringWithFormat:@"%ld年前", years];
}

@end
