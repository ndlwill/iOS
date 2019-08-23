//
//  TestShareInstance.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/22.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestShareInstance.h"

/*
 单例是iOS中常用的一种设计模式。单例模式是一个类在系统中只用一个实例对象。通过全局的一个入口点对这个实例对象进行访问
 单例的好处：
 由于在系统内存中只存在一个对象，因此可以节约系统资源，对于一些需要频繁创建和销毁的对象单例模式无疑可以提高系统的性能
 
 单例分为两种：
 第一、完全意义上的单例：就是无论我们是alloc、copy、还是使用shared方法创建出来的单例对象都是一个；
 非完全意义上的单例：就是我们alloc、copy、还是使用shared方法创建出来的单例对象都是不相同（这种方式其实也就失去了单例的特性）。
 第二：线程安全的单例：就是多个线程同时访问的时候不会出现多个对象
 非线程安全的单例：就是多个线程同时访问的时候可能会出现多个对象
 ###我们一般使用的就是线程安全完全意义上的单例###
 */
@implementation TestShareInstance

static TestShareInstance *instance = nil;
// 使用GCD创建单例，线程安全的
+ (instancetype)sharedInstance
{
    // 1.非完全意义上的单例。[[TestShareInstance alloc] init];那么我们得到的就不是单例了，就是一个新的对象，这样就失去了单例的作用
    if (!instance) {
        NSLog(@"TestShareInstance alloc");
        instance = [[TestShareInstance alloc] init];
    }
    return instance;
}

// 2.完全意义上的单例.这样无论我们是使用alloc、copy、还是使用shared方法都只会创建一个对象，但是这种方式也是不安全的
// alloc会调用allocWithZone方法
// 重写alloc方法 或者底层 allocWithZone
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (instance == nil) {
        instance = [super allocWithZone:zone];
    }
    return instance;
}
// 当copy当前类型的对象时候 ，返回唯一的单例对象
- (id)copyWithZone:(NSZone *)zone {
    return instance;
}

// 3.非线程安全的单例
// 2中就是这样的样式，如果有多个线程同时访问shared方法，可能就会出现在访问的时候instance对象都是空的，那样就会创建多个对象了

// 4.线程安全的单例.就是使用GCD技术或线程锁的方法将线程保护起来，保证方法只执行一次
@end
