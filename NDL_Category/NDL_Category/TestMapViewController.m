//
//  TestMapViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/6/11.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestMapViewController.h"
#import <MAMapKit/MAMapKit.h>

#import "InvisibleWatermark.h"
#import "ResidentThread.h"
#import "GradientRingRatationView.h"
#import "AnnoAnimationView.h"

@interface TestMapViewController () <MAMapViewDelegate>
{
    CLLocationCoordinate2D coords1[5];
}

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAAnimatedAnnotation *carAnno;

@property (nonatomic, strong) ResidentThread *residentThread;

@property (nonatomic, strong) dispatch_queue_t myQueue;
@property (nonatomic, strong) dispatch_group_t group;

@property (nonatomic, copy) NSString *testName;

@property (nonatomic, strong) id obj;

@property (nonatomic, copy) NSString *kvoStr;

@end

@implementation TestMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initCoordinates];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    back.backgroundColor = [UIColor redColor];
    back.frame = CGRectMake(0, 60, 60, 40);
    [self.view addSubview:back];
    
    UIButton *executeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [executeBtn setTitle:@"ExecuteBtn" forState:UIControlStateNormal];
    [executeBtn addTarget:self action:@selector(exeDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    executeBtn.backgroundColor = [UIColor redColor];
    executeBtn.frame = CGRectMake(100, 60, 60, 40);
    [self.view addSubview:executeBtn];
    
    // overlay
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords1 count:sizeof(coords1) / sizeof(coords1[0])];
    [self.mapView addOverlay:polyline];
    
    // anno
    self.carAnno = [[MAAnimatedAnnotation alloc] init];
    self.carAnno.coordinate = coords1[0];
    [self.mapView addAnnotation:self.carAnno];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 300, 100, 60);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"Start" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 343 x 111
//    UIImage *image = [UIImage imageNamed:@"couponBG"];
//    UIImage *image = [UIImage imageNamed:@"welcome"];
    UIImage *image = [UIImage ndl_imageWithColor:UIColorFromHex(0x7C2219) size:CGSizeMake(300, 110)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    imageView.frame = CGRectMake(0, 100, 343, 111);// for couponBG
    imageView.frame = CGRectMake(0, 100, 300, 110);
//    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"===start===");
        [InvisibleWatermark addWatermarkToImage:image text:@"ndl_will" completion:^(UIImage * _Nonnull newImage) {
            imageView.image = newImage;
            
            // 会跟随当前控制器销毁而自动销毁的常驻线程
            self.residentThread = [[ResidentThread alloc] init];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                imageView.image = [InvisibleWatermark colorBumWatermarkImage:newImage];
            });
        }];
    });
    
    self.group = dispatch_group_create();
    self.myQueue = dispatch_queue_create("com.queue.my", DISPATCH_QUEUE_SERIAL);
    dispatch_group_async(_group, _myQueue, ^{
        self.testName = @"123";
    });
    
    // MARK:已验证
//    WEAK_REF(self)
//    _obj = [[NSNotificationCenter defaultCenter] addObserverForName:@"123" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
//        weak_self.testName = @"123";
//    }];
    
    
    // MARK:GradientRingRatationView
    GradientRingRatationView *gradientRingRatationView = [[GradientRingRatationView alloc] initWithFrame:CGRectMake(30, kScreenHeight - 150, 100, 100) arcWidth:3.0 gradienColor:[UIColor redColor]];
