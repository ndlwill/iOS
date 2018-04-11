//
//  NSString+DirPath.m
//  NDL_Category
//
//  Created by ndl on 2018/2/27.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NSString+DirPath.h"

@implementation NSString (DirPath)

+ (NSString *)pathForSearchPathDirectory:(NSSearchPathDirectory)directory
{
    NSString *path = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES).lastObject;
    return path;
}

+ (NSString *)documentDir
{
    return [self pathForSearchPathDirectory:NSDocumentDirectory];
}

+ (NSString *)cachesDir
{
    return [self pathForSearchPathDirectory:NSCachesDirectory];
}

@end
