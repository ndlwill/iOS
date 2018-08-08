//
//  TestRACController.m
//  NDL_Category
//
//  Created by dzcx on 2018/8/2.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestRACController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "RACView.h"
#import "RACProtocol.h"

#import <ReactiveObjC/RACReturnSignal.h>

@interface TestRACController () <RACProtocol>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIImageView *iv;

@property (nonatomic, strong) RACDisposable *timeerDisposable;

@property (nonatomic, strong) RACCommand *command;

@end
/*
 #####ReactiveCocoa操作思想:#####
运用的是Hook（钩子）思想，Hook是一种用于改变API(应用程序编程接口：方法)执行结果的技术.
Hook用处：截获API调用的技术。
Hook原理：在每次调用一个API返回结果之前，先执行你自己的方法，改变结果的输出。
 RAC开发方式：RAC中核心开发方式，也是绑定，之前的开发方式是赋值，而用RAC开发，应该把重心放在绑定，也就是可以在创建一个对象的时候，就绑定好以后想要做的事情，而不是等赋值之后在去做事情
 列如：把数据展示到控件上，之前都是重写控件的setModel方法，用RAC就可以在一开始创建控件的时候，就绑定好数据。
 
 ReactiveCocoa核心方法bind：
 ReactiveCocoa操作的核心方法是bind（绑定）,给RAC中的信号进行绑定，只要信号一发送数据，就能监听到，从而把发送数据改成自己想要的数据。
 在开发中很少使用bind方法，bind属于RAC中的底层方法，RAC已经封装了很多好用的其他方法，底层都是调用bind，用法比bind简单.

 */

// 热信号是主动的，即使你没有订阅事件，它仍然会时刻推送。而冷信号是被动的，只有当你订阅的时候，它才会发送消息。
// - [RACSignal publish]、- [RACMulticastConnection connect]、- [RACMulticastConnection signal]这几个操作生成了一个热信号。
// 热信号可以有多个订阅者，是一对多，信号可以与订阅者共享信息。而冷信号只能一对一，当有不同的订阅者，消息会从新完整发送。


// RACSubject:信号提供者，自己可以充当信号，又能发送信号。
// RACSubject不一样 创建成功就处于热状态 可发送可接受。
/*
 RACSignal在被subscribe的时候可能会产生副作用(Side Effects),就是当一个冷信号被重复订阅的时，导致singnal里的代码重复执行，这可能是你需要的情况，但如果你不要这种情况出现可以用RACMulticastConnection来处理这种情况。
 */

/*
 关于调试，RAC 源码下有 instruments 的两个插件，方便大家使用。
 signalEvents 这个可以看到流动的信号的发出情况，对于时序的问题可以比较好的解决。
 diposable 可以检查信号的 disposable 是否正常
 */

// RAC 的核心思想：创建信号 - 订阅信号 - 发送信号
// ReactiveCocoa维持和保留自己全局的信号。如果它有一个或者多个subscribers（订阅者），信号就会活跃。如果所有的订阅者都移除掉了，信号就会被释放。

// 信号类(RACSiganl)，只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。
 // 默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。
//如何订阅信号：调用信号RACSignal的subscribeNext就能订阅。

// 当一个completed或者error事件之后，订阅会自动的移除。
// 手工的移除将会通过RACDisposable.所有RACSignal的订阅方法都会返回一个RACDisposable实例，它允许你通过处置方法手动的移除订阅。
@implementation TestRACController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, self.view.width, 5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    
    // =====test XMG=====
//    [self testRACSignal];
//    [self testRACDisposable];
//    [self testRACSubject];
//    [self testRACReplaySubject];
//    [self testRACMulticastConnection];
    [self testRACCommand];
//    [self testSwitchToLatest];
    
//    [self testBind];
//    [self testCommonMethods];
//    [self testFlattenMapAndMap];
//    [self testConcat];
//    [self testThen];
//    [self testMerge];
//    [self testZipWith];
    
//    [self testReplay];
    
    /*
    [self setupTextField];
    [self setupButton];
    
    // then方法会一直等待，直到completed事件发出 有效地将控制从一个信号传递给下一个
    // Throttling（限流）
//    每次输入一个字符串都会立即执行然后导致刷新太快 ，导致每秒会显示几次搜索结果。这不是理想的状态。
//    一个好的解决方式就是如果搜索内容不变之后的时间间隔后在搜索比如500毫秒。
    @weakify(self)
    [[[[[[self requestAccessToTwitterSignal] then:^RACSignal * _Nonnull{
        @strongify(self)
        return self.textField.rac_textSignal;
    }] filter:^BOOL(NSString *text) {
        return (text.length > 2);
    }] throttle:0.5] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
        
    } error:^(NSError * _Nullable error) {// then方法传递error事件
        
    }];
    
    
    [[[self signalForLoadingImage:@""] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage *image) {
        NSLog(@"get image");
    }];
    */
    
    /*
     RACDisposable:用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。
     使用场景:不想监听某个信号时，可以通过它主动取消订阅信号。
     */
}

// signal（RACSignal）发送事件流给它的subscriber。目前总共有三种类型的事件：next、error、completed。
// 一个signal在error终止或者完成前，可以发送任意数量的next事件
// RACSignal的每个操作都会返回一个RACsignal，这在术语上叫做连贯接口（fluent interface）。这个功能可以让你直接构建管道，而不用每一步都使用本地变量。
- (void)setupTextField
{
    self.textField = [ControlManager textField];
    self.textField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textField];

    // bind
    [[self.textField.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
        return ^RACSignal *(id value, BOOL *stop){
            return [RACSignal return:[NSString stringWithFormat:@"hello: %@",value]];
        };
    }] subscribeNext:^(id  _Nullable x) {
        
    }];
    
//    [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"text = %@", x);
//    }];
    
    //======================
    // 你只关心超过3个字符长度的用户名，那么你可以使用filter操作来实现这个目的。
//    [[self.textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
//        NSLog(@"value = %@", value);
//        return value.length > 3;
//    }] subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"filter text = %@", x);
//    }];
    
    //======================
    // 在管道中添加另一个操作:事件
    @weakify(self)
    [[[self.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length);// map操作之后的都是NSNumber
    }] filter:^BOOL(NSNumber *value) {
        return [value integerValue] > 3;
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
//        self.textField
        NSLog(@"x = %@", x);
    }];
    //======================