//    gradientRingRatationView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:gradientRingRatationView];
    
    // MARK:AnnoAnimationView
    AnnoAnimationView *annoAnimationView = [[AnnoAnimationView alloc] initWithFrame:CGRectMake(220, kScreenHeight - 150, 60, 84)];
    annoAnimationView.tag = 100;
    annoAnimationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:annoAnimationView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"=========================annoAnimationView start animation");
        [annoAnimationView startAnimation];
    });
    
    UILabel *pLabel = [[UILabel alloc] init];
    pLabel.backgroundColor = [UIColor redColor];
    pLabel.text = @"tep我们hxt";
    pLabel.textColor = [UIColor blackColor];
    pLabel.layer.masksToBounds = YES;
    [self.view addSubview:pLabel];
    [pLabel sizeToFit];
    pLabel.x = 30;
    pLabel.y = kScreenHeight - 150 - 60;
    
    // MARK:=====CALayer=====
    CALayer *caLayer = [CALayer layer];
    caLayer.backgroundColor = [UIColor redColor].CGColor;
    // MARK:When setting the frame the `position' and `bounds.size' are changed to match the given frame
    caLayer.frame = CGRectMake(30, self.view.height - 30 - 10, 100, 30);
    [self.view.layer addSublayer:caLayer];
    // layer frame = {{30, 627}, {100, 30}} bounds = {{0, 0}, {100, 30}}
    NSLog(@"layer frame = %@ bounds = %@", NSStringFromCGRect(caLayer.frame), NSStringFromCGRect(caLayer.bounds));
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // update layer: frame = {{50, 627}, {100, 30}} bounds = {{0, 0}, {100, 30}}
//        caLayer.position = CGPointMake(100, self.view.height - 30 - 10 + 15);
        
        // update layer: frame = {{40, 627}, {100, 30}} bounds = {{0, 0}, {100, 30}}
//        caLayer.transform = CATransform3DMakeTranslation(10, 0, 0);// 会有平移隐式动画
        
        // 只有改变bounds才会真的改变bounds，其他的都是改变frame
        // update layer: frame = {{20, 627}, {120, 30}} bounds = {{0, 0}, {120, 30}}
//        caLayer.bounds = CGRectMake(0, 0, 120, 30);// 会有缩放隐式动画
        
        // update layer: frame = {{20, 627}, {120, 30}} bounds = {{0, 0}, {100, 30}}
//        caLayer.transform = CATransform3DMakeScale(1.2, 1, 1);// 会有缩放隐式动画
        
        // update layer: frame = {{10, 627}, {120, 30}} bounds = {{0, 0}, {100, 30}}
//        caLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMake(1.2, 0, 0, 1.0, -10, 0));// 　缩放和平移
        NSLog(@"update layer: frame = %@ bounds = %@", NSStringFromCGRect(caLayer.frame), NSStringFromCGRect(caLayer.bounds));
    });
    
    
    // MARK:test kvo
    /*
     kvo对容器类的监听:
     Person类中有属性NSMutableArray *array
     NSMutableArray *tempArr = [p mutableArrayValueForKey:@"array"];
     [tempArr addObject:@"11"];这样能触发
     
     [array addObject:@"11"];这样不能触发
     */
    
    [self addObserver:self forKeyPath:@"kvoStr" options:NSKeyValueObservingOptionNew context:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"start kvo");
        // automaticallyNotifiesObserversForKey返回NO: 不重写setter不能触发，重写setter添加willXX didXX能手动触发
        // setter && kvc（底层也会先查找setter方法） 都可以触发kvo
        self.kvoStr = @"123";// 没有重写setter通知触发一次，重写了并willXX didXX通知触发2次。涉及到kvo底层原理，会动态生成一个子类重写setter方法
//        self.kvoStr = @"123";// 设置相同的值，也会触发，可在setter方法中添加判断然后过滤.
        
//        [self setValue:@"234" forKey:@"kvoStr"];
        
        // 直接访问成员变量 不能触发kvo
//        [self changeKVOStr:@"345"];
        
        // 能触发kvo， automaticallyNotifiesObserversForKey返回NO也能触发，因为他有willXX didXX
//        [self changeKVOStr1:@"345"];
    });
    
    
    // MARK:NSMutableURLRequest addValue && setValue
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@""]];
    [request addValue:@"123" forHTTPHeaderField:@"content-type"];
    [request addValue:@"234" forHTTPHeaderField:@"content-type"];
    [request setValue:@"tst" forHTTPHeaderField:@"test"];
    [request setValue:@"txt" forHTTPHeaderField:@"test"];
    /*
     allHTTPHeaderFields = {
     "Content-Type" = "123,234";
     test = txt;
     }
     */
    NSLog(@"allHTTPHeaderFields = %@", request.allHTTPHeaderFields);
    
    [NotificationCenter addObserver:self selector:@selector(handleInnerMessage:) name:@"InnerMessage" object:nil];
    

}

