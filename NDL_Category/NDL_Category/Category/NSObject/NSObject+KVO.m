//
//  NSObject+KVO.m
//  NDL_Category
//
//  Created by dzcx on 2019/6/24.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/message.h>

static NSString * const kNDLKVOClassPrefix = @"NDLKVOClassPrefix_";
static NSString * const kNDLKVOAssociatedObservers = @"NDLKVOAssociatedObservers";

@interface NDLObservationInfo : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) ChangedBlock changedBlock;

@end

@implementation NDLObservationInfo

- (instancetype)initWithObserver:(NSObject *)observer keyPath:(NSString *)keyPath changedBlock:(ChangedBlock)changedBlock
{
    if (self = [super init]) {
        _observer = observer;
        _keyPath = keyPath;
        _changedBlock = changedBlock;
    }
    return self;
}

@end

static NSString *setterFromGetter(NSString *getter)
{
    if (getter.length <= 0) {
        return nil;
    }
    // upper case 大写
    NSString *firstCapitalLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstCapitalLetter, remainingLetters];
    return setter;
}

static NSString *getterFromSetter(NSString *setter)
{
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    // remove 'set' at the begining and ':' at the end
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *keyPath = [setter substringWithRange:range];
    
    // lower case the first letter
    NSString *firstLetter = [[keyPath substringToIndex:1] lowercaseString];
    keyPath = [keyPath stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];
    
    return keyPath;
}

#pragma mark - kvo_class重写的方法
// kvo_class重写class方法
static Class kvo_class(id self, SEL _cmd)
{
    Class selfClass = object_getClass(self);
    Class clazz = class_getSuperclass(selfClass);
    // kvo_class clazz = Person selfClass = NDLKVOClassPrefix_Person
    NSLog(@"kvo_class clazz = %@ selfClass = %@", clazz, selfClass);
    
    return clazz;
}

// kvo_class重写set(KeyPath)方法
static void kvo_setter(id self, SEL _cmd, id newValue)
{
    // 新的 setter 在调用原 setter 方法后，通知每个观察者（调用之前传入的 block ）
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterFromSetter(setterName);
    
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    // kvo_setter self = <Person: 0x600001d1c480> class = Person
    NSLog(@"kvo_setter self = %@ class = %@", self, [self class]);
    // ndl
    id oldValue = [self valueForKey:getterName];
    
    struct objc_super superclazz = {
        .receiver = self,// NDLKVOClassPrefix_Person
        .super_class = class_getSuperclass(object_getClass(self)) // Person
    };
    
    // cast our pointer so the compiler won't complain
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    // call super's(Person)
    // call super's setter, which is original class's setter method
    objc_msgSendSuperCasted(&superclazz, _cmd, newValue);
    
    // look up observers and call the blocks
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(kNDLKVOAssociatedObservers));
    for (NDLObservationInfo *info in observers) {
        if ([info.keyPath isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                info.changedBlock(getterName, self, oldValue, newValue);
            });
        }
    }
}

@implementation NSObject (KVO)

- (void)ndl_addObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
           changedBlock:(ChangedBlock)changedBlock
{
    // 检查对象的类有没有相应的 setter 方法。如果没有抛出异常
    SEL setterSelector = NSSelectorFromString(setterFromGetter(keyPath));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    if (!setterMethod) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have a setter for keyPath %@", self, keyPath];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        
        return;
    }
    // 检查对象 isa 指向的类是不是一个 KVO 类。如果不是，新建一个继承原来类的子类，并把 isa 指向这个新建的子类
    Class clazz = object_getClass(self);// isa指向的类
    NSLog(@"origin class = %@", clazz);
    NSString *clazzName = NSStringFromClass(clazz);
    
    if (![clazzName hasPrefix:kNDLKVOClassPrefix]) {
        clazz = [self kvoClassWithOriginalClassName:clazzName];
        object_setClass(self, clazz);// isa指向kvo类
    }
    
    // 检查对象的 KVO 类重写过没有这个 setter 方法。如果没有，添加重写的 setter 方法
    if (![self hasSelector:setterSelector]) {
        const char* types = method_getTypeEncoding(setterMethod);
        class_addMethod(clazz, setterSelector, (IMP)kvo_setter, types);
    }
    
    // 添加
    NDLObservationInfo *info = [[NDLObservationInfo alloc] initWithObserver:observer keyPath:keyPath changedBlock:changedBlock];
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(kNDLKVOAssociatedObservers));
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)(kNDLKVOAssociatedObservers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [observers addObject:info];
}

- (Class)kvoClassWithOriginalClassName:(NSString *)originalClassName
{
    NSString *kvoClassName = [kNDLKVOClassPrefix stringByAppendingString:originalClassName];
    // The class object named by aClassName, or nil if no class by that name is currently loaded. If aClassName is nil, returns nil
    Class kvoClass = NSClassFromString(kvoClassName);
    
    if (kvoClass) {
        return kvoClass;
    }
    
    // class doesn't exist yet, make it
    Class originalClass = object_getClass(self);
    // 动态创建新的类
    Class createdKvoClass = objc_allocateClassPair(originalClass, kvoClassName.UTF8String, 0);
    
    Method classMethod = class_getInstanceMethod(originalClass, @selector(class));
    const char *types = method_getTypeEncoding(classMethod);
    class_addMethod(createdKvoClass, @selector(class), (IMP)kvo_class, types);
    objc_registerClassPair(createdKvoClass);// 告诉 Runtime 这个类的存在
    
    return createdKvoClass;
}

- (BOOL)hasSelector:(SEL)selector
{
    Class clazz = object_getClass(self);
    NSLog(@"hasSelector  clazz = %@ self = %@", clazz, self);
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(clazz, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        SEL thisSelector = method_getName(methodList[i]);
        if (thisSelector == selector) {
            free(methodList);
            return YES;
        }
    }
    free(methodList);
    return NO;
}

- (void)ndl_removeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath
{
    NSMutableArray* observers = objc_getAssociatedObject(self, (__bridge const void *)(kNDLKVOAssociatedObservers));
    
    NDLObservationInfo *infoToRemove;
    for (NDLObservationInfo* info in observers) {
        if (info.observer == observer && [info.keyPath isEqualToString:keyPath]) {
            infoToRemove = info;
            break;
        }
    }
    
    [observers removeObject:infoToRemove];
}


@end
