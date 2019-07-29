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

#import "ResidentThread.h"

#import <YYKit/YYKit.h>

void stackFrame (void) {
    /* Trigger a crash */
    ((char *)NULL)[1] = 0;
}

@interface TestTVViewController () <UITextViewDelegate>

@property (nonatomic, weak) UITextView *textView;

@property (nonatomic, strong) DebugThread *thread;

@property (nonatomic, strong) Person *person;

@end

@implementation TestTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"我是按钮" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 620, self.view.width, 40);
    [self.view addSubview:button];
    
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
    
    DebugThread *thread = [[DebugThread alloc] initWithTarget:self selector:@selector(threadTask) object:nil];
    [thread start];
    self.thread = thread;// 不强引用 执行完就释放了dealloc,强引用 执行完状态为finish
    
    // test crash
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testCrash];
    });
    
    /*
     Block的存储域:
     _NSConcreteStackBlock // 存储在栈上
     _NSConcreteGlobalBlock // 存储在数据段
     _NSConcreteMallocBlock // 存储在堆上
     使用了静态或者全局变量的时候，block实际上是存放在全局区的
     Block语法的表达式中不使用截获的自动变量，也就是不使用外部变量，block也是存放在全局区的
     
     栈上的forwarding其实是去指向堆中的forwarding，而堆中的forwarding指向的还是自己。所以这样就能保证我们访问的就是同一个变量
     
     在ARC下，通常讲Block作为返回值的时候，编译器会自动加上copy，也就是自动生成复制到堆上的代码
     */
    // __block原理:__block修饰的变量本身是一个结构体，我们存放指针的方式就可以修改实际的值了
    int val = 1;
    void (^blk)(void) = ^{
        printf("%d\n", val);// Block保存了val的瞬间值,值拷贝
    };
    val = 2;
    blk();// 1
    
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
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        YYImage *image = [YYImage imageNamed:@"launch_2"];
//        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.frame = self.view.bounds;
//        [self.view addSubview:imageView];
//    });
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
    
    // textView :{0, 120, 375, 300}
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"textContainer.size = %@", NSStringFromCGSize(self.textView.textContainer.size));
    });
}



- (void)buttonDidClicked:(UIButton *)button
{
    NSLog(@"##buttonDidClicked##");
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:[TestMapViewController new]];
    [self presentViewController:nav animated:YES completion:nil];
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
