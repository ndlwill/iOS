//
//  TestRuntime.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/17.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 /// 创建类
 - (void)creatClassMethod {
 
 Class Person = objc_allocateClassPair([NSObject class], "Person", 0);
 //添加属性
 objc_property_attribute_t type = { "T", "@\"NSString\"" };
 objc_property_attribute_t ownership = { "C", "" }; // C = copy
 objc_property_attribute_t backingivar  = { "V", "_privateName" };
 objc_property_attribute_t attrs[] = { type, ownership, backingivar };
 class_addProperty(Person, "name", attrs, 3);
 //添加方法
 class_addMethod(Person, @selector(name), (IMP)nameGetter, "@@:");
 class_addMethod(Person, @selector(setName:), (IMP)nameSetter, "v@:@");
 //注册该类
 objc_registerClassPair(Person);
 
 //获取实例
 id instance = [[Person alloc] init];
 NSLog(@"%@", instance);
 [instance setName:@"hxn"];
 NSLog(@"%@", [instance name]);
 }
 //get方法
 NSString *nameGetter(id self, SEL _cmd) {
 Ivar ivar = class_getInstanceVariable([self class], "_privateName");
 return object_getIvar(self, ivar);
 }
 //set方法
 void nameSetter(id self, SEL _cmd, NSString *newName) {
 Ivar ivar = class_getInstanceVariable([self class], "_privateName");
 id oldName = object_getIvar(self, ivar);
 if (oldName != newName) object_setIvar(self, ivar, [newName copy]);
 }
 */

/*
给类添加一个属性后，在类结构体里元素会发生变化：
instance_size ：实例的内存大小
objc_ivar_list *ivars:属性列表
 */

// ##runtime##
// http://blog.csdn.net/tianxiawuzhei/article/details/51067490
/*
 每一个对象都有一个名为 isa 的指针，指向该对象的类
 
 class_replaceMethod当类中没有想替换的原方法时，该方法会调用class_addMethod来为该类增加一个新方法，也因为如此，class_replaceMethod在调用时需要传入types参数
 */

/*
 method_exchangeImplementations方法做的事情与如下的操作等价：
 IMP imp1 = method_getImplementation(m1);
 IMP imp2 = method_getImplementation(m2);
 method_setImplementation(m1, imp2);
 method_setImplementation(m2, imp1);
 */

// 在forwardInvocation:消息发送前，Runtime系统会向对象发送methodSignatureForSelector:消息，并取到返回的方法签名用于生成NSInvocation对象
// NSInvocation类型的对象——该对象封装了原始的消息和消息的参数

/*
 当 self 为实例对象时，[self class] 与 object_getClass(self) 等价，因为前者会调用后者。object_getClass([self class]) 得到元类。
 当 self 为类对象时，[self class] 返回值为自身，还是 self。object_getClass(self) 与 object_getClass([self class]) 等价
 
 
 [NSObject class] 与 [object class] 的区别：
 + (Class)class {
 return self;
 }
 
 - (Class)class {
 return object_getClass(self);
 }
 */

/*
 #import <Foundation/Foundation.h>
 
 @interface Student : NSObject
 + (void)learnClass:(NSString *) string;
 - (void)goToSchool:(NSString *) name;
 @end
 
 
 #import "Student.h"
 #import <objc/runtime.h>
 
 @implementation Student
 + (BOOL)resolveClassMethod:(SEL)sel {
 if (sel == @selector(learnClass:)) {
 class_addMethod(object_getClass(self), sel, class_getMethodImplementation(object_getClass(self), @selector(myClassMethod:)), "v@:");
 return YES;
 }
 return [class_getSuperclass(self) resolveClassMethod:sel];
 }
 
 + (BOOL)resolveInstanceMethod:(SEL)aSEL
 {
 if (aSEL == @selector(goToSchool:)) {
 class_addMethod([self class], aSEL, class_getMethodImplementation([self class], @selector(myInstanceMethod:)), "v@:");
 return YES;
 }
 return [super resolveInstanceMethod:aSEL];
 }
 
 + (void)myClassMethod:(NSString *)string {
 NSLog(@"myClassMethod = %@", string);
 }
 
 - (void)myInstanceMethod:(NSString *)string {
 NSLog(@"myInstanceMethod = %@", string);
 }
 @end
 */

/*
 每个 Class 结构体中都有一个 Dispatch Table 的成员变量，Dispatch Table 中建立了每个 SEL（方法名）和对应的 IMP（方法实现，指向 C 函数的指针）的映射关系，Method Swizzling 就是将原有的 SEL 和 IMP映射关系打破，并建立新的关联来达到方法替换的目的
 */
@interface TestRuntime : NSObject

- (void)logRuntime;

@end
/*
 typedef struct objc_class *Class;
 typedef struct objc_object *id;
 
 当你向一个对象发送消息时，runtime会在这个对象所属的那个类的方法列表中查找。
 当你向一个类发送消息时，runtime会在这个类的meta-class的方法列表中查找
 
 self 是指向于一个objc_object结构体的首地址
 objc_class结构体的首地址，也就是self->isa的值
 */
