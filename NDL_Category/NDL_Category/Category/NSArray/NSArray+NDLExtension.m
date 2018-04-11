//
//  NSArray+NDLExtension.m
//  NDL_Category
//
//  Created by ndl on 2018/1/24.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "NSArray+NDLExtension.h"

@implementation NSArray (NDLExtension)

- (NSArray *)ndl_uniqueObjectArray
{
    NSSet *set = [NSSet setWithArray:self];
    return [set allObjects];
}

- (NSArray *)ndl_reversedArray
{
    return [self reverseObjectEnumerator].allObjects;
}

- (NSArray *)ndl_sortWithKey:(NSString *)key ascending:(BOOL)ascending
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    return [self sortedArrayUsingDescriptors:@[sortDescriptor]];
}


@end
