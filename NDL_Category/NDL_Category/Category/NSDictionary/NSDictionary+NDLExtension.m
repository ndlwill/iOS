//
//  NSDictionary+NDLExtension.m
//  NDL_Category
//
//  Created by dzcx on 2018/4/10.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NSDictionary+NDLExtension.h"

@implementation NSDictionary (NDLExtension)

- (id)notNullObjectForKey:(id)key
{
    id obj = self[key];
    if (!obj || [obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return obj;
}

- (id)notNullArrayForKey:(id)key
{
    id obj = [self objectForKey:key];
    if (!obj || [obj isKindOfClass:[NSNull class]]) {
        return [NSArray array];
    }
    return obj;
}

@end
