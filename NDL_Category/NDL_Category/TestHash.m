//
//  TestHash.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/22.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestHash.h"

@implementation TestHash

- (id)copyWithZone:(nullable NSZone *)zone
{
    TestHash *testHash = [[[self class] allocWithZone:zone] init];
    return testHash;
}

// NSSet添加新成员时，需要根据hash值来快速查找成员，以保证集合中是否已经存在该成员
// NSDictionary在查找key时，也是利用了key的hash值来提高查找的效率
// 对象的hash方法什么时候被调用: hash方法只在对象被添加到NSSet和设置为NSDictionary的key时被调用
- (NSUInteger)hash
{
    NSInteger hashValue = [super hash];
    NSLog(@"===TestHash hash: hashValue = %ld===", hashValue);
    return hashValue;
}

@end

/*
 MARK:NSSet底层原理
 NSSet添加key，key值会根据特定的hash函数算出hash值，然后存储数据的时候，会根据hash函数算出来的值，找到对应的下标，如果该下标下已有数据，开放定址法后移动插入，如果数组到达阈值，这个时候就会进行扩容，然后重新hash插入。查询速度就可以和连续性存储的数据一样接近O(1)了
 
 MARK:NSDictionary底层原理
 当有重复的key插入到字典NSDictionary时，会覆盖旧值，而集合NSSet则什么都不做，保证了里面的元素不会重复
 
 字典里的键值对key-value是一一对应的关系
 首先key利用hash函数算出hash值，然后对数组的长度取模，得到数组下标的位置，同样将这个地址对应到values数组的下标，就匹配到相应的value
 要保证一点，就是keys和values这两个数组的长度要一致。所以扩容的时候，需要对keys和values两个数组一起扩容
 
 对于字典NSDictionary设置的key和value，key值会根据特定的hash函数算出hash值，keys和values同样多，利用hash值对数组长度取模，得到其对应的下标index，如果下标已有数据，开放定址法后移插入，如果数组达到阈值，就扩容，然后重新hash插入。这样的机制就把一些不连续的key-value值插入到能建立起关系的hash表中。
 查找的时候，key根据hash函数以及数组长度，得到下标，然后根据下标直接访问hash表的keys和values，这样查询速度就可以和连续线性存储的数据一样接近O(1)了
 */


//struct __CFDictionary {
//    CFRuntimeBase _base;
//    CFIndex _count;        /* number of values */
//    CFIndex _capacity;        /* maximum number of values */
//    CFIndex _bucketsNum;    /* number of slots */
//    uintptr_t _marker;
//    void *_context;        /* private */
//    CFIndex _deletes;
//    CFOptionFlags _xflags;      /* bits for GC */
//    const void **_keys;        /* can be NULL if not allocated yet */
//    const void **_values;    /* can be NULL if not allocated yet */
//};