//    RACSignal *textFieldSignal = self.textField.rac_textSignal;
//    RACSignal *textFieldFilterSignal = [textFieldSignal filter:^BOOL(id  _Nullable value) {
//        NSString *text = value;
//        return text.length > 3;
//    }];
//    [textFieldFilterSignal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"filter text = %@", x);
//    }];
    
    
    //======================
    // 1.首先要做的就是创建一些信号，来表示用户名和密码输入框中的输入内容是否有效。对每个输入框的rac_textSignal应用了一个map转换。输出是一个用NSNumber封装的布尔值。
    // 2.转换这些信号，从而能为输入框设置不同的背景颜色。订阅这些信号，然后用接收到的值来更新输入框的背景颜色。
//    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
//        return @([self isValidPassword:text]);
//    }];
//
//    [[validPasswordSignal map:^id(NSNumber *passwordValid){
//        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
//    }] subscribeNext:^(UIColor *color){
//        self.passwordTextField.backgroundColor = color;
//    }];
    // 下面有一种更好的写法！
    RACSignal *validUserNameSignal = [self.userNameTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUserName:text]);
    }];
    
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidPassword:text]);
    }];
    // RAC宏允许直接把信号的输出应用到对象的属性上。
//    RAC(self.passwordTextField, backgroundColor) = [validPasswordSignal map:^id(NSNumber *passwordValid){
//        return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
//    }];
    
    // 聚合信号
    // 登录按钮只有当用户名和密码输入框的输入都有效时才工作
    // 这两个源信号的任何一个产生新值时，reduce block都会执行，block的返回值会发给下一个信号
//    RACSignal *loginActiveSignal = [RACSignal combineLatest:@[validUserNameSignal, validPasswordSignal]
//                                                     reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid){
//                                                         return @([usernameValid boolValue]&&[passwordValid boolValue]);
//                                                     }];
//    // 响应式编程的一个关键区别，你不需要使用实例变量来追踪瞬时状态
//    [loginActiveSignal subscribeNext:^(NSNumber* loginActive){
//        self.loginButton.enabled = [loginActive boolValue];
//    }];
}

- (void)setupButton
{
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.loginButton];
    // 创建信号-添加订阅
//    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        NSLog(@"button clicked");
//
//    }];
    
//    [[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id _Nullable(__kindof UIControl * _Nullable value) {
//        return [self loginSignal];// 把按钮点击信号转换成了登录信号  // 信号中的信号
//    }] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"x = %@", x);
//    }];
    
    
    // flattenMap:这个操作把按钮点击事件转换为登录信号，同时还从内部信号发送事件到外部信号。
//    [[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
//        return [self loginSignal];
//    }] subscribeNext:^(NSNumber *isSuccess) {
//        NSLog(@"isSuccess = %@", isSuccess);
//    }];
    
    // 添加附加操作（Adding side-effects）
    [[[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        self.loginButton.enabled = NO;
    }] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
        return [self loginSignal];
    }] subscribeNext:^(NSNumber *isSuccess) {//信号订阅 subscribeNext返回 RACDisposable *
        self.loginButton.enabled = YES;
        NSLog(@"isSuccess = %@", isSuccess);
    }];
}

#pragma mark - =====XMG-Start=====
#pragma mark - RACSignal
- (void)testRACSignal
{
    // RACSignal:有数据产生的时候,就使用RACSignal
    // RACSignal使用步骤: 1.创建信号  2.订阅信号 3.发送信号
    RACDisposable *(^didSubscribe)(id<RACSubscriber> subscriber) = ^RACDisposable *(id<RACSubscriber> subscriber) {
        // didSubscribe调用:只要一个信号被订阅就会调用
        // didSubscribe作用:发送数据
        NSLog(@"信号被订阅");
        // 3.发送数据
        [subscriber sendNext:@1];
        
        return nil;
    };
    
    // 1.创建信号(冷信号)
    RACSignal *signal = [RACSignal createSignal:didSubscribe];
    
    // 2.订阅信号(热信号)
    [signal subscribeNext:^(id x) {
        
        // nextBlock调用:只要订阅者发送数据就会调用
        // nextBlock作用:处理数据,展示到UI上面
        
        // x:信号发送的内容
        NSLog(@"%@",x);
    }];
    
    // 只要订阅者调用sendNext,就会执行nextBlock
    // 只要订阅RACDynamicSignal,就会执行didSubscribe
    // 前提条件是RACDynamicSignal,不同类型信号的订阅,处理订阅的事情不一样
}

#pragma mark - RACDisposable
- (void)testRACDisposable
{
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber ) {
        
        //        _subscriber = subscriber;
        
        // 3.发送信号
        [subscriber sendNext:@"123"];
        
        return [RACDisposable disposableWithBlock:^{
            // 只要信号取消订阅就会来这
            // 清空资源
            NSLog(@"信号被取消订阅了");
        }];
    }];
    
    // 2.订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        
        NSLog(@"===%@===",x);
        
    }];
    // 1.创建订阅者,保存nextBlock
    // 2.订阅信号
    
    // 默认一个信号发送数据完毕们就会主动取消订阅.
    // 只要订阅者在,就不会自动取消信号订阅
    // 取消订阅信号
    [disposable dispose];
}

#pragma mark - RACSubject
- (void)testRACSubject
{
    // 可以代替代理
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    // 不同信号订阅的方式不一样
    // RACSubject处理订阅:仅仅是保存订阅者
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者一接收到数据:%@",x);
    }];
    
    // 3.发送数据
    [subject sendNext:@1];
    
    // 这个不会被执行
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅二接收到数据:%@",x);
    }];
    
    // // 底层实现:遍历所有的订阅者,调用nextBlock
    // 执行流程:
    // RACSubject被订阅,仅仅是保存订阅者
    // RACSubject发送数据,遍历所有的订阅,调用他们的nextBlock
}

#pragma mark - RACReplaySubject
- (void)testRACReplaySubject
{
    // 1.创建信号
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 第二个订阅者处于不同的位置 打印不同
    [subject subscribeNext:^(id x) {
        NSLog(@"===%@===",x);
    }];
    // log:1,===1===,2,===2===
    
    // 遍历所有的值,拿到当前订阅者去发送数据
    
    // 3.发送信号
    [subject sendNext:@1];
    [subject sendNext:@2];
    
//    [subject subscribeNext:^(id x) {
//        NSLog(@"===%@===",x);
//    }];
    // log:1,2,===1===,===2===
    
    
    // RACReplaySubject发送数据:
    // 1.保存值
    // 2.遍历所有的订阅者,发送数据
    // RACReplaySubject:可以先发送信号,在订阅信号
}

#pragma mark - RACTuple & RACSequence
// RACTuple:元组类,类似NSArray,用来包装值.
// RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
- (void)testRACTuple
{
    // 元组
    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"213",@"321",@1]];
}

