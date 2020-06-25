//
//  NSObject+LGKVO.m
//  003---自定义KVO
//
//  Created by cooci on 2019/1/5.
//  Copyright © 2019 cooci. All rights reserved.
//

#import "NSObject+LGKVO.h"
#import <objc/message.h>

//static NSString *const kLGKVOPrefix = @"LGKVONotifying_";
//static NSString *const kLGKVOAssiociateKey = @"kLGKVO_AssiociateKey";
//
//@implementation NSObject (LGKVO)
//
//- (void)lg_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(LGKeyValueObservingOptions)options context:(nullable void *)context{
//    
//    // 1: 验证是否存在setter方法 : 不让实例进来
//    [self judgeSetterMethodFromKeyPath:keyPath];
//    // 2: 动态生成子类
//    Class newClass = [self createChildClassWithKeyPath:keyPath];
//    // 3: isa的指向 : LGKVONotifying_LGPerson
//    object_setClass(self, newClass);
//    // 4: 保存观察者信息
//    LGKVOInfo *info = [[LGKVOInfo alloc] initWitObserver:observer forKeyPath:keyPath options:options];
//    NSMutableArray *observerArr = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
//    
//    if (!observerArr) {
//        observerArr = [NSMutableArray arrayWithCapacity:1];
//        [observerArr addObject:info];
//        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey), observerArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//
//}
//
//- (void)lg_observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
//    
//}
//
//
//- (void)lg_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
//    
//    NSMutableArray *observerArr = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
//    if (observerArr.count<=0) {
//        return;
//    }
//    
//    for (LGKVOInfo *info in observerArr) {
//        if ([info.keyPath isEqualToString:keyPath]) {
//            [observerArr removeObject:info];
//            objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey), observerArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//            break;
//        }
//    }
//
//    if (observerArr.count<=0) {
//        // 指回给父类
//        Class superClass = [self class];
//        object_setClass(self, superClass);
//    }
//}
//
//#pragma mark - 验证是否存在setter方法
//- (void)judgeSetterMethodFromKeyPath:(NSString *)keyPath{
//    Class superClass    = object_getClass(self);
//    SEL setterSeletor   = NSSelectorFromString(setterForGetter(keyPath));
//    Method setterMethod = class_getInstanceMethod(superClass, setterSeletor);
//    if (!setterMethod) {
//        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"老铁没有当前%@的setter",keyPath] userInfo:nil];
//    }
//}
//
//#pragma mark -
//- (Class)createChildClassWithKeyPath:(NSString *)keyPath{
//    
//    NSString *oldClassName = NSStringFromClass([self class]);
//    NSString *newClassName = [NSString stringWithFormat:@"%@%@",kLGKVOPrefix,oldClassName];
//    Class newClass = NSClassFromString(newClassName);
//    // 防止重复创建生成新类
//    if (newClass) return newClass;
//    /**
//     * 如果内存不存在,创建生成
//     * 参数一: 父类
//     * 参数二: 新类的名字
//     * 参数三: 新类的开辟的额外空间
//     */
//    // 2.1 : 申请类
//    newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
//    // 2.2 : 注册类
//    objc_registerClassPair(newClass);
//    // 2.3.1 : 添加class : class的指向是LGPerson
//    SEL classSEL = NSSelectorFromString(@"class");
//    Method classMethod = class_getInstanceMethod([self class], classSEL);
//    const char *classTypes = method_getTypeEncoding(classMethod);
//    class_addMethod(newClass, classSEL, (IMP)lg_class, classTypes);
//    // 2.3.2 : 添加setter
//    SEL setterSEL = NSSelectorFromString(setterForGetter(keyPath));
//    Method setterMethod = class_getInstanceMethod([self class], setterSEL);
//    const char *setterTypes = method_getTypeEncoding(setterMethod);
//    class_addMethod(newClass, setterSEL, (IMP)lg_setter, setterTypes);
//    return newClass;
//}
//
//static void lg_setter(id self,SEL _cmd,id newValue){
//    NSLog(@"来了:%@",newValue);
//    // 4: 消息转发 : 转发给父类
//    // 改变父类的值 --- 可以强制类型转换
//    NSString *keyPath = getterForSetter(NSStringFromSelector(_cmd));
//    id oldValue       = [self valueForKey:keyPath];
//    
//    void (*lg_msgSendSuper)(void *,SEL , id) = (void *)objc_msgSendSuper;
//    // void /* struct objc_super *super, SEL op, ... */
//    struct objc_super superStruct = {
//        .receiver = self,
//        .super_class = class_getSuperclass(object_getClass(self)),
//    };
//    //objc_msgSendSuper(&superStruct,_cmd,newValue)
//    lg_msgSendSuper(&superStruct,_cmd,newValue);
//    // 1: 拿到观察者
//    NSMutableArray *observerArr = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
//    
//    for (LGKVOInfo *info in observerArr) {
//        if ([info.keyPath isEqualToString:keyPath]) {
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                NSMutableDictionary<NSKeyValueChangeKey,id> *change = [NSMutableDictionary dictionaryWithCapacity:1];
//                // 对新旧值进行处理
//                if (info.options & LGKeyValueObservingOptionNew) {
//                    [change setObject:newValue forKey:NSKeyValueChangeNewKey];
//                }
//                if (info.options & LGKeyValueObservingOptionOld) {
//                    [change setObject:@"" forKey:NSKeyValueChangeOldKey];
//                    if (oldValue) {
//                        [change setObject:oldValue forKey:NSKeyValueChangeOldKey];
//                    }
//                }
//                // 2: 消息发送给观察者
//                SEL observerSEL = @selector(lg_observeValueForKeyPath:ofObject:change:context:);
//                objc_msgSend(info.observer,observerSEL,keyPath,self,change,NULL);
//            });
//        }
//    }
//    
//}
//
//Class lg_class(id self,SEL _cmd){
//    return class_getSuperclass(object_getClass(self));
//}
//
//#pragma mark - 从get方法获取set方法的名称 key ===>>> setKey:
//static NSString *setterForGetter(NSString *getter){
//    
//    if (getter.length <= 0) { return nil;}
//    
//    NSString *firstString = [[getter substringToIndex:1] uppercaseString];
//    NSString *leaveString = [getter substringFromIndex:1];
//    
//    return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
//}
//
//#pragma mark - 从set方法获取getter方法的名称 set<Key>:===> key
//static NSString *getterForSetter(NSString *setter){
//    
//    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
//    
//    NSRange range = NSMakeRange(3, setter.length-4);
//    NSString *getter = [setter substringWithRange:range];
//    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
//    return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
//}
//
//
//@end
