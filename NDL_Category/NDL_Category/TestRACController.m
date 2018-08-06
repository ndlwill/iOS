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

@interface TestRACController () <RACProtocol>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIImageView *iv;

@property (nonatomic, strong) RACDisposable *timeerDisposable;

@end
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

#pragma mark - RACCommand
- (void)testCommand
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

#pragma mark - RACMulticastConnection
- (void)testRACMulticastConnection
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