- (void)testRACSequence
{
    // 1.遍历数组
    NSArray *numbers = @[@1,@2,@3,@4];
    
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        
        NSLog(@"%@ %@",key,value);
    }];
    
    // 3
    NSArray *dictArr = @[];
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
//    NSArray *flags = [[dictArr.rac_sequence map:^id(id value) {
//
//        return [FlagItem flagWithDict:value];
//    }] array];
}

#pragma mark - RACMulticastConnection
// 用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
// RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.
- (void)testRACMulticastConnection
{
    // RACMulticastConnection使用步骤:
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.创建连接 RACMulticastConnection *connect = [signal publish];
    // 3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
    // 4.连接 [connect connect]
    
    // RACMulticastConnection底层原理:
    // 1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
    // 2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
    // 3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
    // 3.1.订阅原始信号，就会调用原始信号中的didSubscribe
    // 3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
    // 4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
    // 4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock
    
    
    
    // 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
    // 解决：使用RACMulticastConnection就能解决.
    /*
    // 1.创建请求信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"发送请求");
        return nil;
    }];
    // 2.订阅信号
    [signal subscribeNext:^(id x) {
        
        NSLog(@"接收数据");
        
    }];
    // 2.订阅信号
    [signal subscribeNext:^(id x) {
        
        NSLog(@"接收数据");
        
    }];
    // 3.运行结果，会执行两遍发送请求，也就是每次订阅都会发送一次请求
    */
    
    // ==========================================
    // RACMulticastConnection:解决重复请求问题
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // didSubscribe什么时候来:连接类连接的时候
        NSLog(@"发送请求");
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    // 2.创建连接,把信号转换成连接类
    RACMulticastConnection *connect = [signal publish];
//    RACMulticastConnection *connect = [signal multicast:[RACReplaySubject subject]];
    
    // 3.订阅信号，// 不管订阅多少次信号,就会请求一次
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connect.signal subscribeNext:^(id x) {
        // nextBlock:发送数据就会来
        NSLog(@"订阅者一信号 x = %@", x);
    }];
    
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"订阅者二信号 x = %@", x);
    }];
    
    // 4.连接,激活信号
    [connect connect];
}

#pragma mark - RACCommand
//RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。
//使用场景:监听按钮点击，网络请求
- (void)testRACCommand
{
    // 一、RACCommand使用步骤:
    // 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
    // 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
    // 3.执行命令 - (RACSignal *)execute:(id)input
    // 二、RACCommand使用注意:
    // 1.signalBlock必须要返回一个信号，不能传nil.
    // 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
    // 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
    // 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
    // 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
    // 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    // 四、如何拿到RACCommand中返回信号发出的数据。
    // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    // 五、监听当前命令是否正在执行executing
    // 六、使用场景,监听按钮点击，网络请求
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        // input:执行命令传入参数
        NSLog(@"执行命令");
        
        // 创建空信号,必须返回信号
        //        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求数据"];
            // 注意：数据传递完，必须(最好)调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
        
    }];
    
    // 强引用命令，不要被销毁，否则接收不到数据
    _command = command;
    
    // 2-3的顺序不能错误
    // 2.订阅RACCommand中的信号 // 注意:必须要在执行命令前,订阅
    [command.executionSignals subscribeNext:^(id x) {// executionSignals:信号源,信号中信号
        
        [x subscribeNext:^(id x) {
            
            NSLog(@"%@",x);
        }];
        
    }];
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    //    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
    //        NSLog(@"###%@###",x);
    //    }];
    
    
    // 3.执行命令
    [self.command execute:@1];
    
    
    // 5.监听命令是否执行完毕,默认会来一次(默认NO)，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {

        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");

        }else{
            // 执行完成
            NSLog(@"执行完成");
        }

    }];
    
    // 或者
    /*
    RACCommand *command1 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 发送数据
            [subscriber sendNext:@"执行命令产生的数据"];
            return nil;
        }];
    }];
    
    // 如何拿到执行命令中产生的数据
    // 订阅命令内部的信号
    
    // 2.执行命令
    RACSignal *signal = [command1 execute:@1];
    
    // 3.订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@"##==%@",x);
    }];
    */
    
//RACScheduler:RAC中的队列，用GCD封装的。
//RACUnit :表⽰stream不包含有意义的值,也就是看到这个，可以直接理解为nil.
//RACEvent: 把数据包装成信号事件(signal event)。它主要通过RACSignal的-materialize来使用，然并卵。
}

#pragma mark - 常见宏
- (void)testCommonMacro
{
    // 1.
//    RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定。
    // 只要文本框文字改变，就会修改label的文字
//    RAC(self.labelView,text) = _textField.rac_textSignal;
    
    // 2.
//    RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
//    [RACObserve(self.view, center) subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    // 3.@weakify(Obj)和@strongify(Obj),一般两个都是配套使用,解决循环引用问题.
    
    // 4.
//    RACTuplePack：把数据包装成RACTuple（元组类）
//    // 把参数中的数据包装成元组
//    RACTuple *tuple = RACTuplePack(@10,@20);
    
    // 5.
//    RACTupleUnpack：把RACTuple（元组类）解包成对应的数据。
//    // 把参数中的数据包装成元组
//    RACTuple *tuple = RACTuplePack(@"xmg",@20);
//
//    // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
//    // name = @"xmg" age = @20
//    RACTupleUnpack(NSString *name,NSNumber *age) = tuple;
}

#pragma mark - switchToLatest
- (void)testSwitchToLatest
{
    // 创建信号中信号
    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    // 订阅信号
//        [signalOfSignals subscribeNext:^(RACSignal *x) {
//            [x subscribeNext:^(id x) {
//                NSLog(@"%@",x);
//            }];
//        }];
    
    // switchToLatest:获取信号中信号发送的最新信号
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 发送信号
    [signalOfSignals sendNext:signalA];
    
    [signalA sendNext:@125];
    [signalB sendNext:@"BB"];
    [signalA sendNext:@"11"];
}

