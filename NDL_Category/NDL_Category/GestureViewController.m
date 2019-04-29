//
//  GestureViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/4/10.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "GestureViewController.h"
#import "GestureNextViewController.h"

@interface GestureViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIPanGestureRecognizer *pan;

@end

@implementation GestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
//    [self testProperties];
    [self testMutex];
    

    // 跳转Next
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"First before push");
//        [self.navigationController pushViewController:[GestureNextViewController new] animated:YES];
//        // -1 count = 2
//        NSLog(@"First after push vc.count = %ld", self.navigationController.viewControllers.count);
//    });
}

// 1
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"First viewWillDisappear vc.count = %ld", self.navigationController.viewControllers.count);
}
// 3
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"First viewDidDisappear vc.count = %ld", self.navigationController.viewControllers.count);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Next->First count = 1
    NSLog(@"First viewWillAppear vc.count = %ld", self.navigationController.viewControllers.count);
    
    // 会跳转
//    [self presentViewController:[GestureNextViewController new] animated:YES completion:nil];
    // 会跳转
//    [self.navigationController pushViewController:[GestureNextViewController new] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"First viewDidAppear vc.count = %ld", self.navigationController.viewControllers.count);
    
    // 会跳转
//    [self presentViewController:[GestureNextViewController new] animated:YES completion:nil];
    // 会跳转
//    [self.navigationController pushViewController:[GestureNextViewController new] animated:YES];
}

// gesture properties
- (void)testProperties
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    pan.delegate = self;
    // ##default YES:识别到了手势(表示state是begin,不是Possible) 系统将会发送touchesCancelled:withEvent:消息在其事件传递链上，终止触摸事件的传递
//    pan.cancelsTouchesInView = YES;// 1-0,2-0,2-0,5-1,4-1,(5-2,5-2...),5-3
    // NO:不会终止事件的传递
//    pan.cancelsTouchesInView = NO;// 1-0,2-0,2-0,5-1,2-1,(5-2,5-2,2-2...),5-3,3-0
    // ##default NO:在触摸开始的时候(touchesBegan)，就会发消息给事件传递链
//    pan.delaysTouchesBegan = NO;// 1-0,2-0,2-0,5-1,4-1,(5-2,5-2...),5-3
    // 在触摸没有被识别失败前，都不会给事件传递链发送消息
//    pan.delaysTouchesBegan = YES;// 5-1,(5-2,5-2...),5-3
    
    // default YES
//    pan.delaysTouchesEnded = YES;
//    pan.delaysTouchesEnded = NO;
    [self.view addGestureRecognizer:pan];
    self.pan = pan;
}

// 互斥
- (void)testMutex
{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1Action:)];
    if (@available(iOS 11.0, *)) {
        tap1.name = @"=====";
    }
    tap1.delegate = self;
    [self.view addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2Action:)];
    if (@available(iOS 11.0, *)) {
        tap2.name = @"#####";
    }
    tap2.delegate = self;
    [self.view addGestureRecognizer:tap2];
    // o默认情况上面两个只会有1个执行
    
    // 手势冲突 tap1优先执行
//    [tap2 requireGestureRecognizerToFail:tap1];// 指定一个手势需要另一个手势执行失败才会执行
}

#pragma mark - gesture actions
// 5-(1-begin, 2-changed)
- (void)panHandler:(UIGestureRecognizer *)gesture
{
    NSLog(@"panHandler UIGestureRecognizerState = %ld", gesture.state);
}

- (void)tap1Action:(UIGestureRecognizer *)gesture
{
    NSLog(@"tap1Action");
}

- (void)tap2Action:(UIGestureRecognizer *)gesture
{
    NSLog(@"tap2Action");
}

#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    // gestureRecognizer:tap2 otherGestureRecognizer:tap1
//    NSLog(@"!!!!!gestureRecognizer = %@ otherGestureRecognizer = %@", gestureRecognizer, otherGestureRecognizer);
//    return YES;// YES:第一个手势和第二个(otherGestureRecognizer)互斥时，第一个(gestureRecognizer)会失效
//}

// ##推荐##相比上面的
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    // log不固定的
//    // gestureRecognizer:tap1 otherGestureRecognizer:tap2
//    // gestureRecognizer:tap2 otherGestureRecognizer:tap1
//    NSLog(@"!!!!!gestureRecognizer = %@ otherGestureRecognizer = %@", gestureRecognizer, otherGestureRecognizer);
//    return YES;// YES:第一个和第二个互斥时，第二个会失效
//}

// 默认返回NO
// 是否支持多时候触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

// 默认情况下为YES
// 手指触摸屏幕后回调的方法，返回NO则不再进行##手势识别##
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    // 在window对象在有触摸事件发生时，在touchesBegan:withEvent:方法之前调用
//    NSLog(@"shouldReceiveTouch");
//    return YES;
//}

// 开始进行手势识别时调用的方法，返回NO则结束，不再触发手势
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    return YES;
//}

#pragma mark - touch events
// 1
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    // testProperties
    NSLog(@"GestureViewController touchesBegan state = %ld", self.pan.state);// state:0
    
    
    [self.navigationController pushViewController:[GestureNextViewController new] animated:YES];
}
// 2
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    // testProperties
//    NSLog(@"GestureViewController touchesMoved state = %ld", self.pan.state);// state:0
}
// 3
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    // testProperties
//    NSLog(@"GestureViewController touchesEnded state = %ld", self.pan.state);
}
// 4
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    // testProperties
//    NSLog(@"GestureViewController touchesCancelled state = %ld", self.pan.state);// state:1
}



@end
