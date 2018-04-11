//
//  NSString+DirPath.h
//  NDL_Category
//
//  Created by ndl on 2018/2/27.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DirPath)

// NSSearchPathDirectory
+ (NSString *)pathForSearchPathDirectory:(NSSearchPathDirectory)directory;

+ (NSString *)documentDir;

+ (NSString *)cachesDir;

@end