#pragma mark - bind
- (void)testBind
{
    // 假设想监听文本框的内容，并且在每次输出结果的时候，都在文本框的内容拼接一段文字“输出：”
    // 方式一:在返回结果后，拼接。
    [_textField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"输出:%@",x);
    }];
    
    // 方式二:在返回结果前，拼接，使用RAC中bind方法做处理。
    // bind方法参数:需要传入一个返回值是RACStreamBindBlock的block参数
    // RACStreamBindBlock是一个block的类型，返回值是信号，参数（value,stop），因此参数的block返回值也是一个block。
    
    // RACStreamBindBlock:
    // 参数一(value):表示接收到信号的原始值，还没做处理
    // 参数二(*stop):用来控制绑定Block，如果*stop = yes,那么就会结束绑定。
    // 返回值：信号，做好处理，在通过这个信号返回出去，一般使用RACReturnSignal,需要手动导入头文件RACReturnSignal.h。
    
    // bind方法使用步骤:
    // 1.传入一个返回值RACStreamBindBlock的block。
    // 2.描述一个RACStreamBindBlock类型的bindBlock作为block的返回值。
    // 3.描述一个返回结果的信号，作为bindBlock的返回值。
    // 注意：在bindBlock中做信号结果的处理。
    
    // 底层实现:
    // 1.源信号调用bind,会重新创建一个绑定信号。
    // 2.当绑定信号被订阅，就会调用绑定信号中的didSubscribe，生成一个bindingBlock。
    // 3.当源信号有内容发出，就会把内容传递到bindingBlock处理，调用bindingBlock(value,stop)
    // 4.调用bindingBlock(value,stop)，会返回一个内容处理完成的信号（RACReturnSignal）。
    // 5.订阅RACReturnSignal，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
    
    // 注意:不同订阅者，保存不同的nextBlock，看源码的时候，一定要看清楚订阅者是哪个。
    // 这里需要手动导入#import <ReactiveCocoa/RACReturnSignal.h>，才能使用RACReturnSignal。
    
    [[_textField.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
        // 什么时候调用:只要绑定信号被订阅就会调用
        // block作用:表示绑定了一个信号.
        
        return ^RACSignal * _Nullable(id value, BOOL *stop){
            // block调用:只要源信号发送数据,就会调用block
            // block作用:做返回值的处理
            // value:源信号发送的内容
            
            // 做好处理，通过信号返回出去.
            return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
        };
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}
#pragma mark - 常用方法
- (void)testCommonMethods
{
//    代替代理:
    //    rac_signalForSelector：用于替代代理。###监听某对象有没有调用某方法###
    // 1.代替代理
    // 需求：自定义redView,监听红色view中按钮点击
    // 之前都是需要通过代理监听，给红色View添加一个代理属性，点击按钮的时候，通知代理做事情
    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，就要调用这个方法，就会发送信号。
    // 这里表示只要redV调用btnClick:,就会发出信号，订阅就好了。
//    [[redV rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
//        NSLog(@"点击红色按钮");
//    }];
    
//    代替KVO :
//    rac_valuesAndChangesForKeyPath：用于监听某个对象的属性改变。
    // 2.KVO
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil
//    [[redV rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
//    监听事件:
//    rac_signalForControlEvents：用于监听某个事件。
    // 3.监听事件
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
//    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"按钮被点击了");
//    }];
    
//    代替通知:
//rac_addObserverForName:用于监听某个通知。
    // 4.代替通知
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出");
    }];
    
//    监听文本框文字改变:
//rac_textSignal:只要文本框发出改变就会发出这个信号。
    // 5.监听文本框的文字改变
    [_textField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"文字改变了%@",x);
    }];
    
//    处理当界面有多次请求时，需要都获取到数据时，才能展示界面
//rac_liftSelector:withSignalsFromArray:Signals:当传入的Signals(信号数组)，每一个signal都至少sendNext过一次，就会去触发第一个selector参数的方法。
//    使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
}

// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
}

#pragma mark - 操作方法之映射(flattenMap,Map)
// flattenMap，Map用于把源信号内容映射成新的内容
- (void)testFlattenMapAndMap
{
    /*
    // 监听文本框的内容改变，把结构重新映射成一个新值.
    // flattenMap作用:把源信号的内容映射成一个新的信号，信号可以是任意类型。
    
    // flattenMap使用步骤:
    // 3.包装成RACReturnSignal信号，返回出去。
    
    // flattenMap底层实现:
    // 0.flattenMap内部调用bind方法实现的,flattenMap中block的返回值，会作为bind中bindBlock的返回值。
    // 1.当订阅绑定信号，就会生成bindBlock。
    // 2.当源信号发送内容，就会调用bindBlock(value, *stop)
    // 3.调用bindBlock，内部就会调用flattenMap的block，flattenMap的block作用：就是把处理好的数据包装成信号。
    // 4.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
    // 5.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
    
    [[_textField.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        // block什么时候 : 源信号发出的时候，就会调用这个block。
        // block作用 : 改变源信号的内容。
        // 返回值：绑定信号的内容.
        return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
    }] subscribeNext:^(id  _Nullable x) {// // flattenMap中返回的是什么信号,订阅的就是什么信号
        // 订阅绑定信号，每当源信号发送内容，做完处理，就会调用这个block。
        NSLog(@"%@",x);
    }];
    
    
    //===========================
    // 监听文本框的内容改变，把结构重新映射成一个新值.
    
    // Map作用:把源信号的值映射成一个新的值
    
    // Map使用步骤:
    // 1.传入一个block,类型是返回对象，参数是value
    // 2.value就是源信号的内容，直接拿到源信号的内容做处理
    // 3.把处理好的内容，直接返回就好了，不用包装成信号，返回的值，就是映射的值。
    
    // Map底层实现:
    // 0.Map底层其实是调用flatternMap,Map中block中的返回的值会作为flatternMap中block中的值。
    // 1.当订阅绑定信号，就会生成bindBlock。
    // 3.当源信号发送内容，就会调用bindBlock(value, *stop)
    // 4.调用bindBlock，内部就会调用flattenMap的block
    // 5.flattenMap的block内部会调用Map中的block，把Map中的block返回的内容包装成返回的信号。
    // 5.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
    // 6.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
    
    [[_textField.rac_textSignal map:^id(id value) {
        // 当源信号发出，就会调用这个block，修改源信号的内容
        // 返回值：就是处理完源信号的内容。
        return [NSString stringWithFormat:@"输出:%@",value];
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    */
    
    // ==========================
    
    /*
     FlatternMap和Map的区别
     
     1.FlatternMap中的Block返回信号。
     2.Map中的Block返回对象。
     3.开发中，如果信号发出的值不是信号，映射一般使用Map
     4.开发中，如果信号发出的值是信号，映射一般使用FlatternMap。
     */
    
    //signalOfsignals用FlatternMap。
    // 创建信号中的信号
    RACSubject *signalOfsignals = [RACSubject subject];
    signalOfsignals.name = @"signalOfsignals";
    RACSubject *signal = [RACSubject subject];
    signal.name = @"signal";
    
//    [signalOfsignals subscribeNext:^(id  _Nullable x) {
//        [x subscribeNext:^(id  _Nullable x) {
//
//        }];
//    }];
    // 或者
    [[signalOfsignals flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        // 当signalOfsignals的signals发出信号才会调用
        NSLog(@"value = %@", value);// signal
        return value;
    }] subscribeNext:^(id x) {
        
        // 只有signalOfsignals的signal发出信号才会调用，因为内部订阅了bindBlock中返回的信号，也就是flattenMap返回的信号。
        // 也就是flattenMap返回的信号发出内容，才会调用。
        
        NSLog(@"%@-aaa",x);
    }];
    
    // 信号的信号发送信号
    [signalOfsignals sendNext:signal];
    // 信号发送内容
    [signal sendNext:@1];
}

