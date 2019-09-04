//
//  TestTVViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/5/14.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestTVViewController.h"
#import "XLogManager.h"
#import "DebugThread.h"

#import "TestMapViewController.h"

#import "GradientRingView.h"
#import "HighlightGradientProgressView.h"

#import "NSObject+KVO.h"
#import "Person.h"
#import "BaseNavigationController.h"

#import "TestTimerViewController.h"
#import "ResidentThread.h"

#import <YYKit/YYKit.h>
#import "Person.h"

#import "CTMediator+ModuleA.h"
#import "TestButton.h"
#import "TestSubButton.h"
#import "UIControl+TouchLimitation.h"

#import "Object1.h"
#import "Object2.h"

#import "NSString+Algorithm.h"
#import "TestAVFoundationViewController.h"

static int count = 0;

void stackFrame (void) {
    /* Trigger a crash */
    ((char *)NULL)[1] = 0;
}

typedef struct TestStruct{
    int testInt;
    int nextInt;
}TS;

@interface TestTVViewController () <UITextViewDelegate>

@property (nonatomic, weak) UITextView *textView;

@property (nonatomic, strong) DebugThread *thread;

@property (nonatomic, strong) Person *person;

@property (nonatomic, copy) void(^testBB)(void);

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, weak) void(^weakBlock)(void);
@property (nonatomic, copy) void(^strongBlock)(void);

@property (nonatomic, copy) void(^bb)(void);

//@property (nonatomic, strong) Object1 *testPoint;


@end

@implementation TestTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 将结构体封装成NSValue对象
    TS testStruct = {100, 200};
    NSValue *structValue = [NSValue valueWithBytes:&testStruct objCType:@encode(TS)];
    TS temp = {0};
    [structValue getValue:&temp];
    NSLog(@"testInt = %d nextInt = %d", temp.testInt, temp.nextInt);
    
    [self test];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 120, self.view.width, 300)];
    textView.backgroundColor = [UIColor whiteColor];
    /*
     type: 键盘文字 点击作用
     default: return 换行
     UIReturnKeyDone: Done 换行
     */
    textView.returnKeyType = UIReturnKeyDone;
    if (@available(iOS 12.0, *)) {
        textView.textContentType = UITextContentTypeOneTimeCode;
    }
    textView.delegate = self;
//    [textView addObserver:self forKeyPath:@"markedTextRange" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:textView];
    self.textView = textView;
    
    // GradientRingView
    GradientRingView *gradientView = [[GradientRingView alloc] initWithFrame:CGRectMake(0, 420, 150, 150) ringWidth:20.0 ringColors:@[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor greenColor].CGColor]];
    gradientView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:gradientView];
    
    // HighlightGradientProgressView
    HighlightGradientProgressView *progressView = [[HighlightGradientProgressView alloc] initWithFrame:CGRectMake(0, 580, 300, 20) gradientColors:@[(__bridge id)[UIColor cyanColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor cyanColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor cyanColor].CGColor]];
    [self.view addSubview:progressView];
    
    TestButton *button = [TestButton buttonWithType:UIButtonTypeCustom];
    button.testName = @"123";
    [button setTitle:@"我是按钮" forState:UIControlStateNormal];
    [button setTitle:@"-我是按钮-" forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 620, self.view.width, 40);
    button.acceptEventInterval = 3.0;
    [self.view addSubview:button];
    NSLog(@"button.testName = %@", button.testName);
    
    // KVO-Block 
    self.person = [Person personWithName:@"ndl" age:20];
    [self.person ndl_addObserver:self forKeyPath:@"name" changedBlock:^(NSString * _Nonnull keyPath, NSObject * _Nonnull observedObject, id  _Nonnull oldValue, id  _Nonnull newValue) {
        // ##weakSelf##
        NSLog(@"self.person.name = %@", self.person.name);// yxx
        NSLog(@"===newValue = %@ oldValue = %@===", newValue, oldValue);// yxx ndl
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"change name###");
        self.person.name = @"yxx";
    });
    
    NSLog(@"anchorPoint = %@ position = %@", NSStringFromCGPoint(button.layer.anchorPoint), NSStringFromCGPoint(button.layer.position));
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            button.transform = CGAffineTransformMakeScale(1.0, -1.0);// y轴翻转
//            button.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    });
    
    // buttonDidTapped执行 buttonDidClicked不执行
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDidTapped:)];
//    [button addGestureRecognizer:tap];
    
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 600, self.view.width, 40)];
    testView.userInteractionEnabled = NO;// 在他下面的button(与testView同层级)就能响应事件了
    testView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.35];
    [self.view addSubview:testView];
    
