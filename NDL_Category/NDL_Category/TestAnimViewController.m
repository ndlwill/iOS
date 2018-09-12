//
//  TestAnimViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/8/21.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "TestAnimViewController.h"
#import "AnimNextController.h"
#import "WaterRippleView.h"

@interface TestAnimViewController () <CAAnimationDelegate>

@property (nonatomic, weak) CAShapeLayer *animLayer;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation TestAnimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ###borderWidth算在view的frame里面,不是在原始frame的宽高上面在加borderWidth###
    // CG框架绘制border 如果width=1，绘制点应在1/2=0.5 
    self.backView.layer.borderWidth = 5.0;
    self.backView.layer.borderColor = [UIColor greenColor].CGColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 300, 100, 60);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(0, 400, 100, 60);
    nextBtn.backgroundColor = [UIColor cyanColor];
    [nextBtn addTarget:self action:@selector(nextBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    // routeAnimation
    [self routeAnimation];
    
    WaterRippleView *rippleView = [[WaterRippleView alloc] initWithFrame:CGRectMake(kScreenWidth - 300, kScreenHeight - 300, 300, 300) originWH:100];
    [self.view addSubview:rippleView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"===TestAnimViewController viewWillAppear===");
}

- (void)btnDidClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextBtnDidClicked
{
    [self presentViewController:[AnimNextController new] animated:YES completion:nil];
}

- (void)routeAnimation
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 50)];
//    [path addLineToPoint:CGPointMake(250, 300)];
    [path addQuadCurveToPoint:CGPointMake(250, 300) controlPoint:CGPointMake(120, 180)];
    
    CAShapeLayer *routeLayer = [CAShapeLayer layer];
    routeLayer.frame = CGRectMake(0, 0, 300, 300);
//    routeLayer.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5].CGColor;
    routeLayer.lineWidth = 5;
    routeLayer.strokeColor = [UIColor redColor].CGColor;
    routeLayer.fillColor = [UIColor clearColor].CGColor;
    routeLayer.path = path.CGPath;
    [self.view.layer addSublayer:routeLayer];
    
    CAShapeLayer *animLayer = [CAShapeLayer layer];
    animLayer.frame = CGRectMake(0, 0, 300, 300);
    animLayer.lineWidth = 5;
    animLayer.strokeColor = [UIColor greenColor].CGColor;
    animLayer.fillColor = [UIColor clearColor].CGColor;
    animLayer.strokeStart = 0.0;
    animLayer.strokeEnd = 0.0;
    animLayer.path = path.CGPath;
    [self.view.layer addSublayer:animLayer];
    self.animLayer = animLayer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self step1Anim];
}

- (void)step1Anim
{
    self.animLayer.strokeStart = 0.0;
    self.animLayer.strokeEnd = 0.3;
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(0);
    endAnimation.toValue = @(0.3);
    endAnimation.duration = 0.5;
    endAnimation.delegate = self;
    [endAnimation setValue:@"step1" forKey:@"name"];
    [self.animLayer addAnimation:endAnimation forKey:nil];
}

- (void)step2Anim
{
    self.animLayer.strokeStart = 0.7;
    self.animLayer.strokeEnd = 1.0;
    
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = @(0);
    startAnimation.toValue = @(0.7);
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(0.3);
    endAnimation.toValue = @(1.0);
    
    CAAnimationGroup *step2Animation = [CAAnimationGroup animation];
    step2Animation.animations = @[startAnimation, endAnimation];
    step2Animation.duration = 0.5;
    step2Animation.delegate = self;
//    step2Animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [step2Animation setValue:@"step2" forKey:@"name"];
    [self.animLayer addAnimation:step2Animation forKey:nil];
}

- (void)step3Anim
{
//    self.animLayer.strokeStart = 1.0;
//    self.animLayer.strokeEnd = 1.0;
    
    
    
//    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
//    endAnimation.fromValue = @(0.7);
//    endAnimation.toValue = @(1.0);
//    endAnimation.duration = 0.5;
//    endAnimation.delegate = self;
//    [endAnimation setValue:@"step3" forKey:@"name"];
//    [self.animLayer addAnimation:endAnimation forKey:nil];
    
    
    self.animLayer.strokeStart = 0.0;
    self.animLayer.strokeEnd = 0.0;
    
    
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = @(0.7);
    startAnimation.toValue = @(1.0);
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(1.0);
    endAnimation.toValue = @(1.0);
    
    CAAnimationGroup *step2Animation = [CAAnimationGroup animation];
    step2Animation.animations = @[startAnimation, endAnimation];
    step2Animation.duration = 0.5;
    step2Animation.delegate = self;
    //    step2Animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [step2Animation setValue:@"step3" forKey:@"name"];
    [self.animLayer addAnimation:step2Animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animationDidStop");
    if ([[anim valueForKey:@"name"] isEqualToString:@"step1"]) {
        NSLog(@"step1 complete");
        [self step2Anim];
        
    } else if ([[anim valueForKey:@"name"] isEqualToString:@"step2"]) {
        [self step3Anim];
        
    } else if ([[anim valueForKey:@"name"] isEqualToString:@"step3"]) {

//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self step1Anim];
//        });

[self step1Anim];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.animLayer removeAllAnimations];
}

- (void)dealloc
{
    NSLog(@"Test Aim dealloc");
}


@end