#pragma mark - 操作方法之组合concat
//concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
- (void)testConcat
{
    // concat底层实现:
    // 1.当拼接信号被订阅，就会调用拼接信号的didSubscribe
    // 2.didSubscribe中，会先订阅第一个源信号（signalA）
    // 3.会执行第一个源信号（signalA）的didSubscribe
    // 4.第一个源信号（signalA）didSubscribe中发送值，就会调用第一个源信号（signalA）订阅者的nextBlock,通过拼接信号的订阅者把值发送出来.
    // 5.第一个源信号（signalA）didSubscribe中发送完成，就会调用第一个源信号（signalA）订阅者的completedBlock,订阅第二个源信号（signalB）这时候才激活（signalB）。
    // 6.订阅第二个源信号（signalB）,执行第二个源信号（signalB）的didSubscribe
    // 7.第二个源信号（signalA）didSubscribe中发送值,就会通过拼接信号的订阅者把值发送出来.
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        [subscriber sendCompleted];
        
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活。
    RACSignal *concatSignal = [signalA concat:signalB];
    
    // 以后只需要面对拼接信号开发。
    // 订阅拼接的信号，不需要单独订阅signalA，signalB
    // 内部会自动订阅。
    // 注意：第一个信号必须发送完成，第二个信号才会被激活
    [concatSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

#pragma mark - then
//then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号。
- (void)testThen
{
    // then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号
    // 注意使用then，之前信号的值会被忽略掉.
    // 底层实现：1、先过滤掉之前的信号发出的值。2.使用concat连接then返回的信号
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@2];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        
        // 只能接收到第二个信号的值，也就是then返回信号的值
        NSLog(@"%@",x);
    }];
}

#pragma mark - merge
// merge:把多个信号合并为一个信号，任何一个信号有新值的时候就会调用.
- (void)testMerge
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 合并信号,任何一个信号发送数据，都能监听到.
    RACSignal *mergeSignal = [signalA merge:signalB];
    
    [mergeSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    // 底层实现：
    // 1.合并信号被订阅的时候，就会遍历所有信号，并且发出这些信号。
    // 2.每发出一个信号，这个信号就会被订阅
    // 3.也就是合并信号一被订阅，就会订阅里面所有的信号。
    // 4.只要有一个信号被发出就会被监听。
}

#pragma mark - zipWith
//zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。
- (void)testZipWith
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    
    
    // 压缩信号A，信号B
    // zipWith:当一个界面多个请求的时候,要等所有请求完成才能更新UI
    // zipWith:等所有信号都发送内容的时候才会调用
    RACSignal *zipSignal = [signalA zipWith:signalB];
    
    [zipSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 底层实现:
    // 1.定义压缩信号，内部就会自动订阅signalA，signalB
    // 2.每当signalA或者signalB发出信号，就会判断signalA，signalB有没有发出个信号，有就会把最近发出的信号都包装成元组发出。
}

#pragma mark - combineLatest
// 将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。
- (void)testCombineLatest
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 把两个信号组合成一个信号,跟zip一样，没什么区别
    RACSignal *combineSignal = [signalA combineLatestWith:signalB];
    
    [combineSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 底层实现：
    // 1.当组合信号被订阅，内部会自动订阅signalA，signalB,必须两个信号都发出内容，才会被触发。
    // 2.并且把两个信号组合成元组发出。
}

#pragma mark - reduce
// reduce聚合:用于信号发出的内容是元组，把信号发出元组的值聚合成一个值
- (void)testReduce
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    
    // 常见的用法，（先组合在聚合）。combineLatest:(id<NSFastEnumeration>)signals reduce:(id (^)())reduceBlock
    // reduce中的block简介:
    // reduceblcok中的参数，有多少信号组合，reduceblcok就有多少参数，每个参数就是之前信号发出的内容
    // reduceblcok的返回值：聚合信号之后的内容。
    RACSignal *reduceSignal = [RACSignal combineLatest:@[signalA,signalB] reduce:^id(NSNumber *num1 ,NSNumber *num2){
        
        return [NSString stringWithFormat:@"%@ %@",num1,num2];
        
    }];
    
    [reduceSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 底层实现:
    // 1.订阅聚合信号，每次有内容发出，就会执行reduceblcok，把信号内容转换成reduceblcok返回的值。
}

#pragma mark - 操作方法之过滤filter
/// filter:过滤信号，使用它可以获取满足条件的信号.
- (void)testFilter
{
    // 过滤:
    // 每次信号发出，会先执行过滤条件判断.
    [_textField.rac_textSignal filter:^BOOL(NSString *value) {
        return value.length > 3;
    }];
}

