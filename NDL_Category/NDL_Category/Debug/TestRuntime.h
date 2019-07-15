//
//  TestRuntime.h
//  NDL_Category
//
//  Created by dzcx on 2018/7/17.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 返回的是objc_class结构体的首地址，也就是self->isa的值
 */