//    DebugThread *thread = [[DebugThread alloc] initWithTarget:self selector:@selector(threadTask) object:nil];
//    [thread start];
//    self.thread = thread;// 不强引用 执行完就释放了dealloc,强引用 执行完状态为finish
    
    // test crash
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self testCrash];
//    });
    
    /*
     ##Block的存储域:##
     _NSConcreteStackBlock // 存储在栈上
     _NSConcreteGlobalBlock // 存储在数据段(text段),类似函数
     _NSConcreteMallocBlock // 存储在堆上
     
     全局静态 block，不会访问任何外部变量，执行完就销毁
     保存在栈中的 block，当函数返回时会被销毁，和第一种的区别就是调用了外部变量
     保存在堆中的 block，当引用计数为 0 时会被销毁
     
     使用了静态或者全局变量的时候，block实际上是存放在全局区的
     Block语法的表达式中不使用外部变量，block是存放在全局区的
     
     栈上的forwarding其实是去指向堆中的forwarding，而堆中的forwarding指向的还是自己。所以这样就能保证我们访问的就是同一个变量
     
     在ARC下，通常讲Block作为返回值的时候，编译器会自动加上copy，也就是自动生成复制到堆上的代码
     */
    // Block只捕获Block中会用到的变量。由于只捕获了自动变量(自动变量是以值传递方式传递到Block的构造函数里面)的值，并非内存地址，所以Block内部不能改变自动变量的值。Block捕获的外部变量可以改变值的是静态变量，静态全局变量，全局变量
    // __block原理:没有__block修饰，被block捕获，是值拷贝,__block修饰的变量被转化成了一个结构体，复制其引用地址,我们存放指针的方式就可以修改实际的值了
    // __block_impl  结构体中的 FuncPtr 函数指针，指向的就是我们的 Block 的具体实现。真正调用 Block 就是利用这个函数指针去调用的。
    // 为什么能访问外部变量，就是因为将外部变量复制到了结构体中（上面的 int i），即自动变量会作为成员变量追加到 Block 结构体中
    /*
     具有 __block 修饰的变量，会生成一个 Block_byref_a_0 结构体来表示外部变量，然后再追加到 Block 结构体中，这里生成 Block_byref_a_0 这个结构体大概有两个原因：一个是抽象出一个结构体，可以让多个 Block 同时引用这个外部变量；另外一个好管理，因为 Block_byref_a_0 中有个非常重要的成员变量 forwarding  指针，这个指针非常重要（这个指针指向 Block_byref_a_0 结构体），这里是保证当我们将 Block 从栈拷贝到堆中，修改的变量都是同一份
     
     Block 从栈复制到堆上，__block 修饰的变量也会从栈复制到堆上；为了结构体 __block 变量无论在栈上还是在堆上，都可以正确的访问变量，我们需要 forwarding 指针
     
     在 Block 从栈复制到堆上的时候，原本栈上结构体的 forwarding 指针，会改变指向，直接指向堆上的结构体。这样子就可以保证之后我们都是访问同一个结构体中的变量，这里就是为什么 __block 修饰的变量，在 Block 内部中可以修改的原因了
     */
    // 对于全局区的 Block，是不存在作用域的问题，但是栈区 Block 不同，在作用域结束后就会 pop 出栈
    /*
     1.Block 内部没有引用外部变量，Block 在全局区，属于 GlobalBlock
     2.Block 内部有外部变量：
     a.引用全局变量、全局静态变量、局部静态变量：Block 在全局区，属于 GlobalBlock
     b.引用普通外部变量，用 copy，strong 修饰的 Block 就存放在堆区，属于 MallocBlock；用 weak 修饰的Block 存放在栈区，属于 StackBlock
     */
    
    /*
     Block 是一个里面存储了指向定义 block 时的代码块的函数指针，以及block外部上下文变量信息的结构体
     MARK:######block变量截获本质:
     
     https://www.jianshu.com/p/1e8855a1b47d
     
     int a = 0;
     void (^block)(void) = ^{
     NSLog(@"%d",a);
     };
     block();
     转为cpp
     int a = 10;
     void (*block)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, a));
     ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
     
     static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
     int a = __cself->a; // bound by copy
     NSLog((NSString *)&__NSConstantStringImpl__var_folders_lb_tby1gwds2fnb89dzkf4cq3xh0000gn_T_main_9bc6d9_mi_0,a);
     }
     
     ###
     block初始化：block 通过 __main_block_impl_0结构体构造函数进行初始化，同时生成__main_block_func_0静态函数，并将其地址以及其他相关信息储存在__block_impl这个结构体成员变量中。
     其中，__block_impl这个结构体成员变量是__main_block_impl_0的首地址
     block调用：block指针指向的是__main_block_impl_0 的首地址，即__block_impl的地址，所以可以强转为(__block_impl *)类型，并访问其成员FuncPtr，指向的是静态函数地址，并传入参数__main_block_impl_0，也就是block自己
     ###
     
     1.int a = 10:
     struct __ViewController_viewDidLoad_block_impl_0{
     struct __block_impl impl;
     struct __ViewController_viewDidLoad_block_desc_0* Desc;
     int a;// 值截获
     __ViewController_viewDidLoad_block_impl_0(void *fp, struct __ViewController_viewDidLoad_block_desc_0 *desc, int _a, int flags = 0) : a(_a) {
     impl.isa = &_NSConcreteStackBlock;
     impl.Flags = flags;
     impl.FuncPtr = fp;
     Desc = desc;
     }
     }
     block中的变量a的值，就是传递进去的值10
     2.__block int a = 10
     __Block_byref_a_0 *a;
     
     __ViewController_viewDidLoad_block_impl_0(void *fp, struct __ViewController_viewDidLoad_block_desc_0 *desc, __Block_byref_a_0 *_a, int flags = 0) : a(_a->__forwarding){
     
     }
     struct __Block_byref_a_0 {
     void *__isa;
     __Block_byref_a_0 *__forwarding;
     int a;
     }
     __block修饰的变量a成为了对象，并把对象的地址传递给了block
     
     // 原代码
     __block int a = 10;
     // c++源码
     __attribute__((__blocks__(byref))) __Block_byref_a_0 a = {
     (void*)0,
     (__Block_byref_a_0 *)&a,
     0,
     sizeof(__Block_byref_a_0),
     10
     };
     
     __forwarding存放的是自己本身的地址
     结构体内的a变量存放的是外部变量a的值
     
     在block初始化过程中，有一个由栈block指向堆block的过程
     栈空间的block有一个__Block_byref_a_0结构体，
     指向外部__Block_byref_a_0的地址，
     其中它的__forwarding指针指向自身
     
     当block从栈copy到堆时:
     堆空间的block有一个__Block_byref_a_0结构体，
     指向外部__Block_byref_a_0的地址，
     其中它的__forwarding指针指向自身
     
     copy->forwarding = copy;
     就是将堆结构体的__forwarding指针指向自身
     src->forwarding = copy;
     就是将栈结构体的__forwarding指针指向堆结构体
     
     不仅__block修饰的变量会这样，前文的对象类型变量同样会在copy函数内部被转化成类似的结构体进行处理
     
     3.__strong NSNumber *a = @(10);
     NSNumber *a;// 值截获
     __ViewController_viewDidLoad_block_impl_0(void *fp, struct __ViewController_viewDidLoad_block_desc_0 *desc, NSNumber *_a, int flags = 0) : a(_a){
     
     }
     objc_ownership(strong)
     对于对象的局部变量，连同修饰符一起被截获，因此强引用这个对象
     
     对象类型，struct __ViewController_viewDidLoad_block_desc_0多出了copy和dispose函数
     用来 Block 从栈复制到堆、堆上的 Block 废弃的时候分别调用
     
     原有的栈上的结构体指针被copy到了堆，
     同时，copy函数内部会将栈对象指向堆对象
     
     所以，在block初始化作用域内引用计数+2，
     在作用域外栈空间的结构体被回收，引用计数-1，
     在block消亡后，引用计数-1
     
     int main(int argc, char * argv[]) {
     @autoreleasepool {
     
     TestObject *object = [[TestObject alloc] init];
     
     NSLog(@"引用数 %ld",(long)CFGetRetainCount((__bridge CFTypeRef)object));
     block = ^{
     NSLog(@"%@",object);
     };
     NSLog(@"引用数 %ld",(long)CFGetRetainCount((__bridge CFTypeRef)object));
     
     return 0;
     }
     }// 1, 3
     
     int main(int argc, char * argv[]) {
     @autoreleasepool {
     
     TestObject *object = [[TestObject alloc] init];
     NSLog(@"引用数 %ld",(long)CFGetRetainCount((__bridge CFTypeRef)object));
     
     {
     block = ^{
     NSLog(@"%@",object);
     };
     }
     
     NSLog(@"引用数 %ld",(long)CFGetRetainCount((__bridge CFTypeRef)object));
     
     return 0;
     }
     }// 1, 2
     
     typedef void (^Block)(void);
     Block block;
     
     int main(int argc, char * argv[]) {
     @autoreleasepool {
     
     TestObject *object = [[TestObject alloc] init];
     NSLog(@"引用数 %ld",(long)CFGetRetainCount((__bridge CFTypeRef)object));
     
     block = ^{
     NSLog(@"%@",object);
     };
     
     block = nil;
     
     NSLog(@"引用数 %ld",(long)CFGetRetainCount((__bridge CFTypeRef)object));
     
     return 0;
     }
     }// 1, 2
     
     4.static NSNumber *a;
     static int b;
     // 指针截获
     NSNumber **a;
     int *b;
     __ViewController_viewDidLoad_block_impl_0(void *fp, struct __ViewController_viewDidLoad_block_desc_0 *desc, NSNumber **_a, int *_b, int flags = 0) : a(_a), b(_b){
     
     }
     5.全局变量&静态全局边量
     int global_a = 10;
     static int global_b = 20;
     没有截获
     
     MRC时代的block：
     只要block引用外部局部变量，block放在栈里面。
     ARC时代的block：
     只要block引用外部局部变量，block就放在堆里面
     
     
     在ARC大前提下：
     block对对象变量强引用
     对象引用计数不为0则不会释放
     所谓循环引用是指，多个对象之间相互引用，产生了闭环
     __weak typeof(self) weakSelf = self;
     可以看到结构体内的属性变成同样是__weak类型的
     block内部使用strongSelf造成短暂的闭环，但是这个strongSelf在栈空间上，在函数执行结束后，strongSelf会被系统回收
     
     
     Block 底层是用结构体，Block 会转换成 block 结构体，__block 会转换成 __block 结构体。
     然后 block 没有截获外部变量、截获全局变量的都是属于全局区的 Block，即 GlobalBlock；其余的都是栈区的 Block，即 StackBlock；
     对于全局区的 Block，是不存在作用域的问题，但是栈区 Block 不同，在作用域结束后就会 pop 出栈，__block 变量也是在栈区的
     为了解决作用域的问题，Block 提供了 Copy 函数，将 Block 从栈复制到堆上，在 MRC 环境下需要我们自己调用 Block_copy  函数，这里就是为什么 MRC 下，我们为什么需要用 copy 来修饰 Block 的原因。
     然而在 ARC 环境下，编译器会尽可能给我们自动添加 copy 操作
     
     Block 从栈复制到堆上，__block 修饰的变量也会从栈复制到堆上；为了结构体 __block 变量无论在栈上还是在堆上，都可以正确的访问变量，我们需要 forwarding 指针
     在 Block 从栈复制到堆上的时候，原本栈上结构体的 forwarding 指针，会改变指向，直接指向堆上的结构体
     
     在 ARC 环境下，Block 作为函数返回值，会自动调用 Copy 方法，将 Block 从栈复制到堆上（StackBlock -> MallocBlock）
     
     MARK:###
     block引用外部变量，会根据修饰变量的关键字来决定是强引用还是弱引用，如果变量使用__weak修饰，那block会对变量进行弱引用，如果没有__weak，那就是强引用
     但NSTimer方法不会判断修饰target的关键字，所以传self和weakSelf是没有区别的，内部都会对target强引用
     ###
     */
    NSInteger ii = 10;
    void (^bb)(void) = ^{
        NSLog(@"%ld", ii);
    };
    self.bb = bb;
    NSLog(@"bb cunt = %ld", CFGetRetainCount((__bridge CFTypeRef)(bb)));// 1,(self.bb copy/strong指向后)1
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"after bb cunt = %ld", CFGetRetainCount((__bridge CFTypeRef)(bb)));//1,1
        
    });
    NSLog(@"bb = %@", bb);// __NSMallocBlock__
    NSLog(@"bbb = %@", ^{NSLog(@"%ld", ii);});// 使用外部变量，(因为没有把block赋值给变量，如果赋值给变量，系统会对它做copy)__NSStackBlock__， 不使用外部变量，__NSGlobalBlock__
    
    
    int val = 1;
    void (^blk)(void) = ^{
        printf("%d\n", val);// Block保存了val的瞬间值,值拷贝
    };
    val = 2;
    blk();// 1
    
    // __block变量在copy时，由于__forwarding的存在，栈上的__forwarding指针会指向堆上的__forwarding变量，而堆上的__forwarding指针指向其自身，所以，如果对__block的修改，实际上是在修改堆上的__block变量。即__forwarding指针存在的意义就是，无论在任何内存位置， 都可以顺利地访问同一个__block变量
    __block int val1 = 11;
    void (^blk1)(void) = ^{
        val1 = 33;
        printf("%d\n", val1);
    };
    val1 = 22;
    NSLog(@"val1 = %d blk1 = %@", val1, blk1);// 22 __NSMallocBlock__
    blk1();// 33
    NSLog(@"val1 = %d blk1 = %@", val1, blk1);// 33 __NSMallocBlock__
    
    NSNumber *num = @(10);
    void (^varBlock)(void) = ^{
        NSLog(@"num = %@", num);
    };
    num = @(20);
    varBlock();// 10
    
    // block
    // 我们可以通过是否引用外部变量识别，未引用外部变量即为NSGlobalBlock，可以当做函数使用
    float (^sum)(float, float) = ^(float a, float b){
        return a + b;
    };
    NSLog(@"%@", sum);// block is <__NSGlobalBlock__>
    sum(4.f, 5.f);
    
    // block 使用 copy 是从 MRC遗留下来的“传统”,在 MRC 中,方法内部的 block 是在栈区的,使用 copy 可以把它放到堆区.在 ARC 中写不写都行：对于 block 使用 copy 还是 strong 效果是一样的,编译器自动对 block 进行了 copy 操作
    // MRC 环境下：访问外界变量的 Block 默认存储栈中
    // ARC 环境下：访问外界变量的 Block 默认存储在堆中（实际是放在栈区，然后ARC情况下自动又拷贝到堆区），自动释放
    // 如果是一个copy属性的block,它一定是NSMallocBlock.block堆内存的一个明显的特性就是:他会强引用block中的对象
    // 在处理对象时,block会malloc
    Person* model = [Person personWithName:@"ndl" age:21];
    NSLog(@"model count = %ld", CFGetRetainCount((__bridge CFTypeRef)(model)));
    
    float (^sum1)(float, float) = ^(float a, float b){
        NSLog(@"model count = %ld", CFGetRetainCount((__bridge CFTypeRef)(model)));
        model.age = 20;
        return a + b + model.age;
    };
    model.age = 100;
    NSLog(@"%@ age = %ld", sum1, model.age);// block is <__NSMallocBlock__> age = 100
    NSLog(@"sum1 result = %f", sum1(1.0, 2.0));// 1+2+20=23
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"after model count = %ld", CFGetRetainCount((__bridge CFTypeRef)(model)));
    });
    
    NSMutableArray *m_arr = [NSMutableArray arrayWithObject:@"123"];
    NSLog(@"m_arr = %@", m_arr);// 123
    void (^mArrBlock)(void) = ^ {
        [m_arr addObject:@"234"];
//        m_arr = [NSMutableArray arrayWithObject:@"txt"];// 报错 需要外部用__block
    };
    NSLog(@"m_arr = %@", m_arr);// [m_arr addObject:@"234"];: 123
    mArrBlock();
    NSLog(@"m_arr = %@", m_arr);// [m_arr addObject:@"234"];: 123, 234
    // MARK:block在修改NSMutableArray，需不需要添加__block？:不需要
    // block里只是复制了一份这个指针，两个指针指向同一个地址。所以，在block里面对指针指向内容做的修改，在block外面也一样生效
    
    //
    int multiplier = 7;
    // 对栈blockcopy之后，并不代表着栈block就消失了，左边的mallock是堆block，右边被copy的仍是栈block
    int (^myBlock)(int) = ^(int num) {
        return num * multiplier;
    };
    NSLog(@"myBlock = %@ retainCount = %ld", myBlock, CFGetRetainCount((__bridge CFTypeRef)(myBlock)));// __NSMallocBlock__, 1
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"after myBlock = %@ retainCount = %ld", myBlock, CFGetRetainCount((__bridge CFTypeRef)(myBlock)));// 1
    });
    
    int (^staticBlock)(int) = ^(int num) {
        return num * count;
    };
    count = 10;
    NSLog(@"staticBlock = %@ result = %d", staticBlock, staticBlock(3));// __NSGlobalBlock__, 30

    
    void (^nullBlock)() = ^ {
        
    };
    NSLog(@"nullBlock = %@", nullBlock);// __NSGlobalBlock__
    [self func:nullBlock];
    
    static int staticCount = 0;
    void (^staticInMethodBlock)() = ^ {
        staticCount = 1;
    };
    NSLog(@"staticInMethodBlock = %@", staticInMethodBlock);// __NSGlobalBlock__
    
    int weakInt = 0;
    self.weakBlock = ^{
//        int value = weakInt + 1;
        NSLog(@"===self.weakBlock===");
    };
    NSLog(@"weakBlock = %@", self.weakBlock);// 不引用普通外部变量，__NSGlobalBlock__，引用普通外部变量 __NSStackBlock__
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.weakBlock();// __NSGlobalBlock__: 调用打印log，__NSStackBlock__: 调用崩溃，因为作用域结束被系统释放
    });
    
    // strong & copy 打印一致
    int strongInt = 0;
    self.strongBlock = ^{
//        int value = strongInt + 1;
    };
    NSLog(@"strongBlock = %@", self.strongBlock);// 不引用普通外部变量,__NSGlobalBlock__,引用普通外部变量 __NSMallocBlock__
    
    NSMutableArray *mutaArr = [NSMutableArray arrayWithObject:@"123"];
    void (^testBlock)(void) = ^{
        // test1
        [mutaArr addObject:@"234"];
    };
    [mutaArr addObject:@"ndl"];
    testBlock();
    NSLog(@"mutaArr = %@", mutaArr);// test1: @"123", @"ndl", @"234"
    
    
    __weak void (^weakBlock)(void) = ^ {
        NSLog(@"123");
    };
    NSLog(@"匿名block = %@ weakBlock = %@", ^{NSLog(@"111");}, weakBlock);// 都是NSGlobalBlock
    
    // MARK:通过双指针把block外部的变量传到block，改变外部变量的值
