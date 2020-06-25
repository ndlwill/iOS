//
//  NSObject+KVO_Func.m
//  NDL_Category
//
//  Created by ndl on 2020/6/21.
//  Copyright © 2020 ndl. All rights reserved.
//

#import "NSObject+KVO_Func.h"
#import <objc/message.h>
//
//static NSString *const kLGKVOPrefix = @"LGKVONotifying_";
//static NSString *const kLGKVOAssiociateKey = @"kLGKVO_AssiociateKey";
//
//@interface LGInfo : NSObject
//@property (nonatomic, weak) NSObject  *observer;
//@property (nonatomic, copy) NSString    *keyPath;
//@property (nonatomic, copy) LGKVOBlock  handleBlock;
//@end
//
//@implementation LGInfo
//
//- (instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath handleBlock:(LGKVOBlock)block{
//    if (self=[super init]) {
//        _observer = observer;
//        _keyPath  = keyPath;
//        _handleBlock = block;
//    }
//    return self;
//}
//@end
//
//@implementation NSObject (KVO_Func)
//
//- (void)lg_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath block:(LGKVOBlock)block{
//    
//    // 1: 验证是否存在setter方法 : 不让实例进来
//    [self judgeSetterMethodFromKeyPath:keyPath];
//    // 2: 动态生成子类
//    Class newClass = [self createChildClassWithKeyPath:keyPath];
//    // 3: isa的指向 : LGKVONotifying_LGPerson
//    object_setClass(self, newClass);
//    // 4: 保存信息
//    LGInfo *info = [[LGInfo alloc] initWitObserver:observer forKeyPath:keyPath handleBlock:block];
//    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
//    if (!mArray) {
//        mArray = [NSMutableArray arrayWithCapacity:1];
//        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey), mArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    [mArray addObject:info];
//}
//
//- (void)lg_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
//    
//    NSMutableArray *observerArr = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
//    if (observerArr.count<=0) {
//        return;
//    }
//    
//    for (LGInfo *info in observerArr) {
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
//    NSString *keyPath = getterForSetter(NSStringFromSelector(_cmd));
//    id oldValue = [self valueForKey:keyPath];
//    // 4: 消息转发 : 转发给父类
//    // 改变父类的值 --- 可以强制类型转换
//    void (*lg_msgSendSuper)(void *,SEL , id) = (void *)objc_msgSendSuper;
//    // void /* struct objc_super *super, SEL op, ... */
//    struct objc_super superStruct = {
//        .receiver = self,
//        .super_class = class_getSuperclass(object_getClass(self)),
//    };
//    //objc_msgSendSuper(&superStruct,_cmd,newValue)
//    lg_msgSendSuper(&superStruct,_cmd,newValue);
//    
//    // 5: 信息数据回调
//    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
//    
//    for (LGInfo *info in mArray) {
//        if ([info.keyPath isEqualToString:keyPath] && info.handleBlock) {
//            info.handleBlock(info.observer, keyPath, oldValue, newValue);
//        }
//    }
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


