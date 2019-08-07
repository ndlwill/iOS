//
//  NSObject+KVO.h
//  NDL_Category
//
//  Created by dzcx on 2019/6/24.
//  Copyright © 2019 ndl. All rights reserved.
//

/*
 __block:
 编译器会将__block变量包装成一个对象
 只要观察到该变量被 block 所持有，就将“外部变量”在栈中的内存地址放到了堆中。 进而在block内部也可以修改外部变量的值
 */

// KVC的 keyPath中的集合运算符:
// 集合运算符有@avg， @count ， @max ， @min ，@sum
// 格式 @"@sum.age"

/*
 instance对象的isa指向class对象
 class对象的isa指向meta-class对象
 meta-class对象的isa指向基类的meta-class对象
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChangedBlock)(NSString *keyPath, NSObject *observedObject, id oldValue, id newValue);

/*
 如果原类为 Person，那么生成的派生类名为NSKVONotifying_Person每个类对象中都有一个 isa 指针指向当前类，当一个类对象的第一次被观察，那么系统会偷偷将 isa 指针指向动态生成的派生类，从而在给被监控属性赋值时执行的是派生类的 setter 方法键值观察通知依赖于NSObject的两个方法 : willChangeValueForKey:    和 didChangevlueForKey:；在一个被观察属性发生改变之前， willChangeValueForKey:一定会被调用，这就 会记录旧的值。而当改变发生后，didChangeValueForKey: 会被调用，继而 observeValueForKey:ofObject:change:context: 也会被调用。
 补充：KVO 的这套实现机制中苹果还偷偷重写了 class 方法，让我们误认为还是使用的当前类 ，从而达到隐藏生成的派生类
 
 setter 方法随后负责通知观察对象属性的改变状况
 当修改instance对象的属性时，会调用Foundation的_NSSetXXXValueAndNotify函数:
 willChangeValueForKey:
 父类原来的setter
 didChangeValueForKey:
 内部会触发监听器（Oberser）的监听方法( observeValueForKeyPath:ofObject:change:context:）
 */

/*
 KVO 的实现:
 当你观察一个对象时，一个新的类会动态被创建。这个类继承自该对象的原本的类，并重写了被观察属性的 setter 方法。自然，重写的 setter 方法会负责在调用原 setter 方法之前和之后，通知所有观察对象值的更改。最后把这个对象的 isa 指针 ( isa 指针告诉 Runtime 系统这个对象的类是什么) 指向这个新创建的子类，对象就神奇的变成了新创建的子类的实例
 */
@interface NSObject (KVO)

- (void)ndl_addObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
           changedBlock:(ChangedBlock)changedBlock;

- (void)ndl_removeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END

/*
 对象的内存销毁时间表，分四个步骤:
 1.调用 -release ：引用计数变为零
 对象正在被销毁，生命周期即将结束.
 不能再有新的 __weak 弱引用，否则将指向 nil.
 调用 [self dealloc]
 
 2.父类调用 -dealloc
 继承关系中最直接继承的父类再调用 -dealloc
 如果是 MRC 代码 则会手动释放实例变量们（iVars）
 继承关系中每一层的父类 都再调用 -dealloc
 
 3.NSObject 调 -dealloc
 只做一件事：调用 Objective-C runtime 中的 object_dispose() 方法
 
 4.调用 object_dispose()
 为 C++ 的实例变量们（iVars）调用 destructors
 为 ARC 状态下的 实例变量们（iVars） 调用 -release
 解除所有使用 runtime Associate 方法关联的对象
 解除所有 __weak 引用
 调用 free()
 */
