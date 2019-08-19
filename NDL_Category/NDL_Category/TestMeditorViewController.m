//
//  TestMeditorViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/8/1.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestMeditorViewController.h"
#import "CoreTextView.h"

@interface TestMeditorViewController ()

@property (nonatomic, strong) NSTimer *timer;

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
    
    // 改变锚点
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
    
    // Assets.xcassets里的图片只支持[UIImage imageNamed],不能从Bundle中加载.不能根据路径读取图片，因为图片会被打包在Assets.car文件中
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