//    Person *ppp = [[Person alloc] init];
//    ppp.name = @"ndl";
//    NSLog(@"ppp = %@ name = %@", ppp, ppp.name);// 0x600002a30a20, ndl
//    void (^aaaBlock)(Person **p) = ^(Person **p){
//        *p = [[Person alloc] init];
//        (*p).name = @"yxx";
//        NSLog(@"*p = %@ name = %@", *p, (*p).name);// 0x600002a2e9e0 yxx
//    };
//    aaaBlock(&ppp);
//    NSLog(@"===ppp = %@ name = %@", ppp, ppp.name);// 0x600002a2e9e0, yxx
    
    
//    NSURLProtocol
    
//    NSURLConnection
//    NSURLConnectionDelegate
    
//    NSURLSession

    // =====perform selector=====
    /*
    SEL selector = NSSelectorFromString(@"aTestMethod");
    // 1
//    [self performSelector:@selector(aTestMethod)];
    
    // 2
//    ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
    
    // 3
//    IMP imp = [self methodForSelector:selector];
//    void (*func)(id, SEL) = (void *)imp;
//    func(self, selector);
     */
    
    // 摇一摇
//    Application.applicationSupportsShakeToEdit = YES;
//    [self becomeFirstResponder];
    
    
    
    // 0,7,1,2,3,4,5,6 固定的
    dispatch_queue_t ndlQueue = dispatch_queue_create("ndl_queue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"===0===");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"===1===");
        dispatch_sync(ndlQueue, ^{
            NSLog(@"===2===");
        });
        
        NSLog(@"===3===");
        dispatch_sync(ndlQueue, ^{
            NSLog(@"===4===");
        });
        
        NSLog(@"===5===");
        dispatch_sync(ndlQueue, ^{
            NSLog(@"===6===");
        });
    });
    
    // 0,7,1,8,2,10,3,9,11,4,5,6 不固定的
    /*
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"===8===");
        dispatch_sync(ndlQueue, ^{
            NSLog(@"===9===");
        });
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"===10===");
        dispatch_sync(ndlQueue, ^{
            NSLog(@"===11===");
        });
    });
     */
    
    NSLog(@"===7===");
    
    
    
    
    // =====YYImage=====
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        YYImage *image = [YYImage imageNamed:@"launch_2"];
//        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.frame = self.view.bounds;
//        [self.view addSubview:imageView];
//    });
    
    
    /*
     NSDate 或 CFAbsoluteTimeGetCurrent 返回的系统时钟时间
     从时钟偏移量的角度 mach_absolute_time() 和 CACurrentMediaTime 基于内建时钟.能够更精确的测试时间,并且不会根据外部的时间变化而变化.(例如,时区变化\夏时制),它和系统的upTime有关.系统重启后,CACurrentMediaTime 也会重新设置.
     */
    NSTimeInterval timeIntervalSinceReferenceDate = [[NSDate date] timeIntervalSinceReferenceDate];
    NSDate *date = [NSDate date];
    CFAbsoluteTime cfTime = CFAbsoluteTimeGetCurrent();
    CFTimeInterval caTime = CACurrentMediaTime();
    NSLog(@"timeIntervalSinceReferenceDate = %lf\ncfTime = %lf\ncaTime = %lf\ndate = %@", timeIntervalSinceReferenceDate, cfTime, caTime, date);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 延时函数，会在内部创建一个 NSTimer，然后添加到当前线程的RunLoop中。也就是如果当前线程没有开启RunLoop，该方法会失效
        [self performSelector:@selector(test1) withObject:nil afterDelay:2];
        // 如果RunLoop的mode中一个item都没有，RunLoop会退出。即在调用RunLoop的run方法后，由于其mode中没有添加任何item去维持RunLoop的事件循环，RunLoop随即还是会退出
        // 所以我们自己启动RunLoop，一定要在添加item后
        [[NSRunLoop currentRunLoop] run];// 这个不写上面的test1不执行
        NSLog(@"after test1");
    });
    
    // ===memory manage===
    Object1 *obj1 = [[Object1 alloc] init];
    Object2 *obj2 = [[Object2 alloc] init];
    obj1.obj = obj2;
    obj2.obj1 = obj1;
    // MARK:循环引用，说到底还是引用计数问题###
