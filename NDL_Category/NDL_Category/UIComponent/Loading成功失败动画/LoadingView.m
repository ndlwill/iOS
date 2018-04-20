//
//  LoadingView.m
//  NDL_Category
//
//  Created by dzcx on 2018/4/20.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "LoadingView.h"

#import "ArcToCircleLayer.h"


static CGFloat const kRadius = 100;


@interface LoadingView () <CAAnimationDelegate>

@property (nonatomic, strong) ArcToCircleLayer *step1Layer;

@end

@implementation LoadingView

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"===LoadingView Dealloc===");
}

#pragma mark - Public Methods
- (void)startAnimation
{
    [self reset];
    [self startStep1Animation];
}

#pragma mark - Private Methods
- (void)reset
{
    [self.step1Layer removeFromSuperlayer];
}

// execute执行
- (void)startStep1Animation
{
    self.step1Layer = [ArcToCircleLayer layer];
    [self.layer addSublayer:self.step1Layer];
    
    CGFloat wh = 2 * kRadius + kLineWidth;
    self.step1Layer.bounds = CGRectMake(0, 0, wh, wh);
    self.step1Layer.position = CGPointMake(self.width / 2, self.height / 2);
    
    self.step1Layer.progress = 1.0;// modelLayer status
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = 1.0;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
//    [animation setValue:@"step1Animation" forKey:@"name"];
    [self.step1Layer addAnimation:animation forKey:@"step1Animation"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}

@end
