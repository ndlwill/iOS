//
//  NSObject+NDLExtension.h
//  NDL_Category
//
//  Created by dzcx on 2018/5/23.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 MARK:block
 传进 Block 之前，把self转换成 weakSelf
 如果在 Block 执行完成之前，self 被释放了，weakSelf 也会变为 nil
 _strong 确保在 Block 内，strongSelf 不会被释放
 内部的strongSelf是个局部变量 仅存在于栈中 当strongSelf.str 执行完 strongSelf就会回收
 
 block内部的weakSelf有可能为self或者为nil
 eg:AFNetworking
 __weak __typeof(self)weakSelf = self;
 AFNetworkReachabilityStatusBlock callback = ^(AFNetworkReachabilityStatus status) {
 __strong __typeof(weakSelf)strongSelf = weakSelf;
 
 strongSelf.networkReachabilityStatus = status;
 if (strongSelf.networkReachabilityStatusBlock) {
 strongSelf.networkReachabilityStatusBlock(status);
 }
 
 };
 (比如当前界面正在加载网络数据, 而此时用户关闭了该界面). 这样在某些情况下代码会崩溃. 所以为了让self不为nil, 我们在block内部将weakSelf转成strongSelf. 当block结束时, 该strongSelf变量也会被自动释放. 既避免了循环引用, 又让self在block内部不为nil.
 
 外部的weakSelf是为了打破环，从而使得没有循环引用，而内部的strongSelf仅仅是个局部变量，存在栈中，会在block执行结束后回收，不会再造成循环引用
 */

/*
 MARK:循环引用
 
 引起循环引用:
 1.对象相互引用
 2.block问题。
 3.多个对象相互持有形成一个封闭的环
 
 解决循环引用:
 第一个办法是「事前避免」，我们在会产生循环引用的地方使用 weak 弱引用，以避免产生循环引用
 第二个办法是「事后补救」，我们明确知道会存在循环引用，但是我们在合理的位置主动断开环中的一个引用，使得对象得以回收
 1.weakSelf
 2.断开循环链条
 在 YTKNetwork 库中，我们的每一个网络请求 API 会持有回调的 block，回调的 block 会持有 self，而如果 self 也持有网络请求 API 的话，我们就构造了一个循环引用。虽然我们构造出了循环引用，但是因为在网络请求结束时，网络请求 API 会主动释放对 block 的持有，因此，整个循环链条被解开，循环引用就被打破了，所以不会有内存泄漏问题
 */

/*
 MARK:performSelector传递两个以上参数
 
 1.将所有参数放入一个字典／数组传过去
 2.使用objc_msgSend()传递
 3.NSInvocation
 
 传递结构体:
 将结构体封装成NSValue对象
 */

/*
 MARK:Category 已验证
 Category并没有覆盖主类的同名方法，只是Category的方法排在方法列表前面，而主类的方法被移到了方法列表的后面
 */

/*
 MARK:方法交换
 1.method_exchangeImplementations(Method _Nonnull m1, Method _Nonnull m2)
 2.
 
 class_getInstanceMethod(Class _Nullable cls, SEL _Nonnull name)
 
 method_getImplementation(Method _Nonnull m)
 
 // 给类添加一个新的方法和该方法的具体实现 返回值: yes-方法添加成功, no-方法添加失败
 // IMP imp:
 1. C语言写法:（IMP）方法名
 2. OC的写法: class_getMethodImplementation(self,@selector(方法名：))
 class_addMethod(Class _Nullable cls, SEL _Nonnull name, IMP _Nonnull imp,
 const char * _Nullable types)
 eg:
 + (BOOL)resolveInstanceMethod:(SEL)sel
 {
 if (sel == @selector(drive))
 {
 class_addMethod([self class], sel, class_getMethodImplementation(self,@selector(startEngine:)), "v@:@");
 return YES;
 }
 return [super resolveInstanceMethod:sel];
 }
 - (void)startEngine:(NSString *)brand
 {

 }

 class_replaceMethod(Class _Nullable cls, SEL _Nonnull name, IMP _Nonnull imp,
 const char * _Nullable types)

 */

/*
 MARK:内存管理
 - retainCount
 __CFDoExternRefOperation
 CFBasicHashGetCountOfKey
 
 - retain
 __CFDoExternRefOperation
 CFBasicHashAddValue
 
 - release
 __CFDoExternRefOperation
 CFBasicHashRemoveValue
 (CFBasicHashRemoveValue返回0时，-release调用dealloc)
 
 - (NSUInteger)retainCount  {
 return (NSUInteger)__CFDoExternRefOperation(OPERATION_retainCount,self);
 }
 
 - (id)retain  {
 return (id)__CFDoExternRefOperation(OPERATION_retain,self);
 }
 
 - (void)release  {
 return __CFDoExternRefOperation(OPERATION_release,self);
 }
 
 
 int __CFDoExternRefOperation(uintptr_r op,id obj) {
 CFBasicHashRef table = 取得对象对应的散列表(obj);
 int count;
 
 switch(op) {
 case OPERATION_retainCount:
 count = CFBasicHashGetCountOfKey(table,obj);
 return count;
 case OPERATION_retain:
 CFBasicHashAddValue(table,obj);
 return obj;
 case OPERATION_release:
 count = CFBasicHashRemoveValue(table,obj):
 return 0 == count;
 }
 }
 
 采用散列表（引用计数表）来管理引用计数
 */

/*
 MARK:autorelease
 作用是将对象放入自动释放池中，当自从释放池销毁时对自动释放池中的对象都进行一次release操作
 */

