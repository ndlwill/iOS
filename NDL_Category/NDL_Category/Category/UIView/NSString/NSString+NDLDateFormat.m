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

@end
