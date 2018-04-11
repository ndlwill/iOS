//
//  Person.m
//  NDL_Category
//
//  Created by ndl on 2018/2/27.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)dealloc
{
    NSLog(@"Person Dealloc");
}

+ (instancetype)personWithName:(NSString *)name age:(NSInteger)age
{
    Person *person = [[Person alloc] init];
    person.name = name;
    person.age = age;
    return person;
}

@end