/*
 MARK:内存分配（堆和栈）
 只有oc对象需要进行内存管理,任何继承了NSObject的对象
 非oc对象类型比如基本数据类型不需要进行内存管理
 
 Objective-C的对象在内存中是以堆的方式分配空间的,并且堆内存是由你释放的，就是release
 OC对象存放于堆里面(堆内存要程序员手动回收)
 非OC对象一般放在栈里面(栈内存会被系统自动回收)
 堆里面的内存是动态分配的，所以也就需要程序员手动的去添加内存、回收内存
 
 进程内存区域:
 代码区：代码段是用来存放可执行文件的操作指令（存放函数的二进制代码），也就是说是它是可执行程序在内存中的镜像
 
 全局（静态）区包含下面两个分区：
 数据区：数据段用来存放可执行文件中已初始化全局变量，换句话说就是存放程序静态分配的变量和全局变量。
 BSS区：BSS段包含了程序中未初始化全局变量。
 
 常量区：常量存储区，这是一块比较特殊的存储区，他们里面存放的是常量，
 
 堆（heap）区：堆是由程序员分配和释放，用于存放进程运行中被动态分配的内存段，它大小并不固定，可动态扩张或缩减。当进程调用alloc等函数分配内存时，新分配的内存就被动态添加到堆上（堆被扩张）；当利用realse释放内存时，被释放的内存从堆中被剔除（堆被缩减），因为我们现在iOS基本都使用ARC来管理对象，所以不用我们程序员来管理，但是我们要知道这个对象存储的位置。
 
 栈（stack）区：栈是由编译器自动分配并释放，用户存放程序临时创建的局部变量，存放函数的参数值，局部变量等。也就是说我们函数括弧“{}”中定义的变量（但不包括static声明的变量，static意味这在数据段中存放变量）。除此以外在函数被调用时，其参数也会被压入发起调用的进程栈中，并且待到调用结束后，函数的返回值也会被存放回栈中。由于栈的先进后出特点，所以栈特别方便用来保存/恢复调用现场。从这个意义上将我们可以把栈看成一个临时数据寄存、交换的内存区
 
 栈是向低地址扩展的数据结构，是一块连续的内存的区域。堆是向高地址扩展的数据结构，是不连续的内存区域
 */

/*
 MARK:isEqual方法:
 对于基本类型, ==运算符比较的是值; 对于对象类型, ==运算符比较的是对象的地址(即是否为同一对象)
 
 UIColor *color1 = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
 UIColor *color2 = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
 NSLog(@"color1 == color2 = %@", color1 == color2 ? @"YES" : @"NO");
 NSLog(@"[color1 isEqual:color2] = %@", [color1 isEqual:color2] ? @"YES" : @"NO");
 
 打印结果如下:
 color1 == color2 = NO
 [color1 isEqual:color2] = YES
 ==运算符只是简单地判断是否是同一个对象, 而isEqual方法可以判断对象是否相同
 UIColor, isEqual方法已经实现好了
 
 常见类型的isEqual方法还有NSString isEqualToString / NSDate isEqualToDate / NSArray isEqualToArray / NSDictionary isEqualToDictionary / NSSet isEqualToSet
 
 重写自定义对象的isEqual方法:
 */

// ###关联对象###
// 在obj dealloc时候会调用object_dispose，检查有无关联对象，有的话_object_remove_assocations删除

// 当在主线程上同步调度任务的时候才会出现死锁

/*
 当参数obj为Object实例对象:
 object_getClass(obj)与[obj class]输出结果一直，均获得isa指针，即指向类对象的指针
 
 当参数obj为Class类对象:
 object_getClass(obj)返回类对象中的isa指针，即指向元类对象的指针；[obj class]返回的则是其本身
 
 obj为Rootclass类对象:
 object_getClass(obj)返回根类对象中的isa指针，因为跟类对象的isa指针指向Rootclass‘s metaclass(根元类)，即返回的是根元类的地址指针；[obj class]返回的则是其本身
 
 object_getClass(obj)返回的是obj中的isa指针；而[obj class]则分两种情况：一是当obj为实例对象时，[obj  class]中class是实例方法：- (Class)class，返回的obj对象中的isa指针；二是当obj为类对象（包括元类和根类以及根元类）时，调用的是类方法：+ (Class)class，返回的结果为其本身
 */

/*
 ###反射: 这些操作都是发生在运行时的###
 // SEL和字符串转换
 FOUNDATION_EXPORT NSString *NSStringFromSelector(SEL aSelector);
 FOUNDATION_EXPORT SEL NSSelectorFromString(NSString *aSelectorName);
 // Class和字符串转换
 FOUNDATION_EXPORT NSString *NSStringFromClass(Class aClass);
 FOUNDATION_EXPORT Class __nullable NSClassFromString(NSString *aClassName);
 // Protocol和字符串转换
 FOUNDATION_EXPORT NSString *NSStringFromProtocol(Protocol *proto) NS_AVAILABLE(10_5, 2_0);
 FOUNDATION_EXPORT Protocol * __nullable NSProtocolFromString(NSString *namestr) NS_AVAILABLE(10_5, 2_0);
 
 通过这些方法，我们可以在运行时选择创建那个实例，并动态选择调用哪个方法。这些操作甚至可以由服务器传回来的参数来控制，我们可以将服务器传回来的类名和方法名，实例为我们的对象
 // 假设从服务器获取JSON串，通过这个JSON串获取需要创建的类为ViewController，并且调用这个类的getDataList方法。
 Class class = NSClassFromString(@"ViewController");
 ViewController *vc = [[class alloc] init];
 SEL selector = NSSelectorFromString(@"getDataList");
 [vc performSelector:selector];
 根据后台推送过来的数据，进行动态页面跳转，跳转到页面后根据返回到数据执行对应的操作
 */

/*
 对象在运行时获取其类型的能力称为内省
 */

