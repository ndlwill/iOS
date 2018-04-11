//
//  NSFileManager+NDLExtension.m
//  NDL_Category
//
//  Created by ndl on 2018/2/27.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NSFileManager+NDLExtension.h"

@implementation NSFileManager (NDLExtension)

+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory
{
    return [[self defaultManager] URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (BOOL)skipBackupToFile:(NSString *)filePath
{
    return [[[NSURL alloc] initFileURLWithPath:filePath] setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
}

+ (CGFloat)availableDiskSpace
{
    NSDictionary *attrs = [[self defaultManager] attributesOfFileSystemForPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject error:nil];
    return [attrs[NSFileSystemFreeSize] unsignedLongLongValue] / (double)0x100000;
}

@end
