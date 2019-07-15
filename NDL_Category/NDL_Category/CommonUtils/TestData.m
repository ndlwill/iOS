//
//  TestData.m
//  NDL_Category
//
//  Created by dzcx on 2019/6/11.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestData.h"

@implementation TestData

- (NSDictionary *)transformOriginData:(NSDictionary *)originData
{
    return (originData ? @{@"id" : originData[@"id"], @"name" : originData[@"name"]} : nil);
}

@end