/*
 在消息调用的过程中，objc_msgSend的动作比较清晰：首先在 Class 中的缓存查找 IMP （没缓存则初始化缓存），如果没找到，则向父类的 Class 查找。如果一直查找到根类仍旧没有实现，则用 _objc_msgForward函数指针代替 IMP。最后，执行这个 IMP
 */

/*
 ###Method###
 typedef struct objc_method *Method;
 
 struct objc_method {
 SEL method_name; // 方法选择器。
 char *method_types; // 存储着方法的参数类型和返回值类型。
 IMP method_imp; // 函数指针。
 }
 */

// 类对象内部也有一个 isa 指针指向元对象(meta class)，元对象内部存放的是类方法列表。
// 类对象内部还有一个 superclass 的指针，指向他的父类对象
// 所有父类的成员变量和自己的成员变量都会存放在该对象所对应的存储空间中
/*
 Objective-C 对象的结构图：
 isa 指针
 根类的实例变量
 倒数第二层父类的实例变量
 …
 父类的实例变量
 类的实例变量
 */

// extension: 在编译期决定，它就是类的一部分，在编译期和头文件里的 @interface 以及实现文件里的 @implement 一起形成一个完整的类
// category: 它是在运行期决定的,category 的加载是发生在运行时
// extension 可以添加实例变量，而 category 是无法添加实例变量的（因为在运行期，对象的内存布局已经确定，如果添加实例变量就会破坏类的内部布局)
// category 的方法没有「完全替换掉」原来类已经有的方法，也就是说如果 category 和原来类都有 methodA，那么 category 附加完成之后，类的方法列表里会有两个 methodA.category 的方法被放到了新方法列表的前面，而原来类的方法被放到了新方法列表的后面，这也就是我们平常所说的category 的方法会「覆盖」掉原来类的同名方法，这是因为运行时在查找方法的时候是顺着方法列表的顺序查找的，它只要一找到对应名字的方法，就会返回，不会管后面可能还有一样名字的方法。
// 在类的 +load方法调用的时候，我们可以调用 category 中声明的方法.因为附加 category 到类的工作会先于 +load方法的执行
// +load的执行顺序是先类，后 category，而 category 的+load 执行顺序是根据编译顺序决定的。虽然对于 +load的执行顺序是这样，但是对于「覆盖」掉的方法，则会先找到最后一个编译的 category 里的对应方法

/*
 关联对象:
 在 runtime 中所有的关联对象都由 AssociationsManager 管理。AssociationsManager 里面是由一个静态 AssociationsHashMap 来存储所有的关联对象的。这相当于把所有对象的关联对象都存在一个全局 map 里面。而 map 的 key 是这个对象的指针地址（任意两个不同对象的指针地址一定是不同的），而这个 map 的 value 又是另外一个 AssociationsHashMap，里面保存了关联对象的 KV 对。runtime 的销毁对象函数 objc_destructInstance里面会判断这个对象有没有关联对象，如果有，会调用 _object_remove_assocations 做关联对象的清理工作
 */

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
 ##弱引用管理##
 添加weak变量:通过哈希算法位置查找添加。如果查找对应位置中已经有了当前对象所对应的弱引用数组，就把新的弱引用变量添加到数组当中；如果没有，就创建一个弱引用数组，并将该弱引用变量添加到该数组中
 
 当一个被weak修饰的对象被释放:
 清除weak变量，同时设置指向为nil。当对象被dealloc释放后，在dealloc的内部实现中，会调用弱引用清除的相关函数，会根据当前对象指针查找弱引用表，找到当前对象所对应的弱引用数组，将数组中的所有弱引用指针都置为nil
 */

