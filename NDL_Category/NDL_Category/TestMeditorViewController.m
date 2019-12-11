//
//  TestMeditorViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/1.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestMeditorViewController.h"
#import "CoreTextView.h"
#import "TestHash.h"
#import "TestShareInstance.h"
#import "TestCategory.h"

#import <objc/message.h>
#import <objc/runtime.h>

@interface TestMeditorViewController ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *randoms;
@property (nonatomic, strong) dispatch_semaphore_t sem;

@property (nonatomic, strong) TestHash *testHash;
@property (nonatomic, strong) TestHash *testHash1;

@property (nonatomic, strong) TestCategory *testCategory;

@end

@implementation TestMeditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.colorFlag) {
        self.view.backgroundColor = [UIColor cyanColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    CoreTextView *ctView = [[CoreTextView alloc] initWithFrame:CGRectMake(10, 120, self.view.width - 20, 450)];
    ctView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:ctView];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CGSize size = [ctView sizeThatFits:CGSizeZero];
//        ctView.size = size;
//    });
    
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 100, 40)];
    testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:testView];
    // (50, 84), (50, 84), (0.5, 0.5), frame = {{0, 64}, {100, 40}}
    NSLog(@"testView.center = %@ position = %@ anchorPoint = %@ frame = %@", NSStringFromCGPoint(testView.center), NSStringFromCGPoint(testView.layer.position), NSStringFromCGPoint(testView.layer.anchorPoint), NSStringFromCGRect(testView.frame));// center属性是针对与frame属性的中心点坐标
    // 当frame变化时，bounds和center相应变化
    
    // MARK:改变锚点
    testView.layer.anchorPoint = CGPointMake(0, 0);
    // (50, 84), (50, 84), (0, 0), frame = {{50, 84}, {100, 40}} 但视图显示的位置变化了，显示根据anchorPoint + position
    NSLog(@"testView.center = %@ position = %@ anchorPoint = %@ frame = %@", NSStringFromCGPoint(testView.center), NSStringFromCGPoint(testView.layer.position), NSStringFromCGPoint(testView.layer.anchorPoint), NSStringFromCGRect(testView.frame));
    
//    testView.bounds = CGRectMake(0, 0, 80, 40);// 只改变宽高
//    // 50, 84  当bounds变化时，frame会根据新bounds的宽和高，在不改变center的情况下，进行重新设定
//    NSLog(@"testView.center = %@", NSStringFromCGPoint(testView.center));
//    // 设置bounds，只会关注size，x和y不影响
//    testView.bounds = CGRectMake(0, 20, 80, 40);
//    // 50, 84
//    NSLog(@"testView.center = %@", NSStringFromCGPoint(testView.center));
    
    
    
    // test timer
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
//    [self.timer fire];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    });
    
    // MARK:Assets.xcassets里的图片只支持[UIImage imageNamed],不能从Bundle中加载.不能根据路径读取图片，因为图片会被打包在Assets.car文件中
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(60, 600, 60, 60)];
    NSString *assetPath = [[NSBundle mainBundle] pathForResource:@"avatar" ofType:@"png"];// nil
    // /.../Bundle/Application/3FBC8440-CD34-43E3-BD2D-FB406E44F86A/NDL_Category.app/1024x1024.png
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"1024x1024" ofType:@"png"];
    NSLog(@"assetPath = %@ bundlePath = %@", assetPath, bundlePath);
    iv.image = [UIImage imageNamed:@"1024x1024"];
    iv.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:iv];
    iv.transform = CGAffineTransformMakeRotation(60);
    
    // MARK:NSString
    NSString *normalStr = @"我么事77hytss";
    NSLog(@"normalStr.length = %lu", normalStr.length);// 10
    // NSString是UTF-16编码的, 也就是16位的unichar字符的序列
    for (NSInteger i = 0; i < normalStr.length; i++) {
        unichar ch = [normalStr characterAtIndex:i];
        NSLog(@"ch = %hu", ch);
    }
    
    NSString *emojiStr = @"👍🏼wom我🤨们";
    NSLog(@"emojiStr.length = %lu", emojiStr.length);// 11
    NSRange range = NSMakeRange(0, 0);
    for(NSInteger i = 0; i < emojiStr.length; i += range.length){
        range = [emojiStr rangeOfComposedCharacterSequenceAtIndex:i];
        NSLog(@"range = %@", NSStringFromRange(range));// 两个emoji分别为{0, 4}, {8, 2}
        NSString *str = [emojiStr substringWithRange:range];
        NSLog(@"str = %@", str);
    }
    
    // masony 动画
//    UIView *animView = [[UIView alloc] init];
//    animView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:animView];
//    [animView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.height.mas_equalTo(60);
//    }];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [animView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.view).offset(-100);
//        }];
//        [UIView animateWithDuration:5.0 animations:^{
    //            [self.view layoutIfNeeded];// ###view.superView layoutIfNeeded###
