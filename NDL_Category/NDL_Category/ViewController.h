//
//  ViewController.h
//  NDL_Category
//
//  Created by ndl on 2017/9/14.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

// 面试 && ###
// https://blog.csdn.net/qxuewei/article/details/79418952
// https://blog.csdn.net/qxuewei/

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

/*
 objccn:
 https://objccn.io/issues/
 */

/*
 AOP:
 AOP主要是被使用在日志记录，性能统计，安全控制，事务处理，异常处理几个方面
 */

/*
 不到万不得已最好永远都不要去改动第三方的库源码，采用继承的方式永远要优于修改
 */

/*
 UIView && CALayer
 每一个单位区间其实都是一个梯形，也就是说我们只需要通过画一个三角形和一个矩形就可以画出一个单位区间
 
 layer内部维护着三分layer tree，分别是presentLayer Tree(动画树)，modeLayer Tree(模型树), Render Tree(渲染树)，在做 iOS动画的时候，我们修改动画的属性，在动画的其实是Layer的presentLayer的属性值，而最终展示在界面上的其实是提供View的modelLayer
 
 但是如果你在16.7ms内做的事情太多，导致CPU，GPU无法在指定时间内完成指定的工作，那么就会出现卡顿现象，也就是丢帧
 60fps是Apple给出的最佳帧率，但是实际中我们如果能保证帧率可以稳定到30fps就能保证不会有卡顿的现象，60fps更多用在游戏上
 
 UIView从Draw到Render的过程有如下几步:
 每一个UIView都有一个layer，每一个layer都有个content，这个content指向的是一块缓存，叫做backing store。
 UIView的绘制和渲染是两个过程，当UIView被绘制时，CPU执行drawRect，通过context将数据写入backing store。
 当backing store写完后，通过render server交给GPU去渲染，将backing store中的bitmap数据显示在屏幕上
 
 */

/*
 crash:
 Crash分为两种，一种是由EXC_BAD_ACCESS引起的，原因是访问了不属于本进程的内存地址，有可能是访问已被释放的内存；另一种是未被捕获的Objective-C异常（NSException），导致程序向自身发送了SIGABRT信号而崩溃。其实对于未捕获的Objective-C异常，我们是有办法将它记录下来的，如果日志记录得当，能够解决绝大部分崩溃的问题

*/
