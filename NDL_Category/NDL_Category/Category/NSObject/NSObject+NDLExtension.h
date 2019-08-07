//
//  NSObject+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/5/23.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 一个 Objective-C对象如何进行内存布局？（考虑有父类的情况）:
 所有父类的成员变量和自己的成员变量都会存放在该对象所对应的存储空间中
 父类的方法和自己的方法都会缓存在类对象的方法缓存中，类方法是缓存在元类对象中
 
 每个 Objective-C 对象都有相同的结构:
 Objective-C 对象的结构图
 ISA指针
 根类(NSObject)的实例变量
 倒数第二层父类的实例变量
 ...
 父类的实例变量
 类的实例变量
 */

/*
 Category编译之后的底层结构是struct category_t，里面存储着分类的对象方法、类方法
 在程序运行的时候，runtime会将Category的数据，合并到类信息中（类对象、元类对象中）
 */

/*
 当你向一个对象发送消息时，runtime会在这个对象所属的那个类的方法列表中查找。
 当你向一个类发送消息时，runtime会在这个类的meta-class的方法列表中查找
 
 self和[self class]的区别，self 是指向于一个objc_object结构体的首地址， [self class]返回的是objc_class结构体的首地址，也就是self->isa的值
 
 对于一个类对象来讲self返回的其实是一个指向objc_class对象的指针的地址；对于一个实例对象来讲self返回的其实是一个指向objc_object对象的指针地址
 
 + (Class)class {
 return self;
 }
 
 - (Class)class {
 // 返回的是isa指针指向的地址
 return object_getClass(self);
 }
 这两个方法其实是返回一个指向objc_class的对象指针,它们两个返回的地址是一样的
 
 superclass:
 + (Class)superclass {
 return self->superclass;
 }
 
 - (Class)superclass {
 return [self class]->superclass;
 }
 
 isMemberOfClass:
 + (BOOL)isMemberOfClass:(Class)cls {
 return object_getClass((id)self) == cls;
 }
 
 - (BOOL)isMemberOfClass:(Class)cls {
 return [self class] == cls;
 }
 
 isKindOfClass:
 + (BOOL)isKindOfClass:(Class)cls {
 for (Class tcls = object_getClass((id)self); tcls; tcls = tcls->superclass) {
 if (tcls == cls) return YES;
 }
 return NO;
 }
 
 - (BOOL)isKindOfClass:(Class)cls {
 for (Class tcls = [self class]; tcls; tcls = tcls->superclass) {
 if (tcls == cls) return YES;
 }
 return NO;
 }
 
 isSubclassOfClass:
 + (BOOL)isSubclassOfClass:(Class)cls {
 for (Class tcls = self; tcls; tcls = tcls->superclass) {
 if (tcls == cls) return YES;
 }
 return NO;
 }
 */
@interface NSObject (NDLExtension)

// 模型转字典 // 针对一层模型
- (NSDictionary *)ndl_model2Dictionary;

- (id)ndl_performSelector:(SEL)selector withObjects:(NSArray<id> *)objects;

@end

/*
 KVC:
 
 + (BOOL)accessInstanceVariablesDirectly;
 //默认返回YES，表示如果没有找到Set<Key>方法的话，会按照_key，_iskey，key，iskey的顺序搜索成员，设置成NO就不这样搜索
 
 设值:
 当调用setValue：属性值 forKey：@”name“的代码时，底层的执行机制如下：
 
 程序优先调用set<Key>:属性值方法，代码通过setter方法完成设置。注意，这里的<key>是指成员变量名，首字母大小写要符合KVC的命名规则
 如果没有找到setName：方法，KVC机制会检查+ (BOOL)accessInstanceVariablesDirectly方法有没有返回YES，默认该方法会返回YES，如果你重写了该方法让其返回NO的话，那么在这一步KVC会执行setValue：forUndefinedKey：方法，不过一般开发者不会这么做。所以KVC机制会搜索该类里面有没有名为_<key>的成员变量，无论该变量是在类接口处定义，还是在类实现处定义，也无论用了什么样的访问修饰符，只在存在以_<key>命名的变量，KVC都可以对该成员变量赋值。
 如果该类即没有set<key>：方法，也没有_<key>成员变量，KVC机制会搜索_is<Key>的成员变量。
 如果该类即没有set<Key>：方法，也没有_<key>和_is<Key>成员变量，KVC机制再会继续搜索<key>和is<Key>的成员变量。再给它们赋值。
 如果上面列出的方法或者成员变量都不存在，系统将会执行该对象的setValue：forUndefinedKey：方法，默认是抛出异常。
 
 如果开发者想让这个类禁用KVC里，那么重写+ (BOOL)accessInstanceVariablesDirectly方法让其返回NO即可，这样的话如果KVC没有找到set<Key>:属性名时，会直接用setValue：forUndefinedKey：方法
 */