//    obj1 = nil;// 还是循环引用，obj1是stack指向堆内存，不影响堆对象的引用计数
    obj1.obj = nil;// 这样可以解除循环引用。obj1.obj堆对象强引用Object2，赋值为nil，Object2引用计数-1
    
    
    Object1 *testObj = [[Object1 alloc] init];
    NSLog(@"testObj retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(testObj)));// 1
    void (^objBlock)(void) = ^ {
        NSLog(@"testObj = %@", testObj);
    };
    NSLog(@"testObj retainCount = %ld objBlock = %ld", CFGetRetainCount((__bridge CFTypeRef)(testObj)), CFGetRetainCount((__bridge CFTypeRef)(objBlock)));// 3, 1
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"testObj retainCount = %ld objBlock = %ld", CFGetRetainCount((__bridge CFTypeRef)(testObj)), CFGetRetainCount((__bridge CFTypeRef)(objBlock)));// 1, 1
    });
    
    NSString *originStr = @"hello";
    NSLog(@"reverseStr = %@", [originStr ndl_reverseString]);
    
    // MARK:单指针，双指针在方法参数中的区别
//    Object1 *testPoint = [[Object1 alloc] init];
//    NSLog(@"testPoint = %@ testPoint = %p testPointPos = %p", testPoint, testPoint, &testPoint);// 0x600003d78b00, 0x600003d78b00, 0x7ffeee411200
//    // ###MARK:单指针，在方法内会复制一个临时的指针副本，指向同一个值，在方法内操作的都是这个临时副本## 指针也是有内存地址的
//    [self testPoint:testPoint];
//    NSLog(@"=testPoint = %@ =testPoint = %p", testPoint, testPoint);// 0x600003d78b00, 0x600003d78b00
    
    
    // MARK:test双指针,在方法内会改变方法外指针的指向。所以要想在方法里面为指针赋值，可以使用双指针来解决
    Object1 *dObj = [[Object1 alloc] init];
    dObj.name = @"dObj";
    NSLog(@"dObj = %@", dObj);// 0x6000038c2020
    [self testDObj:&dObj];
    NSLog(@"dObj = %@ name = %@", dObj, dObj.name);// 0x6000038cba40 ndl
    
    NSLog(@"============");
    /*
     MARK:什么时候使用自动释放池
     大内存消耗对象的重复创建时
     写循环，循环里面包含了大量临时创建的对象,让每次循环结束时，可以及时释放临时对象的内存
     for (int i = 0; i < 10000000; i++)
     {
     @autoreleasepool{
     NSMutableArray *array = [NSMutableArray new];
     NSMutableDictionary *dic = [NSMutableDictionary new];
     NSMutableArray *array1 = [NSMutableArray new];
     NSMutableDictionary *dic1 = [NSMutableDictionary new];
     NSMutableArray *array2 = [NSMutableArray new];
     NSMutableDictionary *dic2 = [NSMutableDictionary new];
     NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"testimage"], 1);
     NSError *error;
     NSURL *url = [NSURL URLWithString:@"www.baidu.com"];
     NSString *fileContents = [NSString stringWithContentsOfURL:url
     encoding:NSUTF8StringEncoding
     error:&error];
     }
     }
     */
    
    
    // MARK:引用计数
    /*
     栈区：
     创建临时变量时由编译器自动分配，在不需要的时候自动清除的变量的存储区.里面的变量通常是局部变量、函数参数等
     
     mrc:
     1.每个对象被创建时引用计数都为1
     2.每当对象被其他指针引用时，需要手动使用[obj retain];让该对象引用计数+1。
     3.当指针变量不在使用这个对象的时候，需要手动释放release这个对象。 让其的引用计数-1.
     4.当一个对象的引用计数为0的时候，系统就会销毁这个对象
     
     当你使用ARC时，编译器会在在适当位置插入release和autorelease
     ARC时代引入了strong强引用来带代替retain，引入了weak弱引用
     在ARC下编译器会自动在合适位置为OC对象添加release操作.会在当前线程Runloop退出或休眠时销毁这些对象
     ARC:几个修饰符:__strong,__weak,__autoreleasing和引用计数
     NSLog(@"count = %ld", CFGetRetainCount((__bridge CFTypeRef)([[Person alloc] init])));// 1 等下就会被释放
     // strong: Person *person;
     self.person = [[Person alloc] init];
     NSLog(@"count = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.person)));// 2,延迟几秒还是2
     
     __strong:
     id obj = [[NSObject alloc] init];
     等价于
     id __strong obj = [[NSObject alloc] init];
     runtime->
     id obj = objc_msgSend(NSObject,@selector(alloc));
     objc_msgSend(obj,@selector(init));
     // 编译器在obj作用域结束时自动插入release
     objc_release(obj);
     
     以alloc/new/copy/mutableCopy生成的对象,这种对象会被当前的变量所持有,引用计数会加1
     
     不是用被持有的方式生成对象:
     id obj = [NSMutableArray array];
     这种方式生成的对象不会被obj持有,通常情况下会被注册到autoreleasepool中
     runtime->
     id obj = objc_msgSend(NSMutableArray,@selector(array));
     // 调用objc_retainAutoreleasedReturnValue函数,这个函数的作用是返回注册在autoreleasepool当中的对象
     objc_retainAutoreleasedReturnValue(obj);
     // 编译器在obj作用域结束时自动插入release
     objc_release(obj);
     
     
     objc_retainAutoreleaseReturnValue():
     这个函数一般是和objc_retainAutoreleasedReturnValue()成对出现的.目的是注册对象到autoreleasepool中
objc_retainAutoreleaseReturnValue()函数在发现对象调用了方法或者函数之后又调用了objc_retainAutoreleasedReturnValue(),那么就不会再把返回的对象注册到autoreleasepool中了,而是直接把对象传递过去
     
     __weak:
     用weak修饰的对象在销毁后会被自动置为nil.凡是用weak修饰过的对象,必定是注册到autoreleasepool中的对象
     
     weak变量未使用的情况下:
     // obj默认有__strong修饰
     id obj = [[NSObject alloc] init];
     id __weak obj1 = obj;
     runtime->
     // 省略obj的实现
     id obj1;
     // 通过objc_initWeak初始化变量
     objc_initWeak(&obj1,obj);
     // 通过objc_destroyWeak释放变量
     objc_destroyWeak(&obj1);
     
     objc_initWeak()函数的作用是将obj1初始化为0,然后将obj作为参数传递到这个函数中objc_storeWeak(&obj1,obj)
     objc_destroyWeak()函数则将0作为参数来调用:objc_storeWeak(&obj1,0)
     objc_storeWeak()函数的作用是以第二个参数(obj || 0)作为key,第一个参数(&obj1)作为value,将第一个参数的地址注册到weak表中.当key为0,即从weak表中删除变量地址
     
     weak变量被使用的情况下:
     id __weak obj1 = obj;
     // 这里使用了obj1这个用weak修饰的变量
     NSLog(@"%@",obj1);
     runtime->
     id obj1;
     objc_initWeak(&obj1,obj);
     id tmp = objc_loadWeakRetained(&obj1);
     objc_autorelease(tmp);
     NSLog(@"%@",tmp);
     objc_destroyWeak(&obj1);
当我们使用weak修饰的对象时,实际过程中产生了一个tmp对象,因为objc_loadWeakRetained()函数会从weak表中取出weak修饰的对象,所以tmp会对这个取出的对象进行一次强引用
     weak修饰的对象在当前变量作用域结束前都可以放心使用
     objc_autorelease()会将tmp对象也注册到autoreleasepool中
     
     __autoreleasing:
     它的主要作用就是将对象注册到autoreleasepool中
     
     block内套一层strongObject:
     在异步线程中weakObject可能会被销毁,所以需要套一层strong
     */
    
    
}

