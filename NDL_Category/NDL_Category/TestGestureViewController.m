//
//  TestGestureViewController.m
//  NDL_Category
//
//  Created by dzcx on 2018/12/4.
//  Copyright © 2018 ndl. All rights reserved.
//

#import "TestGestureViewController.h"

@interface TestGestureViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *bgView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation TestGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 80, 200, 180)];
    bgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 80, 200, 180)];
    self.scrollView.bounces = YES;
    self.scrollView.delegate = self;
    // ###contentSize > scrollView.size才会触发###
    [self.scrollView.panGestureRecognizer addTarget:self action:@selector(scrollViewPan:)];
    self.scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 260)];
//    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 160)];
    self.imageView.userInteractionEnabled = YES;// 必须写
    self.imageView.backgroundColor = [UIColor cyanColor];
    [self.scrollView addSubview:self.imageView];
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPan:)];
    [self.pan addTarget:self action:@selector(imageViewSecondPan:)];// 可以添加多个target/action
    self.pan.delegate = self;
    [self.imageView addGestureRecognizer:self.pan];
    
    // contentSize > scrollView.size
    // 下面都不写 imageViewPan默认先触发
    // scrollViewPan优先触发
//    [self.pan requireGestureRecognizerToFail:self.scrollView.panGestureRecognizer];
    // imageViewPan优先触发 (panGestureRecognizer不触发，也就不滚动了)
//    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.pan];
    
    // contentSize < scrollView.size
    // 下面都不写 imageViewPan默认先触发
    // imageViewPan优先触发 因为scrollViewPan没有触发
//    [self.pan requireGestureRecognizerToFail:self.scrollView.panGestureRecognizer];
//    imageViewPan优先触发
//    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.pan];
    
    self.scrollView.contentSize = self.imageView.size;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // frame改变了
    NSLog(@"frame = %@ tran = %@", NSStringFromCGRect(self.scrollView.frame), NSStringFromCGAffineTransform(self.scrollView.transform));// frame = {{120, 170}, {100, 90}}
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 同时写 只用后面的
//    self.scrollView.transform = CGAffineTransformMakeScale(0.5, 0.5);// size = {100, 90} halfSize = {50, 45}
//    self.scrollView.transform = CGAffineTransformMakeTranslation(50, 45);
    // 同时有效果
    self.scrollView.transform = CGAffineTransformMake(0.5, 0, 0, 0.5, 50, 45);
    
}

- (void)scrollViewPan:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"scrollViewPan");
}

// contentSize > scrollView.size才会触发
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"TestGestureViewController scrollViewDidScroll");
//}

//
- (void)imageViewPan:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"imageViewPan");
}

- (void)imageViewSecondPan:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"imageViewSecondPan");
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 只有contentSize > scrollView.size才会触发 YES表示两个都执行（scrollViewPan && imageViewPan）
    if (gestureRecognizer == self.pan && otherGestureRecognizer == self.scrollView.panGestureRecognizer) {
        NSLog(@"gestureRecognizer = %@ otherGestureRecognizer = %@", gestureRecognizer, otherGestureRecognizer);
        
        return YES;// NO的话只执行gestureRecognizer所对应的 即imageViewPan
    }
    
    return NO;
}

@end
