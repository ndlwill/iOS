//
//  NSFileManager+NDLExtension.h
//  NDL_Category
//
//  Created by ndl on 2018/2/27.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSFileManager (NDLExtension)

+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory;

// Adds a special filesystem flag to a file to avoid iCloud backup it.
+ (BOOL)skipBackupToFile:(NSString *)filePath;

// ???
+ (CGFloat)availableDiskSpace;

@end