- (void)testDObj:(Object1 **)DObj
{
    // &dObj是dobj指针的地址，即DObj，*DObj则是指针的指针指向的值（即dobj），给*DObj赋值，即改变了dObj的值（指向）
    *DObj = [[Object1 alloc] init];
    (*DObj).name = @"ndl";
    NSLog(@"*DObj = %@", *DObj);// 0x6000038cba40
}

- (void)testPoint:(Object1 *)obj
{
    NSLog(@"obj = %@ obj = %p objPos = %p", obj, obj, &obj);// 0x600003d78b00, 0x600003d78b00, 0x7ffeee410d68
    obj = [[Object1 alloc] init];
    NSLog(@"=obj = %@ =obj = %p", obj, obj);// 0x600003da44e0, 0x600003da44e0
}

- (void)testMethodWithName:(NSString *)name
{
    // 方法参数name是一个指针，指向传入的参数指针所指向的对象内存地址。name是在栈中
    // 通过打印地址可以看出来，传入参数的对象内存地址与方法参数的对象内存地址是一样的。但是指针地址不一样。
    NSLog(@"name指针地址:%p,name指针指向的对象内存地址:%p",&name,name);
}

- (void)test1
{
    NSLog(@"===test===");
}

- (void)func:(void (^)())funcBlock
{
    NSLog(@"funcBlock = %@", funcBlock);// __NSGlobalBlock__
    
    void (^methodBlock)() = ^ {
        
    };
//    methodBlock();
    NSLog(@"methodBlock = %@", methodBlock);// __NSGlobalBlock__
}