#pragma mark - ignore
// ignore:忽略完某些值的信号.
- (void)testIgnore
{
    // 内部调用filter过滤，忽略掉ignore的值
    [[_textField.rac_textSignal ignore:@"1"] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // // ignoreValues:忽略所有的值
    [[_textField.rac_textSignal ignoreValues] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - distinctUntilChanged
// distinctUntilChanged:当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉。
- (void)testDistinctUntilChanged
{
    // 过滤，当上一次和当前的值不一样，就会发出内容。
    // 在开发中，刷新UI经常使用，只有两次数据不一样才需要刷新
    [[_textField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - take
// take:从开始一共取N次的信号
- (void)testTake
{
    // 1、创建信号
    RACSubject *signal = [RACSubject subject];
    
    // 2、处理信号，订阅信号
    [[signal take:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号
    [signal sendNext:@1];
    
    [signal sendNext:@2];
}

#pragma mark - takeLast
// takeLast:取最后N次的信号,前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号.
- (void)testTakeLast
{
    // 1、创建信号
    RACSubject *signal = [RACSubject subject];
    
    // 2、处理信号，订阅信号
    [[signal takeLast:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号
    [signal sendNext:@1];
    
    [signal sendNext:@2];
    
    [signal sendCompleted];
}

#pragma mark - takeUntil
// takeUntil:(RACSignal *):获取信号直到执行完这个信号
- (void)testTakeUntil
{
    // 监听文本框的改变，直到当前对象被销毁
    [_textField.rac_textSignal takeUntil:self.rac_willDeallocSignal];
}

#pragma mark - skip
// skip:(NSUInteger):跳过几个信号,不接受。
- (void)testSkip
{
    // 表示输入第一次，不会被监听到，跳过第一次发出的信号
    [[_textField.rac_textSignal skip:1] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - switchToLatest
// switchToLatest:用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。
- (void)_testSwitchToLatest
{
    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    [signalOfSignals sendNext:signal];
    [signal sendNext:@1];
    
    // 获取信号中信号最近发出信号，订阅最近发出的信号。
    // 注意switchToLatest：只能用于信号中的信号
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - 操作方法之秩序
- (void)testOrder
{
//doNext: 执行Next之前，会先执行这个Block
//doCompleted: 执行sendCompleted之前，会先执行这个Block
    
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] doNext:^(id x) {
        // 执行[subscriber sendNext:@1];之前会调用这个Block
        NSLog(@"doNext");;
    }] doCompleted:^{
        // 执行[subscriber sendCompleted];之前会调用这个Block
        NSLog(@"doCompleted");;
        
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - 操作方法之线程
- (void)testThread
{
//deliverOn: 内容传递切换到制定线程中，副作用在原来线程中,把在创建信号时block中的代码称之为副作用。
//subscribeOn: 内容传递和副作用都会切换到制定线程中。
}

#pragma mark - 操作方法之时间
// timeout：超时，可以让一个信号在一定的时间后，自动报错。
#pragma mark - timeout
- (void)testTimeout
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }] timeout:1 onScheduler:[RACScheduler currentScheduler]];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        // 1秒后会自动调用
        NSLog(@"%@",error);
    }];
}

#pragma mark - interval
// interval 定时：每隔一段时间发出信号
- (void)testInterval
{
    [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - delay
// delay 延迟发送next。
- (void)testDelay
{
    RACSignal *signal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        return nil;
    }] delay:2] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

#pragma mark - 操作方法之重复
#pragma mark - retry
// retry重试 ：只要失败，就会重新执行创建信号中的block,直到成功.
- (void)testRetry
{
    __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (i == 10) {
            [subscriber sendNext:@1];
        }else{
            NSLog(@"接收到错误");
            [subscriber sendError:nil];
        }
        i++;
        
        return nil;
        
    }] retry] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    } error:^(NSError *error) {
        
        
    }];
}

#pragma mark - replay
// replay重放：当一个信号被多次订阅,反复播放内容
- (void)testReplay
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        
        return nil;
    }] replay];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者%@",x);
        
    }];
    
    [signal subscribeNext:^(id x) {

        NSLog(@"第二个订阅者%@",x);

    }];
}

#pragma mark - throttle
// throttle节流:当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出。
- (void)testThrottle
{
//    RACSubject *signal = [RACSubject subject];
//    
//    _signal = signal;
//    
//    // 节流，在一定时间（1秒）内，不接收任何信号内容，过了这个时间（1秒）获取最后发送的信号内容发出。
//    [[signal throttle:1] subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//    }];
}

#pragma mark - =====XMG-End=====

#pragma mark - Delegate
// RACSubject信号提供者:自己可以充当信号，又能发送信号
/*
 RACReplaySubject:重复提供信号类，RACSubject的子类
 RACReplaySubject可以先发送信号，再订阅信号，RACSubject就不可以。
 
 使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。
 
 使用场景二:可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值。
 */
- (void)testDelegate
{
    // 在一个自定义view里面定义一个公开属性：delegateSignal
    // @property (nonatomic, strong) RACSubject *delegateSignal;
    
    RACView *view = [[RACView alloc] init];
    [self.view addSubview:view];
    view.delegateSignal = [RACSubject subject];
    
    [view.delegateSignal subscribeNext:^(NSString *text) {
        
    }];
    
    // 或者
    [[view rac_signalForSelector:@selector(buttonDidClicked:)] subscribeNext:^(RACTuple * _Nullable x) {
        UIButton *button = (UIButton *)x[0];
        
    }];
    
    // 或者
    [[self rac_signalForSelector:@selector(testForProtocol) fromProtocol:@protocol(RACProtocol)] subscribeNext:^(RACTuple * _Nullable x) {
        
    }];
    [self testForProtocol];
    
    
}

- (void)testForProtocol
{
    
}

#pragma mark - RACCommand_
- (void)_testCommand
{
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            // 模拟网络加载
//            [self loadData:^(id response) {
//                // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
//                [subscriber sendNext:response];
//                [subscriber sendCompleted];
//            } fail:^(NSError *error) {
//                [subscriber sendError:error];
//            }];
            
            return nil;
        }];
    }];
    
    // 3.订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        // x 为信号中的信号
        [x subscribeNext:^(id  _Nullable x) {
            // 此处的 x 才是网络请求到的数据
            NSLog(@"%@",x);
        }];
    }];
    
    // 4.执行命令, 执行时可以传值
    [command execute:nil];
    
    // 步骤三可以简化
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        // 网络请求到的数据
        NSLog(@"%@",x);
    }];
}

/*
 -(void)setViewModel:(LMLoginViewModel *)viewModel{
 _viewModel = viewModel;
 self.button.rac_command = self.viewModel.loginCommand;
 //判断是否正在执行
 [self.button.rac_command.executing subscribeNext:^(id x) {
 if ([x boolValue]) {
 NSLog(@"View: login..");
 } else {
 NSLog(@"View: end logining");
 }
 }];
 
 //执行结果
 [self.button.rac_command.executionSignals.flatten subscribeNext:^(id x) {
 NSLog(@"View:result:%@",x);
 }];
 
 //错误处理
 [self.button.rac_command.errors subscribeNext:^(id x) {
 NSLog(@"error:%@",x);
 }];
 }
 */

#pragma mark - RAC宏
- (void)testMacro
{
//    RACObserve(<#TARGET#>, <#KEYPATH#>)
    
//    RACTupleUnpack(NSString *key, NSString *value) =
    
}

#pragma mark - map
- (void)testMap
{
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    
    NSArray *array = @[@11, @22];
    NSArray *resultArray = [[array.rac_sequence map:^id _Nullable(id  _Nullable value) {
//        Person *p =
//        return p;
        return nil;
    }] array];
    
}

