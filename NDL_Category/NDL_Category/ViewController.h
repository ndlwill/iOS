//
//  ViewController.h
//  NDL_Category
//
//  Created by ndl on 2017/9/14.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 // 控制器添加其他view或者删除view（或者改变self.view的size）会调viewWillLayoutSubviews
 // 布局顺序 (先self.view上面的subView布局 viewDidLayoutSubviews后 再subView里面的subViews布局)
 1.TestLifeCircleViewController viewWillLayoutSubviews
 2.TestLifeCircleViewController viewDidLayoutSubviews
 3.TestLifeCircleView layoutSubviews
 
 // view
 // view的宽高改变 会调用view的layoutSubviews
 改变x,y 不会调用view的layoutSubviews
 
 // view setModel（vc给view传model） 然后改变view中model的某个数据，控制器中的数据源也发生改变
 
 // view.transform的CGAffineTransformMakeScale(0.9, 0.9); 会改变view的frame
 
 // MAMapView
 // 没网情况下[AMapFoundationKit][Info] : 错误信息：似乎已断开与互联网的连接
 // 位置或者设备方向更新后，会立即调用此函数
 // 每隔15秒自动调用
 -(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
 
 创建map 不会自动调用- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction
 
 self.mapView setCenterCoordinate方法 会通知调用
 - (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction(如果设置的setCenterCoordinate与先前的相同 也调用方法)
 
 
 @interface MAPointAnnotation : MAShape
 ///是否固定在屏幕一点, 注意，拖动或者手动改变经纬度，都会导致设置失效
 @property (nonatomic, assign, getter = isLockedToScreen) BOOL lockedToScreen;
 
 
 ===================================MAUserLocation
 @property (nonatomic, readonly) MAUserLocation *userLocation;// mapView自带的user大头针
 self.mapView.userLocation.title = @"您的位置在这里";
 // 相当于设置userLocation的属性
 MAUserLocationRepresentation *represent = [[MAUserLocationRepresentation alloc] init];
 represent.showsAccuracyRing = YES;
 represent.showsHeadingIndicator = YES;
 represent.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
 represent.strokeColor = [UIColor lightGrayColor];;
 represent.lineWidth = 2.f;
 represent.image = [UIImage imageNamed:@"userPosition"];
 [self.mapView updateUserLocationRepresentation:represent];// 设定UserLocationView样式
 
 设定UserLocationView样式。如果用户自定义了userlocation的annotationView，或者该annotationView还未添加到地图上，此方法将不起作用
- (void)updateUserLocationRepresentation:(MAUserLocationRepresentation *)representation;
 
 或者
 
 ///用户位置精度圈 对应的overlay
 @property (nonatomic, readonly) MACircle *userLocationAccuracyCircle;
 
 - (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
 {
自定义定位精度对应的MACircleView.
if (overlay == mapView.userLocationAccuracyCircle)
{
    MACircleRenderer *accuracyCircleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
    
    accuracyCircleRenderer.lineWidth    = 2.f;
    accuracyCircleRenderer.strokeColor  = [UIColor lightGrayColor];
    accuracyCircleRenderer.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
    
    return accuracyCircleRenderer;
}

return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    自定义userLocation对应的annotationView.
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"userPosition"];
        
        self.userLocationAnnotationView = annotationView;
        
        return annotationView;
    }
    
    return nil;
}
 
 ===================================
 */
@interface ViewController : UIViewController


@end