//// 开始摇动
//- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//
//}
//// 取消摇动
//- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//
//}
//// 摇动结束
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//
//}

- (void)dealloc
{
    NSLog(@"===[TestTVViewController dealloc]===");
}

- (void)threadTask
{
    NSLog(@"log threadTask");
}

- (void)testCrash
{
    // xlog日志
//    for (NSInteger i = 0; i < 5; i++) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [XLogManager logWithLevel:XLogLevelDebug moduleName:@"TestTextView" fileName:NSStringFromClass([self class]) lineNumber:__LINE__ funcName:__FUNCTION__ format:@"count = %ld", i];
//
//            if (i == 4) {
//                [XLogManager flushLog:^{
//
//                }];
//            }
//        });
//    }
    
    
//    [self arrayIndexOutOfBoundsException];
//    [self unrecognizableSelectorException];
//    [self abortSignalException];
//    [self raiseException];
    
    /* Add another stack frame */
//    stackFrame();
}

// ==============================================
// 前两个方法属于系统奔溃，直接编译运行，即可监听到Crash异常信息
// 数组越界异常
- (void)arrayIndexOutOfBoundsException
{
    NSArray *array= @[@"sss", @"xxx", @"ooo"];
    [array objectAtIndex:5];
}

// 无法识别的方法异常
- (void)unrecognizableSelectorException
{
    [self performSelector:@selector(ndl) withObject:nil afterDelay:2.0];
}

// 终止信号异常
- (void)abortSignalException
{
    int list[2] = {1,2};
    int *p = list;
    // 导致SIGABRT的错误，因为内存中根本就没有这个空间，哪来的free，就在栈中的对象而已
    free(p);
    p[1] = 5;
}

