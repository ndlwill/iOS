//
//  WaveView.m
//  NDL_Category
//
//  Created by dzcx on 2018/7/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "WaveView.h"

/*
 y = sin(x)
 
 正弦曲线公式：y=Asin(ωx+φ)+k
 A :振幅,曲线最高位和最低位的距离
 ω :角速度,用于控制周期大小，单位x中起伏的个数
 K :偏距,曲线上下偏移量
 φ :初相,曲线左右偏移量
 */

// 如果第一层为余弦曲线，第二层则需添加正弦曲线，这样看起来就会有分层的感觉
@interface WaveView ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, copy) NSArray<UIColor *> *waveColors;
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *waveLayers;

// A
@property (nonatomic, assign) CGFloat waveAmplitude;
// w
@property (nonatomic, assign) CGFloat wavePalstance;
// φ
@property (nonatomic, assign) CGFloat waveOffsetX;
// k
@property (nonatomic, assign) CGFloat waveOffsetY;
// 移动速度
@property (nonatomic, assign) CGFloat waveSpeedX;

@end

@implementation WaveView
#pragma mark - Lazy Load
- (NSMutableArray<CAShapeLayer *> *)waveLayers
{
    if (!_waveLayers) {
        _waveLayers = [NSMutableArray array];
    }
    return _waveLayers;
}

#pragma mark - init
// 默认背景色 clearColor
- (instancetype)initWithFrame:(CGRect)frame waveColors:(NSArray<UIColor *> *)waveColors
{
    if (self = [super initWithFrame:frame]) {
        _waveColors = waveColors;
        
        [self _setupUI];
        [self _initialDatas];
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

#pragma mark - Setter
- (void)setProgress:(CGFloat)progress
{
    if (progress > 1.0) {
        progress = 1.0;
    }
    _progress = progress;
}

#pragma mark - Life Circle
- (void)dealloc
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - Private Methods
- (void)_initialDatas
{
    _waveAmplitude = 10;
    _wavePalstance = M_PI / self.width;// 0.5:起伏个数会很多 0.08:起伏个数会很少
    _waveOffsetX = 0;
    _waveOffsetY = self.height;// 最底部
    _progress = 0.0;
    _waveSpeedX = _wavePalstance * 5;
    
    _waveSpacing = 3.0;
}

- (void)_setupUI
{
    self.layer.cornerRadius = self.width / 2.0;
    self.layer.masksToBounds = YES;
    
    for (NSInteger i = 0; i < self.waveColors.count; i++) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = self.waveColors[i].CGColor;
        [self.layer addSublayer:layer];
        [self.waveLayers addObject:layer];
    }
}

- (void)_updateLayer:(CAShapeLayer *)shapeLayer offsetX:(CGFloat)offsetX
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, self.waveOffsetY);
    CGFloat moveToY = self.waveOffsetY;
    // 曲线路径
    for (CGFloat x = 0.0; x <= self.width; x++) {
        moveToY = self.waveAmplitude * sin(self.wavePalstance * x + offsetX) + self.waveOffsetY;
        CGPathAddLineToPoint(path, nil, x, moveToY);
    }
    CGPathAddLineToPoint(path, nil, self.width, self.height);
    CGPathAddLineToPoint(path, nil, 0, self.height);
    CGPathCloseSubpath(path);
    shapeLayer.path = path;
    CGPathRelease(path);
    
    
    /*
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.waveOffsetY)];
    CGFloat moveToY = self.waveOffsetY;
    // 曲线路径
    for (CGFloat x = 0.0; x <= self.width; x++) {
        moveToY = self.waveAmplitude * sin(self.wavePalstance * x + self.waveOffsetX) + self.waveOffsetY;
        [path addLineToPoint:CGPointMake(x, moveToY)];
    }
    [path addLineToPoint:CGPointMake(self.width, self.height)];
    [path addLineToPoint:CGPointMake(0, self.height)];
    [path closePath];
    self.oneShapeLayer.path = path.CGPath;
     */
}

#pragma mark - CADisplayLink
- (void)updateWave
{
    // updateX
    self.waveOffsetX += self.waveSpeedX;
    
    // smooth handle
    CGFloat targetY = self.height - _progress * self.height;
    if (_waveOffsetY < targetY) {
        _waveOffsetY += 2.0;
    }
    if (_waveOffsetY > targetY ) {
        _waveOffsetY -= 2.0;
    }
    
    // updateLayer
    CGFloat waveSpacing = 0.0;
    for (NSInteger i = 0; i < self.waveLayers.count; i++) {
        waveSpacing = i * _waveSpacing;
        [self _updateLayer:self.waveLayers[i] offsetX:self.waveOffsetX + waveSpacing];
    }
}

#pragma mark - Public Methods
//- (void)startAnimation
//{
//    self.displayLink.paused = NO;
//}

#pragma mark - Overrides
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    NSLog(@"===willMoveToSuperview===");
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    NSLog(@"===willMoveToWindow===");
}

@end
