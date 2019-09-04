//
//  Object1.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/24.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "Object1.h"

@implementation Object1

// KVO:比如Object1里面的所有属性都触发kvo 要和Object1关联起来
+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    // key:
    
    NSSet *keypaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"obj1"]) {// obj1: 某个类里的包含Object1 *obj1对象
        keypaths = [[NSSet alloc] initWithObjects:@"obj1.name", @"obj1.age", nil];
    }

    return keypaths;
}

- (void)dealloc
{
    NSLog(@"Object1 dealloc");
}

@end
