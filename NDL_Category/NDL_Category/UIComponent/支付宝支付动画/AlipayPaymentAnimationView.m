//
//  AlipayPaymentAnimationView.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/8.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "AlipayPaymentAnimationView.h"

static CGFloat const kStrokeLineWidth = 4.0;

static CGFloat const kTotalSteps = 60.0;
static CGFloat const kFastStepPerFrame = 2.0;// 60.0里面的2.0
static CGFloat const kSlowStepPerFrame = 0.3;

@interface AlipayPaymentAnimationView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;

@property (nonatomic, assign) CGFloat progress;// 0.0-1.0  (0-2pi的比例)

@end

@implementation AlipayPaymentAnimationView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _progress = 0.0;
        
        [self _setupUI];
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLayer)];
        self.displayLink.paused = YES;
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"===AlipayPaymentAnimationView dealloc===");
}

#pragma mark - CADisplayLink
- (void)updateLayer
{
//    NSLog(@"===updateLayer===");
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    _progress += [self increasedProgress];
    if (_progress >= 1.0) {
        _progress = 0.0;
    }
    
     _endAngle = -M_PI_2 + _progress * 2 * M_PI;// _progress * 2 * M_PI转了3/4pi 开始慢动画
    if (_endAngle > M_PI) {// 快动画结束，开始慢动画
        // _progress处于0.75时，startAngle处于-M_PI_2，tempProgress = 0
        // _progress处于1.0时，startAngle处于3 / 2 * M_PI = 270，tempProgress = 1
        CGFloat tempProgress = 1 - (1 - _progress) * 4;
        _startAngle = -M_PI_2 + tempProgress * 2 * M_PI;
    } else {// 快动画
        _startAngle = -M_PI_2;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2.0, height / 2.0) radius:((width > height ? height : width) / 2.0 - kStrokeLineWidth / 2.0)  startAngle:_startAngle endAngle:_endAngle clockwise:YES];
    
    self.shapeLayer.path = path.CGPath;
}

#pragma mark - Private Methods
- (void)_setupUI
{
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.bounds = self.bounds;
    self.shapeLayer.position = CGPointMake(self.width / 2.0, self.height / 2.0);// 默认(0, 0)
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeColor = NDLRGBColor(16, 142, 233).CGColor;//[UIColor ndl_randomColor].CGColor;
    self.shapeLayer.lineWidth = kStrokeLineWidth;
    self.shapeLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.shapeLayer];
}

// totalProgress = 1.0
- (CGFloat)increasedProgress
{
    if (_endAngle > M_PI) {
        return kSlowStepPerFrame / kTotalSteps;
    }
    
    return kFastStepPerFrame / kTotalSteps;
}

#pragma mark - Class Methods
+ (AlipayPaymentAnimationView *)showInView:(UIView *)superView
{
    // 移除AlipayPaymentAnimationView
    for (AlipayPaymentAnimationView *view in superView.subviews) {
        if ([view isKindOfClass:[AlipayPaymentAnimationView class]]) {
            NSLog(@"===remove AlipayPaymentAnimationView===");
            [view.displayLink invalidate];// 防止循环引用
            view.displayLink = nil;
            [view removeFromSuperview];
            break;
        }
    }
    
    AlipayPaymentAnimationView *alipayView = [[AlipayPaymentAnimationView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    alipayView.backgroundColor = [UIColor redColor];
    [superView addSubview:alipayView];
    alipayView.center = superView.center;
    [alipayView resumeAnimation];
    
    return alipayView;
}

#pragma mark - Public Methods
- (void)resumeAnimation
{
    if (self.displayLink.isPaused) {
        self.displayLink.paused = NO;
    }
}

- (void)pauseAnimation
{
    if (!self.displayLink.isPaused) {
        self.displayLink.paused = YES;
    }
}

//- (void)stopAnimation
//{
//}

@end