/*
 MARK:###block原理###
 Block是将函数及其执行上下文封装起来的对象
 
 NSInteger num = 3;
 NSInteger(^block)(NSInteger) = ^NSInteger(NSInteger n){
 return n*num;
 };
 block(2);
 
 clang -rewrite-objc WYTest.m
 NSInteger num = 3;
 NSInteger(*block)(NSInteger) = ((NSInteger (*)(NSInteger))&__WYTest__blockTest_block_impl_0((void *)__WYTest__blockTest_block_func_0, &__WYTest__blockTest_block_desc_0_DATA, num));
 ((NSInteger (*)(__block_impl *, NSInteger))((__block_impl *)block)->FuncPtr)((__block_impl *)block, 2);
 
 其中WYTest是文件名，blockTest是方法名
 __WYTest__blockTest_block_impl_0结构体为:
 struct __WYTest__blockTest_block_impl_0 {
 struct __block_impl impl;
 struct __WYTest__blockTest_block_desc_0* Desc;
 NSInteger num;//局部变量
 __WYTest__blockTest_block_impl_0(void *fp, struct __WYTest__blockTest_block_desc_0 *desc, NSInteger _num, int flags=0) : num(_num) {
 impl.isa = &_NSConcreteStackBlock;
 impl.Flags = flags;
 impl.FuncPtr = fp;
 Desc = desc;
 }
 };
 
 __block_impl结构体为:
 struct __block_impl {
 void *isa;//isa指针，所以说Block是对象
 int Flags;
 int Reserved;
 void *FuncPtr;//函数指针
 };
 
 static NSInteger __WYTest__blockTest_block_func_0(struct __WYTest__blockTest_block_impl_0 *__cself, NSInteger n) {
 NSInteger num = __cself->num; // bound by copy
 return n*num;
 }
 
 __block修饰的变量也是以指针形式截获的，并且生成了一个新的结构体对象
 全局变量，静态全局变量不截获,直接取值
 static NSInteger num3 = 300;
 
 NSInteger num4 = 3000;
 
 - (void)blockTest
 {
 NSInteger num = 30;
 
 static NSInteger num2 = 3;
 
 __block NSInteger num5 = 30000;
 
 void(^block)(void) = ^{
 
 NSLog(@"%zd",num);//局部变量
 
 NSLog(@"%zd",num2);//静态变量
 
 NSLog(@"%zd",num3);//全局变量
 
 NSLog(@"%zd",num4);//全局静态变量
 
 NSLog(@"%zd",num5);//__block修饰变量
 };
 
 block();
 }
 
 编译后:
 struct __WYTest__blockTest_block_impl_0 {
 struct __block_impl impl;
 struct __WYTest__blockTest_block_desc_0* Desc;
 NSInteger num;//局部变量
 NSInteger *num2;//静态变量
 __Block_byref_num5_0 *num5; // by ref//__block修饰变量
 __WYTest__blockTest_block_impl_0(void *fp, struct __WYTest__blockTest_block_desc_0 *desc, NSInteger _num, NSInteger *_num2, __Block_byref_num5_0 *_num5, int flags=0) : num(_num), num2(_num2), num5(_num5->__forwarding) {
 impl.isa = &_NSConcreteStackBlock;
 impl.Flags = flags;
 impl.FuncPtr = fp;
 Desc = desc;
 }
 };
 
 impl.isa = &_NSConcreteStackBlock;这里注意到这一句，即说明该block是栈block）
 可以看到局部变量被编译成值形式，而静态变量被编成指针形式，全局变量并未截获。而__block修饰的变量也是以指针形式截获的，并且生成了一个新的结构体对象
 struct __Block_byref_num5_0 {
 void *__isa;
 __Block_byref_num5_0 *__forwarding;
 int __flags;
 int __size;
 NSInteger num5;
 };
 该对象有个属性：num5，即我们用__block修饰的变量。
 这里__forwarding是指向自身的(栈block)
 另外,block里访问self或成员变量都会去截获self
 
 __block变量在copy时，由于__forwarding的存在，栈上的__forwarding指针会指向堆上的__forwarding变量，而堆上的__forwarding指针指向其自身，所以，如果对__block的修改，实际上是在修改堆上的__block变量
 */

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


/*
 #pragma mark - Runtime Class Construct
 int32_t testRuntimeMethodIMP(id self, SEL _cmd, NSDictionary *dic) {
 NSLog(@"testRuntimeMethodIMP: %@", dic);
 // Print:
 // testRuntimeMethodIMP: {
 //     a = "para_a";
 //     b = "para_b";
 // }
 
 return 99;
 }
 - (void)runtimeConstruct {
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wundeclared-selector"
 Class cls = objc_allocateClassPair(SuperClass.class, "RuntimeSubClass", 0);
 // Method returns: "int32_t"; accepts: "id self", "SEL _cmd", "NSDictionary *dic". So use "i@:@" here.
 class_addMethod(cls, @selector(testRuntimeMethod), (IMP) testRuntimeMethodIMP, "i@:@");
 // You can only register a class once.
 objc_registerClassPair(cls);
 
 id sub = [[cls alloc] init];
 NSLog(@"%@, %@", object_getClass(sub), class_getSuperclass(object_getClass(sub))); // Print: RuntimeSubClass, SuperClass
 Class metaCls = objc_getMetaClass("RuntimeSubClass");
 if (class_isMetaClass(metaCls)) {
 NSLog(@"YES, %@, %@, %@", metaCls, class_getSuperclass(metaCls), object_getClass(metaCls)); // Print: YES, RuntimeSubClass, SuperClass, NSObject
 } else {
 NSLog(@"NO");
 }
 
 
 unsigned int outCount = 0;
 Method *methods = class_copyMethodList(cls, &outCount);
 for (int32_t i = 0; i < outCount; i++) {
 Method method = methods[i];
 NSLog(@"%@, %s", NSStringFromSelector(method_getName(method)), method_getTypeEncoding(method));
 }
 // Print: testRuntimeMethod, i@:@
 free(methods);
 
 
 int32_t result = (int) [sub performSelector:@selector(testRuntimeMethod) withObject:@{@"a":@"para_a", @"b":@"para_b"}];
 NSLog(@"%d", result); // Print: 99
 
 
 // Destroy instances of cls class before destroy cls class.
 sub = nil;
 // Do not call this function if instances of the cls class or any subclass exist.
 objc_disposeClassPair(cls);
 
 #pragma clang diagnostic pop
 }
 #pragma mark - Runtime Ivar&Property Construct
 NSString * runtimePropertyGetterIMP(id self, SEL _cmd) {
 Ivar ivar = class_getInstanceVariable([self class], "_runtimeProperty");
 
 return object_getIvar(self, ivar);
 }
 void runtimePropertySetterIMP(id self, SEL _cmd, NSString *s) {
 Ivar ivar = class_getInstanceVariable([self class], "_runtimeProperty");
 NSString *old = (NSString *) object_getIvar(self, ivar);
 if (![old isEqualToString:s]) {
 object_setIvar(self, ivar, s);
 }
 }
 - (void)aboutIvarAndProperty {
 
 
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wundeclared-selector"
 // 1: Add property and getter/setter.
 Class cls = objc_allocateClassPair(SuperClass.class, "RuntimePropertySubClass", 0);
 BOOL b = class_addIvar(cls, "_runtimeProperty", sizeof(cls), log2(sizeof(cls)), @encode(NSString));
 NSLog(@"%@", b ? @"YES" : @"NO"); // Print: YES
 
 objc_property_attribute_t type = {"T", "@\"NSString\""};
 objc_property_attribute_t ownership = {"C", ""}; // C = copy
 objc_property_attribute_t isAtomic = {"N", ""}; // N = nonatomic
 objc_property_attribute_t backingivar  = {"V", "_runtimeProperty"};
 objc_property_attribute_t attrs[] = {type, ownership, isAtomic, backingivar};
 class_addProperty(cls, "runtimeProperty", attrs, 4);
 class_addMethod(cls, @selector(runtimeProperty), (IMP) runtimePropertyGetterIMP, "@@:");
 class_addMethod(cls, @selector(setRuntimeProperty), (IMP) runtimePropertySetterIMP, "v@:@");
 
 // You can only register a class once.
 objc_registerClassPair(cls);
 
 // 2: Print all properties.
 unsigned int outCount = 0;
 objc_property_t *properties = class_copyPropertyList(cls, &outCount);
 for (int32_t i = 0; i < outCount; i++) {
 objc_property_t property = properties[i];
 NSLog(@"%s, %s\n", property_getName(property), property_getAttributes(property));
 }
 // Print:
 // runtimeProperty, T@"NSString",C,N,V_runtimeProperty
 free(properties);
 
 
 // 3: Print all ivars.
 Ivar *ivars = class_copyIvarList(cls, &outCount);
 for (int32_t i = 0; i < outCount; i++) {
 Ivar ivar = ivars[i];
 NSLog(@"%s, %s\n", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
 }
 // Print:
 // _runtimeProperty, {NSString=#}
 free(ivars);
 
 
 // 4: Use runtime property.
 id sub = [[cls alloc] init];
 [sub performSelector:@selector(setRuntimeProperty) withObject:@"It-is-a-runtime-property."];
 NSString *s = [sub performSelector:@selector(runtimeProperty)]; //[sub valueForKey:@"runtimeProperty"];
 NSLog(@"%@", s); // Print: It-is-a-runtime-property.
 
 
 // 5: Clear.
 // Destroy instances of cls class before destroy cls class.
 sub = nil;
 // Do not call this function if instances of the cls class or any subclass exist.
 objc_disposeClassPair(cls);
 #pragma clang diagnostic pop
 }
 */