- (void)raiseException
{
    [NSException raise:@"raiseException-name" format:@"raiseException-format"];
}
// ==============================================

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"self retainCount = %ld self = %@", CFGetRetainCount((__bridge CFTypeRef)(self)), self);// 11 0x7fa5d0408930
    __weak typeof(self) weakSelf = self;
    NSLog(@"self retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));// 11
    // self的引用计数+1，栈中的strongSelf_s作用域结束后被释放使得self的引用计数-1
//    __strong typeof(self) strongSelf_ = weakSelf;
    
//    self.testBB = ^{
//        // self
////        NSLog(@"self retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));// 13
////        self.tag = @"123";
////        NSLog(@"self retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));// 13
//
//        // weakSelf
//        NSLog(@"self retainCount = %ld weakSelf = %@", CFGetRetainCount((__bridge CFTypeRef)(weakSelf)), weakSelf);// 12 0x7fa5d0408930
//        weakSelf.tag = @"123";
//        NSLog(@"tag = %@", weakSelf.tag);// 123
//    };
//    self.testBB();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"==========");
        NSLog(@"self retainCount = %ld self = %@", CFGetRetainCount((__bridge CFTypeRef)(self)), self);//weakSelf 7, self 8
    });
    NSLog(@"after dispatch_after");
    
    // textView retainCount
//    NSLog(@"textView retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.textView)));// 3
//    UITextView *temp = self.textView;
//    NSLog(@"textView retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.textView)));// 4
//    __strong UITextView *temp1 = self.textView;
//    NSLog(@"textView retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.textView)));// 5
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"textView retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.textView)));// 3
//    });
    
    
    // textView :{0, 120, 375, 300}
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"textContainer.size = %@", NSStringFromCGSize(self.textView.textContainer.size));
//    });
    
}



- (void)buttonDidClicked:(UIButton *)button
{
    NSLog(@"##buttonDidClicked##");
//    [self dismissViewControllerAnimated:YES completion:nil];

    // tes map
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:[TestMapViewController new]];
    [self presentViewController:nav animated:YES completion:nil];
    
    // CTMediator
//    [self presentViewController:[[CTMediator sharedInstance] moduleA_TestViewController] animated:YES completion:nil];
    
    // TestTimer
//    [self presentViewController:[TestTimerViewController new] animated:YES completion:nil];
}

- (void)buttonDidTapped:(UITapGestureRecognizer *)gesture
{
    NSLog(@"##buttonDidTapped##");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"markedTextRange"]) {
        UITextRange *markedTextRange = change[NSKeyValueChangeNewKey];
        NSLog(@"###observeValueForKeyPath markedTextRange = %@###", markedTextRange);
    }
}

- (void)test
{
    NSString *str = @"123";
    NSLog(@"subStr = %@", [str substringToIndex:1]);// @"1"
    
    // 13个字符
    
    // testStr.length: UTF-16 code units
    NSString *testStr = @"sdf🤨123j🤨7sdf";// 15(个码元) flag = 0 【末尾+我 16(个码元)】
    // 30, 19
//    NSLog(@"UTF16 = %ld UTF8 = %ld", [testStr lengthOfBytesUsingEncoding:NSUTF16StringEncoding], [testStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
//    testStr = @"123sdfg你懂";// flag = 0
//    testStr = @"asd123";// flag = 1
//    testStr = @"sdf🤨123j🤨7sdf我";// 16 flag = 0
    BOOL flag = [testStr canBeConvertedToEncoding:NSASCIIStringEncoding];
    NSLog(@"length = %ld flag = %ld", testStr.length, [NSNumber numberWithBool:flag].integerValue);
    
    // @"sdf🤨123j🤨7sdf"
//    NSLog(@"UTF16-flag = %ld UTF8-flag = %ld", [testStr canBeConvertedToEncoding:NSUTF16StringEncoding], [testStr canBeConvertedToEncoding:NSUTF8StringEncoding]);// 1, 1
    
    // UTF16 空字符串是2字节
//    testStr = @"asd123";// UTF16, UTF8: 14, 6
//    testStr = @"123sdfg你懂";// 20, 13(UTF8 汉字3字节)
//    testStr = @"sdf🤨1你";// 16(UTF16 汉字2字节 🤨4字节) ,11(UTF8 🤨4字节)
//    NSData *testStrData = [testStr dataUsingEncoding:NSUTF16StringEncoding];
//    testStrData = [testStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"testStrData.length = %ld", testStrData.length);// 32, 19
    
//    Byte *bytes = (Byte *)testStrData.bytes;
    
    for (NSUInteger i = 0; i < testStr.length; i++) {
        NSRange range = [testStr rangeOfComposedCharacterSequenceAtIndex:i];
        NSLog(@"range = %@", NSStringFromRange(range));
        /*
         2019-05-15 16:09:26.791512+0800 NDL_Category[20738:158453] range = {0, 1}
         2019-05-15 16:09:26.791674+0800 NDL_Category[20738:158453] range = {1, 1}
         2019-05-15 16:09:26.791860+0800 NDL_Category[20738:158453] range = {2, 1}
         2019-05-15 16:09:26.792022+0800 NDL_Category[20738:158453] range = {3, 2}
         2019-05-15 16:09:26.792176+0800 NDL_Category[20738:158453] range = {3, 2}
         2019-05-15 16:09:26.792354+0800 NDL_Category[20738:158453] range = {5, 1}
         2019-05-15 16:09:26.792803+0800 NDL_Category[20738:158453] range = {6, 1}
         2019-05-15 16:09:26.793274+0800 NDL_Category[20738:158453] range = {7, 1}
         2019-05-15 16:09:26.793605+0800 NDL_Category[20738:158453] range = {8, 1}
         2019-05-15 16:09:26.793913+0800 NDL_Category[20738:158453] range = {9, 2}
         2019-05-15 16:09:26.794387+0800 NDL_Category[20738:158453] range = {9, 2}
         2019-05-15 16:09:26.794978+0800 NDL_Category[20738:158453] range = {11, 1}
         2019-05-15 16:09:26.795325+0800 NDL_Category[20738:158453] range = {12, 1}
         2019-05-15 16:09:26.809670+0800 NDL_Category[20738:158453] range = {13, 1}
         2019-05-15 16:09:26.809888+0800 NDL_Category[20738:158453] range = {14, 1}
         2019-05-15 16:09:26.810064+0800 NDL_Category[20738:158453] range = {15, 1}// 原有字符串末尾+我
         */
    }
    
    // 计数
    __block NSInteger count = 0;
    [testStr enumerateSubstringsInRange:NSMakeRange(0, testStr.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        count++;
        NSLog(@"count = %ld subString = %@ (substringRange = %@) [enclosingRange = %@]", count, substring, NSStringFromRange(substringRange), NSStringFromRange(enclosingRange));
    }];
    /*
     2019-05-15 16:09:26.810348+0800 NDL_Category[20738:158453] count = 1 subString = s (substringRange = {0, 1}) [enclosingRange = {0, 1}]
     2019-05-15 16:09:26.810666+0800 NDL_Category[20738:158453] count = 2 subString = d (substringRange = {1, 1}) [enclosingRange = {1, 1}]
     2019-05-15 16:09:26.811006+0800 NDL_Category[20738:158453] count = 3 subString = f (substringRange = {2, 1}) [enclosingRange = {2, 1}]
     2019-05-15 16:09:26.811198+0800 NDL_Category[20738:158453] count = 4 subString = 🤨 (substringRange = {3, 2}) [enclosingRange = {3, 2}]
     2019-05-15 16:09:26.811356+0800 NDL_Category[20738:158453] count = 5 subString = 1 (substringRange = {5, 1}) [enclosingRange = {5, 1}]
     2019-05-15 16:09:26.811527+0800 NDL_Category[20738:158453] count = 6 subString = 2 (substringRange = {6, 1}) [enclosingRange = {6, 1}]
     2019-05-15 16:09:26.811680+0800 NDL_Category[20738:158453] count = 7 subString = 3 (substringRange = {7, 1}) [enclosingRange = {7, 1}]
     2019-05-15 16:09:26.811865+0800 NDL_Category[20738:158453] count = 8 subString = j (substringRange = {8, 1}) [enclosingRange = {8, 1}]
     2019-05-15 16:09:26.812030+0800 NDL_Category[20738:158453] count = 9 subString = 🤨 (substringRange = {9, 2}) [enclosingRange = {9, 2}]
     2019-05-15 16:09:26.812473+0800 NDL_Category[20738:158453] count = 10 subString = 7 (substringRange = {11, 1}) [enclosingRange = {11, 1}]
     2019-05-15 16:09:26.812888+0800 NDL_Category[20738:158453] count = 11 subString = s (substringRange = {12, 1}) [enclosingRange = {12, 1}]
     2019-05-15 16:09:26.813258+0800 NDL_Category[20738:158453] count = 12 subString = d (substringRange = {13, 1}) [enclosingRange = {13, 1}]
     2019-05-15 16:09:26.813684+0800 NDL_Category[20738:158453] count = 13 subString = f (substringRange = {14, 1}) [enclosingRange = {14, 1}]
     2019-05-15 16:09:26.813941+0800 NDL_Category[20738:158453] count = 14 subString = 我 (substringRange = {15, 1}) [enclosingRange = {15, 1}]
     */
}

