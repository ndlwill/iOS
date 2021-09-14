//
//  AV7ViewController.h
//  NDL_Category
//
//  Created by youdone-ndl on 2020/12/17.
//  Copyright © 2020 ndl. All rights reserved.
//

// MARK: 捕捉功能之录制视频缩放
/**
 AVCaptureDevice提供videoZoomFactor属性，用用控制捕捉设备的缩放等级。
 这个属性最小值为1，即不能进行缩放的图片。最大值由捕捉谁被属性activeFormat决定。它是AVCaptureDeviceFormat的实例，还包含有设备支持的最大缩放值videoMaxZoomFactor

 设备执行缩放效果是通过居中裁剪由摄像头传感器捕捉到的图片实现。所以过度放大会损失图片质量，具体根据需求判定。
 
 设置缩放系数有两种方式：
 1、直接设置activeCamera.videoZoomFactor
 if (!self.activeCamera.isRampingVideoZoom) {
     NSError *error;
     if ([self.activeCamera lockForConfiguration:&error]) {
         // 如果捕捉设备当前没有将视频缩放，需要锁定设备进行配置，与其他配置相同
         
         CGFloat zoomFactor = pow([self maxZoomFactor], zoomValue);
         //应用程序提供的缩放范围四1x到4x，这一增长是指数形式的，
         //需要通过计算最大缩放因子的zoomValue次幂(0到1)来计算zoomFactor值。
         
         self.activeCamera.videoZoomFactor = zoomFactor;
         [self.activeCamera unlockForConfiguration];
     } else {
         [self.delegate deviceConfigurationFailedWithError:error];
     }
 }
 
 2、通过方法rampToVideoZoomFactor: withRate:
 需要传递计算的zoomFactor和速率rate值(达到最终结果的速率，通常1-3)。
 CGFloat zoomFactor = pow([self maxZoomFactor], zoomValue);
     NSError *error;
     if ([self.activeCamera lockForConfiguration:&error]) {
         [self.activeCamera rampToVideoZoomFactor:zoomFactor withRate:1];
         // rampToVideoZoomFactor: withRate:需要传递计算的zoomFactor和速率rate值。
         [self.activeCamera unlockForConfiguration];
     } else {
         [self.delegate deviceConfigurationFailedWithError:error];
     }
 两种方法区别在于值变化的过程，最终的结果是一样的。
 
 附加属性说明
 1、activeCamera.videoZoomFactor
 当前缩放值

 2、MIN(self.activeCamera.activeFormat.videoMaxZoomFactor, 4.0)
 确定最大允许缩放因子，4.0是个随意值，不过需要定义一个合理的缩放范围，通常不希望将内容缩放至videoMaxZoomFactor大小，太大就不实用了。如果视图设置缩放因子超过允许最大值，就会出现异常。

 3、[activeCamera cancelVideoZoomRamp]
 取消当前缩放进程，并设置zoomFactor为当前状态

 4、添加缩放值变化监听
 [self.activeCamera addObserver:self
                             forKeyPath:@"videoZoomFactor"
                                options:0
                                context:&THRampingVideoZoomContext];
         [self.activeCamera addObserver:self
                             forKeyPath:@"rampingVideoZoom"
                                options:0
                                context:&THRampingVideoZoomFactorContext];
 对应两种改变缩放系数的方法，添加不同的监听。
 
 5、验证是否支持缩放

 videoMaxZoomFactor属性，用于控制设备的缩放等级，这个属性的最小值为1.0，即不能进行缩放的图片。最大值由捕捉设备的activeFormat决定
 - (BOOL)cameraSupportsZoom {
     return self.activeCamera.activeFormat.videoMaxZoomFactor > 1.f;
     
 }
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AV7ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