/*
 autorelease对象在什么时刻释放:
 手动干预释放时机、系统自动去释放。
 
 手动干预释放时机：手动指定 autoreleasepool 的 autorelease 对象，在当前作用域大括号结束时释放。
 系统自动去释放：不手动指定 autoreleasepool 的 autorelease 对象出了作用域之后，会被添加到最近一次创建的自动释放池中，并会在当前的 runloop 迭代结束时释放。而它能够释放的原因是系统在每个 runloop 迭代中都加入了自动释放池 Push 和 Pop。一个典型的例子是在一个类方法中创建一个对象并作为返回值，这时就需要将该对象放置到对应的 autoreleasepool 中
 
 所以在每一次完整的 runloop 结束之前，对于的自动释放池里面的 autorelease 对象会被销毁。
 在 runloop 检测到事件并启动后，就会创建对应的自动释放池
 
 
 @autoreleasepool 当自动释放池被销毁或者耗尽时，会向自动释放池中的所有对象发送 release 消息，释放自动释放池中的所有对象
 
 objc_autoreleasepoolPush
 objc_autoreleasepoolPop
 objc_autorelease
 
 编译器会将 @autoreleasepool {} 改写为:
 void * ctx = objc_autoreleasePoolPush;
 {}
 objc_autoreleasePoolPop(ctx);
 
 ###AutoreleasePool没有单独的内存结构，而是通过AutoreleasePoolPage为节点的双向链表来实现##
 AutoreleasePool并没有单独的结构，而是由若干个AutoreleasePoolPage以双向链表的形式组合而成（分别对应结构中的parent指针和child指针）
 
 void *objc_autoreleasePoolPush(void) {
 return AutoreleasePoolPage::push();
 }
 
 void objc_autoreleasePoolPop(void *ctxt) {
 AutoreleasePoolPage::pop(ctxt);
 }
 每一个指针代表一个需要 release 的对象或者 POOL_SENTINEL（哨兵对象，代表一个 autoreleasepool 的边界）
一个 pool token 就是这个 pool 所对应的 POOL_SENTINEL 的内存地址。当这个 pool 被 pop 的时候，所有内存地址在 pool token 之后的对象都会被 release
 Thread-local storage（线程局部存储）指向 hot page ，即最新添加的 autoreleased 对象所在的那个 page
 
 objc_autoreleasePoolPush:
 一个 push 操作其实就是创建一个新的 autoreleasepool ，对应 AutoreleasePoolPage 的具体实现就是往 AutoreleasePoolPage 中的 next 位置插入一个 POOL_SENTINEL ，并且返回插入的 POOL_SENTINEL 的内存地址。这个地址也就是我们前面提到的 pool token ，在执行 pop 操作的时候作为函数的入参
 hotPage 可以理解为当前正在使用的 AutoreleasePoolPage
 调用 page->add(obj) 方法将对象添加至 AutoreleasePoolPage 的栈中
 在每个自动释放池初始化调用 objc_autoreleasePoolPush 的时候，都会把一个 POOL_SENTINEL push 到自动释放池的栈顶，并且返回这个 POOL_SENTINEL 哨兵对象
 每次objc_autoreleasePoolPush，实际上是不断地向栈中插入哨兵对象
 
 当我们看到一个@autoreloeasepool{}的代码的时候，转换之后如上代码，可以理解为在双向链表结构的基础上，每个node节点就是poolpage对象，该对象有固定大小4096，前几个字节用于存储属性字段，后面从begin地址开始到end地址结束用来存储自动释放池里面的对象，就会在属性字段挨着的地址上出现一个哨兵标志POOL_SENTINEL，也就是nil标志自动释放池的出现，返回值地址用来标志对应的池子，后续pop的时候根据池子遍历对象挨个执行release操作
 
 autorelease 操作:
 AutoreleasePoolPage 的 autorelease，它跟 push 操作的实现非常相似。只不过 push 操作插入的是一个 POOL_SENTINEL ，而 autorelease 操作插入的是一个具体的 autoreleased 对象
 
 objc_autoreleasePoolPop:
 objc_autoreleasePoolPop 函数本质上也是调用的 AutoreleasePoolPage 的 pop 函数
 pop 函数的入参就是 push 函数的返回值，也就是 POOL_SENTINEL 的内存地址，即 pool token 。当执行 pop 操作时，内存地址在 pool token 之后的所有 autoreleased 对象都会被 release 。直到 pool token 所在 page 的 next 指向 pool token 为止
 
 objc_autoreleasePoolPush的返回值正是这个哨兵对象的地址，被objc_autoreleasePoolPop(哨兵对象)作为入参，于是：
 1.根据传入的哨兵对象地址找到哨兵对象所处的page
 2.在当前page中，将晚于哨兵对象插入的所有autorelease对象都发送一次- release消息，并向回移动next指针到正确位置
 从最新加入的对象一直向前清理，可以向前跨越若干个page，直到哨兵所在的page（在一个page中，是从高地址向低地址清理）
 
 嵌套的AutoreleasePool:
 pop的时候总会释放到上次push的位置为止，多层的pool就是多个哨兵对象而已
 
 每创建一个池子，会在首部创建一个 哨兵 对象,作为标记
 最外层池子的顶端会有一个next指针。当链表容量满了，就会在链表的顶端，并指向下一张表
 
 next指针作为游标指向栈顶最新add进来的autorelease对象的下一个位置
 
 总结:
 @autorelease展开来其实就是objc_autoreleasePoolPush和objc_autoreleasePoolPop，但是这两个函数也是封装的一个底层对象AutoreleasePoolPage，实际对应的是AutoreleasePoolPage::push和AutoreleasePoolPage::pop
 根据AutoreleasePoolPage双向链表的结构，可以看到当调用objc_autoreleasePoolPush的时候实际上除了初始化poolpage对象属性之外，还会插入一个POOL_SENTINEL哨兵，用来区分不同autoreleasepool之间包裹的对象
 当对象调用 autorelease 方法时，会将实际对象插入 AutoreleasePoolPage 的栈中，通过next指针移动
 其中每个双向链表的node节点也就是poolpage对象内存大小为4096，除了基础属性之外，外插一个POOL_SENTINEL，每出现一个@autorelease就会有一个哨兵，剩下的通过begin和end来标识是否存储满，满了就会重新创建一个poolpage来链接链表，按照这个套路，出现一个PoolPush就创建一个哨兵，出现一个对象的autorelease，就增加一个实际的对象，满了就创建新的链表节点这样衍生下去
 AutoreleasePoolPage::pop那么当调用pop的时候，会传入需要drain的哨兵节点，遍历该内存地址上方所有对象，直到遇到对应的哨兵，然后释放栈中遍历到的对象，每删除一页就修正双向链表的指针
 ARC下，直接调用上面的方法，整个线程都被自动释放池双向链表管理，Push创建的时候插入哨兵对象，当我们在内部写代码的时候，会自动添加Autorelease，对象会加入到在哨兵节点之间，加入到next指针上，一个个往后移，满了4096就换下一个poolPage对象节点来存储，出了释放池，会调用pop，传入自动释放池的哨兵给pop，然后遍历哨兵内存地址之后的所有对象执行release，最后吧next指针移到目标哨兵
 
 
 App启动的时候会在主Runloop里面注册两个观察者和一个回调函数:
 第一个Observe观察到entry即将进入loop的时候，会调用_objc_autoreleasePoolPush（）创建自动释放池，优先级最高，保证在所有回调方法之前。
 第二个Observe观察到即将进入休眠或者退出的时候，当监听到Beforewaiting的时候，调用_objc_autoreleasePoolPop() 和 _objc_autoreleasePoolPush() 释放旧的创建新的，当监听到Exit的时候调用_objc_autoreleasePoolPop释放pool，这里的Observe优先级最低，发生在所有回调函数之后
 
 App启动后，苹果在主线程 RunLoop 里注册了两个 Observer，其回调都是 _wrapRunLoopWithAutoreleasePoolHandler()
 第一个 Observer 监视的事件是 Entry(即将进入 Loop)，其回调内会调用 _objc_autoreleasePoolPush()创建自动释放池
 第二个 Observer 监视了两个事件： BeforeWaiting(准备进入休眠) 时调用_objc_autoreleasePoolPop()和 _objc_autoreleasePoolPush()释放旧的池并创建新池；Exit(即将退出 Loop) 时调用 _objc_autoreleasePoolPop()来释放自动释放池
 */