//        }];
//    });
    
    /*
     str = @“100”:
     字符串常量存储于文字常量区，在编译时会加载到内存，进程销毁才释放
     所以stringA = @“hello” 与字符串 stringB = @“hello”指向的内存地址是一样的
     也就是说stringA == stringB为True
     
     不受内存管理
编译器在编译的时候，把这个变量值@"XXX"添加到常量表里面，常量表里面的变量在APP结束之后才会被释放，指向这块常量表的指针都不受retainCount管理
     
     lldb: p str
     (__NSCFConstantString)
     
     只有Format形式生成的string对象才会拷贝内存
     initWithFormat: 和 stringWithFormat: 方法生成的字符串分配在堆区
     */
    NSString *str = @"100";
    NSString *str1 = @"100";
    // 1.[NSString stringWithFormat:@"%d", 100]; && @"100" -> NO, YES, YES
    // 2.@"100" && @"100" -> YES, YES, YES
    NSLog(@" = %@", (str == str1) ? @"YES" : @"NO");
    NSLog(@"isEqualToString = %@", [str isEqualToString:str1] ? @"YES" : @"NO");
    NSLog(@"isEqual = %@", [str isEqual:str1] ? @"YES" : @"NO");// If two objects are equal, they must have the same hash value
    
    // =========================test hash
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    self.testHash = [[TestHash alloc] init];
    [mDic setObject:@"1" forKey:self.testHash];// Dictionary以对象作为key: hashValue = 105553178147424->返回的就是该对象的内存地址
    NSLog(@"self.testHash = %@", self.testHash);// <TestHash: 0x600003b03a60> (16进制->10进制) 105553178147424
    // 但是NSSet 添加对象的hash值 并不是对象的内存地址
    /*
     对关键属性的hash值进行位或运算作为hash值
     Person对象: name,birthday属性
     - (NSUInteger)hash {
     return [self.name hash] ^ [self.birthday hash];
     }
     */
    
    
    // =========================test sharedInstance
    __block TestShareInstance *instance1 = nil;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        instance1 = [TestShareInstance sharedInstance];
    });
//    TestShareInstance *instance2 = [TestShareInstance sharedInstance];
    __block TestShareInstance *instance2 = nil;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        instance2 = [TestShareInstance sharedInstance];
    });
    
    TestShareInstance *instance3 = [[TestShareInstance alloc] init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"instance1 = %@ instance2 = %@ instance3 = %@", instance1, instance2, instance3);
    });
    
    // =========================test category
    self.testCategory = [[TestCategory alloc] init];
    // 如果有1个分类，方法列表有两个test方法，test方法打印分类的log
    [CommonUtils logInstanceMethodListForClass:[self.testCategory class]];
    // 如果有2个分类，方法列表有3个test方法，test方法打印按编译顺序，打印后编译的分类的log
    [self.testCategory test];
    [self.testCategory test1];// TestCategory Extension teswizzle_test1
//    [self.testCategory testAddMethod];
    
    // old方法不存在的情况下，见TestCategory+Extension.m
    [self.testCategory newTestAddMethod];// 经过方法交换后log: newTestAddMethod.应该调oldTestAddMethod 但因为oriMethod为null,最终调用的还是自己的方法，即newTestAddMethod
    [self.testCategory performSelector:@selector(oldTestAddMethod) withObject:nil];// 经过方法交换后log: newTestAddMethod
    ((void (*)(id, SEL))objc_msgSend)(self.testCategory, @selector(oldTestAddMethod));// 经过方法交换后log: newTestAddMethod
    
    // replaceMethod
    [self.testCategory testReplaceMethod];
    // 1.
//    [self.testCategory performSelector:@selector(testReplace)];// testReplaceImp
//    [self.testCategory testReplaceImp];// testReplaceImp
    // 2.
    [self.testCategory beReplacedMethod];// testReplaceImp
    [self.testCategory testReplaceImp];// testReplaceImp
    
    // MARK: 生产者 && 消费者
//    NSLog(@"=============================");
//    self.sem = dispatch_semaphore_create(1);
//    self.randoms = [NSMutableArray array];
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.concurrent", DISPATCH_QUEUE_CONCURRENT);
//    // 生产
//    dispatch_async(concurrentQueue, ^{
//        while (YES) {
//            sleep(1);
//            NSInteger randomNum = random() % 10;
//            dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);
//            [self.randoms addObject:@(randomNum)];
//            NSLog(@"生产了 = %ld", randomNum);
//            dispatch_semaphore_signal(self.sem);
//        }
//    });
//    // 消费
//    dispatch_async(concurrentQueue, ^{
//        while (YES) {
//            if (self.randoms.count > 0) {
//                dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);
//                NSLog(@"消费了 = %ld", [self.randoms.firstObject integerValue]);
//                [self.randoms removeFirstObject];
//                dispatch_semaphore_signal(self.sem);
//            }
//        }
//    });
    
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerUpdate
{
    NSLog(@"timerUpdate");
}

- (void)dealloc
{
    NSLog(@"TestMeditorViewController dealloc");
}


@end
