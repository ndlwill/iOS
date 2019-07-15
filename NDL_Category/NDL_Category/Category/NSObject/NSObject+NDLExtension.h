//
//  NSObject+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/5/23.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

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