/*
 ##runloop##
 
 事件响应:
 苹果注册了一个 Source1 (基于 mach port 的) 用来接收系统事件，其回调函数为 __IOHIDEventSystemClientQueueCallback()
 当一个硬件事件(触摸/锁屏/摇晃等)发生后，首先由 IOKit.framework 生成一个 IOHIDEvent 事件并由 SpringBoard 接收
 SpringBoard 只接收按键(锁屏/静音等)，触摸，加速，接近传感器等几种 Event，随后用 mach port 转发给需要的App进程。随后苹果注册的那个 Source1 就会触发回调，并调用 _UIApplicationHandleEventQueue() 进行应用内部的分发
 _UIApplicationHandleEventQueue() 会把 IOHIDEvent 处理并包装成 UIEvent 进行处理或分发，其中包括识别 UIGesture/处理屏幕旋转/发送给 UIWindow 等。通常事件比如 UIButton 点击、touchesBegin/Move/End/Cancel 事件都是在这个回调中完成的
 
 手势识别:
 当上面的 _UIApplicationHandleEventQueue() 识别了一个手势时，其首先会调用 Cancel 将当前的 touchesBegin/Move/End 系列回调打断。随后系统将对应的 UIGestureRecognizer 标记为待处理
 苹果注册了一个 Observer 监测 BeforeWaiting (Loop 即将进入休眠) 事件，这个 Observer 的回调函数是 _UIGestureRecognizerUpdateObserver()，其内部会获取所有刚被标记为待处理的 GestureRecognizer，并执行 GestureRecognizer 的回调
 当有 UIGestureRecognizer 的变化(创建/销毁/状态改变)时，这个回调都会进行相应处理
 
 界面更新:
 当在操作 UI 时，比如改变了 Frame、更新了 UIView/CALayer 的层次时，或者手动调用了 UIView/CALayer 的 setNeedsLayout/setNeedsDisplay方法后，这个 UIView/CALayer 就被标记为待处理，并被提交到一个全局的容器去。
 苹果注册了一个 Observer 监听 BeforeWaiting(即将进入休眠) 和 Exit (即将退出 Loop) 事件，回调去执行一个很长的函数： _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv()。这个函数里会遍历所有待处理的 UIView/CAlayer 以执行实际的绘制和调整，并更新 UI 界面

 PerformSelector:
 当调用 NSObject 的 performSelector:afterDelay: 后，实际上其内部会创建一个 Timer 并添加到当前线程的 RunLoop 中。所以如果当前线程没有 RunLoop，则这个方法会失效。
 当调用 performSelector:onThread: 时，实际上其会创建一个 Timer 加到对应的线程去，同样的，如果对应线程没有 RunLoop 该方法也会失效
 
 GCD:
 当调用 dispatch_async(dispatch_get_main_queue(), block) 时，libDispatch 会向主线程的 RunLoop 发送消息，RunLoop 会被唤醒，并从消息中取得这个 block，并在回调 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__() 里执行这个 block。但这个逻辑仅限于 dispatch 到主线程，dispatch 到其他线程仍然是由 libDispatch 处理的
 
 
 CFSocket，是最底层的接口，只负责 socket 通信。
 CFNetwork，是基于 CFSocket 等接口的上层封装
 NSURLConnection，是基于 CFNetwork 的更高层的封装
 Source0 (即需要手动触发的Source)
 当开始网络传输时，我们可以看到 NSURLConnection 创建了两个新线程：com.apple.NSURLConnectionLoader 和 com.apple.CFSocket.private。其中 CFSocket 线程是处理底层 socket 连接的。NSURLConnectionLoader 这个线程内部会使用 RunLoop 来接收底层 socket 的事件，并通过之前添加的 Source0 通知到上层的 Delegate
 NSURLConnectionLoader 中的 RunLoop 通过一些基于 mach port 的 Source 接收来自底层 CFSocket 的通知。当收到通知后，其会在合适的时机向 CFMultiplexerSource 等 Source0 发送通知，同时唤醒 Delegate 线程的 RunLoop 来让其处理这些通知。CFMultiplexerSource 会在 Delegate 线程的 RunLoop 对 Delegate 执行实际的回调
 
 RunLoop 启动前内部必须要有至少一个 Timer/Observer/Source
 
 AFNetworking 2.x
 通常情况下，调用者需要持有这个 NSMachPort (mach_port) 并在外部线程通过这个 port 发送消息到 loop 内；但此处添加 port 只是为了让 RunLoop 不至于退出，并没有用于实际的发送消息
 当需要这个后台线程执行任务时，AFNetworking 通过调用 [NSObject performSelector:onThread:..] 将这个任务扔到了后台线程的 RunLoop 中
 */

