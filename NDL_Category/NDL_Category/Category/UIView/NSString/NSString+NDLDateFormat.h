//
//  NSString+NDLDateFormat.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/6.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NDLDateFormat)

// return : yyyy年MM月dd日       self:@"2017-10-11"   str:@"-"
- (instancetype)ndl_stringFromSeparateString:(NSString *)str;
// [@"2017-12-12 09:01" dateWithFormatter:@"yyyy-MM-dd HH:mm"] string&fmt要相对应 不然返回null
- (NSDate *)ndl_dateWithFormatter:(NSString *)fmtStr;
// 2017-12-12 00:00 -> 2017年12月12日 00:00
- (instancetype)ndl_convertToCNDateString;
// 几天前，几分钟前等
+ (instancetype)ndl_convertToTimeStatusFromTimeInterval:(NSTimeInterval)timeInterval;

@end
