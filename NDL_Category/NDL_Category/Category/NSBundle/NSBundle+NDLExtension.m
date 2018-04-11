//
//  NSBundle+NDLExtension.m
//  NDL_Category
//
//  Created by ndl on 2018/1/31.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NSBundle+NDLExtension.h"

@implementation NSBundle (NDLExtension)

// bundle相当于一个文件夹 得到指定的bundle
+ (NSBundle *)ndl_vendorBundleWithName:(NSString *)bundleName
{
    NSArray *items = [bundleName componentsSeparatedByString:@"."];
    NSString *firstStr = items.firstObject;
    NSString *lastStr = items.lastObject;
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:firstStr ofType:lastStr]];

    return bundle;
}

+ (UIImage *)ndl_imageNamed:(NSString *)imageName bundleName:(NSString *)bundleName
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    imageName = (3.0 == scale ? [NSString stringWithFormat:@"%@@3x.png", imageName] : [NSString stringWithFormat:@"%@@2x.png", imageName]);
    return [UIImage imageWithContentsOfFile:[[[NSBundle ndl_vendorBundleWithName:bundleName] resourcePath] stringByAppendingPathComponent:imageName]];
}

+ (NSString *)ndl_localizedStringForKey:(NSString *)key bundleName:(NSString *)bundleName
{
    return [self ndl_localizedStringForKey:key value:nil bundleName:bundleName];
}

+ (NSString *)ndl_localizedStringForKey:(NSString *)key value:(NSString *)value bundleName:(NSString *)bundleName
{
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) language = @"en";
    else if ([language hasPrefix:@"es"]) language = @"es";
    else if ([language hasPrefix:@"fr"]) language = @"fr";
    else if ([language hasPrefix:@"zh"]) {
        if ([language rangeOfString:@"Hans"].location != NSNotFound) {
            language = @"zh-Hans";
        } else {
            language = @"zh-Hant";
        }
    } else {
        language = @"en";
    }
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle ndl_vendorBundleWithName:bundleName] pathForResource:language ofType:@"lproj"]];
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
    //NSLocalizedString(@"key", @"对这个key的描述");
}

@end