- (void)handleInnerMessage:(NSNotification *)notification
{
    NSLog(@"thread = %@ userInfo = %@", [NSThread currentThread], notification.userInfo);
}

- (void)setKvoStr:(NSString *)kvoStr
{
//    if ([_kvoStr isEqualToString:kvoStr]) {
//        return;
//    }
    
    [self willChangeValueForKey:@"kvoStr"];
    _kvoStr = kvoStr;
    [self didChangeValueForKey:@"kvoStr"];
}

- (void)changeKVOStr:(NSString *)newKvoStr
{
    _kvoStr = newKvoStr;
}

- (void)changeKVOStr1:(NSString *)newKvoStr
{
    [self willChangeValueForKey:@"kvoStr"];// 记录旧值
    _kvoStr = newKvoStr;
    [self didChangeValueForKey:@"kvoStr"];// 触发observeValueForKeyPath
}

// 这个方法只和setter相关
//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
//{
//    if ([key isEqualToString:@"kvoStr"]) {
//        return NO;// 表示不能自动发送通知
//    }
//
//    return [super automaticallyNotifiesObserversForKey:key];
//}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"newValue = %@", change[NSKeyValueChangeNewKey]);
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"kvoStr"];
    NSLog(@"TestMapViewController dealloc");
}

- (void)backDidClicked:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)exeDidClicked:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    [self.residentThread executeTask:^{
        NSLog(@"###execute residentThread task###");
    }];
}

- (void)buttonDidClicked:(UIButton *)pSender
{
    NSLog(@"===buttonDidClicked===");
    [[self.view viewWithTag:100] removeFromSuperview];

    // ===test addMoveAnimationWithKeyCoordinates===
//    self.carAnno.coordinate = coords1[0];
//
//    [self.carAnno addMoveAnimationWithKeyCoordinates:coords1 count:sizeof(coords1) / sizeof(coords1[0]) withDuration:6.0 withName:nil completeCallback:nil];
}

- (void)initCoordinates {
    coords1[0].latitude = 39.852136;
    coords1[0].longitude = 116.30095;
    
    coords1[1].latitude = 39.852136;
    coords1[1].longitude = 116.40095;
    
    coords1[2].latitude = 39.932136;
    coords1[2].longitude = 116.40095;
    
    coords1[3].latitude = 39.932136;
    coords1[3].longitude = 116.40095;
    
    coords1[4].latitude = 39.982136;
    coords1[4].longitude = 116.48095;
}

#pragma mark - MAMapViewDelegate
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 26.f;
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType = kMALineCapRound;
        polylineRenderer.strokeImage = [UIImage imageNamed:@"path_planning_64x64"];
        // 或者
//        polylineRenderer.lineWidth    = 8.f;
//        polylineRenderer.lineJoinType = kMALineJoinRound;
//        polylineRenderer.lineCapType = kMALineCapRound;
//        polylineRenderer.strokeColor = [UIColor redColor];

        return polylineRenderer;
        
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        NSString *pointReuseIndetifier = @"myReuseIndetifier";
        MAAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:pointReuseIndetifier];
            
            UIImage *image  =  [UIImage imageNamed:@"taxi_22x39"];
            annotationView.image =  image;
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.draggable                    = NO;
        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MAAnnotationView *annoView in views) {
        CGRect endFrame = annoView.frame;
        annoView.y = annoView.y - kScreenHeight;
        
        // MARK:CASpringAnimation iOS9.0
        [UIView animateWithDuration:0.45 delay:1.0 usingSpringWithDamping:0.8 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [annoView setFrame:endFrame];
        } completion:nil];
        
        //        [UIView beginAnimations:@"drop" context:NULL];
        //        [UIView setAnimationDuration:0.45];
        //        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        //        [annoView setFrame:endFrame];
        //        [UIView commitAnimations];
    }
}


@end
