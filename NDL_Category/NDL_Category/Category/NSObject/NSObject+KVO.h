//
//  NSObject+KVO.h
//  NDL_Category
//
//  Created by dzcx on 2019/6/24.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChangedBlock)(NSString *keyPath, NSObject *observedObject, id oldValue, id newValue);

/*
 KVO 的实现:
 当你观察一个对象时，一个新的类会动态被创建。这个类继承自该对象的原本的类，并重写了被观察属性的 setter 方法。自然，重写的 setter 方法会负责在调用原 setter 方法之前和之后，通知所有观察对象值的更改。最后把这个对象的 isa 指针 ( isa 指针告诉 Runtime 系统这个对象的类是什么 ) 指向这个新创建的子类，对象就神奇的变成了新创建的子类的实例
 */
@interface NSObject (KVO)

- (void)ndl_addObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
           changedBlock:(ChangedBlock)changedBlock;

- (void)ndl_removeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