#pragma mark - RACMulticastConnection-
- (void)_testRACMulticastConnection
{
    /*
    // This signal starts a new request on each subscription.
    RACSignal *networkRequest = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *operation = [client
                                             HTTPRequestOperationWithRequest:request
                                             success:^(AFHTTPRequestOperation *operation, id response) {
                                                 [subscriber sendNext:response];
                                                 [subscriber sendCompleted];
                                             }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 [subscriber sendError:error];
                                             }];
        
        [client enqueueHTTPRequestOperation:operation];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
    
    // Starts a single request, no matter how many subscriptions `connection.signal`
    // gets. This is equivalent to the -replay operator, or similar to
    // +startEagerlyWithScheduler:block:.
    RACMulticastConnection *connection = [networkRequest multicast:[RACReplaySubject subject]];
    [connection connect];
    
    [connection.signal subscribeNext:^(id response) {
        NSLog(@"subscriber one: %@", response);
    }];
    
    [connection.signal subscribeNext:^(id response) {
        NSLog(@"subscriber two: %@", response);
    }];
    */
    // RACMulticastConnection的init是以networkRequest作为sourceSignal，而最终connnection.signal指的是[RACReplaySubject subject]
     
    // 如果我们不用RACMulticastConnection的话，那就会因为执行了两次subscription而导致发了两次网络请求。
    // 对一个Signal进行multicast之后，我们是对connection.signal进行subscription而不是原来的networkRequest。
}

/*
 单向绑定
 Unidirectional binding
 */
// 双向绑定
- (void)TwoWayBinding
{
//    模型 –> UI 的绑定（模型发生改变，UI跟着改变）
    // 自定义一个模型Person，有name、age、height三个属性
//    自定义一个视图，包含nameField、ageField、heightField三个输入框
    
    
    // 字符串的绑定
//    RAC(_nameField,text) = RACObserve(p, name);
//    // 基本数据类型的绑定
//    RAC(_ageField,text) = [RACObserve(p, age) map:^id _Nullable(id  _Nullable value) {
//        return [value description];
//    }];
//    RAC(_heightField,text) = [RACObserve(p, height) map:^id _Nullable(id  _Nullable value) {
//        return [value description];
//    }];
//
////    UI –> 模型的绑定（UI发生改变，模型跟着改变）
//    [[RACSignal combineLatest:@[_nameField.rac_textSignal,_ageField.rac_textSignal,_heightField.rac_textSignal]] subscribeNext:^(RACTuple *x) {
//        p.name = x.first;
//        p.age = [x.second integerValue];
//        p.height = [x.third doubleValue];
//    }];
}

#pragma mark - RACTuple:元组类,类似NSArray,用来包装值
- (void)testTuple
{
    NSArray *array = @[@11, @22];
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        
    }];
    
    NSDictionary *dictionary = @{@"key1":@"value1", @"key2":@"value2", @"key3":@"value3"};
    [dictionary.rac_sequence.signal subscribeNext:^(id x) {
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"key:%@,value:%@",key,value);
    }];
    
    /* 创建元祖 */
    RACTuple *tuple1 = [RACTuple tupleWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    
    /* 从别的数组中获取内容 */
    RACTuple *tuple2 = [RACTuple tupleWithObjectsFromArray:@[@"1", @"2", @"3", @"4", @"5"]];
    
    /* 利用 RAC 宏快速封装 */
    RACTuple *tuple3 = RACTuplePack(@"1", @"2", @"3", @"4", @"5");
    
    
    NSArray *array1 = @[@"1", @"2", @"3", @"4", @"5"];
    NSArray *newArray = [[array1.rac_sequence mapReplace:@"0"] array]; // 将所有内容替换为 0
}

#pragma mark - Notification通知
- (void)testNotification
{
    [[NotificationCenter rac_addObserverForName:@"" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
    }];
}

#pragma mark - KVO
- (void)testKVO
{
    [RACObserve(self.loginButton, highlighted) subscribeNext:^(id  _Nullable x) {
        
    }];
    
    //
    
    [[self.view rac_valuesForKeyPath:@"frame" observer:self] subscribeNext:^(id  _Nullable x) {
        
    }];
}

#pragma mark - 调度器
- (void)testScheduler
{
    //RACScheduler 调度器 控制线程
    //startEagerlyWithScheduler  Eagerly立即 Lazily稍后
    //schedulerWithPriority 指定等级的异步并发队列
    //信号传递到那个线程deliverOn -> mainThreadScheduler(主线程)  currentScheduler(当前线程)
    RAC(self.iv, image) = [[RACSignal startEagerlyWithScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground] block:^(id<RACSubscriber> subscriber) {
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ww3.sinaimg.cn/bmiddle/7128be06jw1ei4hfthoj3j20hs0bomyd.jpg"]
                                             options:NSDataReadingMappedAlways
                                               error:&error];
        if(error) {
            [subscriber sendError:error];
        }else{
            [subscriber sendNext:[UIImage imageWithData:data]];
            [subscriber sendCompleted];
        }
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

#pragma mark - Timer
- (void)testTimer
{
    @weakify(self)
    self.timeerDisposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        @strongify(self)
        NSLog(@"当前时间：%@", x); // x 是当前的系统时间
        
        /* 关闭计时器 */
        [self.timeerDisposable dispose];
    }];
}

#pragma mark - 信号的处理
- (void)testSignalHandle
{
    // 转换（map）、过滤（filter） 取双层信号中内层信号的值：flattenMap
    // 1.filter过滤
    // 2.map转换
    // 3.concat:按一定顺序拼接信号
    RACSequence *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence;
    RACSequence *numbers = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;
    // Contains: A B C D E F G H I 1 2 3 4 5 6 7 8 9
    RACSequence *concatenated = [letters concat:numbers];
    [concatenated.signal subscribeNext:^(id x) {
        //NSLog(@"concatenated - >%@",x);
    }];
    
    RACSignal *signalA1 = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"我恋爱啦"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalB1 = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"我结婚啦"];
        [subscriber sendCompleted];
        return nil;
    }];
    [[signalA1 concat:signalB1] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 4.flatten (合并)
    //switchToLatest 的原理是当有新的signal来的时候，就dispose老的signal，订阅新的signal，而 flatten 不会 dispose 老的 signal
    RACSubject *oneSubject = [RACSubject subject];
    RACSubject *twoSubject = [RACSubject subject];
    RACSignal *signalOfSignals = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        [subscriber sendNext:oneSubject];
        [subscriber sendNext:twoSubject];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *flattened = [signalOfSignals flatten];
    // Outputs: A 1 B C 2
    [flattened subscribeNext:^(NSString *x) {
        //NSLog(@"%@", x);
    }];
    [oneSubject sendNext:@"A"];
    [twoSubject sendNext:@"1"];
    [oneSubject sendNext:@"B"];
    [oneSubject sendNext:@"C"];
    [twoSubject sendNext:@"2"];
    
    // 5.flattenMap 把源信号的内容映射成一个新的信号，信号可以是任意类型
    
    // 6.merge:把多个信号合并为一个信号，任何一个信号有新值的时候就会调用
//    [[RACSignal merge:@[self.userIdTF.rac_textSignal,self.userPWTF.rac_textSignal]] subscribeNext:^(id x) {
//        NSLog(@"merge - >%@",x);
//    }];
    /*
     RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(idsubscriber) {
     [subscriber sendNext:@"纸厂污水"];
     return nil;
     }];
     RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(idsubscriber) {
     [subscriber sendNext:@"电镀厂污水"];
     return nil;
     }];
     [[RACSignal merge:@[signalA, signalB]] subscribeNext:^(id x) {
     NSLog(@"处理%@",x);
     }];
     */
    
    // 7.combineLatest(组合)将多个信号合并起来
    // 8.switchToLatest(选择最新的信号)
    // 注意switchToLatest：只能用于信号中的信号
    RACSubject *switchSignal = [RACSubject subject];
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];

    // 获取信号中信号最近发出信号，订阅最近发出的信号。
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"switchToLatest-> %@",x);
    }];
    [switchSignal sendNext:signalA];
    [switchSignal sendNext:signalB];
    [signalA sendNext:@1];
    [signalB sendNext:@2];
    
    // 9.ignore(忽略)