/*
 ###runloop###
 RunLoop是通过内部维护的事件循环(Event Loop)来对事件/消息进行管理的一个对象
 对于RunLoop而言最核心的事情就是保证线程在没有消息的时候休眠，在有消息时唤醒，以提高程序性能
 
 CFRunLoopRef,对应 runloop
 
 CFRunLoopModeRef，对应 runloop mode
 
 CFRunLoopSourceRef，对应 source，表示事件产生的地方。Source 有两个版本：Source0 和 Source1。Source0 只包含了一个回调（函数指针），它并不能主动触发事件。使用时，你需要先调用 CFRunLoopSourceSignal(source)，将这个 Source 标记为待处理，然后手动调用 CFRunLoopWakeUp(runloop) 来唤醒 RunLoop，让其处理这个事件。Source1 包含了一个 mach_port 和一个回调（函数指针），被用于通过内核和其他线程相互发送消息。这种 Source 能主动唤醒 RunLoop 的线程
 
 CFRunLoopTimerRef，对应 timer，是基于时间的触发器。它和 NSTimer 是 toll-free bridged 的，可以混用。其包含一个时间长度和一个回调（函数指针）。当其加入到 RunLoop 时，RunLoop 会注册对应的时间点，当时间点到时，RunLoop 会被唤醒以执行那个回调
 
 CFRunLoopObserverRef，对应 observer，表示观察者。每个 Observer 都包含了一个回调（函数指针），当 RunLoop 的状态发生变化时，观察者就能通过回调接受到这个变化。可以观测的时间点有以下几个：
 kCFRunLoopEntry，即将进入Loop
 kCFRunLoopBeforeTimers，即将处理 Timer
 kCFRunLoopBeforeSources，即将处理 Source
 kCFRunLoopBeforeWaiting，即将进入休眠
 kCFRunLoopAfterWaiting，刚从休眠中唤醒
 kCFRunLoopExit，即将退出Loop


 Source/Timer/Observer 被统称为 mode item，一个 item 可以被同时加入多个 mode
 一个 item 被重复加入同一个 mode 时是不会有效果的
 一个 mode 中一个 item 都没有，则 RunLoop 会直接退出，不进入循环
 
 线程的运行的过程中需要去处理不同情境的不同事件，mode 则是这个情景的标识，告诉当前应该响应哪些事件。一个 RunLoop 包含若干个 Mode，每个 Mode 又包含若干个 Source/Timer/Observer。每次调用 RunLoop 的主函数时，只能指定其中一个 Mode，这个 Mode 被称作 CurrentMode。如果需要切换 Mode，只能退出 Loop，再重新指定一个 Mode 进入。这样做主要是为了分隔开不同组的 Source/Timer/Observer，让其互不影响
 struct __CFRunLoopMode {
 CFStringRef _name;            // Mode Name, 例如 @"kCFRunLoopDefaultMode"
 CFMutableSetRef _sources0;    // Set
 CFMutableSetRef _sources1;    // Set
 CFMutableArrayRef _observers; // Array
 CFMutableArrayRef _timers;    // Array
 ...
 };
 
 struct __CFRunLoop {
 CFMutableSetRef _commonModes;     // Set
 CFMutableSetRef _commonModeItems; // Set<Source/Observer/Timer>
 CFRunLoopModeRef _currentMode;    // Current Runloop Mode
 CFMutableSetRef _modes;           // Set
 ...
 };
 
 CommonModes：一个 Mode 可以将自己标记为 Common 属性（通过将其 ModeName 添加到 RunLoop 的 commonModes 中）。每当 RunLoop 的内容发生变化时，RunLoop 都会自动将 _commonModeItems里的 Source/Observer/Timer 同步到具有 Common 标记的所有 Mode 里
 应用场景举例：
 主线程的 RunLoop 里有两个预置的 Mode：kCFRunLoopDefaultMode 和 UITrackingRunLoopMode。这两个 Mode 都已经被标记为 Common 属性。DefaultMode 是 App 平时所处的状态，TrackingRunLoopMode 是追踪 ScrollView 滑动时的状态。当你创建一个 Timer 并加到 DefaultMode 时，Timer 会得到重复回调，但此时滑动一个 TableView 时，RunLoop 会将 mode 切换为 TrackingRunLoopMode，这时 Timer 就不会被回调，并且也不会影响到滑动操作，因为这个 Timer 作为一个 mode item 并没有被添加到 commonModeItems 里，所以它不会被同步到其他 Common Mode 里
 
 有时你需要一个 Timer，在两个 Mode 中都能得到回调，一种办法就是将这个 Timer 分别加入这两个 Mode。还有一种方式，就是将 Timer 加入到顶层的 RunLoop 的 commonModeItems 中。commonModeItems 被 RunLoop 自动更新到所有具有 Common 属性的 Mode 里去
 
 CFRunLoop 对外暴露的管理 Mode 接口只有下面 2 个：
 CFRunLoopAddCommonMode(CFRunLoopRef runloop, CFStringRef modeName);
 CFRunLoopRunInMode(CFStringRef modeName, ...)

 Mode 暴露的管理 mode item 的接口有下面几个:
 CFRunLoopAddSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFStringRef modeName);
 CFRunLoopAddObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFStringRef modeName);
 CFRunLoopAddTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFStringRef mode);
 CFRunLoopRemoveSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFStringRef modeName);
 CFRunLoopRemoveObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFStringRef modeName);
 CFRunLoopRemoveTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFStringRef mode);
 
 你只能通过 mode name 来操作内部的 mode，当你传入一个新的 mode name 但 RunLoop 内部没有对应 mode 时，RunLoop会自动帮你创建对应的 CFRunLoopModeRef。对于一个 RunLoop 来说，其内部的 mode 只能增加不能删除。
 
 苹果公开提供的 Mode 有两个，你可以用这两个 Mode Name 来操作其对应的 Mode：
 kCFRunLoopDefaultMode (NSDefaultRunLoopMode)
 UITrackingRunLoopMode
 
 同时苹果还提供了一个操作 Common 标记的字符串：kCFRunLoopCommonModes (NSRunLoopCommonModes)，你可以用这个字符串来操作 Common Items，或标记一个 Mode 为 Common
 
 source0:
 即非基于port的，也就是用户触发的事件。需要手动唤醒线程
 source1:
 基于port的，包含一个 mach_port 和一个回调，可监听系统端口和通过内核和其他线程发送的消息，能主动唤醒RunLoop，接收分发系统事件。
 具备唤醒线程的能力
 
 
 五种CFRunLoopMode:
 kCFRunLoopDefaultMode：默认模式，主线程是在这个运行模式下运行
 UITrackingRunLoopMode：跟踪用户交互事件（用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他Mode影响）
 UIInitializationRunLoopMode：在刚启动App时第进入的第一个 Mode，启动完成后就不再使用
 GSEventReceiveRunLoopMode：接受系统内部事件，通常用不到
 kCFRunLoopCommonModes：伪模式，不是一种真正的运行模式，是同步Source/Timer/Observer到多个Mode中
 
 RunLoop通过mach_msg()函数接收、发送消息。它的本质是调用函数mach_msg_trap()，相当于是一个系统调用，会触发内核状态切换。在用户态调用 mach_msg_trap()时会切换到内核态
 
 保证子线程数据回来更新UI的时候不打断用户的滑动操作:
 将更新UI事件放在主线程的NSDefaultRunLoopMode上执行即可，这样就会等用户不再滑动页面，主线程RunLoop由UITrackingRunLoopMode切换到NSDefaultRunLoopMode时再去更新UI
 */