// MARK: KVO自动销毁机制
/**
 static NSString *const kLGKVOPrefix = @"LGKVONotifying_";
 static NSString *const kLGKVOAssiociateKey = @"kLGKVO_AssiociateKey";

 @interface LGInfo : NSObject
 @property (nonatomic, weak) NSObject  *observer;
 @property (nonatomic, copy) NSString    *keyPath;
 @property (nonatomic, copy) LGKVOBlock  handleBlock;
 @end

 @implementation LGInfo

 - (instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath handleBlock:(LGKVOBlock)block{
     if (self=[super init]) {
         _observer = observer;
         _keyPath  = keyPath;
         _handleBlock = block;
     }
     return self;
 }
 @end

 @implementation NSObject (LGKVO)

 //- (void)dealloc{
 //    Class superClass = [self class];
 //    object_setClass(self, superClass);
 //}

 + (BOOL)kc_hookOrigInstanceMenthod:(SEL)oriSEL newInstanceMenthod:(SEL)swizzledSEL {
     Class cls = self;
     Method oriMethod = class_getInstanceMethod(cls, oriSEL);
     Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
     
     if (!swiMethod) {
         return NO;
     }
     if (!oriMethod) {
         class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
         method_setImplementation(swiMethod, imp_implementationWithBlock(^(id self, SEL _cmd){ }));
     }
     
     BOOL didAddMethod = class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
     if (didAddMethod) {
         class_replaceMethod(cls, swizzledSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
     }else{
         method_exchangeImplementations(oriMethod, swiMethod);
     }
     return YES;
 }


 + (void)load{
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{

         [self kc_hookOrigInstanceMenthod:NSSelectorFromString(@"dealloc") newInstanceMenthod:@selector(myDealloc)];
     });
 }

 - (void)myDealloc{

     Class superClass = [self class];
     object_setClass(self, superClass);
     [self myDealloc];
 }

 - (void)lg_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath block:(LGKVOBlock)block{
     
     // 1: 验证是否存在setter方法 : 不让实例进来
     [self judgeSetterMethodFromKeyPath:keyPath];
     // 2: 动态生成子类
     Class newClass = [self createChildClassWithKeyPath:keyPath];
     // 3: isa的指向 : LGKVONotifying_LGPerson
     object_setClass(self, newClass);
     // 4: 保存信息
     NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
     LGInfo *info = [[LGInfo alloc] initWitObserver:observer forKeyPath:keyPath handleBlock:block];

   
     // observer - 哈希 - 独立的数组
     // FB  controller.infos -- controller -> self - vc
     // LGVC - controller -- infos
     
     
     if (!mArray) {
         mArray = [NSMutableArray arrayWithCapacity:1];
         objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey), mArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
     }
     
     for (LGInfo *info1 in mArray) {
         if (info1.observer == observer && [info1.keyPath isEqualToString:keyPath]) {
             break;
         }
         [mArray addObject:info];
     }
 }

 - (void)lg_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
     
     NSMutableArray *observerArr = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
     
     if (observerArr.count<=0) {
         return;
     }
     
     // FB -- 系统
     // KVO - KVC -- 普通
     // 集合 - 模拟 -- 探究 -- 思维
     for (LGInfo *info in observerArr) {
         if (!info.observer) {
             [observerArr removeObject:info];
             break;
         }
     }

     for (LGInfo *info in observerArr) {
         if ([info.keyPath isEqualToString:keyPath]) {
             [observerArr removeObject:info];
             objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey), observerArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
             break;
         }
     }
     
     if (observerArr.count<=0) {
         // 指回给父类
         Class superClass = [self class];
         object_setClass(self, superClass);
     }
 }

 #pragma mark - 验证是否存在setter方法
 - (void)judgeSetterMethodFromKeyPath:(NSString *)keyPath{
     Class superClass    = object_getClass(self);
     SEL setterSeletor   = NSSelectorFromString(setterForGetter(keyPath));
     Method setterMethod = class_getInstanceMethod(superClass, setterSeletor);
     if (!setterMethod) {
         @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"老铁没有当前%@的setter",keyPath] userInfo:nil];
     }
 }

 #pragma mark -
 - (Class)createChildClassWithKeyPath:(NSString *)keyPath{
     
     NSString *oldClassName = NSStringFromClass([self class]);
     NSString *newClassName = [NSString stringWithFormat:@"%@%@",kLGKVOPrefix,oldClassName];
     Class newClass = NSClassFromString(newClassName);
     // 防止重复创建生成新类
     if (newClass) return newClass;
     // 2.1 : 申请类
     newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
     // 2.2 : 注册类
     objc_registerClassPair(newClass);
     // 2.3.1 : 添加class : class的指向是LGPerson
     SEL classSEL = NSSelectorFromString(@"class");
     Method classMethod = class_getInstanceMethod([self class], classSEL);
     const char *classTypes = method_getTypeEncoding(classMethod);
     class_addMethod(newClass, classSEL, (IMP)lg_class, classTypes);
     // 2.3.2 : 添加setter
     SEL setterSEL = NSSelectorFromString(setterForGetter(keyPath));
     Method setterMethod = class_getInstanceMethod([self class], setterSEL);
     const char *setterTypes = method_getTypeEncoding(setterMethod);
     class_addMethod(newClass, setterSEL, (IMP)lg_setter, setterTypes);
     // 2.3.3 : 添加dealloc
     SEL deallocSEL = NSSelectorFromString(@"dealloc");
     Method deallocMethod = class_getInstanceMethod([self class], deallocSEL);
     const char *deallocTypes = method_getTypeEncoding(deallocMethod);
     class_addMethod(newClass, deallocSEL, (IMP)lg_dealloc, deallocTypes);
     
     return newClass;
 }

 static void lg_dealloc(id self,SEL _cmd){
     Class superClass = [self class];
     object_setClass(self, superClass);
 }

 static void lg_setter(id self,SEL _cmd,id newValue){
     NSLog(@"来了:%@",newValue);
     NSString *keyPath = getterForSetter(NSStringFromSelector(_cmd));
     id oldValue = [self valueForKey:keyPath];
     // 4: 消息转发 : 转发给父类
     // 改变父类的值 --- 可以强制类型转换
     void (*lg_msgSendSuper)(void *,SEL , id) = (void *)objc_msgSendSuper;
     
     struct objc_super superStruct = {
         .receiver = self,
         .super_class = class_getSuperclass(object_getClass(self)),
     };
     //objc_msgSendSuper(&superStruct,_cmd,newValue)
     lg_msgSendSuper(&superStruct,_cmd,newValue);
     
     // 5: 信息数据回调
     NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
     
     for (LGInfo *info in mArray) {
         if ([info.keyPath isEqualToString:keyPath] && info.handleBlock) {
             info.handleBlock(info.observer, keyPath, oldValue, newValue);
         }
     }
 }

 Class lg_class(id self,SEL _cmd){
     return class_getSuperclass(object_getClass(self));
 }

 #pragma mark - 从get方法获取set方法的名称 key ===>>> setKey:
 static NSString *setterForGetter(NSString *getter){
     
     if (getter.length <= 0) { return nil;}
     
     NSString *firstString = [[getter substringToIndex:1] uppercaseString];
     NSString *leaveString = [getter substringFromIndex:1];
     
     return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
 }

 #pragma mark - 从set方法获取getter方法的名称 set<Key>:===> key
 static NSString *getterForSetter(NSString *setter){
     
     if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
     
     NSRange range = NSMakeRange(3, setter.length-4);
     NSString *getter = [setter substringWithRange:range];
     NSString *firstString = [[getter substringToIndex:1] lowercaseString];
     return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
 }


 @end

 
 */