#pragma mark - UITextViewDelegate
// UITextViewTextDidChangeNotification

// 在keyboardWillShow前面执行// 键盘弹出前计算textView的bottomY
// 1-1
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewShouldBeginEditing length = %ld", textView.text.length);
    return YES;
}

// 3-1
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSLog(@"textViewShouldEndEditing");
    return YES;
}

// 在keyboardWillShow后面执行
// 1-2
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing");
}

// 3-2
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textViewDidEndEditing");
}

// ##没有text点击删除 第三方键盘和系统i键盘都走这个方法## shouldChangeTextInRange curText =  (range = {0, 0}) [replacementText = ]
// 一开始光标的位子:range(0,0)
// 2-1
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self logCommonWithTextView:textView tagStr:@"shouldChangeTextInRange"];
    // range:改变的范围
    NSLog(@"shouldChangeTextInRange curText = %@ (range = %@) [replacementText = %@]", textView.text, NSStringFromRange(range), text);
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    // range:表示应该改变text的范围
    NSUInteger curTotalTextLen = textView.text.length;
    // 光标位置（光标位置 || 范围开始位置）
    NSUInteger cursorIndex = range.location;
    NSUInteger cursorLen = range.length;// 光标选中的textLen
    // 光标前的textLen
    NSUInteger beforeCursorTextLen = cursorIndex;
    // 替换的textLen
    NSUInteger replaceTextLen = text.length;
    
    return YES;
}
// 2-3
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange");
    
    NSString *curText = textView.text;
    NSUInteger curTotalTextLen = curText.length;
    if (curTotalTextLen > kTextViewMaxTextLength) {
        // 最后个Character(码元)
        NSRange lastIndexRange = [curText rangeOfComposedCharacterSequenceAtIndex:kTextViewMaxTextLength - 1];
        NSUInteger lastIndex = lastIndexRange.location;
        NSUInteger lastIndexLen = lastIndexRange.length;
        NSInteger substringToIndex = 0;// 截取到的index，也表示现在的textLen
        
        // 组合字符序列 超过了kTextViewMaxTextLength
        if (lastIndex + lastIndexLen > kTextViewMaxTextLength) {
            substringToIndex = lastIndex;
        } else {
            substringToIndex = lastIndex + lastIndexLen;
        }
        
        NSString *resultStr = [curText substringToIndex:substringToIndex];
        [textView setText:resultStr];
    }
}

// 选中的改变（包括光标的改变）
// 2-2 ||
// (改变光标位置,范围选中)会掉
//- (void)textViewDidChangeSelection:(UITextView *)textView
//{
//    [self logCommonWithTextView:textView tagStr:@"textViewDidChangeSelection"];
//    NSLog(@"textViewDidChangeSelection");
//}

- (void)logCommonWithTextView:(UITextView *)textView tagStr:(NSString *)tagStr
{
    UITextRange *markedTextRange = [textView markedTextRange];
    UITextRange *selectedTextRange = [textView selectedTextRange];
    NSString *markedText = [textView textInRange:markedTextRange];
    
    // ###
    NSRange selectedRange = textView.selectedRange;// 选中的范围
    
    UITextPosition *beginPos = textView.beginningOfDocument;
    UITextPosition *endPos = textView.endOfDocument;
    
    NSLog(@"===%@:markedTextRange = %@ selectedTextRange = %@ markedText = %@ selectedRange = %@ beginPos = %@ endPos = %@===", tagStr, markedTextRange, selectedTextRange, markedText, NSStringFromRange(selectedRange), beginPos, endPos);
}

@end
