//
//  TestCategory.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/23.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestCategory.h"

@implementation TestCategory

- (void)test
{
    NSLog(@"TestCategory origin test");
}

- (void)test1
{
    NSLog(@"TestCategory origin test1");
}

//- (void)testAddMethod
//{
//    Method newMethod = class_getInstanceMethod([self class], @selector(newTestAddMethod));
//    BOOL flag = class_addMethod([self class], @selector(test1), method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
//    NSLog(@"flag = %@", flag ? @"YES" : @"NO");// NO 添加test1失败,原本就存在test1
//}

- (void)newTestAddMethod
{
    NSLog(@"newTestAddMethod");
}

- (void)testReplaceMethod
{
    Method method = class_getInstanceMethod([self class], @selector(testReplaceImp));
    NSLog(@"testReplaceImp TypeEncoding = %s", method_getTypeEncoding(method));
    // 替换方法: 1.如果testReplace不存在，相当于添加方法testReplace，如果执行testReplace会log:testReplaceImp
//    class_replaceMethod([self class], @selector(testReplace), method_getImplementation(method), method_getTypeEncoding(method));
    
    // 2.如果beReplacedMethod存在，把beReplacedMethod的实现替换为method的实现
    class_replaceMethod([self class], @selector(beReplacedMethod), method_getImplementation(method), method_getTypeEncoding(method));
}

- (void)beReplacedMethod
{
    NSLog(@"beReplacedMethod");
}

- (void)testReplaceImp
{
    NSLog(@"testReplaceImp");
}

@end
