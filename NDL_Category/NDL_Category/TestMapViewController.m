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

@interface TestMapViewController () <MAMapViewDelegate>
{
    CLLocationCoordinate2D coords1[5];
}

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAAnimatedAnnotation *carAnno;

@property (nonatomic, strong) ResidentThread *residentThread;

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
    UIImage *image = [UIImage imageNamed:@"couponBG"];
//    UIImage *image = [UIImage imageNamed:@"welcome"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 100, 343, 111);
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
}

- (void)dealloc
{
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
    self.carAnno.coordinate = coords1[0];
    
    [self.carAnno addMoveAnimationWithKeyCoordinates:coords1 count:sizeof(coords1) / sizeof(coords1[0]) withDuration:6.0 withName:nil completeCallback:nil];
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


@end
