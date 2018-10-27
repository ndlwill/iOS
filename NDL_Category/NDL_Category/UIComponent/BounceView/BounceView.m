//
//  BounceView.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/23.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "BounceView.h"

@interface BounceView ()
{
    CGFloat _bounceSpacing;
}

@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) CGRect contentFrame;

@property (nonatomic, strong) UIView *topControlPointView;
@property (nonatomic, strong) UIView *leftControlPointView;
@property (nonatomic, strong) UIView *bottomControlPointView;
@property (nonatomic, strong) UIView *rightControlPointView;

@end

@implementation BounceView

#pragma mark - Lazy Load
- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = ({
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.backgroundColor = [UIColor grayColor].CGColor;
            shapeLayer.fillColor = [UIColor redColor].CGColor;
            shapeLayer;
        });
    }
    return _maskLayer;
}

- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink.paused = YES;
    }
    return _displayLink;
}

- (UIView *)topControlPointView
{
    if (!_topControlPointView) {
        _topControlPointView = [[UIView alloc] init];
//        _topControlPointView.backgroundColor = [UIColor cyanColor];
        _topControlPointView.frame = CGRectMake(0, 0, 20, 20);
        [self addSubview:_topControlPointView];
    }
    return _topControlPointView;
}

- (UIView *)leftControlPointView
{
    if (!_leftControlPointView) {
        _leftControlPointView = [[UIView alloc] init];
//        _leftControlPointView.backgroundColor = [UIColor greenColor];
        _leftControlPointView.frame = CGRectMake(0, 0, 20, 20);
        [self addSubview:_leftControlPointView];
    }
    return _leftControlPointView;
}

- (UIView *)bottomControlPointView
{
    if (!_bottomControlPointView) {
        _bottomControlPointView = [[UIView alloc] init];
//        _bottomControlPointView.backgroundColor = [UIColor yellowColor];
        _bottomControlPointView.frame = CGRectMake(0, 0, 20, 20);
        [self addSubview:_bottomControlPointView];
    }
    return _bottomControlPointView;
}

- (UIView *)rightControlPointView
{
    if (!_rightControlPointView) {
        _rightControlPointView = [[UIView alloc] init];
//        _rightControlPointView.backgroundColor = [UIColor blueColor];
        _rightControlPointView.frame = CGRectMake(0, 0, 20, 20);
        [self addSubview:_rightControlPointView];
    }
    return _rightControlPointView;
}


#pragma marl - init
- (instancetype)initWithFrame:(CGRect)frame bounceSpacing:(CGFloat)bounceSpacing
{
    if (self = [super initWithFrame:frame]) {
        _bounceSpacing = bounceSpacing;
        
        [self _initializeData];
        [self _setupUI];
    }
    return self;
}
#pragma mark - Private Methods
- (void)_initializeData
{
    self.contentFrame = CGRectMake(_bounceSpacing, _bounceSpacing, self.width - 2 * _bounceSpacing, self.height - 2 * _bounceSpacing);
    self.maskLayer.frame = self.contentFrame;
    self.maskLayer.path = [UIBezierPath bezierPathWithRect:self.maskLayer.bounds].CGPath;
}

- (void)_setupUI
{
    [self _updateControlViewsCenter];
    
    self.layer.mask = self.maskLayer;
}

// 初始化
- (void)_updateControlViewsCenter
{
    self.topControlPointView.center = CGPointMake(self.width / 2.0, _bounceSpacing);
    self.leftControlPointView.center = CGPointMake(_bounceSpacing, self.height / 2.0);
    self.bottomControlPointView.center = CGPointMake(self.width / 2.0, self.height - _bounceSpacing);
    self.rightControlPointView.center = CGPointMake(self.width - _bounceSpacing, self.height / 2.0);
}

- (CGPathRef)_pathFromPerFrame
{
    CGFloat contentWidth = self.contentFrame.size.width;
    CGFloat contentHeight = self.contentFrame.size.height;

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];// self.maskLayer.frame = self.contentFrame;
    [path addQuadCurveToPoint:CGPointMake(contentWidth, 0) controlPoint:CGPointMake(contentWidth / 2.0, self.topControlPointView.layer.presentationLayer.position.y - _bounceSpacing)];// top
    [path addQuadCurveToPoint:CGPointMake(contentWidth, contentHeight) controlPoint:CGPointMake(self.rightControlPointView.layer.presentationLayer.position.x - _bounceSpacing, contentHeight / 2.0)];// right
    [path addQuadCurveToPoint:CGPointMake(0, contentHeight) controlPoint:CGPointMake(contentWidth / 2.0, self.bottomControlPointView.layer.presentationLayer.position.y - _bounceSpacing)];// bottom
    [path addQuadCurveToPoint:CGPointZero controlPoint:CGPointMake(self.leftControlPointView.layer.presentationLayer.position.x - _bounceSpacing, contentHeight / 2.0)];// left
    
    // 两个控制点 offset = 圆的直径 / 3.6
    //[path addCurveToPoint:<#(CGPoint)#> controlPoint1:<#(CGPoint)#> controlPoint2:<#(CGPoint)#>]
    // 阻尼振动: 式子中的 5 相当于阻尼系数，数值越小幅度越大；式子中的 30 相当于震荡频率 ，数值越大震荡次数越多
    // y = 1 - e(-5x次方)*cos(30x)
    
    return path.CGPath;
}

#pragma mark - DisplayLink
- (void)onDisplayLink
{
    self.maskLayer.path = [self _pathFromPerFrame];
}

#pragma mark - Overrides
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.displayLink.paused) {
        return;
    }
    self.displayLink.paused = NO;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1.5 options:0 animations:^{
        self.topControlPointView.frame = CGRectOffset(self.topControlPointView.frame, 0, -_bounceSpacing);
        self.leftControlPointView.frame = CGRectOffset(self.leftControlPointView.frame, -_bounceSpacing, 0);
        self.bottomControlPointView.frame = CGRectOffset(self.bottomControlPointView.frame, 0, _bounceSpacing);
        self.rightControlPointView.frame = CGRectOffset(self.rightControlPointView.frame, _bounceSpacing, 0);
    } completion:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"ended top frame = %@", NSStringFromCGRect(self.topControlPointView.frame));// touch begin最终的frame
    NSLog(@"ended topModelLayer positionY = %f", self.topControlPointView.layer.modelLayer.position.y);// touch begin最终的y = 0.0
    NSLog(@"ended topPresentationLayer positionY = %f", self.topControlPointView.layer.presentationLayer.position.y);// 该是多少就是多少
    [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.15 initialSpringVelocity:5.5 options:0 animations:^{
        [self _updateControlViewsCenter];
    } completion:^(BOOL finished) {
        self.displayLink.paused = YES;
    }];
}

@end
