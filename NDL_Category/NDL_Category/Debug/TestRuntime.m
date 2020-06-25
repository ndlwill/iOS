//
//  TestRuntime.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/17.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestRuntime.h"

@implementation TestRuntime

- (void)logRuntime
{
    NSLog(@"###TestRuntime logRuntime###");
}

#pragma mark - 遍历方法-ivar-property
- (void)printClassAllMethod:(Class)cls{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    for (int i = 0; i<count; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        IMP imp = class_getMethodImplementation(cls, sel);
        NSLog(@"%@-%p",NSStringFromSelector(sel),imp);
    }
    free(methodList);
}

#pragma mark - 遍历类以及子类
- (void)printClasses:(Class)cls{
    
    /// 注册类的总数
    int count = objc_getClassList(NULL, 0);
    NSLog(@"count = %d", count);
    
    /// 创建一个数组， 其中包含给定对象
    NSMutableArray *mArray = [NSMutableArray arrayWithObject:cls];
    /// 获取所有已注册的类
    Class* classes = (Class*)malloc(sizeof(Class)*count);
    objc_getClassList(classes, count);
    for (int i = 0; i<count; i++) {
        if (cls == class_getSuperclass(classes[i])) {
            [mArray addObject:classes[i]];
        }
    }
    free(classes);
    NSLog(@"classes = %@", mArray);
}

@end