//    [[self.userIdTF.rac_textSignal ignore:@"sunny"] subscribeNext:^(NSString *value) {
//        NSLog(@"`sunny` could never appear : %@", value);
//    }];
    
    // 10 take(取)
    // 从开始一共取N次的next值，不包括Competion和Error
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendNext:@"3"];
        [subscriber sendCompleted];
        return nil;
    }] take:2] subscribeNext:^(id x) {
        NSLog(@"only 1 and 2 will be print: %@", x);
    }];
    
    // 11 takeUntil(取值，直到某刻结束)
    //当给定的signal完成前一直取值。
//    [self.userIdTF.rac_textSignal takeUntil:self.rac_willDeallocSignal];
    
    // 12.takeUntilBlock(对于每个next值，运行block，当block返回YES时停止取值)
//    [[self.userIdTF.rac_textSignal takeUntilBlock:^BOOL(NSString *value) {
//        return [value isEqualToString:@"stop"];
//    }] subscribeNext:^(NSString *value) {
//        NSLog(@"current value is not `stop`: %@", value);
//    }];
    
    // 13.then:用于连接两个信号
    //当第一个信号完成，才会连接then返回的信号
    
    // 14.distinctUntilChanged:当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉。
//    过滤，当上一次和当前的值不一样，就会发出内容。在开发中，刷新UI经常使用，只有两次数据不一样才需要刷新
    [[self.userNameTextField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"distinctUntilChanged -> %@",x);
    }];
    
    // 15.timeout 超时，可以让一个信号在一定的时间后，自动报错。
    RACSignal *timeOutSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }] timeout:1 onScheduler:[RACScheduler currentScheduler]];
    
    [timeOutSignal subscribeNext:^(id x) {
        NSLog(@"timeOutSignal -> %@",x);
    } error:^(NSError *error) {
        // 1秒后会自动调用
        NSLog(@"timeOut error-> %@",error);
    }];
    
    // 16.interval 定时：每隔一段时间发出信号
    [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {
        //返回当前时间
        NSLog(@"interval 1ms -> %@",x);
    }];
    
    // 17.delay 延迟发送信号
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        return nil;
    }] delay:2] subscribeNext:^(id x) {
        
        NSLog(@"delay 2s-> %@",x);
    }];
    
    // 18. retry重试 ：只要失败，就会重新执行创建信号中的block,直到成功.
    __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (i == 10) {
            [subscriber sendNext:@1];
        }else{
            [subscriber sendError:nil];
        }
        i++;
        return nil;
    }] retry] subscribeNext:^(id x) {
        NSLog(@"retrySignal -> %@",x);
    } error:^(NSError *error) {
        NSLog(@"接收到错误");
    }];
    
    // 19.throttle节流:当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出。
    RACSubject *throttleSignal = [RACSubject subject];
    
    // 节流，在一定时间（1秒）内，不接收任何信号内容，过了这个时间（1秒）获取最后发送的信号内容发出。
    [[throttleSignal throttle:1] subscribeNext:^(id x) {
        
        NSLog(@"throttleSignal -> %@",x);
    }];
    
    // 20.reduce聚合信号
//    reduceblcok中的参数，有多少信号组合，reduceblcok就有多少参数，每个参数就是之前信号发出的内容
//    reduceblcok的返回值：聚合信号之后的内容。
//    [[RACSignal combineLatest:@[validPasswordSignal,validUserNameSignal] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
//        return @([usernameValid boolValue] && [passwordValid boolValue]);
//    }] subscribeNext:^(NSNumber *signupActive) {
//        self.loginBtn.enabled = [signupActive boolValue];
//    }];
    
    // 21.doNext:
//    你可以看到doNext:是直接跟在按钮点击事件的后面。而且doNext: block并没有返回值。因为它是附加操作，并不改变事件本身。
//    [[[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
//        self.loginBtn.enabled = NO;
//    }] flattenMap:^RACStream *(id value) {
//        return [self loginSignal];
//    }] subscribeNext:^(id x) {
//        self.loginBtn.enabled = YES;
//        
//    }];
}

#pragma mark - Private Methods
- (RACSignal *)loginSignal
{
    // 把一个异步API用信号封装
    // 当这个信号有subscriber时，block里的代码就会执行
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self loginWithUserName:self.userNameTextField.text password:self.passwordTextField.text complete:^(BOOL success) {
            // 信号发送了一个next事件来表示登录是否成功，随后是一个complete事件
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        
        return nil;// 这个block的返回值是一个RACDisposable对象，它允许你在一个订阅被取消时执行一些清理工作。当前的信号不需要执行清理操作，所以返回nil就可以了。
    }];
}

- (RACSignal *)requestAccessToTwitterSignal
{
    // deny
    NSError *accessError = [NSError errorWithDomain:@"NDLDomain" code:-100 userInfo:nil];
    
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        [self loginWithUserName:@"" password:@"" complete:^(BOOL success) {
            if (!success) {
                [subscriber sendError:accessError];
            } else {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)signalForLoadingImage:(NSString *)imageURL
{
    RACScheduler *scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground];
    
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        UIImage *image = [UIImage imageWithData:data];
        [subscriber sendNext:image];
        [subscriber sendCompleted];
        return nil;
    }] subscribeOn:scheduler];
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password complete:(void (^)(BOOL success))completeBlock
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completeBlock) {
            completeBlock(YES);
        }
    });
}

- (BOOL)isValidPassword:(NSString *)text
{
    return YES;
}

- (BOOL)isValidUserName:(NSString *)text
{
    return YES;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.textField.frame = CGRectMake(20, 80, self.view.width - 40, 40);
    self.loginButton.frame = CGRectMake(20, CGRectGetMaxY(self.textField.frame) + 10, 80, 40);
}


@end
